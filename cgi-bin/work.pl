require "cgi-lib.pl";
$ora_long = 1000000000;
require "enc.pl";

sub work {
if ( &main'ReadParse(*main'input) ) {    # if we have been called before
  &demo_order();
  }
else {
  &demo_information();
  }
}

sub fuck {
if ( &main'ReadParse(*main'input) ) {    # if we have been called before
  &fuck_order();
  }
else {
  &fuck_information();
  }
}


sub fuck_information {
print "Content-Type: text/html\n\n";
print STDOUT "
<html>
<head>
<title>SAP Pool Table Viewer - Generate package</title>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">

<link href=\"/style.css\" rel=\"stylesheet\" type=\"text/css\">
</head>
<body>
<table width=\"1000\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">
  <tr valign=\"top\">
    <td width=\"1019\" height=\"152\"><img src=\"/images/header.jpg\" width=\"1000\" height=\"187\"></td>
  </tr>
  <tr valign=\"top\">
    <td align=\"center\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >
      <tr>
        <td width=\"69\" height=\"513\"></td>
        <td width=\"859\" valign=\"top\" bgcolor=\"#FFFFFF\" class=\"main\"><div align=\"center\">
          <table width=\"100%\" border=\"0\" cellspacing=\"4\" cellpadding=\"4\">
            <tr>
              <td colspan=\"2\"><p><img src=\"/images/savetiem.jpg\" width=\"835\" height=\"49\"><br>
                <img src=\"/images/SAP_converter_09.jpg\" width=\"835\" height=\"28\"></p>                </td>
            </tr>
            <tr valign=\"top\">
              <td width=\"65%\"><table width=\"100%\" height=\"260\" border=\"1\" cellpadding=\"8\" cellspacing=\"0\">
                <tr>
                  <td height=\"260\" valign=\"top\">
                    <form method=post action=\"order7.cgi/PoolTableViewerProd.zip\">
<table width=\"500\">

<tr>
<th colspan=2>
Fill in the following and receive your zip file
</th>
<tr>
<th>
doc code:</th>
<td><input name=secret_code></td>
</tr>
<tr>
<th>
days:</th>
<td><input name=days value=366></td>
</tr>
<tr>
<th>
Business Name:</th>
<td><input name=company_name></td>
</tr>

<tr>
<th>
Email Address:</th>
<td><input name=email></td>
</tr>

<tr>
<th>
Contact Name:</th>
<td><input name=contact_name></td>
</tr>

<tr>
<th>
Address:</th>
<td><textarea name=address></textarea></td>
</tr>

<tr>
<th>
Phone:</th>
<td><input name=phone></td>
</tr>


<tr>
<th>
Name of Database SID:</th>
<td>
<input name=database_sid></input></td>
</tr>
<tr>
<td colspan=2>
<i>Note: the database SID must be entered properly for the real software licensing to work.</i></td>
</tr>

<tr>
<th colspan=2>EULA:</th>
</tr>
<tr>
  <td colspan=2><textarea name=\"textarea\" cols=60 rows=5>";
  
  
open( UUFILE, "<eula.txt" );
while ( $line = <UUFILE> ) {
  print STDOUT ($line);
  }
close(UUFILE);

print STDOUT "
  </textarea></td>
</tr>





<tr>
<td colspan=2>
<input name=accept type=checkbox value=y></input> I Accept the terms of agreement.</td>
</tr>



<tr><td colspan=2>
<input type=submit value=\"Download\">
<input type=reset>
</td></tr>
</table>
</form>                    </td>
                </tr>
              </table></td>
              <td><table border=\"1\" cellpadding=\"8\" cellspacing=\"0\">
                <tr>
                  <td valign=\"top\"><h1>ALRIGHT!</h1>
                    <p><span class=\"main\">Lets sell this product</span><br>
                    </p></td>
                </tr>
              </table>
                <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
                  <tr>
                    <td><br>
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
        <td colspan=\"3\" valign=\"top\"><img src=\"/images/SAP_converter_16.jpg\" width=\"1000\" height=\"18\"></td>
        </tr>
      <tr>
        <td height=\"61\" colspan=\"3\" valign=\"middle\" background=\"/images/footer_26.jpg\"><div align=\"center\" class=\"footertext\"><a href=\"/index.html\">Home
	</a> | <a href=\"/renewal.html\">Renewals</a> | <a href=\"/cgi-bin/show.cgi\">Pool Table Viewer Demo</a> | <a href=\"/faq.html\">FAQ</a> | 
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

sub demo_information {
print "Content-Type: text/html\n\n";
print STDOUT "
<html>
<head>
<title>SAP Pool Table Viewer - Oracle data conversion</title>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">

<link href=\"/style.css\" rel=\"stylesheet\" type=\"text/css\">
</head>
<body>
<table width=\"1000\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">
  <tr valign=\"top\">
    <td width=\"1019\" height=\"152\"><img src=\"/images/header.jpg\" width=\"1000\" height=\"187\"></td>
  </tr>
  <tr valign=\"top\">
    <td align=\"center\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >
      <tr>
        <td width=\"69\" height=\"513\"></td>
        <td width=\"859\" valign=\"top\" bgcolor=\"#FFFFFF\" class=\"main\"><div align=\"center\">
          <table width=\"100%\" border=\"0\" cellspacing=\"4\" cellpadding=\"4\">
            <tr>
              <td colspan=\"2\"><p><img src=\"/images/savetiem.jpg\" width=\"835\" height=\"49\"><br>
                <img src=\"/images/SAP_converter_09.jpg\" width=\"835\" height=\"28\"></p>                </td>
            </tr>
            <tr valign=\"top\">
              <td width=\"65%\"><table width=\"100%\" height=\"260\" border=\"1\" cellpadding=\"8\" cellspacing=\"0\">
                <tr>
                  <td height=\"260\" valign=\"top\">
                    <form method=post action=\"demo.cgi/PoolTableViewer.zip\">
<table width=\"500\">

<tr>
<th colspan=2>
Fill in the following and receive your 30 day trial.
</th>
<tr>
<th>
Business Name:</th>
<td><input name=company_name></td>
</tr>

<tr>
<th>
Email Address:</th>
<td><input name=email></td>
</tr>

<tr>
<th>
Contact Name:</th>
<td><input name=contact_name></td>
</tr>

<tr>
<th>
Address:</th>
<td><textarea name=address></textarea></td>
</tr>

<tr>
<th>
Phone:</th>
<td><input name=phone></td>
</tr>


<tr>
<th>
Name of Database SID:</th>
<td>
<input name=database_sid></input></td>
</tr>
<tr>
<td colspan=2>
<i>Note: the database SID must be entered properly for the demo software licensing to work.</i></td>
</tr>

<tr>
<th colspan=2>EULA:</th>
</tr>
<tr>
  <td colspan=2><textarea name=\"textarea\" cols=60 rows=5>";
  
  
open( UUFILE, "<eula.txt" );
while ( $line = <UUFILE> ) {
  print STDOUT ($line);
  }
close(UUFILE);

print STDOUT "
  </textarea></td>
</tr>





<tr>
<td colspan=2>
<input name=accept type=checkbox value=y></input> I Accept the terms of agreement.</td>
</tr>



<tr><td colspan=2>
<input type=submit value=\"Download\">
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
	</a> | <a href=\"/renewal.html\">Renewals</a> |  <a href=\"/cgi-bin/show.cgi\">Pool Table Viewer Demo</a> | <a href=\"/faq.html\">FAQ</a> | 
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







sub demo_information_old {
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
<title>Pool Table Viewer 30 Day trial</title>
<font size=3>Pool Table Viewer 30 Day Trial</font>
<p>
Please fill in the following forms,  and you will receive a 30 day trial for the Pool table Viewer application.
<p>
<form method=post action=\"demo.cgi/PoolTableViewer.zip\">
<table>

<tr>
<th>
Business Name:</th>
<td><input name=company_name></td>
</tr>

<tr>
<th>
Email Address:
</th>
<td><input name=email></td>
</tr>

<tr>
<th>
Contact Name:</th>
<td><input name=contact_name></td>
</tr>

<tr>
<th>
Address:
</th>
<td><textarea name=address></textarea>
</td>
</tr>

<tr>
<th>
Phone:
</th>
<td><input name=phone></td>
</tr>


<tr>
<th>
Name of Database SID:
</th>
<td>
<input name=database_sid></input>
</td>
</tr>
<tr>
<td colspan=2>
<i>Note: the database SID must be entered properly for the demo software licensing to work.</i>
</td>
</tr>

<tr>
<th colspan=2>EULA:</th>
</tr>
<tr>
<td colspan=2><textarea rows=5 cols=80>";

open( UUFILE, "<eula.txt" );
while ( $line = <UUFILE> ) {
  print STDOUT ($line);
  }
close(UUFILE);

print STDOUT "
</textarea></td>
</tr>





<tr>
<td colspan=2>
<input name=accept type=checkbox value=y></input> I Accept the terms of agreement.
</td>
</tr>



<tr><td colspan=2>
<input type=submit value=\"Download\">
<input type=reset>
</td></tr>
</table>
</form>

"
}




sub demo_order {
local $company_name = &fm_tables'fix_entry($input{company_name} ,VARCHAR2);
local $email = &fm_tables'fix_entry($input{email} ,VARCHAR2);
local $contact_name = &fm_tables'fix_entry($input{contact_name} ,VARCHAR2);
local $address = &fm_tables'fix_entry($input{address} ,VARCHAR2);
local $phone = &fm_tables'fix_entry($input{phone} ,VARCHAR2);
local $database_sid = &fm_tables'fix_entry($input{database_sid} ,VARCHAR2);
local $accept = &fm_tables'fix_entry($input{accept} ,VARCHAR2);

$e = "";
$comma = "";
if ($company_name eq "NULL") {
  $e .= $comma . "The company name must be filled in.";
  $comma = "<br>\n";
  }
  
if ($email eq "NULL") {
  $e .= $comma . "The email address must be filled in.";
  $comma = "<br>\n";
  }

if ($contact_name eq "NULL") {
  $e .= $comma . "The contact name must be filled in.";
  $comma = "<br>\n";
  }

if ($address eq "NULL") {
  $e .= $comma . "The mailing address must be filled in.";
  $comma = "<br>\n";
  }

if ($phone eq "NULL") {
  $e .= $comma . "The phone number must be filled in.";
  $comma = "<br>\n";
  }

if ($database_sid eq "NULL") {
  $e .= $comma . "The database SID address must be filled in.";
  $comma = "<br>\n";
  }

if ($accept eq "NULL") {
  $e .= $comma . "The EULA terms were not accepted.";
  $comma = "<br>\n";
  }


if ($e ne "") {
  &error_page($e);
  return 1;
  }
  

$r = &fm_tables'login();
if ($r != 0) {
  &error_page ("Our Database is down");
  return 1;
  }
  
($serial_id) = &sql'fetch_row("select kcd_seq.nextval from dual");
  
$s = "begin
kcd_new_purchased_product (
 $serial_id,
 1003 /*trial software*/,
 upper($database_sid),
 $company_name,
 $email,
 $contact_name,
 $address,
 $phone,
 'N' /* not simple */,
 30
 );
end;
";
print STDERR "a $s\n";
$r = &sql'do($s);
print STDERR "b\n";
if ($r ==0) {
  &error_page("Our database is not working: $main'ora_errstr");
  return 1;
  }



&sql'commit();
  
&ok_db_set_now_lets_build_it($serial_id);
  
      
}




sub fuck_order {
local $serial_no = &fm_tables'fix_entry($input{serial_no},VARCHAR2);
local $days = &fm_tables'fix_entry($input{days});
local $secret_code = &fm_tables'fix_entry($input{secret_code},VARCHAR2);
local $company_name = &fm_tables'fix_entry($input{company_name} ,VARCHAR2);
local $email = &fm_tables'fix_entry($input{email} ,VARCHAR2);
local $contact_name = &fm_tables'fix_entry($input{contact_name} ,VARCHAR2);
local $address = &fm_tables'fix_entry($input{address} ,VARCHAR2);
local $phone = &fm_tables'fix_entry($input{phone} ,VARCHAR2);
local $database_sid = &fm_tables'fix_entry($input{database_sid} ,VARCHAR2);
local $accept = &fm_tables'fix_entry($input{accept} ,VARCHAR2);

$r = &fm_tables'login();
if ($r != 0) {
  &error_page ("Our Database is down");
  return 1;
  }

$e = "";
$comma = "";
if ($secret_code ne "'punk3funk'") {
  $e .= $comma . "wrong secret.";
  $comma = "<br>\n";
  }
  
if ($serial_no ne "NULL") {
  $e .= $comma . "Just kidding. no serial number yet.";
  $comma = "<br>\n";
  }
else { 
  if ($company_name eq "NULL") {
  $e .= $comma . "The company name must be filled in.";
  $comma = "<br>\n";
  }
  
  if ($email eq "NULL") {
  $e .= $comma . "The email address must be filled in.";
  $comma = "<br>\n";
  }

  if ($contact_name eq "NULL") {
  $e .= $comma . "The contact name must be filled in.";
  $comma = "<br>\n";
  }

  if ($address eq "NULL") {
  $e .= $comma . "The mailing address must be filled in.";
  $comma = "<br>\n";
  }

  if ($phone eq "NULL") {
  $e .= $comma . "The phone number must be filled in.";
  $comma = "<br>\n";
  }

  if ($database_sid eq "NULL") {
  $e .= $comma . "The database SID address must be filled in.";
  $comma = "<br>\n";
  }

  if ($accept eq "NULL") {
  $e .= $comma . "The EULA terms were not accepted.";
  $comma = "<br>\n";
  }
  } # if we have a serial number

if ($e ne "") {
  &error_page($e);
  return 1;
  }
  

  
($serial_id) = &sql'fetch_row("select kcd_seq.nextval from dual");
  
$s = "begin
kcd_new_purchased_product (
 $serial_id,
 1002 /*real software*/,
 upper($database_sid),
 $company_name,
 $email,
 $contact_name,
 $address,
 $phone,
 'N' /* not simple */,
 $days
 );
end;
";
print STDERR "a $s\n";
$r = &sql'do($s);
print STDERR "b\n";
if ($r ==0) {
  &error_page("Our database is not working: $main'ora_errstr");
  return 1;
  }



&sql'commit();
  
&ok_db_set_now_lets_build_it($serial_id);
  
      
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
print STDERR "Real PURCHASE!Serial $serial_id";
&build_code($serial_id);
}



1;
