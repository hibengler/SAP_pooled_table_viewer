#!/usr/bin/perl

# This script obsuftigates and drms the code - by watermarking the code in multiple ways
# because of the multiple ways, it is likely that we can figure out who copied what
# Serial is a special code that we internally set.  It is not to be stored riectly
$serial = AGHEY;
# Database name is the name of the database
$database_name = "EAT AT JOES";
$owner = "SAPSR3";
# company name is the name of the company
$company_name ='PGP';
# serial2 is used to figure out which key field means what
$serial2 = DFKRRDFSJKDSFKEE;
# a-i are 0-9 but the others variate
# serial3 is used to osfucitae the name of the variables
$serial3=AQKLP;
# serial4 is used for return atermarking
$serial4=ASE;





#print STDOUT &add_code_code($serial,$database_name) . "\n";
#print STDOUT &sub_code_code(&add_code_code($serial,$database_name) 
#              ,$database_name). "\n";
#print STDOUT &number_to_code(223342432) . "\n";
#print STDOUT &code_to_number(&number_to_code(223342432)) . "\n";

open(CRECODE,">crecode.sql");
print CRECODE &generate_crecode($serial1,$serial2,$serial3,$serial4,"JOE","Supersmith","SAPSR3"); 
close CRECODE;
open (BUILD_POOL_TABLE,">build_pool_table.sql");
print BUILD_POOL_TABLE &generate_build_pool_table($serial1,$serial2,$serial3,$serial4,"JOE","Supersmith","SAPSR3");
close BUILD_POOL_TABLE;


sub number_to_code {
local ($a) = @_;
local ($s);
local ($m);
if ($a == 0) { return ("A");}
$m = $a % 26;
while (int($a/26) != 0) {
  $s .= chr(65+$m);
  $a = int($a/26);
  $m = $a % 26;
  }
if ($m != 0) {
  $s .= chr(65+$m);
  }
$s;
}



sub code_to_number {
local ($a) = @_;
local ($s);
local ($l,$i);
$l=length($a);
$i=$l-1;
$s=0;
while ($i>=0) {
  $s = $s *26 + ( (ord(substr($a,$i,1))+65) % 26);
  $i--;
  }
$s;
}

sub sub_code_code {
local ($a,$b) = @_;
local ($ac,$bc,$s);
local ($la,$lb,$l,$i);
$la = length($a);
$lb = length($b);
$l=$la;
if ($l < $lb) {
  $l = $lb;
  }
for ($i=0;$i < $l;$i++) {
  $ac = ord( substr($a,$i % $la,1));
  $bc = ord(substr($b,$i % $lb,1));
  $s .= chr(65+ ($ac+65  + 26-(($bc + 65)%26) ) % 26);
  }
return $s;
}

sub add_code_code {
local ($a,$b) = @_;
local ($ac,$bc,$s);
local ($la,$lb,$l,$i);
$la = length($a);
$lb = length($b);
$l=$la;
if ($l < $lb) {
  $l = $lb;
  }
for ($i=0;$i < $l;$i++) {
  $ac = ord( substr($a,$i % $la,1));
  $bc = ord(substr($b,$i % $lb,1));
  $s .= chr(65+ ($ac+65 + $bc + 65) % 26);
  }
return $s;
}


# idx 
# this find the numerical value of an upeprcase ALPHA string at a given position
# it can handle any streen and returns a number between 0 and 25
#
sub idx{
local ($code,$pos) = @_;
return (ord(substr($code,$pos,1))+65) % 26;
}







sub generate_function_names_from_serial2 
{
# serial2 should eb 14 characters long. Company specific



local ($serial2) = @_;
local @pool,@char,@number,@int,@packed,@column,@concatenate,@string,@hex;

@pool = qw(pool pl pol ple pole poole puul xpool xpl xpol xple xpole xpoole xpool xpuul p xp pt poolt plt
 xpt xpoolt ptable ptab pltab pooltb);
@char = qw(charact charac char chr ch chr vchr 
varch vrch vchr varc vc text txt tx 
vtxt vartext vt t x xt vxtxt str string st vstr varstr stg xstr);
@number = qw(num number n nbr numb nb dec decimal nint nin ni nintger wint wnum 
numeric nmrical d dml ndec xnum xnumber xnumb xdec xdecml xnbr numword ctrnum);
@int = qw(i int inte integ integr integer igr ig itg in bytel byte
byt ibyt ibyte iofbyte byteini bi bin bint bint binaryi
binint codeint intcode intbyte incode xint xinteger);
@packed = qw(p pk pc pck pak pac pack packd packed dpack packdat bcd cbcd cpack
xp xpk xpck xpac xpack xpackd xpacked pckdata xbcd cpak cp cpk packdata);
@column = qw(c col clm column colmn cl co 
dec decode deccol decd ident parse make get gather pull fix format 
eat consume consum reduce compute deduce derive take fill convert);
@concatenate = qw(add con concat conc concatnt concenate postpend merge merg
append appnd apnd ap apd extend extnd extd ed xtnd finesse finish mark polish);
@string = qw(s string str strg ch chr char chars charstg cstring cstr 
vs vstr vstrg vch vchr vchar vchars vstring sv strv strgv chv chrv charv polishv);
@hex = qw(code x hx hex hexd hexad hexadml hexdml hdml hxd xd hd
cx chx chex chexd chexad chexadml hxb hexb base16 c09af mhex mh mhx mhexad);


$prefix = "sx_";
# 0 pool
# 1 char
# 2 column
# 3 number
# 4 hex
# 5 int
# 6 packed
# 7 concatenate
# 8 string
# 9-13  5 - sx_fieldpos_for_table and sx_raw_packed_to_number.  This is the simple drm ha ha ha
$pl =  $pool[&idx($serial2,0)];
$cl = $column[&idx($serial2,2)];

$sx_pool_char_column = $prefix . $pl .
        "_" . $char[&idx($serial2,1)] .
	"_" . $cl;
$sx_pool_number_column = $prefix . $pl .
        "_" . $number[&idx($serial2,3)] .
	"_" . $cl;
$sx_pool_hex_column = $prefix . $pl .
        "_" . $hex[&idx($serial2,4)] .
	"_" . $cl;
$sx_pool_int1_column = $prefix . $pl .
        "_" . $int[&idx($serial2,5)] .
	"1_" . $cl;
$sx_pool_int2_column = $prefix . $pl .
        "_" . $int[&idx($serial2,5)] .
	"1_" . $cl;
$sx_pool_int4_column = $prefix . $pl .
        "_" .  $int[&idx($serial2,5)] .
	"1_" . $cl;
$sx_pool_packed_column = $prefix . $pl .
        "_" . $packed[&idx($serial2,6)] .
	"_" . $cl;
$sx_concatenate_string = $prefix . $pl .
        "_" . $concatenate[&idx($serial2,7)] .
	"_" . $string[&idx($serial2,8)] ;
$sx_fieldpos_for_table = $prefix . "fieldpos_" . substr($serial2,9,5);
$sx_number_to_fieldpos = $prefix . $number[&idx($serial2,3)] . "_to_fieldpos";
$sx_raw_packed_to_number = $prefix . "raw_packed_number_" .  substr($serial2,9,5);
$sx_pool_column =  $prefix . $pl . "_" . $cl;
$sx_pool_date_column =  $prefix . $pl . "_date_$cl";
$sx_pool_time_column  =  $prefix . $pl . "_time_$cl";
$sx_pool_double_column  =  $prefix . $pl . "_double_$cl" ;
$sx_pool_float_column  =  $prefix . $pl . "_float_$cl";
}

















sub generate_char_codes_from_serial3 
{
# Serial3 must be specially made
# the first letter should be <=Q
# all other letters should not clash with the first letter.
#
# pos -0 	a-I - 0-9 that does change - first one - if > 16 then we add an extra comment
# pos 1		V - Variable char - variable character length - expects a number afterwards
# pos 2		F - fixed length - expects a number afterwards
# pos 3		P - packed decimal
# pos 4		J - extra
# 
#
local ($serial3) = @_;
local @taken;
local $i;
for ($i=0;$i<26;$i++) { $taken[$i] =0;}

$a = &idx($serial3,0);
if ($a >= 16) {
  $a = $a - 16;
  $extra = "/*coded*/";
  }
$from_letter = chr(65 + $a);
$to_letter = chr(65 + $a + 9);
$one_letter =  chr(65 + $a + 1);
$two_letter =  chr(65 + $a + 2);
$three_letter =  chr(65 + $a + 3);
$four_letter =  chr(65 + $a + 4);
$five_letter =  chr(65 + $a + 5);
$six_letter =  chr(65 + $a + 6);
$seven_letter =  chr(65 + $a + 7);
$eight_letter =  chr(65 + $a + 8);
$nine_letter =  chr(65 + $a + 9);
$zero_letter =  chr(65 + $a );

$taken[$a]=1;
$taken[$a+1]=1;
$taken[$a+2]=1;
$taken[$a+3]=1;
$taken[$a+4]=1;
$taken[$a+5]=1;
$taken[$a+6]=1;
$taken[$a+7]=1;
$taken[$a+8]=1;
$taken[$a+9]=1;
$a = &idx($serial3,1);
if (!$taken[$a]) {
  $taken[$a]=1;
  $varv = chr(65 + $a);
  
  $a = &idx($serial3,2);
  if (!$taken[$a]) {
    $taken[$a]=1;
    $varf = chr(65 + $a);
    
    $a = &idx($serial3,3);
    if (!$taken[$a]) {
      $taken[$a]=1;
      $varp = chr(65 + $a);

    
      $a = &idx($serial3,4);
      if (!$taken[$a]) {
        $taken[$a]=1;
        $varj = chr(65 + $a);
        return;
        }
      }
    }
  }
# if here, some of the variables clash
$from_letter="C";
$a=2;
print STDERR "CLASH SERIAL3 $serial3\n";
$one_letter =  chr(65 + $a + 1);
$two_letter =  chr(65 + $a + 2);
$three_letter =  chr(65 + $a + 3);
$four_letter =  chr(65 + $a + 4);
$five_letter =  chr(65 + $a + 5);
$six_letter =  chr(65 + $a + 6);
$seven_letter =  chr(65 + $a + 7);
$eight_letter =  chr(65 + $a + 8);
$nine_letter =  chr(65 + $a + 9);
$zero_letter =  chr(65 + $a );
$to_letter="L";
$varv="A";
$varf = "S";
$varp = "H";
$varj = "X";
$extra=  "/* $serial3 */";

}


























sub generate_build_pool_table {
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name,$owner) = @_;
# Serial is a special code that we internally set.  It is not to be stored directly
# Database name is the name of the database
# company name is the name of the company
# serial2 is used to osfucitae the name of the variables - it should be unique for company
# is used to figure out which key field means what. Company specific
# serial3 is used for translating the variable code  
# a-i are 0-9 but the others variate
# serial4 is used for return watermarking
local $dbug;
local ($s) = ("");

$dbug="\nselect 'dbms_lob.substr(vardata,20,1) zhib,dataln,' from dual;";
# $dbug = ""


&generate_function_names_from_serial2($serial2);
&generate_char_codes_from_serial3($serial3);

$s = "
REM build_pool_table.sql
REM Copyright(R) Killer Cool Development 2007-2008 All Rights Reserved.
REM This code has been copyrighted for the company $company_name
REM For use in the oracle database named $database_name where the SAP tables are in $owner
REM
REM Package Version 1.4
REM ModuleVersion 2.1.18.1
REM This program will generate an extract view that allows access to pool tables via Oracle.
REM It takes 4 parameters
REM view_name - the name of the view
REM prefix - the name of the prefix to use for the view names.  Normally this is null \"\", but
REM You could set it to whatever you desire.  Note that the auxilliary function and table names will be prefixed with
REM $prefix regardless of this setting.
REM
REM owner
REM Usually, this is SAPSR3.
REM
REM code_owner
REM This could be 
REM   SAPSR3 - If you dare to put these views. This is more convienent but less safe.
REM   SAPSR3P - A separate schema with limited access to only POOL tables and DDL tables. This is more safe.
REM   another user - If just testing.
REM owner - the owner of the SAP tables
REM This script is designed to be run by a DBA account on the database that gets the views.
REM                
define view_name=\"\&1\"
define prefix=\"\&2\"
define owner=\"\&3\"
define code_owner=\"\&4\"



select 'create or replace view \&code_owner..\"\&prefix.\&view_name\" as select' from dual;$dbug
select 
decode(to_number(position),1,null,',')||
decode(keyflag,'X',
   decode(inttype,'C','substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen) ||') ',
	'N','to_number(substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen)||')) ',
'D','to_date(substr(varkey,'||(startint+1)
      ||','||
              to_number(intlen)||'),''YYYYMMDD'') ',
'substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen) ||') '	      
	),
   decode(inttype,
   'C',' substr(\&code_owner..$sx_pool_char_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||
     '''),1,'||leng||')'
,  'N',' \&code_owner..$sx_pool_number_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'X', decode(datatype,
         'RAW',' \&code_owner..$sx_pool_hex_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT1',' \&code_owner..$sx_pool_int1_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT2',' \&code_owner..$sx_pool_int2_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT4',' \&code_owner..$sx_pool_int4_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         , ' \&code_owner..$sx_pool_hex_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
	 )
,  'P',' \&code_owner..$sx_pool_packed_column(vardata,dataln,'||dataseq||','||fieldpos||','
     ||leng||','||decimals||','''||tabname||''','''||fieldname||''')'
,  'D',' \&code_owner..$sx_pool_date_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'F',' \&code_owner..$sx_pool_double_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  ' ',' \&code_owner..$sx_pool_hex_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'T',' \&code_owner..$sx_pool_char_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,'???unknown inttype '||inttype||'.'
	))
	   || decode(inttype,' ','\"'||fieldname||position|| '\"','\"'||fieldname||'\"')
from	   
(select c.*,(select nvl(sum(intlen),0) startint
      from \&owner..dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag='X') startint,
(select nvl(count(*),0)+1 dataseq
      from \&owner..dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag=' ') dataseq,
(select nvl(sum(intlen),0) startint
      from \&owner..dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag != 'X') startdataint      ,
    \&code_owner..$sx_concatenate_string(\&code_owner..$sx_fieldpos_for_table(tabname,as4local,as4vers,fieldname)) fieldpos
from \&owner..dd03l c
) c
where c.tabname='\&view_name'
order by position;
select ',varkey from \&owner..\"'||
sqltab||'\" where tabname = ''\&view_name'';'
 from \&owner..dd02l where tabname='\&view_name';

";
$s;
}






























sub generate_crecode {
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name,$owner) = @_;
# Serial is a special code that we internally set.  It is not to be stored riectly
# Database name is the name of the database
# company name is the name of the company
# serial2 is used to figure out which key field means what. Company specific
# a-i are 0-9 but the others variate
# serial3 is used to osfucitae the name of the variables
# serial4 is used for return atermarking

local ($s) = ("");



&generate_function_names_from_serial2($serial2);
&generate_char_codes_from_serial3($serial3);

$s = "
REM crecode.sql
REM Copyright(r) KCD 2007-2008 All Rights Reserved.
REM This code has been copyrighted for the company $company_name
REM For use in the oracle database named $database_name where the SAP tables are in $owner
REM
REM Package Version 1.4
REM ModuleVersion 1.14.3.2
REM These database functions 
REM It takes 4 parameters
REM view_name - the name of the view
REM
REM owner
REM Usually, this is SAPSR3.
REM
REM code_owner
REM This could be 
REM   SAPSR3 - If you dare to put these views. This is more convienent but less safe.
REM   SAPSR3P - A separate schema with limited access to only POOL tables and DDL tables. This is more safe.
REM   another user - If just testing.
REM owner - the owner of the SAP tables
REM This script is designed to be run by a DBA account on the database that gets the views.
REM 
REM
REM Objects created:
REM the following objects are created by this code:
REM
REM $sx_fieldpos_for_table
REM $sx_raw_packed_to_number
REM $sx_pool_column
REM $sx_pool_char_column
REM $sx_pool_number_column
REM $sx_pool_int1_column               
REM $sx_pool_int2_column               
REM $sx_pool_int4_column 
REM $sx_pool_date_column
REM $sx_pool_time_column
REM $sx_pool_packed_column
REM $sx_concatenate_string
REM $sx_pool_double_column
REM 
REM All of these functions are used to help read the COBOL based structures.
REM 
REM Prerequisites
REM              
REM The table SX_LICENSE must exist in the code section
REM The oracle package utl_raw must be created.
REM 
REM 
REM  
define owner=\"\&1\"
define code_owner=\"\&2\"


create or replace function &code_owner..$sx_number_to_fieldpos(xval in number)
return varchar2
is
x varchar2(200);
y varchar2(200);
i number(8);
l number(8);
begin
x := xval;
y := '';
l := length(x);
i := 1;
loop
  exit when i>l;
  y := y || chr(ascii(substr(x,i,1)) + " . (ord($from_letter) - ord("0")) . ");
  i := i + 1;
  end loop;
return y;
end;
/
 

create or replace function &code_owner..$sx_fieldpos_for_table(xtabname in varchar2,
xas4local in varchar2,
xas4vers in varchar2,
xcolname in varchar2
)
return varchar2
is
x varchar2(2000);
cursor abc is select decode(inttype,'C',decode(intlen,1,'$varf$two_letter',2,'$varf$four_letter','$varv'||  
      &code_owner..$sx_number_to_fieldpos(intlen*2)),
   'N',decode(intlen,1,'$varf$two_letter',2,'$varf$four_letter','$varv'|| &code_owner..$sx_number_to_fieldpos(intlen*2)),
   'X','$varf'||  &code_owner..$sx_number_to_fieldpos(intlen),
   'D','$varf$one_letter$six_letter',
   'T','$varf$one_letter$two_letter',
   'F','$varf$eight_letter',
   ' ','$varf'|| &code_owner..$sx_number_to_fieldpos(intlen*2), 
   'P','$varp'||&code_owner..$sx_number_to_fieldpos(intlen+0), 
   '?') code
 from &owner..dd03l 
 where tabname = xtabname
 and as4local = xas4local
 and as4vers = xas4vers
 and keyflag = ' '
 order by position;
 
   
begin
x := null;
for a in abc loop
  x := x || a.code;
  end loop;
return x;
end;
/


create or replace function &code_owner..$sx_raw_packed_to_number(x in raw,xleng in number,
xdecimals in number,xtabname in varchar2,xcolname in varchar2)
 return number is
vo raw(1024);
y number;
leng number;
decimals number;
xc varchar2(200);
ft varchar2(1);
x1 varchar2(2);
xn varchar2(200);
c1 varchar2(1);
n1 number;
ynumber number(10);
begin
leng := xleng;
decimals := xdecimals;
if (mod(leng,2) = 0) then /*if even make odd */
  leng := leng +1;
  end if;
xc := x;
y := 1;
/* convert hex into a number */
n1 := 0;
loop
  c1 := substr(xc,y,1);
  exit when (c1 >'9') or (c1 is null);
  n1 := n1*10+(ascii(c1)-ascii('0'));
  y := y + 1;
  end loop;
if c1 = 'D' then 
  n1 := -n1;
  end if;
loop
  exit when decimals <=0;
  n1 := n1 / 10;
  decimals := decimals - 1;
  end loop;

return n1;
exception when others then return null;
end;
/



create or replace function &code_owner..$sx_pool_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return raw
is
buf raw(4);
ystart number;
ft varchar2(1);
x1 varchar2(10);
xn varchar2(200);
c1 varchar2(1);
n1 number;
maxc varchar2(2);
maxn1 number;
ynumber number(10);
fieldpos number;
startcode varchar2(10);
fixednum number;
vskip number;
xmode number;
begin
ynumber := 1;
n1 := 0;
fieldpos := 1;

if xbloblength < 0 then
  startcode := dbms_lob.substr(xblob,2,1);
  
  n1 := 0;
  c1 := substr(startcode,3,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
  c1 := substr(startcode,4,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
  c1 := substr(startcode,1,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
  c1 := substr(startcode,2,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
   
   /* twos compliment */
   n1 :=  n1 - 32768; 
   if n1=xbloblength then
     xmode := 2; /* modern mode */
     ystart := 4;
   else
     xmode := 0; /* strange mode where there is no length stored */
     ystart := 1; /* maybee start before that , like A004 */
     end if; /* if we are equal to the negative length  */
   
else  /*  if we are fixed length up to 256.   negative numbers are the new record format */
  startcode := dbms_lob.substr(xblob,2,1);
  
  n1 := 0;
  c1 := substr(startcode,3,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
  c1 := substr(startcode,4,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
  c1 := substr(startcode,1,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;
  c1 := substr(startcode,2,1);
  if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
    else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
   end if;

   
   /* twos compliment */
   if n1=xbloblength then
     xmode := 1; /* simple length mode */
     ystart := 3;
   else
     xmode := 0; /* strange mode where there is no length stored */
     ystart := 1; /* maybee start before that , like A004 */
     end if; /* if we are equal to the negative length  */
   end if; /*  if we are greater than 256.   negative numbers are the new record format */
  
vskip := 0;
loop
  ft := substr(fieldtypes,fieldpos,1); /* get the field type - $varv or $varf or $varp 
  $varv is for variable langth character string  and it is pretty easy.
  $varf is for a fixed length in bytes
  $varp is for a packed number that is read until there is some number where
   the lower part is not between 0-9 (0C for +, 0D for -, 0F for unsigned)*/

  maxn1 := 0;
  loop
     maxc := substr(fieldtypes,fieldpos+1,1); /* get the number code */
     exit when nvl(maxc,'$varj') <'$from_letter' or nvl(maxc,'$varj') > '$to_letter';
     fieldpos := fieldpos +1;
     maxn1 := maxn1 * 10 + ascii(maxc) - ascii('$from_letter');
    end loop;
      
  if vskip >0 then
    vskip := vskip -1;
    n1 := 0;
  else 
    
    if ft = '$varv' and xmode = 2 then
      x1 := dbms_lob.substr(xblob,2,ystart);
      /* convert hex into a number */
      n1 := 0;
      c1 := substr(x1,1,1);
      if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
      else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
      end if;
      c1 := substr(x1,2,1);
      if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
      else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
      end if;
      n1 := n1 * 2; /* unicode 2 byte words */
      
      
      if n1 = 0 and xmode = 2 then /* skip fields! */
        /* same code to take byte out */
        n1 := 0;
        c1 := substr(x1,3,1);
        if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
        else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
        end if;
        c1 := substr(x1,4,1);
        if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
        else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
        end if;
        vskip := n1 - 1; /* vskip is the indicator! a skip of 1 is a noop here */
	ystart := ystart + 1;  /* skip the second byte indicator */
	n1 := 0; /* this record is skipped as well */
        end if; /* if we are skipping fields */      
      ystart := ystart + 1;
    elsif ft = '$varf'  /* fixed length 1 word (2 bytes) */
            or
	   ( ft = '$varv' and xmode != 2) /*Q and we are an older style */
	   then
      if /* hack */ xbloblength >0 and maxn1 = 2 and xtabname= 'T5M4S' then
        ystart := ystart+1; /* skip one extra zero that is in this format */
	n1 := maxn1;
      else
        n1 := maxn1;
	end if;
    elsif ft='$varp'  then /* packed number */
      n1 := 1;
      xn := dbms_lob.substr(xblob,50,ystart);
      
        if maxn1 >4 and
           (substr(xn,1,2) = '00') then /* skip fields packed  - does not work with 4 or less. - 4 is not tested - 3 is! */
        /* same code to take byte out */
        n1 := 0;
        c1 := substr(xn,3,1);
        if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
        else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
        end if;
        c1 := substr(xn,4,1);
        if (c1 <='9') then n1 := n1*16+(ascii(c1)-ascii('0'));
        else n1 := n1 * 16 + ascii(c1) - ascii('A') + 10;
        end if;
        vskip := n1 - 1; /* vskip is the indicator! a skip of 1 is a noop here */
        ystart := ystart + 1;  /* skip the second byte indicator */
        n1 := 0; /* this record is skipped as well */
        ystart := ystart + 1;
         /* if we are skipping fields */       
      else /* no skip */

        loop
          /* convert hex into a number */
          c1 := substr(xn,((n1-1)*2)+2,1);
          exit when nvl(c1,'P') > '9';
          n1 := n1 + 1;
          end loop;
        end if;
      end if;
    end if; /* we are not being skipped */
  ynumber := ynumber + 1;
  fieldpos := fieldpos + 1;
    
  exit when ynumber > xnumber;
 
  ystart := ystart + n1;
  end loop;

return dbms_lob.substr(xblob,n1,ystart);
end;
/

show error
l

  
create or replace function &code_owner..$sx_pool_hex_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
 return raw is
begin
return $sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname);
exception when others then return null;
end;
/ 



create or replace function &code_owner..$sx_pool_char_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return varchar2
is
begin
return utl_i18n.raw_to_char($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),'AL16UTF16');
end;
/

create or replace function &code_owner..$sx_pool_number_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return number
is
begin
return to_number(utl_i18n.raw_to_char($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),'AL16UTF16'));
end;
/

create or replace function &code_owner..$sx_pool_int1_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return number
is
begin
return utl_raw.cast_to_binary_integer($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname));
end;
/

create or replace function &code_owner..$sx_pool_int2_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return number
is
begin
return utl_raw.cast_to_binary_integer($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname));
end;
/

create or replace function &code_owner..$sx_pool_int4_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return number
is
begin
return utl_raw.cast_to_binary_integer($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname));
end;
/

create or replace function &code_owner..$sx_pool_date_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return varchar2
is
begin
return utl_i18n.raw_to_char($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),'AL16UTF16');
end;
/

create or replace function &code_owner..$sx_pool_time_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return varchar2
is
begin
return 
  utl_i18n.raw_to_char($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),'AL16UTF16');
/*to_date('19800101'||
  utl_i18n.raw_to_char($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),'AL16UTF16'),'YYYYMMDDHH24MISS');
  */
end;
/

create or replace function &code_owner..$sx_pool_packed_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,
xleng in number, xdecimals in number,xtabname in varchar2,xcolname in varchar2)
return number
is
begin
return $sx_raw_packed_to_number($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),xleng,xdecimals,xtabname,xcolname);
end;
/



create or replace function &code_owner..$sx_concatenate_string (xlarge in varchar2)
return varchar2 is
y varchar2(2000);
x varchar2(2000);
begin
/*x := null;
y := xlarge;
loop
  exit when y is null;
  if length(y)> 80 then
    x := x || substr(y,1,80) || ''' || ''';
    y := substr(y,81);
  else
    x := x || y;
    y := null;
  end if;
  end loop;*/
  
y := '''' || xlarge || '''';
return y;
end;
/


create or replace function &code_owner..$sx_pool_double_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return number
is
begin
return utl_raw.cast_to_binary_double($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname));
end;
/
";

$s;
}
