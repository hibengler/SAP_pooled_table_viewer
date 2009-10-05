#!/usr/bin/perl
################################################################
# @(#) sql.pll 1.52 16 Jan 1996
# @(#) Perl library file for ECIS
#
#
# SQL PACKAGE
#
################################################################


package sql;

################################################################

$LDA = '';

$SessionCnt = 0;

$StrSchema	= "";

$statement= "";

$cache_login[0]=0;
$cache_login[1]=0;
$cache_login[2]=0;
$cache_login[3]=0;
$cache_login[4]=0;
$cache_size=5;
#$cache_lda ldas
#$cache_database - $cache_user, $cache_password


# flush database logins that are over 10 minutes old - because they might go stale.
sub cache_flush_too_old 
{
local ($i,$curtime);
$curtime=time();
for ($i=0;$i<$cache_size;$i++) {
  if (($cache_login[$i]!=0)&&($curtime - $cache_login[$i] > 6000)) {
    &'ora_logoff($cache_lda[$i]);
    $cache_lda[$i]="";
    $cache_login[$i]=0;
    }  
  }
}

sub cache_flush_all
{
local ($i,$curtime);
$curtime=time();
for ($i=0;$i<$cache_size;$i++) {
  if (($cache_login[$i]!=0)) {
    &'ora_logoff($cache_lda[$i]);
    $cache_lda[$i]="";
    $cache_login[$i]=0;
    }  
  }
}


sub cache_logoff
{
for ($i=0;$i<$cache_size;$i++) {
  if (($cache_lda[$i] == $LDA)) {
    $cache_lda[$i]="";
    $cache_login[$i]=0;
    }
  }	
&'ora_logoff ($LDA);
    

}

# look throught the cache to see if we already logged in.  If we did,  then great!
# if not,  than we need the free entry
# if there are no free entries,  then we need to free up the earliest login
sub cache_login
{
local($database,$user,$password) = @_;
$database = uc $database;
$user = uc $user;
$password = uc $password;
local ($i,$curtime,$earliest_time,$earliest_index,$free_index);
&cache_flush_too_old(); # if there are really old db connections,  axe them

$curtime=time();
$earliest_time=$curtime;
$earliest_index= -1;
$free_index = -1;
for ($i=0;$i<$cache_size;$i++) {
  if ($cache_login[$i]!=0) {
    if (($cache_database[$i] eq $database)&&
        ($cache_user[$i] eq $user)&&
	($cache_password[$i] eq $password)) {
      # match
      $LDA = $cache_lda[$i];
      # test it out before we ok this
      local $test;
      ($test) = &fetch_row("select 'x' from dual");
      if ($test eq "") {
          # doesnt work,  log this off
          warn "cache LOGIN is stale: $database, $user, $password ...\n" if ($DEBUG);
	  print STDERR "stale logging off  $database, $user pos $i\n";
	  &'ora_logoff($cache_lda[$i]);
	  $cache_lda[$i]="";
	  $cache_login[$i]=0;
	  # this one is free now!
	  if ($free_index == -1)  {$free_index = $i;}
	  }	  
      else {
        $cache_login[$i] = $curtime;
        return(0);
	}
      }
    else { # no match,  but find the oldest login to reuse.
      if ($cache_login[$i] < $earliest_time) {
        $earliest_time = $cache_login[$i];
	$earliest_index = $i;
	} 
      }
    } # if this cache is used
  else { # free - keep track of the position so if we cannot find the login,  we can free it up
    if ($free_index == -1)  {$free_index = $i;}
    }
  }

# missed the cache - either log off the least used,  or use a blank position
if ($free_index != -1) {
  $i = $free_index;
  }
else {
  $i = $earliest_index;
  &'ora_logoff($cache_lda[$i]);
  $cache_lda[$i]="";
  $cache_login[$i]=0;
  }  

warn "cache LOGIN: $database, $user, $password ...\n" if ($DEBUG);

$LDA = &'ora_login ($database, "$user","$password");
	
$r= &err_check_noprint;
if ($r) {
  $previous_user=$user;
  $previous_database=$database;
  }
else {
  $cache_login[$i]=$curtime;
  $cache_lda[$i]=$LDA;
  $cache_database[$i] = $database;
  $cache_user[$i] = $user;
  $cache_password[$i] = $password;
  &do("alter session set nls_timestamp_format = 'yyyy-mm-dd hh24:mi:ss'");
  &do("alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss'");
  &do("alter session set nls_timestamp_tz_format = 'yyyy-mm-dd hh24:mi:ss'");
  }
warn "($LDA)\n" if ($DEBUG);
return $r;
}


################################################################
# Routines to get/set the schema name.
################################################################

sub schema_get
{
    substr ($StrSchema, 0, length ($StrSchema) - 1);
}

sub schema_set
{
    local ($name) = @_;

    $StrSchema = ($name ne "") ? "$name." : "";
}

################################################################

%Ora_Errno_is_Fatal =
    (
     -31,	1,
     -60,	1,
     -61,	1,
     -62,	1,
     -63,	1,
     -64,	1,
     -66,	1,
     -67,	1,
     -68,	1,
     -69,	1,
    );

################################################################
################################################################
# err_check
################################################################
# INPUT: None.
#
# OUTPUT: None.
#
# NOTES: We check the ora_errno global variable to see if any oracle
# errors have occurred.  If so, check to see if they are fatal (by
# looking them up in %Ora_Errno_is_Fatal).  If we get a fatal error,
# send ourselves a SIGUSR1 to indicate that we should either shutdown
# or restart.
# returns 1 if there is an error
################################################################
################################################################

sub err_check
{
    if ($'ora_errno)
    {
       $last_errno = $'ora_errno;
       $last_errstr = $'ora_errstr;
       $last_statement = $'ora_statement;
	&error ("Oracle code $last_errno: [$last_errstr]");
	warn "---STATEMENT----------------------\n$statement"
	    if ($statement && $DEBUG);

	if ($Ora_Errno_is_Fatal {int ($'ora_errno / 100)})
	{
	    &error ("Fatal Oracle Error...sending SIGUSR1");

	    kill ("USR1", $$);
	}
	return 1;
    }
return 0;
}



sub err_check_noprint
{
    if ($'ora_errno)
    {
	$sqlerror= ("Oracle code $'ora_errno: [$'ora_errstr]");

	if ($Ora_Errno_is_Fatal {int ($'ora_errno / 100)})
	{

	    kill ("USR1", $$);
	}
	return 1;
    }
return 0;
}

################################################################
# quote is a routine to protect text being placed into SQL.
################################################################

sub quote
{
    local ($_) = @_;

    s/'/''/og;

    "'" . $_ . "'";
}

################################################################
# Here is the start of the oraperl wrapper subs.
################################################################

sub do
{
    local ($statement,@params) = @_;


    warn "DO: $statement\n" if ($DEBUG);

    local ($result) = &'ora_do ($LDA, $statement,@params);

    warn "DO: result = [$result]\n" if ($DEBUG);

    &err_check;

    $result;
}

sub fetch_row
{
    local ($csr) = &open (@_);
    if ($csr) {
      local (@row) = &fetch ($csr);
      &close ($csr);
      warn "FETCH_ROW: [@row]\n" if ($DEBUG);
      @row;
      }
    else {
      local (@row);
      warn "FETCH_ROW: [@row]\n" if ($DEBUG);
      @row;
      }
        
}

sub fetch_rows
{
    local ($csr) = &open (@_);

    local (@rows);

    local (@row);
    while (@row = &fetch ($csr))
    {
	push (@rows, join ($;, @row));
    }

    &close ($csr);

    warn "FETCH_ROWS: [...]\n" if ($DEBUG);

    @rows;
}

sub fetch_tidy_rows
{
    local ($csr) = &open (@_);

    local (@rows);

    local (@row);
    while (@row = &fetch ($csr))
    {
	push (@rows, join ($;, &'list_tidy (@row)));
    }

    &close ($csr);

    warn "FETCH_TIDY_ROWS: [...]\n" if ($DEBUG);

    @rows;
}

sub open
{
    local ($r,$cache) = @_;
    local ($csr);
    $statement=$r;

    warn "OPEN: $statement ($cache)\n" if ($DEBUG);
    warn "LDA is $LDA, and cache is $cache\n" if ($DEBUG);
    $csr = &'ora_open ($LDA, $statement, $cache);
    &err_check;

    $csr;
}

sub close
{
    local ($csr) = @_;

    warn "CLOSE: $csr\n" if ($DEBUG);

    &'ora_close ($csr);
    &err_check;
    $statement="";
}

sub fetch
{
    local ($csr, $trunc) = @_;
    local(@got);

    print STDERR "FETCH: $csr  = [" if ($DEBUG);
    @got = &'ora_fetch ($csr);
    &err_check;
    warn "@got]\n" if ($DEBUG);

    @got;
}

sub commit
{
    if ($LDA)
    {
	&debug ("ORA_COMMIT")
	    if ($main'VERBOSE);

	&'ora_commit ($LDA);
	&err_check;
    }
}

sub rollback
{
    if ($LDA)
    {
	&debug ("ORA_ROLLBACK")
	    if ($main'VERBOSE);

	&'ora_rollback ($LDA);
    }
}






sub login
{
local ($r)= "";
    if (!$LDA)
    {
	local ($database, $user, $password) = @_;

	########################################
	# Default values for arguments
	########################################

	$database = $StrDatabase if (!$database);
	$user = $StrUser if (!$user);
	$password = $StrPassword if (!$password);

	########################################

	warn "LOGIN: $database, $user, $password ...\n" if ($DEBUG);
	
        $r = &cache_login($database,$user,$password);
	if ($r) {
         $last_errno = $'ora_errno;
         $last_errstr = $'ora_errstr;
          &error ("Oracle code $last_errno: [$last_errstr]");
          warn "---STATEMENT----------------------\n$statement"
          if ($statement && $DEBUG);

          if ($Ora_Errno_is_Fatal {int ($'ora_errno / 100)})
              {
                &error ("Fatal Oracle Error...sending SIGUSR1");

                kill ("USR1", $$);
              }
          }
	warn "($LDA)\n" if ($DEBUG);
	return $r;
    }
return 0;
}



sub login_noprint
{
local ($r)= "";
    if (!$LDA)
    {
        ($database, $user, $password) = @_;

	########################################
	# Default values for arguments
	########################################

	$database = $StrDatabase if (!$database);
	$user = $StrUser if (!$user);
	$password = $StrPassword if (!$password);

	########################################


        $r = &cache_login($database,$user,$password);
	return $r;
    }
return 0;
}

sub logoff
{
    if ($LDA)
    {
	warn "LOGOFF: $LDA\n" if ($DEBUG);
&cache_logoff();
	&err_check;

	$LDA = '';
    }
}

################################################################
################################################################
# nextval
################################################################
# These are routines to grab current/next sequence numbers
################################################################
################################################################

sub nextval
{
    local ($sequencename) = @_;

    local ($val) = &sql'fetch_row (<<ENDSQL);

Select	$sequencename.NEXTVAL
	From	DUAL

ENDSQL

    $val;
}

################################################################
################################################################
# The following routines create various SQL statments from other data
# structures.
################################################################
################################################################

sub select_tidy_rows	{ &fetch_tidy_rows (&select_statement (@_)); }

sub select_statement
{
    local (*cols, *tables, *cnf, *order) = @_;

    local (@tables_new) = @tables;
    grep ($_ = "$StrSchema$_", @tables_new);

    local ($statement)
	= ("Select\t\t" . join (",\n\t\t", @cols) . "\n"
	   . "\tFrom\t" . join (",\n\t\t", @tables_new) . "\n"
	   . ((@cnf)
	      ? "\tWhere\t" . join ("\n\t  And\t", @cnf) . "\n"
	      : "")
	   . ((@order)
	      ? "\tOrder By " . join (", ", @order) . "\n"
	      : "")
	   );
    
    $statement;
}

sub delete_statement
{
    local ($table, *cnf) = @_;

    local ($statement)
	= ("Delete\tFrom\t$StrSchema$table\n"
	   . ((@cnf)
	      ? "\tWhere\t" . join ("\n\t  And\t", @cnf) . "\n"
	      : "")
	   );

    $statement;
}

sub insert_statement
{
    local ($table, *cols, *vals) = @_;

    local ($statement)
	= ("Insert\tInto\t$StrSchema$table\n"
	   . ((@cols)
	      ? "\t(" . join (",\n\t\t", @cols) . ")\n"
	      : "")
	   . "\tValues (" . join (",\n\t\t", @vals) . ")\n");

    $statement;
}

sub update_statement
{
    local ($table, *settings, *cnf) = @_;

    local ($statement)
	= ("Update\t$StrSchema$table\n"
	   . "\tSet\t\t" . join (",\n\t\t", @settings) . "\n"
	   . ((@cnf)
	      ? "\tWhere\t" . join ("\n\t  And\t", @cnf) . "\n"
	      : "")
	   );

    $statement;
}

################################################################
################################################################
# cnf_predicate
# dnf_predicate
################################################################
# These are routines that build confjunctive/disjunctive normal form
# SQL predicates for placement in SQL where clauses.
# Also add 'order by' to be placed in SQL statement
################################################################
################################################################

sub cnf_predicate
{
    local (@cnf) = @_;

    local ($pred) = ((@cnf)
		     ? "(" . join (" And ", @cnf) . ")"
		     : "1 = 1");

    $pred;
}

sub dnf_predicate
{
    local (@dnf) = @_;

    local ($pred) = ((@dnf)
		     ? "(" . join (" Or ", @dnf) . ")"
		     : "1 = 1");

    $pred;
}

sub equals_predicate
{
    local ($a, $b) = @_;

    (($b ne "")
     ? "$a = " . &quote ($b)
     : "$a IS NULL");
}


################################################################
# Check to see if we are actually running oraperl.
################################################################

if (! defined &'ora_login)
{ 
    &warn ("$0: SQL library requires oraperl");
}

################################################################


sub error {
  local ($a) = @_;
  print STDERR "$a\n";
  if ($statement ne "") {
    print STDERR "Ststement: $statement\n";
    $statement="";
    }
  #die;
  }

sub warn {
  }
sub debug {
  }


1; # Return OK
