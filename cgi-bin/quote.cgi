#!/usr/bin/perl
require "sql.pl";
require "fm_tables.pl";

require "cgi-lib.pl";

sub work {
if ( &main'ReadParse(*main'input) ) {    # if we have been called before
  &thank_you()
  }
else {
  &redirect_quote();
  }
}

sub redirect_quote {
print "Content-Type: text/html\n\n

I'm sorry,  I didn't get that.  Please press back and try again.<hr>";
}


sub thank_you {
print "Content-Type: text/html\n\n";

print "<STYLE type=text/css>BODY {
	BACKGROUND-COLOR: #99cccc
}
A {
	
}
A:link {
	
}
A:visited {
	
}
A:hover {
	
}
A:active {
	
}
H1 {
	
}
H2 {
	
}
H3 {
	
}
H4 {
	
}
H5 {
	
}
H6 {
	
}
</style><title>Thank You</title>
<font size=6><b>Thank You!</b></font><br><br>
Thank you for the quote request.  You will be emailed with the quote shortly!";



foreach $key ( keys(%main'input) ) {
 print STDERR "	$key =      $main'input{$key}\n";
	    }


	    
$call =
"| /usr/bin/mail -s \"Quote request\" hib@kcd.com killercooldevelopment@gmail.com";

        open( MAIL, $call );
foreach $key ( keys(%main'input) ) {
 print MAIL "	$key =      $main'input{$key}\n";
	    }


close(MAIL);
	    

}



&work();

