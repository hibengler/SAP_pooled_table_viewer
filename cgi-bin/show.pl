require "cgi-lib.pl";
$ora_long = 1000000000;
require "enc.pl";

sub work {
if ( &main'ReadParse(*main'input) ) {    # if we have been called before
  &show_work();
  }
else {
  &show_information();
  }
}


sub show_work {
if ($main'input{page} eq "1") {
  &show_page1();
  }
elsif ($main'input{page} eq "2") {
  &show_page2();
  }

elsif ($main'input{page} eq "3") {
  &show_page3();
  }
else {
  &show_page1();
  }
}


sub show_information {
print "Content-Type: text/html\n\n";
print STDOUT "
<html>
<head>
<title>SAP Pool Table Viewer - Oracle data conversion Show examples</title>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">

<link href=\"/style.css\" rel=\"stylesheet\" type=\"text/css\">
</head>
<body>
<table width=\"1000\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">
  <tr valign=\"top\">
    <td width=\"1019\" height=\"152\"><img src=\"/images/header.jpg\" width=\"1000\" height=\"187\"></td>
  </tr>
  <tr valign=\"top\">
    <td align=\"center\">
    <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >
      <tr>
        <td width=\"69\" height=\"513\"></td>
        <td width=\"859\" valign=\"top\" bgcolor=\"#FFFFFF\" class=\"main\"><div align=\"center\">
          <table width=\"100%\" border=\"0\" cellspacing=\"4\" cellpadding=\"4\">
            <tr>
              <td colspan=\"2\"><p><font size=7>Examples</font><br>
                <img src=\"/images/SAP_converter_09.jpg\" width=\"835\" height=\"28\"></p>                </td>
            </tr>
            <tr valign=\"top\">
              <td width=\"65%\"><table width=\"100%\" 
	      height=\"260\" border=\"1\" cellpadding=\"8\" cellspacing=\"0\">
                <tr>
                  <td height=\"260\" valign=\"top\">
                    <form method=post action=\"show.cgi\">
<table width=\"500\">

<tr>
<th colspan=2>
Choose one of the pool tables as an example
</th>
<tr>
<td colspan=2>
";

&sql'login(ernie,sapsr3p_demo,demoit);

&fm_tables'show_descriptor_as_selection("select l.table_name,l.table_name||' - '||t.ddtext text
 from examples l,sapsr3.dd02t t
   where 
      t.ddlanguage(+) = decode(l.table_name,l.table_name,'E','E')
      and t.tabname (+) = l.table_name
      order by 1",0,1,pool_table,"",1);
      

print STDOUT "
</tr>








<tr><td colspan=2>
<input type=submit value=\"Proceed\">
<input type=reset>
</td></tr>
</table>
</form>                    </td>
                </tr>
              </table></td>
              <td><table border=\"1\" cellpadding=\"8\" cellspacing=\"0\">
                <tr>
                  <td valign=\"top\"><h1>Why make a <br>
                    Pool Table Viewer</h1>
                    <p><span class=\"main\">Hibbard Engler,  the company founder,  was working on a transition of a business to SAP&reg;,  when he found out that reading from the Oracle&reg; database directly was a &quot;big no-no&quot;.  Wanting to make SAP&reg; compatible with his web based reporting software,  and undaunted by such a statement, Hibbard looked at ways to read and present the pool table directly.  After much work and time,  this new product is the end result.</span><br>
                    </p></td>
                </tr>
              </table>
                <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
                  <tr>
                    <td><br>
                        <img src=\"/images/freedata.gif\" width=\"283\" height=\"187\"></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          <br>
        </div></td>
        <td width=\"72\">&nbsp;</td>
      </tr>
      <tr>
        <td colspan=\"3\" valign=\"top\"><img src=\"/images/SAP_converter_16.jpg\" width=\"1000\" height=\"18\"></td>
        </tr>
      <tr>
        <td height=\"61\" colspan=\"3\" valign=\"middle\" background=\"/images/footer_26.jpg\"><div align=\"center\" class=\"footertext\"><a href=\"/index.html\">Home
	</a> | <a href=\"/renewal.html\">Renewals</a> | Pool Table Viewer Demo</a> | <a href=\"/faq.html\">FAQ</a> | 
	<a href=\"/saving.html\">Saving Money with PTV</a> | <a href=\"/contact.html\">Contact</a></div></td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>Brought 
to you by </FONT><A href=\"http://www.kcd.com\"><FONT>Killer Computer Development, 
LLC.</FONT></A><FONT> <BR><BR></FONT><FONT size=1><FONT>Oracle, JD Edwards, 
PeopleSoft, and Siebel are registered trademarks of Oracle Corporation and/or 
its affiliates.<BR>SAP and R/3; are the trademark(s) or registered trademark(s) 
of SAP AG in Germany and in several other countries. <FONT 
size=+0></FONT></FONT></FONT></BODY></HTML>

"
}






sub heading {
local ($pname,$pdescription,$explanation) = @_;
print "Content-Type: text/html\n\n";
print STDOUT "
<html>
<head>
<title>SAP Pool Table Viewer - Oracle data conversion Example Pool table $pname</title>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">

<link href=\"/style.css\" rel=\"stylesheet\" type=\"text/css\">
</head>
<body>
<table width=\"1000\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">
  <tr valign=\"top\">
    <td width=\"1019\" height=\"152\"><img src=\"/images/header.jpg\" width=\"1000\" height=\"187\"></td>
  </tr>
  <tr valign=\"top\">
    <td align=\"center\">
    <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >
      <tr>
        <td width=\"69\" height=\"513\"></td>
        <td width=\"859\" valign=\"top\" bgcolor=\"#FFFFFF\" class=\"main\"><div align=\"center\">
          <table width=\"100%\" border=\"0\" cellspacing=\"4\" cellpadding=\"4\">
            <tr>
              <td colspan=\"2\"><p><font size=7>Example: $pname </font>$pdescription<br>
                $explanation
		</p>                </td>
            </tr>
            <tr valign=\"top\">
              <td width=\"100%\"><table width=\"100%\" 
	      height=\"260\" border=\"1\" cellpadding=\"8\" cellspacing=\"0\">
                <tr>
                  <td height=\"260\" valign=\"top\">
<table width=\"700\">";

}




sub footing {
print STDOUT "</table>
                    </td>
                </tr>
              </table></td>
            </tr>
          </table>
          <br>
        </div></td>
        <td width=\"72\">&nbsp;</td>
      </tr>
      <tr>
        <td height=\"61\" colspan=\"3\" valign=\"middle\" background=\"/images/footer_26.jpg\"><div align=\"center\" class=\"footertext\"><a href=\"/index.html\">Home
	</a> | <a href=\"/renewal.html\">Renewals</a> | Pool Table Viewer Demo</a> | <a href=\"/faq.html\">FAQ</a> | 
	<a href=\"/saving.html\">Saving Money with PTV</a> | <a href=\"/contact.html\">Contact</a></div></td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>Brought 
to you by </FONT><A href=\"http://www.kcd.com\"><FONT>Killer Computer Development, 
LLC.</FONT></A><FONT> <BR><BR></FONT><FONT size=1><FONT>Oracle, JD Edwards, 
PeopleSoft, and Siebel are registered trademarks of Oracle Corporation and/or 
its affiliates.<BR>SAP and R/3; are the trademark(s) or registered trademark(s) 
of SAP AG in Germany and in several other countries. <FONT 
size=+0></FONT></FONT></FONT></BODY></HTML>

"
}




sub show_page1 {
local $pool_table = &fm_tables'fix_entry($input{pool_table} ,VARCHAR2);
&sql'login(ernie,sapsr3p_demo,demoit);

($test) = &sql'fetch_row("select 1 from user_views where view_name=$pool_table");
if (!($test)) {
  &error_page("Invalid pool table");
  return 1;
  }
($pname,$sqltab) = &sql'fetch_row("select tabname,sqltab from sapsr3.dd02l
                                   where tabname=$pool_table");
($pdescription) = &sql'fetch_row("select ddtext
                      from sapsr3.dd02t where tabname=$pool_table
                                  and ddlanguage='E'");
$copy = "Pooled tables are stored in a cryptic format in Oracle.  The following shows the differences between
what is available in SAP, and Oracle." .
"<br><a href=\"show.cgi\">Prev " .
"<a href=\"show.cgi?pool_table=$pname&page=2\">Next";

&heading($pname,$pdescription,$copy);

print STDOUT "
<tr><td>The pooled table<br>";

print STDOUT "<table border=1><tr><th>Column</th><th>Datatype</th></tr>\n";
$csr=&sql'open(
   "select column_name,data_type ,t.ddtext from user_tab_Columns ,sapsr3.dd03t t 
   where table_name =$pool_table
   and t.tabname (+) = user_tab_columns.table_name
   and t.fieldname (+) = user_tab_columns.column_name
   and t.ddlanguage (+) = decode(user_tab_columns.table_name,'s','E','E')
   and column_name not in ('VARKEY')
   order by column_id");
while (@row=&sql'fetch($csr)) {
  ($colname,$dt,$ddtext) = @row;
  print STDOUT "<tr><td>$colname</td><td>$dt</td></tr>\n";
  }
  &sql'close($csr);
print STDOUT "</table>";

print STDOUT "</td><td valign=top>What is in the Oracle table $sqltab:<br>
";
print STDOUT "<table border=1><tr><th>Column</th><th>Datatype</th><th>Description</th></tr>\n";
$csr=&sql'open(
   "select column_name,data_type ,
   decode(column_name,'TABNAME','The name of the Pooled table.',
                      'VARKEY','A concatenation of all the key fields.',
		      'DATALN','Internal code number holding the length of the data.',
		      'VARDATA','A Cobol record storing the pooled data.')
		      descr
   from all_tab_Columns 
   where owner='SAPSR3'
     and table_name ='$sqltab'
   order by column_id");


while (@row=&sql'fetch($csr)) {
  ($colname,$dt,$ddtext) = @row;
  print STDOUT "<tr><td>$colname</td><td>$dt</td><td>$ddtext</td></tr>\n";
  }
&footing();
}









sub show_page2 {
local $pool_table = &fm_tables'fix_entry($input{pool_table} ,VARCHAR2);
&sql'login(ernie,sapsr3p_demo,demoit);

($test) = &sql'fetch_row("select 1 from user_views where view_name=$pool_table");
if (!($test)) {
  &error_page("Invalid pool table");
  return 1;
  }
($pname,$sqltab) = &sql'fetch_row("select tabname,sqltab from sapsr3.dd02l
                                   where tabname=$pool_table");
($pdescription) = &sql'fetch_row("select ddtext
                      from sapsr3.dd02t where tabname=$pool_table
                                  and ddlanguage='E'");
				  
$copy = "Without Pool Table Viewer,  Retriving data from Oracle is difficult.
Here is an example query" .
"<br><a href=\"show.cgi?pool_table=$pname&page=1\">Prev " .
"<a href=\"show.cgi?pool_table=$pname&page=3\">Next";

&heading($pname,$pdescription,$copy);

print STDOUT "
<tr><td>Command: SELECT varkey,dataln,vardata FROM $sqltab WHERE tabname=$pool_table
<br>";

&fm_tables'display_table_simple("SELECT varkey,dataln,vardata FROM sapsr3.$sqltab 
WHERE tabname=$pool_table
 and rownum<11");


&footing();
}








sub show_page3 {
local $pool_table = &fm_tables'fix_entry($input{pool_table} ,VARCHAR2);
&sql'login(ernie,sapsr3p_demo,demoit);

($test) = &sql'fetch_row("select 1 from user_views where view_name=$pool_table");
if (!($test)) {
  &error_page("Invalid pool table");
  return 1;
  }
($pname,$sqltab) = &sql'fetch_row("select tabname,sqltab from sapsr3.dd02l
                                   where tabname=$pool_table");
($pdescription) = &sql'fetch_row("select ddtext
                      from sapsr3.dd02t where tabname=$pool_table
                                  and ddlanguage='E'");
				  
$copy = "With Pool Table Viewer,  Retriving data from Oracle is easy.
Here is an example query" .
"<br><a href=\"show.cgi?pool_table=$pname&page=2\">Prev </a>" .
"<a href=\"show.cgi\">Again </a>" ;

&heading($pname,$pdescription,$copy);

print STDOUT "
<tr><td>Command: SELECT * FROM $pname
<br>";

&fm_tables'display_table_simple("SELECT * FROM $pname
WHERE rownum<11");


&footing();
}


sub error_page {
local ($e) = @_;
print "Content-Type: text/html\n\n";
print STDOUT "
<STYLE type=text/css>BODY {
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
</style>
I am sorry,  but we had some errors processing your form:
<p>
$e
<p>
Please go back and try again.
";
}

sub ok_db_set_now_lets_build_it {
local ($serial_id) = @_;
print STDERR "Serial $serial_id";
&build_code($serial_id);
}



1;
