use Date::Manip;
use Date::Calc;
use Spreadsheet::WriteExcel::Big;
use Spreadsheet::WriteExcel::Utility;
package fm_tables;
# Version 1.1.1.1






sub ajax_init {
print STDOUT "
<html>
<body>
<script type=\"text/javascript\">
function ajaxFunction()
  {
  var xmlHttp;
  try
    {
    // Firefox, Opera 8.0+, Safari
    xmlHttp=new XMLHttpRequest();
    }
  catch (e)
    {
    // Internet Explorer
    try
      {
      xmlHttp=new ActiveXObject(\"Msxml2.XMLHTTP\");
      }
    catch (e)
      {
      try
        {
        xmlHttp=new ActiveXObject(\"Microsoft.XMLHTTP\");
        }
      catch (e)
        {
        alert(\"Your browser does not support AJAX!\");
        return false;
        }
      }
    }

xmlHttp.onreadystatechange=function()
  {
  if(xmlHttp.readyState==4)
    {
    document.myForm.time.value=xmlHttp.responseText;
    }
  }
    xmlHttp.open(\"GET\",\"time.asp\",true);
    xmlHttp.send(null);
}
</script>
<form name=\"myForm\">
Name: <input type=\"text\"
onkeyup=\"ajaxFunction();\" name=\"username\" />
Time: <input type=\"text\" name=\"time\" />
</form>

</body>
</html>
";
}


sub display_spreadsheet_simple {
local ($select_statement,$from,$pre) = @_;
local ($numrows) = (0);
local ($breakx) = (0);
local ($rowtext) = ("");
local ($worksheet,$selectsheet) = ("","");
local ($datetime);
$datetime = `date`;
my $workbook = Spreadsheet::WriteExcel::Big->new("/tmp/xx$$.xls");
$worksheet = $workbook->add_worksheet();
$selectsheet = $workbook->add_worksheet();
$selectsheet->write_string(2,0,"User Name");
$selectsheet->write_string(2,1,$sql'user);
$selectsheet->write_string(3,0,"Database");
$selectsheet->write_string(3,1,$sql'database);

$selectsheet->write_string(4,0,"date");
$selectsheet->write_string(4,1,$datetime);

$selectsheet->write_string(5,0,"Statement");
$selectsheet->write_string(5,1,$select_statement);
&add_query_to_spreadsheet ($worksheet,0,0,$select_statement);
$workbook->close();

print "Content-type: application/vnd.ms-excel\n\n";
system("cat /tmp/xx$$.xls");
system("rm -f 2>/dev/null xx$$.xls");

}

sub add_query_to_spreadsheet {
local ($worksheet,$startrow,$startcol,$select_statement)= @_;
local ($numrows) = (0);
local ($breakx) = (0);
local ($rowtext) = ("");
local ($col) = ($startcol);
#
# Compute the headings
#
if (!($csr = &sql'open($select_statement))) {
  local ($x) = "";
  $x = $main'ora_errstr; 
  $worksheet->write($startrow,$startcol,"Error:$x");
  return(0);
  }
# If the cursor doesn't open, we have an error

if (@row = &sql'fetch($csr)) { # need a row
  @fmt = &main'ora_titles($csr,0);
  $heading="";
  $count=0;
  while ($count < @fmt) {
    $worksheet->write($startrow,$col ,$fmt[$count]);
    $col++;
    $count++;
    }

  # print out the first row we got
  $count = 0;
  $col = $startcol;
  while ($count < @row) {
    if ((substr($row[$count],0,1) eq "=")) {
        $worksheet->write_string($startrow+1+$numrows,$col,$row[$count]);
    } else {
    	$worksheet->write($startrow+1+$numrows,$col,$row[$count]);
     	}
    $col++; 
    $count++;
    }
  $numrows++;
  $breakx++;
  #
  # Get all the other rows and print them out too!
  #
  while (@row = &sql'fetch($csr)) {
    if (($startrow+1+$numrows) > 65000) {
       $worksheet->write(($startrow+1+$numrows),$col,"...");
       break;
       }
    $count = 0;
    $col = $startcol;
    while ($count < @row) {
      if ((substr($row[$count],0,1) eq "=")) {
        $worksheet->write_string($startrow+1+$numrows,$col,$row[$count]);
	} else {
        $worksheet->write($startrow+1+$numrows,$col,$row[$count]);
	}
      $col++;
      $count++;
      }
    $numrows++;
    $breakx++;
    }
  }
else {
  $worksheet->write($startrow,$startcol,"No rows found");
  return(0);
  }
&sql'close($csr);

return(0);
}



#
#
# This module has many subs tp handle the table stuff
#
#
#
sub display_table_simple {
local ($select_statement,$from,$pre) = @_;
local ($numrows) = (0);
local ($breakx) = (0);
local ($rowtext) = ("");

#
# Compute the headings
#
if (!($csr = &sql'open($select_statement))) {
  &query_error($select_statement,$main'ora_errstr);
  return(0);
  }
# If the cursor doesn't open, we have an error

if (@row = &sql'fetch($csr)) { # need a row
  @fmt = &main'ora_titles($csr,0);
  $heading="";
  $count=0;
  while ($count < @fmt) {
    $heading = $heading . "<TH>" . $fmt[$count] . "</TH>";
    $count++;
    }
  print STDOUT "<table border=1>";
  print STDOUT "<tr></tr><tr>$heading</tr>\n";
  

  # print out the first row we got
  $count = 0;
  while ($count < @row) {
    $rowtext .= "<td valign=top>" . &t2html($row[$count],$pre) . "</td>";
    $count++;
    }
  print STDOUT "<tr>$rowtext</tr>\n";
  $numrows++;
  $breakx++;
  #
  # Get all the other rows and print them out too!
  #
  while (@row = &sql'fetch($csr)) {
    if ($breakx >=100) {
      print STDOUT "</td></tr></table>\n";
      print STDOUT "<table border=1> <tr> <tr>$heading</tr>\n";
      $breakx = 0;
      }
    # print out the first row we got
    $rowtext="";
    $count = 0;
    while ($count < @row) {
      $rowtext .= "<td valign=top>" . &t2html($row[$count],$pre) . "</td>";
      $count++;
      }
    print STDOUT "<tr>$rowtext</tr>\n";
    $numrows++;
    $breakx++;
    }
  }
else {
  print STDOUT "No rows found";
  return(0);
  }
print STDOUT "</td></tr></table>";
&sql'close($csr);

return(1);
}


sub t2urlval {
local ($t) = @_;
$t =~ s/:/%7f;/g;
$t =~ s/\+/%2B/g;
$t =~ s/ /+/g;
return $t;
}

# converts text to a vlaue that can be stored in a value= clause.
# adds the quotes too
sub t2hval {
local ($t) = @_;
$t =~ s/\\/\\\\/g;
$t =~ s/\"/\\\";/g;
return ("\"" . $t . "\"");
}

# converts text in a string to something that html will print out
sub t2html {
local ($t,$pre) = @_;
local $slash = "/";
$t =~ s/\&/\&amp;/g;
$t =~ s/\</\&lt;/g;
$t =~ s/\>/\&gt;/g;
$t =~ s/\"/\&quot;/g;

if ($pre ne "") {
  $t =~ s/\r\n/<br$slash>/g;
  $t =~ s/\n/<br$slash>/g;
  $t =~ s/\r/<br$slash>/g;
  }
return $t;
}




sub yes_no_maybee {
local ($name,$yesprompt,$noprompt,$mayprompt,$value,$orientation) = @_;
if ($yesprompt eq "") {$yesprompt = "Yes";}
if ($noprompt eq "") {$noprompt = "No";}
if ($mayprompt eq "") {$mayprompt = "";}
$yesprompt = &t2html($yesprompt);
$noprompt = &t2html($noprompt);
$mayprompt = &t2html($mayprompt);
if ($orientation eq "V") {
  print STDOUT "<table cellpadding='0' cellspacing='0' border='0'>";
}
else {
  print STDOUT "<table border='0'>";
}
print STDOUT "
  <tr>
    <td><input name=$name type='radio' value='Y' ";
if ($value eq "Y") {print STDOUT "checked='Y'";}
print STDOUT ">$yesprompt </td>";
if ($orientation eq "V") {print STDOUT "</tr> <tr>";}
print STDOUT "
    <td>
<input name=$name type=radio value=N ";
if ($value eq "N") {print STDOUT "checked='Y'";}
print STDOUT ">$noprompt </td>";
if ($orientation eq "V") {print STDOUT "</tr> <tr>";}
print STDOUT "
    <td>
<input name=$name type=radio value=\"\" ";
if ($value eq "") {print STDOUT "checked='Y'";}
print STDOUT ">$mayprompt
    </td>
  </tr>
</table>";
}







sub yes_no {
local ($name,$value) = @_;
print STDOUT "<input name='$name' type='checkbox' value='Y'";
if ($value eq "Y") {print STDOUT " checked='Y'";}
print STDOUT ">";
}






sub show_descriptor_as_table {
local ($select_statement,$multi,$hide_first_field,$name) = @_;
local ($numrows) = (0);
local ($breakx) = (0);
local ($rowtext) = ("");   
#
# Compute the headings
#
if (!($csr = &sql'open($select_statement))) {
  &query_error($select_statement,$main'ora_errstr);
  return(0);
  }
# If the cursor doesn't open, we have an error

if (@row = &sql'fetch($csr)) { # need a row
  @fmt = &main'ora_titles($csr,0);
  $heading="";
  if ($hide_first_field==1) {
    $count=1;}
  else
    {$count=0;}
  while ($count < @fmt) {
    $heading = $heading . "<TH>" . $fmt[$count] . "</TH>";
    $count++;
    } 
  print STDOUT "<table border=1>";
  print STDOUT "<tr></tr><tr>$heading<th>Select</th></tr>\n";
  

  # print out the first row we got
  if ($hide_first_field==1) {
    $count=1;}
  else
    {$count=0;}
  while ($count < @row) {
    $rowtext .= "<td>" . &t2html($row[$count]) . "</td>";
    $count++;
    }
  print STDOUT "<tr>$rowtext";
  if ($multi == 1) {
    print STDOUT 
      "<td><input type='checkbox' name='$name' value="
       . &t2hval($row[0]) . "></td></tr>\n";
  } else {
    print STDOUT "<td><input type='radio' name='$name' value="
     . &t2hval($row[0]) . "></td></tr>\n";
  }  
  $numrows++;
  $breakx++;
  #
  # Get all the other rows and print them out too!
  #
  while (@row = &sql'fetch($csr)) {
    if ($breakx >=100) {
      print STDOUT "</td></tr></table>\n";
      print STDOUT "<table border='1'> <tr> <tr>$heading<th>Select</th></tr>\n";
      $breakx = 0;
      }
    # print out the first row we got
    $rowtext="";
    if ($hide_first_field==1) {
      $count=1;}
    else
      {$count=0;}
    while ($count < @row) {
      $rowtext .= "<td>" . &t2html($row[$count]) . "</td>";
      $count++;
      }
    print STDOUT "<TR>$rowtext";
    if ($multi == 1) {
      print STDOUT "<td><input type='checkbox' name='$name' value=" .
        &t2hval($row[0]) . "></td></tr>\n";
    } else {
      print STDOUT "<td><input type='radio' name='$name' value=" .
        &t2hval($row[0]) . "></td></tr>\n";
    }  
    $numrows++;
    $breakx++;
    }
  
  }
else {
  print STDOUT "No rows found";
  return(0);
  }
print STDOUT "</td></tr></table>";
&sql'close($csr);

return(1);
}



sub href_in_app {
# formname - name of the form
# modename - mode
# extra - extra parameters
# alt - tet for alt
local ($formname,$modename,$extra,$alt)= @_;
if ($alt eq "") {
  print STDOUT 
  "<a href=\"?module_id=$formname&session_id=$session_id&mode=$modename$extra\">";
  }
else {
  print STDOUT 
  "<a href=\"?module_id=$formname&session_id=$session_id&mode=$modename$extra\""
  . " alt=" . &t2hval($alt) . ">";
  }
}

sub href_in_app_string {
# formname - name of the form
# modename - mode
# extra - extra parameters
# alt - tet for alt
local ($formname,$modename,$extra,$alt)= @_;
local ($a) = "";
if ($alt eq "") {
  $a .=
  "<a href=\"?module_id=$formname&session_id=$session_id&mode=$modename$extra\">";
  }
else {
  $a .=
  "<a href=\"?module_id=$formname&session_id=$session_id&mode=$modename$extra\""
  . " alt=" . &t2hval($alt) . ">";
  }
$a;
}




sub show_descriptor_as_table_of_links {
#
# select statement something like select rowid,etc from wherever
# fieldname - usually rowids
# formname - name of the form
# modname - name of the mode to go to 
local ($select_statement,$fieldname,$formname,$modename) = @_;
local ($numrows) = (0);
local ($breakx) = (0);
local ($rowtext) = ("");   
#
# Compute the headings
#
if (!($csr = &sql'open($select_statement))) {
  &query_error($select_statement,$main'ora_errstr);
  return(0);
  }
# If the cursor doesn't open, we have an error

if (@row = &sql'fetch($csr)) { # need a row
  @fmt = &main'ora_titles($csr,0);
  $heading="";
  $count=1;
  while ($count < @fmt) {
    $heading = $heading . "<TH>" .$fmt[$count] . "</TH>";
    $count++;
    } 
  print STDOUT "<table border=1>";
  print STDOUT "<tr></tr><tr>$heading</tr>\n";
  
  $atext = "<a href=\"?module_id=$formname&app_id=$app_id&session_id=$session_id&mode=$modename&$fieldname=" .
                          &t2urlval($row[0]) . "\">";
  $rowtext="";
  # print out the first row we got
  $count=1;
  while ($count < @row) {
    if ($count == 1) {
      if ($row[$count] eq "") {$row[$count]="_";}
      $rowtext .= "<td>$atext" . &t2html($row[$count]) . "</a></td>";
      }
    else {
      $rowtext .= "<td>" . &t2html($row[$count]) . "</td>";
    }
    $count++;
    }
    
  print STDOUT "<tr>$rowtext</tr>\n";
  $numrows++;
  $breakx++;
  #
  # Get all the other rows and print them out too!
  #
  while (@row = &sql'fetch($csr)) {
    if ($breakx >=100) {
      print STDOUT "</td></tr></table>\n";
      print STDOUT "<table border=1> <tr> <tr>$heading</tr>\n";
      $breakx = 0;
      }
    # print out the first row we got
    $rowtext="";
    $atext = "<a href=\"?module_id=$formname&app_id=$app_id&session_id=$session_id&mode=$modename&$fieldname=" .
                          &t2urlval($row[0]) . "\">";
    $count=1;
    while ($count < @row) {
      if ($count == 1) {
        if ($row[$count] eq "") {$row[$count]="_";}
        $rowtext .= "<td>$atext" . &t2html($row[$count]) . "</a></td>";
        }
      else {
        $rowtext .= "<td>" . &t2html($row[$count]) . "</td>";
      }
      $count++;
      }
    
    print STDOUT "<tr>$rowtext</tr>\n";
    $numrows++;
    $breakx++;
    }
  
  }
else {
  print STDOUT "No rows found";
  return(0);
  }
print STDOUT "</td></tr></table>";
&sql'close($csr);

return(1);
}




# this function is used go gasther values and create a string with values
# concatanated with "\0".  This list of values is used to identify 
# what values are selected for multi type selections.
sub gather_assigned_values {
local ($select_statement) = @_;
$value = "";
if (!($csr = &sql'open($select_statement))) {
  &query_error($select_statement,$main'ora_errstr);
  return("");
  }
$split = "";
while (@row = &sql'fetch($csr)) {
  $value .= $split . $row[0];
  $split = "\0";
  }
&sql'close($csr);
return($value);
}



# note - multi = 1 for multi-select,  multi=-1 for a blank row
sub show_descriptor_as_selection {
local ($select_statement,$multi,$size,$name,$value,$hide) = @_;
local ($lv) = ("");
local ($numrows) = (0);
local ($breakx) = (0);
if ($multi==1) {
  print STDOUT "<select name='$name' multiple='Y' size='$size'>";
# figure out a list of values
  local ($lv_array) = (0);
  @lv_array = split(/\0/,$value);
  foreach (@lv_array) {
    local ($x) = ($_);
    $lv{$x} = 1;
    }
  
  }
else {
  print STDOUT "<select name='$name' size='$size'>"
}
if (!($csr = &sql'open($select_statement))) {
  print STDOUT "<select>\n";
  &query_error($select_statement,$main'ora_errstr);
  return(0);
  }
while (($multi==-1)||(@row = &sql'fetch($csr))) {
  if ($multi == -1) { # hack for optional line
    @row=("","");
    $multi=0;
    }
  if ($multi == 0) {
    if ($hide) {
      if ($row[0] eq $value) {
        print STDOUT "<option value=" . &t2hval($row[0]) . " selected='Y'/>" . 
          &t2html($row[1]) . "\n";
      } else {
        print STDOUT "<option value=" . &t2hval($row[0]) . "/>" .
         &t2html($row[1]) . "\n";
        }
      }
    else {
      if ($row[0] eq $value) {
        print STDOUT "<option value=" . &t2hval($row[0]) . " selected='Y'/>" . 
          &t2html($row[0]) . "\n";
      } else {
        print STDOUT "<option value=" . &t2hval($row[0]) . "/>" .
         &t2html($row[0]) . "\n";
        }
      }
    }   # if we are single mode
  else {
    if ($hide) {
      if ($lv{$row[0]} == 1) {
        print STDOUT "<option value=" . &t2hval($row[0]) . " selected='Y'/>" . 
          &t2html($row[1]) . "\n";
      } else {
        print STDOUT "<option value=" . &t2hval($row[0]) . "/>" .
         &t2html($row[1]) . "\n";
        }
      }
    else {
      if ($lv{$row[0]} == 1) {
        print STDOUT "<option value=" . &t2hval($row[0]) . " selected='Y'/>" . 
          &t2html($row[0]) . "\n";
      } else {
        print STDOUT "<option value=" . &t2hval($row[0]) . "/>" .
         &t2html($row[0]) . "\n";
        }
      }
    }
  $numrows++;
  $breakx++;
  }
print STDOUT "</select>";
&sql'close($csr);

return(1);
}




# same as show_descriptor_as_selection but outputs to a string
sub show_descriptor_as_selection_string {
local ($select_statement,$multi,$size,$name,$value,$hide) = @_;
local ($lv) = ("");
local ($numrows) = (0);
local ($breakx) = (0);
local ($w);
if ($multi==1) {
  $w .=  "<select name=$name MULTIPLE size=$size>";
# figure out a list of values
  local ($lv_array) = (0);
  @lv_array = split(/\0/,$value);
  foreach (@lv_array) {
    local ($x) = ($_);
    $lv{$x} = 1;
    }
  
  }
else {
  $w .=  "<select name=$name size=$size>"
}
if (!($csr = &sql'open($select_statement))) {
  $w .=  "<select>\n";
  $w .= &query_error_string($select_statement,$main'ora_errstr);
  return($w);
  }
while (@row = &sql'fetch($csr)) {
  if ($multi == 0) {
    if ($hide) {
      if ($row[0] eq $value) {
        $w .=  "<option value=" . &t2hval($row[0]) . " selected>" . 
          &t2html($row[1]) . "\n";
      } else {
        $w .=  "<option value=" . &t2hval($row[0]) . ">" .
         &t2html($row[1]) . "\n";
        }
      }
    else {
      if ($row[0] eq $value) {
        $w .=  "<option value=" . &t2hval($row[0]) . " selected>" . 
          &t2html($row[0]) . "\n";
      } else {
        $w .=  "<option value=" . &t2hval($row[0]) . ">" .
         &t2html($row[0]) . "\n";
        }
      }
    }   # if we are single mode
  else {
    if ($hide) {
      if ($lv{$row[0]} == 1) {
        $w .=  "<option value=" . &t2hval($row[0]) . " selected>" . 
          &t2html($row[1]) . "\n";
      } else {
        $w .=  "<option value=" . &t2hval($row[0]) . ">" .
         &t2html($row[1]) . "\n";
        }
      }
    else {
      if ($lv{$row[0]} == 1) {
        $w .=  "<option value=" . &t2hval($row[0]) . " selected>" . 
          &t2html($row[0]) . "\n";
      } else {
        $w .=  "<option value=" . &t2hval($row[0]) . ">" .
         &t2html($row[0]) . "\n";
        }
      }
    }
  $numrows++;
  $breakx++;
  }
$w .=  "</select>";
&sql'close($csr);
return($w);
}




sub show_descriptor_as_radio {
local ($select_statement,$multi,$size,$name,$value) = @_;
local ($numrows) = (0);
local ($breakx) = (0);
   
if (!($csr = &sql'open($select_statement))) {
  &query_error($select_statement,$main'ora_errstr);
  return(0);
  }
while (@row = &sql'fetch($csr)) {
  if ($row[1] eq "") {
    if ($multi == 1) {
      if ($row[0] eq $value) {
        print STDOUT "<input type='checkbox' name='$name' checked='Y' value="
	. &t2hval($row[0]) .
         "/>" . &t2html($row[0]) ."\n";
      } else {
        print STDOUT "<input type='checkbox' name='$name' value=" .
	 &t2hval($row[0]) .
         "/>" . &t2html($row[0]) . "\n";
        }
      }
    else {
      if ($row[0] eq $value) {
        print STDOUT "<input type='radio' name='$name' checked='Y' value=" 
	  . &t2hval($row[0]) .
         "/>" . &t2html($row[0]) . "\n";
      } else {
        print STDOUT "<input type='radio' name='$name' value=" .
	  &t2hval($row[0]) .
         "/>" . &t2html($row[0]) . "\n";
        }
      }
    }
  else {
    if ($multi == 1) {
      if ($row[0] eq $value) {
        print STDOUT "<input type='checkbox' name='$name' checked='Y' value=" . 
	&t2hval($row[0]) .
         "/>" . &t2html($row[1]) . "\n";
      } else {
        print STDOUT "<input type='checkbox' name='$name' value=" . 
	 &t2hval($row[0]) .
         "/>" . &t2html($row[1]) . "\n";
        }
      }
    else {
      if ($row[0] eq $value) {
        print STDOUT "<input type='radio' name='$name' checked='Y' value=" 
	. &t2hval($row[0]) .
         "/>". &t2html($row[1]) . "\n";
      } else {
        print STDOUT "<input type='radio' name='$name' value=" . 
	  &t2hval($row[0]) .
         "/>" . &t2html($row[1]) . "\n";
        }
      }
    }
    
  $numrows++;
  $breakx++;
  }
&sql'close($csr);

return(1);
}



sub query_error {
local ($stmt,$error) = @_;
print STDOUT &query_error_string($stmt,$error);
}


sub query_error_string {
local ($stmt,$error) = @_;
local ($w);
$w .= "<B>Internal error</B><p/>
Internal error runing the following<br/>
<i>" . &t2html($stmt) . "</i>
<p/>
Error is " . &t2html($error);
$w;
}


sub build_where_clause {
local ($oldwc,$field_name,$match_value,$datatype,$format,$ciflag) = @_;
# oldwc - the old where clause that will be properly appended to
# field_name the name of the oracle field -  such as C.CUSTOMER_ID
# match_value - the value to match -  this might have multiple values separated by the null character
#datatype - the oracle datatype
# format - the format of the date datatype or the timestamp sdatatype - optional
# ciflag - 1 - upper(a) = upper(field)
# ciflag - 2 - upper(a) = field 
# ciflag - 4 - normalwith spaces separating multiple values
# ciflag - 5 - upper(1) = upper(field) with spaces separating multiple values
# ciflag - 5 - upper(1) = field with spaces separating multiple values
# otherwise - a = field
# 
# note - if a field has multiple values split by the null key,  they will be handled by 'OR'
# note 2 -  number fields split by the space character are also handled with or
# note 3 - date fields with 2 values will be assumed to be a special case of a range.
# in this case - cifield of 0 is >=  <=.
# cifield of 1 is >=  and <
# cifield of 2 is >=trunc and <trunc(+1)
local ($spaceflag) = (0);
# extract space flag from ciflag - spaceflag means tha multiple fields separated by spaces are ok for text fields also
if ($ciflag >=4) {
  $spaceflag=1;
  $ciflag = $ciflag -4;
  }
  


local ($wc) = ("");
if ($match_value eq "") {$wc = $oldwc}
else {
  # see if this is a multi-field entry
  local ($ary) = (0);
  local ($match_values) = ($match_value);
  if (($datatype eq "NUMBER")||($spaceflag==1)) {
    $match_values =~ s/ /\0/g;
    $match_values =~ s/,/\0/g;
    }    
  
  $mm=$match_values;
  $match_values =~ s/\0\0/\0/g;
  while ($mm ne $match_values) {
    $mm=$match_values;
    $match_values =~ s/\0\0/\0/g;
    } 

  @ary = split(/\0/,$match_values);
  if (@ary >= 1) {  # single equals value
    $comma = "(";
    }
  else {
    $comma = "";
    }
  if ((@ary == 2)&&($datatype eq "DATE")) {
    if ($ciflag == 1) {
      if ($ary[0] ne "") {
        if ($ary[1] ne "") {
          $wc .= $comma . "( $field_name >= trunc(" . &fix_entry($ary[0],'DATE',$format) . 
	  ") and $field_name < trunc(" . 
	    &fix_entry($ary[1],'DATE',$format) . ")+1 )";
	  }
	else {
          $wc .= $comma . "$field_name >= " . &fix_entry($ary[0],'DATE',$format);
          }
	}
      else {
          $wc .= $comma . "$field_name <= " . &fix_entry($ary[1],'DATE',$format);
      	}
      } # ciflag is 1
    elsif ($ciflag == 2) {
      if ($ary[0] ne "") {
        if ($ary[1] ne "") {
          $wc .= $comma . "( $field_name >= " . &fix_entry($ary[0],'DATE',$format) . " and $field_name < " . 
	    &fix_entry($ary[1],'DATE',$format) . ")";
	  }
	else {
          $wc .= $comma . "$field_name >= " . &fix_entry($ary[0],'DATE',$format);
          }
	}
      else {
          $wc .= $comma . "$field_name < " . &fix_entry($ary[1],'DATE',$format);
      	}
      } # ciflag is 2    
    else  {
      if ($ary[0] ne "") {
        if ($ary[1] ne "") {
          $wc .= $comma . "( $field_name >= " . &fix_entry($ary[0],'DATE',$format) . " and $field_name <= " . 
	    &fix_entry($ary[1],'DATE',$format) . ")";
	  }
	else {
          $wc .= $comma . "$field_name >= " . &fix_entry($ary[0],'DATE',$format);
          }
	}
      else {
          $wc .= $comma . "$field_name <= " . &fix_entry($ary[1],'DATE',$format);
      	}
      } # ciflag is 0
    } # if we are a date range
  else {
    foreach (@ary) {
    local ($key) = ($_);
    
    if ($datatype eq "NUMBER") {
      $wc .= $comma . "$field_name = $key";
      }
    elsif ($datatype eq "DATE") {
      $wc .= $comma . "$field_name = " . &fix_entry($key,'DATE',$format);
      }
    elsif ($datatype eq "TIMESTAMP6_LTZ") {
      $wc .= $comma . "$field_name = " . &fix_entry($key,'TIMESTAMP6_LTZ',$format);
      }
    else {
      if ($ciflag == 1) {    
        if ($key  =~ /\%/) {
          $wc .= $comma . "upper($field_name) like upper("  . 
  	    &fix_entry($key,'VARCHAR2') . ")";
          } # if upper like
        else {
          $wc .= $comma . "upper($field_name) = upper("  
  	  . &fix_entry($key,'VARCHAR2') . ")";
          } # if upper =
        } # if case insensitive
      elsif ($ciflag == 2) {
        # uppercase the user specified field,  but not the field itself
	# performance hack
        if ($key  =~ /\%/) {
          $wc .= $comma . "$field_name like upper("  . 
  	    &fix_entry($key,'VARCHAR2') . ")";
          } # if upper like
        else {
          $wc .= $comma . "$field_name = upper("  
  	  . &fix_entry($key,'VARCHAR2') . ")";
          } # if upper =
        } # if fold upper	
      else { # not case insensitive
        if ($key  =~ /\%/) {
          $wc .= $comma . "$field_name like "  . &fix_entry($key,'VARCHAR2');
          } # if exact like
        else {
          $wc .= $comma . "$field_name = " . &fix_entry($key,'VARCHAR2');
          } # if exact =
        } # if case sensitive   
      } # if we are a characterish file
    $comma = " or ";
    } # for each value	
   } # if we are not the special date range 
  if (@ary >= 1) {  # single equals value
    $wc .= ")";
    }
  if ($oldwc ne "") {
    if ($wc eq "") {
      $wc = $oldwc;
      }
    else {
      $wc = "$oldwc \n  and $wc";
      }
    }
  }
$wc;
}






# oldwc the old where clause
# match_value - the field that contains one or more filters
# mode - the mode of doing the filters 0 - and 1 - or
sub build_filter_clause {
local ($oldwc,$match_value,$mode) = @_;
local ($wc) = ("");

print STDERR "a $oldwc $match_value $mode\n";

if ($match_value eq "") {$wc = $oldwc}
else {
  # see if this is a multi-field entry
  local ($ary) = (0);
  local ($match_values) = ($match_value);
  @ary = split(/\0/,$match_values);

  foreach (@ary) {
    local ($key) = ($_);
    
    print STDERR "B $key\n";
    local ($snippit) = &sql'fetch_row("select description 
    from nice_filter where pk = $key");
    
    print STDERR "B2 $snippit\n";
    if ($mode eq 0) {
      $wc = &and_to_where_clause($wc,$snippit);
      }
    else {
      $wc = &or_to_where_clause($wc,$snippit);
      }
    print STDERR "c $wc\n";
    } # for each value	
  
  if ($wc ne "") { 
    $wc = "(" . $wc . ")"; 
    if ($oldwc ne "") {
      $wc = "$oldwc \n  and $wc";
      }
    }
  else {
    $wc = $oldwc;
    }
  }
$wc;
}



sub and_to_where_clause {

local ($a,$b) = @_;
local ($result) = "";
if ($a eq "") {
  if ($b eq "") {
    $result="";
    }
  else {
    $result=$b;
    }
  }
else {
  if ($b eq "") {
    $result=$a;
    }
  else {
    $result= "($a) and ($b)";
    }
  }
$result;
}

sub or_to_where_clause {

local ($a,$b) = @_;
local ($result) = "";
if ($a eq "") {
  if ($b eq "") {
    $result="";
    }
  else {
    $result=$b;
    }
  }
else {
  if ($b eq "") {
    $result=$a;
    }
  else {
    $result= "(($a) or ($b))";
    }
  }
$result;
}


sub finalize_where_clause {
local ($wc) = @_;
if ($wc ne "") {
  $wc = "\nwhere $wc";
  }
$wc;
}



sub finalize_order {
local ($order) = @_;
if ($order ne "") {
  $order = "\norder by $order";
  }
$order;
}





sub fix_entry {
local ($value,$datatype,$format) = @_;
local ($result) = ("");
if ($datatype eq "NUMBER") {
  if ($value eq "") {
    $result="NULL";
    }
  else {$result=$value;}
  }
elsif ($datatype eq "YN") {
  if ($value eq "Y") {
    $result="'Y'";
    }
  else {$result="'N'";}
  }
elsif ($datatype eq "DATE") {
  if ($value eq "") {
    $result="NULL";
    }
  # check for dd-mon-rr
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-rr')";
    }
  elsif (($value =~ /^ *[0-9]\-[0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\-[0-9] *$/)||
         ($value =~ /^ *[0-9]\-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\-[0-9][0-9] *$/)) {
    $result="to_date('$value/'||to_char(sysdate,'yyyy'),'mm-dd-rr')";
    }
  elsif ((
    $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)||
    ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-yyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/rr')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)) {
         $result="to_date('$value','mm/dd/yyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_date('$value'||to_char(sysdate,'yyyy'),'dd-monyyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_date('$value/'||to_char(sysdate,'yyyy'),'mm/dd/yyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-rr hh24:mi:ss')";
    }
  elsif ((
          $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
          ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/rr hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/rr hh24:mi')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/yyyy hh24:mi')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date(to_char(sysdate,'yyyy'||'-$value'),'yyyy-dd-mon hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date(to_char(sysdate,'yyyy'||'/$value'),'yyyy/mm/dd hh24:mi:ss')";
    }
  elsif (($value == 0)&& ($value ne '0')) { # if the date is not numeric format
    $result="to_date('$value','$format')";
    }
  else { 
# numeric  (format will be 0 or 1 and the date will be a number - implying days from 1900 or 1904
    if ($format eq 1) {
      $result="(to_date('1-jan-1904','dd-mon-yyyy') + $value - 1)";
      }
    else { # 1900
      if ($value >  59) {
        $result ="(to_date('12-31-1899','mm-dd-yyyy') + $value - 1)";
	}
      else {
        $result ="(to_date('12-31-1899','mm-dd-yyyy') + $value )";
        }
      } # 1900    
    } # numeric format
  }
elsif ($datatype eq "TIMESTAMP6_LTZ") { # timestamp with local time zone
  # check for dd-mon-rr
  if ($value eq "") {
    $result="NULL";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-rr')";
    }
  elsif (($value =~ /^ *[0-9]\-[0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\-[0-9] *$/)||
         ($value =~ /^ *[0-9]\-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value/'||to_char(sysdate,'yyyy'),'mm-dd-rr')";
    }
  elsif ((
    $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)||
    ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-yyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/rr')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)) {
         $result="to_timestamp('$value','mm/dd/yyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value'||to_char(sysdate,'yyyy'),'dd-monyyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/rr hh24:mi')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/yyyy hh24:mi')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_timestamp('$value/'||to_char(sysdate,'yyyy'),'mm/dd/yyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-rr hh24:mi:ss')";
    }
  elsif ((
          $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
          ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/rr hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp(to_char(sysdate,'yyyy'||'-$value'),'yyyy-dd-mon hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp(to_char(sysdate,'yyyy'||'/$value'),'yyyy/mm/dd hh24:mi:ss')";
    }
  elsif (($value == 0)&& ($value ne '0')) { # if the date is not numeric format
    $result="to_date('$value','$format')";
    }
  else { 
# numeric  (format will be 0 or 1 and the date will be a number - implying days from 1900 or 1904
    if ($format eq 1) {
$result=
"to_timestamp(to_char(to_date('1-jan-1904','dd-mon-yyyy') + $value - 1),'yyyymmddhh24miss'),'yyyymmddhh24miss')";
      }
    else { # 1900
      if ($value >  59) {
        $result ="to_timestamp(to_char(to_date('12-31-1899','mm-dd-yyyy') + $value - 1),'yyyymmddhh24miss'),'yyyymmddhh24miss')";
	}
      else {
        $result ="to_timestamp(to_char(to_date('12-31-1899','mm-dd-yyyy') + $value ),'yyyymmddhh24miss'),'yyyymmddhh24miss')";
        }
      } # 1900    
    } # numeric format
  }
else {  
  if ($value eq "") {
    $result = "NULL";
    }
  else {
    $x= "'||chr(10)\n||'";
    $value =~ s/\'/\'\'/g;
    $value =~ s/\n/$x/g;
    $x= "'||chr(13)||'";
    $value =~ s/\r/$x/g;
    $result= "'$value'";
    }
  }
$result;
}






sub deduce_date {
my ($val) = @_;
# this is the excpensice way.  fixe this soon!!!!
#my ($t) = &sql'fetch_row("select " . fix_entry($val,"DATE") . " from dual");
#$t =~ s/ /T/g;
my $t;
$t = main'xl_parse_date($val);
return($t);
}




#
# some day this will handl;e ranges, is null and the like
# but today this is pretty much like fix_entry
sub fix_query {
local ($colname,$value,$datatype,$format) = @_;
local ($result) = ("");
if ($datatype eq "NUMBER") {
  if ($value eq "") {
    $result="NULL";
    }
  else {$result=$value;}
  }
elsif ($datatype eq "DATE") {
  if ($value eq "") {
    $result="NULL";
    }
  # check for dd-mon-rr
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-rr')";
    }
  elsif ((
    $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)||
    ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-yyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/rr')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)) {
         $result="to_date('$value','mm/dd/yyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_date('$value'||to_char(sysdate,'yyyy'),'dd-monyyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_date('$value'||to_char(sysdate,'yyyy'),'mm/ddyyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-rr hh24:mi:ss')";
    }
  elsif ((
          $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
          ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','dd-mon-yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/rr hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date('$value','mm/dd/yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date(to_char(sysdate,'yyyy'||'-$value'),'yyyy-dd-mon hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_date(to_char(sysdate,'yyyy'||'/$value'),'yyyy/mm/dd hh24:mi:ss')";
    }
  else {
    $result="to_date('$value','$format')";
    }
  }
elsif ($datatype eq "TIMESTAMP6_LTZ") {
  if ($value eq "") {
    $result="NULL";
    }
  # check for dd-mon-rr
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-rr')";
    }
  elsif ((
    $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)||
    ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-yyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/rr')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *$/)) {
         $result="to_timestamp('$value','mm/dd/yyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value'||to_char(sysdate,'yyyy'),'dd-monyyyy')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *$/)) {
    $result="to_timestamp('$value'||to_char(sysdate,'yyyy'),'mm/ddyyyy')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-rr hh24:mi:ss')";
    }
  elsif ((
          $value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
          ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','dd-mon-yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/ )||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/rr hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp('$value','mm/dd/yyyy hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]-[A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp(to_char(sysdate,'yyyy'||'-$value'),'yyyy-dd-mon hh24:mi:ss')";
    }
  elsif (($value =~ /^ *[0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)||
         ($value =~ /^ *[0-9][0-9]\/[0-9][0-9] *[0-9][0-9]:[0-9][0-9]:[0-9][0-9] *$/)) {
    $result="to_timestamp(to_char(sysdate,'yyyy'||'/$value'),'yyyy/mm/dd hh24:mi:ss')";
    }
  else {
    $result="to_timestamp('$value','$format')";
    }
  }
else {  
  if ($value eq "") {
    $result = "NULL";
    }
  else {
    if ($value =~ /\'/) {
      local ($x,$c,$i) = ("","",0);
      while ($i < length($value)) {
        $c=substr($result,$i,1);
	if ($c eq "'") {
	  $c="''";
	  }
	$x .= $c;
	$i++;
	}
      $value=$x;
      }
    $result= "'$value'";
    }
  }
"$colname =$result";
}















sub in_role {
local ($roletest) = @_;
local ($okay) = ("");
local ($roletest2) = 
  &fix_entry($roletest,VARCHAR2);
$xselect = "select rownum from
 customer_roles b where b.customer_id=$the_acting_customer_id
     and b.role_name = $roletest2
     and rownum<2";
$okay = &sql'fetch_row($xselect);
if ($okay ==1) { return(1);}
return(0);
}


sub action_allowed {
local ($action,$customer_id) = @_;
local ($okay) = ("");
return(1); # for now
$xselect = "select rownum from nice_user_actions a,
 customer_roles b where b.customer_id=$customer_id
     and b.role_name = a.role_name
     and a.action_name='$action'
     and rownum<2";

$okay = &sql'fetch_row($xselect);
if ($okay == 1) { return(1);}
return(0);
}






sub getevalfile {
local ($filename) = @_;
local ($bigstring) = ("print STDOUT \"");
open(PTFILE,$filename);
while (<PTFILE>) {
  $bigstring .= $_;
  }
$bigstring .= "\";";
return $bigstring;
close PTFILE;
}





sub login {
  open(PWDFILE,"pwd.cfg");
  local ($i)=(0);
  local ($x) = ("");
  while (<PWDFILE>) {
    $x=$_;
    $i++;
    if ($i == 1) {
      $ocl_username=$x
      }
    }
close PWDFILE;
 ($ocl_hostname,$ocl_username,$ocl_password) = split(/ /,$ocl_username);
local ($r); 
$r=  &sql'login($ocl_hostname,$ocl_username,$ocl_password);
return $r;
}


sub check_security {
local ($action) = @_;
return(1); # security is handled in nice instead
&login();
$session_id = $main'input{session_id};
if ($session_id eq "") {
  &enter_username_password("");
      return(0);
  }
  
local ($pk,$customer_id,$where_ip,$exp) = 
&sql'fetch_row("select pk,user_fk,from_ip_address,trunc((sysdate-to_date(to_char(end_time,'yyyymmddhh24miss'),
    'yyyymmddhh24miss'))*24)
  from nice_session where pk=$session_id");
if ($pk eq "") {
  &fail_security(1,"Invalid Session ID $session_id","","");
  return(0);
}
if ($customer_id eq "") {
  $customer_id=1; # so we can check other bad things first 
  }
if ($exp > 0) {
  &fail_security($customer_id,"Session expired for $exp hours","","");
  return(0);
  }
if ($ENV{'REMOTE_ADDR'} ne $where_ip) {
  &fail_security($customer_id,"Different ip address for session","","");
  return(0);
  }
if ($exp == 0) {
  &sql'do("update nice_session set end_time = sysdate+2/24 where
      pk=$session_id");
  &sql'commit();
  }
# ok.  if the customer id was 1,  we didn't really log in yet
if ($customer_id == 1) {
  if (!&nice'check_credentials()) {
      return(0);
      }
  
  }  
# keep checking things
if (!&action_allowed("$action",$customer_id) ){
  &no_access($action);
  return(0);
  }
$the_acting_customer_id=$customer_id; 
# note the session id is also global.
return(1);
}
  

sub check_username_password {
local ($username,$password) = ("","");
&login();
$username = $main'input{username};
$password = $main'input{password};
if ($username eq "") {
  &enter_username_password("");
      return(0);
  }

if ($password eq "") {
  &enter_username_password("Password was not specified!");
      return(0);
  }
  # ''' need to hack-proof the username here
local ($customer_id,$customer_name,$active_customer,$customer_password) = 
  &sql'fetch_row("select customer_id,customer_name,
    active_customer,customer_password
    from customers where customer_name = '$username'");
  if ($customer_password eq "????") {
      &fail_security
      ($customer_id,"That customer has no password");
      return(0);
      }
  if ($active_customer ne "Y") {
      &fail_security($customer_id,"That is an invalid account",$username,$password);
      return(0);
      }
  if ($customer_password ne $password) {
      &fail_security($customer_id,"That password is INVALID!!!",$username,$password);
      return(0);
      }
local ($remote_addr) = $ENV{'REMOTE_ADDR'};
if ($remote_addr eq "") {$remote_addr = 'localhost';}

# ok, now everything is cool, we need to make the session_id
$session_id="";
($session_id) = &sql'fetch_row("select nice_seq.nextval/1000000 from dual");
 $statement="insert into nice_session  (pk,end_time,from_ip_address)
  values ($session_id,sysdate+2/24,'" . $remote_addr . "')";
  if (!&sql'do("$statement")) {
    &technical_difficulties($statement,$main'ora_errstr,0);
    return(0);
    }
  &sql'commit();
 $the_acting_customer_id=$customer_id; 
# global. yeah, I know.
 return(1);
}





sub new_session {
&nice'new_session();
}

sub action_allowed {
local ($action,$customer_id) = @_;
local ($okay) = ("");
$xselect = "select rownum from role_actions a,
 customer_roles b where b.customer_id=$customer_id
     and b.role_name = a.role_name
     and a.action_name='$action'
     and rownum<2";

$okay = &sql'fetch_row($xselect);
if ($okay ne "") { return(1);}
return(0);
}


sub enter_username_password {
local ($reason)=@_;
local ($number_bogus) = &sql'fetch_row("select count(*)
  from nice_bogus_attempt where from_ip_address = '" . $ENV{'REMOTE_ADDR'} .
     "' and cleared=0");
if ($number_bogus > 5) {
  &fail_security(0,"IP Address " . $ENV{'REMOTE_ADDR'} . 
  " is denied access because of too many ($number_bogus) bogus attempts.","","");
  return(0); # guess they wont be seeing the security screen
  }
print STDOUT "Content-type: text/html\n\n
  
  
  <body bgcolor=\"#40a050\" vlink=\"#999900\"
  alink=\"#999900\" text=\"#000000\">
  <br/> 
  <title>Nicer</title>
  <head><font size='6'>
  <center>Welcome to Nice's<br/>Web Internet Service Provision, <br/>also known as 
  </font><br/><font size=9>Nicer</center></font></head>
  
  <p/>
  <hr/>
  We will need your customer name and your customer password.  
  <br/><b>Note</b>- this is not the same as your unix username and password used for everything else.
  <br/>
  
  <form action=\"\" method=post>
  <b>User Name:  </b>";
&show_descriptor_as_selection(
  "select name from `dnice_usercustomers where customer_password !='????' and 
     active_customer='Y' order by customer_name",0,8,"username","");
print STDOUT   "<b> Password:</b>   <input type='password' name='password'/><p/>
<br/>  
  <i>As soon as this step is done, you can enjoy the wonderful array of features
  awaiting you.</i>
";
  print STDOUT "<hr/>
  <input type='hidden' name=\"module_id\" value=\"login\"/>
  <input type='submit' value=\"Enter Nicer\"/>
  <input type='reset' value=\"Clear\"/>
  </form>
<hr/>Brought to you by:
<center><font size=6>Nice <br/></font>
<font size=7>
</font>
<br/>
<p/>
<table cellpadding='5' border='8' width='85%'>
<tr>
</tr>
</table>
<br/>

<br/>
$reason<br/>
  ";
}
    

sub fail_security {
local ($customer_id,$reason,$username,$password) = @_;
local ($email) = &sql'fetch_row(
"select email from nice_user where pk=$customer_id");
open(MAIL,"| mail $email hengler@kcd.com") || die "mail not sent to $email";
print MAIL "From: KCD system security sleuth\n";
print MAIL "To: $email\n";
print MAIL "cc: hib\n";
print MAIL "Subject: Attempted break in\n\n";
print MAIL "Somebody tried to break into your account with a password of
$password and the username $username. but was disallowed because of \n$reason";
local ($xdate) = `date`;
print MAIL 
"\nThis happened at $xdate.\n  We thwarted their break in this time, 
but you might want to change your user id and password just in case\n";
close(MAIL);

local ($where_ip) = ($ENV{'REMOTE_ADDR'});
# need session id?
($statement) =("insert into nice_bogus_attempt(pk,from_ip_address,cleared,
     descr,user_modified_fk) values (nice_seq.nextval,'$where_ip',0,'$reason',$customer_id)");
if (!&sql'do($statement)) {
  &technical_difficulties($statement,$main'ora_errstr,0);
  }
&sql'commit();
print STDOUT "Content-type: text/html\n\n";
print STDOUT "<body bgcolor=\"#bb0000\" vlink=\"#999900\"
alink=\"#999900\" text=\"#ffff00\">

<title>YOU bad person!!!</title>
<head>YOU bad person!!!</head>

You could not break into nice because of the following:
$reason
<p/>
Several people will be notified of your attempt to break in.
<p/>
Have a nice day
<p/>
";
}

sub no_access {
local ($action) = @_;
print STDOUT "Content-type: text/html\n\n";
print STDOUT "<body bgcolor=\"#dddd00\" vlink=\"#999900\"
alink=\"#999900\" text=\"#000000\">

<title>No access to $action</title>
<head>No access to $action</head>

You do not have access to do that function. Sorry.
<p/>
Have a nice day
<p/>
";
}


sub set_security {
print STDOUT &set_security_string();
}

sub set_security_string {
local ($w);
$w =  "<input type='hidden' name='session_id' value=\"" .
   $fm_tables'session_id . "\"/>
   ";
 $w;
}



sub technical_difficulties {
local ($statement,$error,$id) = @_;
print STDOUT "Content-type: text/html\n\n";
print STDOUT " <html>
  <body>
    <h2>Nicer: Technical Difficulties</h2>

I am sorry,  but we seem to be having technical difficulties bringing
up the basic nicer functionality.<p></p>
This should never happen,  but you know how it is.<p></p>

    Here is some information that someone should be able to use,
    to shed light on something, somehow:

    <hr></hr>
    Statement: " . &t2html($statement) ." <br></br><br/>

    Error: " . &t2html($error) . "
<HR></HR>Sorry for the inconvienence.
  </body>
  </html>
";


}



# reset all variables so that we can use this in mod_perl
sub resetit {
reset 'a-z';
}






# &fm_tables'push - &fm_tables'push a html object on the stack
# used to make xml correct
sub push() {
if ($stack_pointer eq "") {
  $stack_pointer=0;
  }
($stack[$stack_pointer++])= @_;
}

# pop - pop an object of the stack
# used to make xml correct
sub pop() {
my ($number,$checkcode) = @_;
my ($i);
if ($number eq "") {
  $number=1;
  }
for ($i=0;$i<$number;$i++) {
  if ($checkcode eq "") {
    if ($stack_pointer) {
      my $code = $stack[--$stack_pointer];
      print STDOUT "</$code>\n"
      }
    else {
      $i=$number;
      }
    }
  else {
    my $flag=1;
    while ($flag) {
      if ($stack_pointer) {
        my $code = $stack[--$stack_pointer];
        print STDOUT "</$code>\n";
	if ($code eq $checkcode) {
	  $flag=0;
	  }
        }
      else {
        $i=$number;
	$flag=0;
        }
      } # while looking for a specific code
    } # if we are checking for a specific code
  } # for each iteration
}



sub usableforms_init {
if ($usable_forms_initted eq "") {
print STDERR "aaa $main'constant_static_url/usableforms.js\n";
# print STDOUT "<script type=\"text/javascript\" src=\"$main'constant_static_url/usableforms.js\"></script>";
  $usable_forms_initted = "1";
  }
}


1;



