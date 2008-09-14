#!/usr/bin/perl
#
#

use Oraperl;
eval 'use Oraperl; 1' || die $@ if $] >= 5;
$ora_long = 1000000000;

require "sql.pl";
require "fm_tables.pl";





#
# build_code - this does most of the work
# it creates files
#
#sub build_code {
#local ($serial_id) = @_;
$serial_id=1;
&fm_tables'login();

($serial_id,$serial,$serial2,$serial3,$serial4,$enc_n,$enc_e,
$database_name,
$company_name) = &sql'fetch_row("select serial_id,serial,
serial2,
serial3,
serial4,
n,
e,
database_name,
company_name
from kcd_purchased_product
where serial_id=$serial_id");

srand $serial_id;
# This script obsuftigates and drms the code - by watermarking the code in multiple ways
# because of the multiple ways, it is likely that we can figure out who copied what
# Serial is a special code that we internally set.  It is not to be stored riectly
$serial_id=1;
#$serial = AGHEY;
# Database name is the name of the database
#$database_name = "EAT AT JOES";
# company name is the name of the company
#$company_name ='PGP';
# serial2 is used to figure out which key field means what
#$serial2 = DFKRRDFSJKDSFKEE;
# a-i are 0-9 but the others variate
# serial3 is used to osfucitae the name of the variables
#$serial3=AQKLP;
# serial4 is used for return atermarking
#$serial4=ASE;
#$enc_n = '2085011741866147';
#$enc_e = 65537;



#print STDOUT &add_code_code($serial,$database_name) . "\n";
#print STDOUT &sub_code_code(&add_code_code($serial,$database_name) 
#              ,$database_name). "\n";
#print STDOUT &number_to_code(223342432) . "\n";
#print STDOUT &code_to_number(&number_to_code(223342432)) . "\n";

$builddir="/build/$serial_id";
system("cp -r /build/0 $builddir");

open(CRETAB,">$builddir/cretab.sql");
print CRETAB &generate_cretab($serial1,$serial2,$serial3,$serial4,$database_name,$company_name); 
close CRETAB;
open(CRECODE,">$builddir/crecode.sql");
print CRECODE &generate_crecode($serial1,$serial2,$serial3,$serial4,$database_name,$company_name); 
close CRECODE;
open(PRIMETAB,">$builddir/primetab.sql");
print PRIMETAB &generate_primetab($serial1,$serial2,$serial3,$serial4,$database_name,$company_name); 
close PRIMETAB;
open (BUILD_POOL_TABLE,">$builddir/build_pool_table.sql");
print BUILD_POOL_TABLE &generate_build_pool_table($serial1,$serial2,$serial3,$serial4,$database_name,$company_name);
close BUILD_POOL_TABLE;
open (BUILD_POOL_DEBUG,">$builddir/build_pool_debug.sql");
print BUILD_POOL_DEBUG &generate_build_pool_debug($serial1,$serial2,$serial3,$serial4,$database_name,$company_name);
close BUILD_POOL_DEBUG;
open (LICENSECODE,">$builddir/initial_license.sql");
print LICENSECODE &generate_license_code($serial_id,$database_name,$company_name);
close LICENSECODE;





# convert a numerical code to an alpha uppercase equivilant
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


# convert an Alpha uppercase code to a number
sub code_to_number {
local ($a) = @_;
local ($s);
local ($l,$i);
$l=length($a);
$i=$l-1;
$s=0;
while ($i>=0) {
  $s = $s *26 + ( (ord(substr($a,$i,1))-65) % 26);
  $i--;
  }
$s;
}


# subtract some code words
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
  $s .= chr(65+ ($ac-65  + 26-(($bc - 65)%26) ) % 26);
  }
return $s;
}


# add some code words
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
  $s .= chr(65+ ($ac-65 + $bc - 65) % 26);
  }
return $s;
}




# idx 
# this find the numerical value of an upeprcase ALPHA string at a given position
# it can handle any streen and returns a number between 0 and 25
#
sub idx{
local ($code,$pos) = @_;
return (ord(substr($code,$pos,1))-65+26+26+26) % 26;
}






#
# generate_function_names_from_serial2
# this helps keep the code varaying from each installation
#
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
@debg = qw(dbg debug db test tst tstdb testdb testdbg eval testeval 
dbgeval evaluate evaltst evaldb dbeval debugtest dbgtst overvw dbgview view undstnd
parsedbg deduce underdbg testview viewtest viewdb);


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
$debg = $debg[&idx($serial2,2)];

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
$sx_debug_column = $prefix . $pl . "_" . $debg;
$sx_dd03l = $prefix . "dd03l";
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
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name) = @_;
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
#$dbug = ""


&generate_function_names_from_serial2($serial2);
&generate_char_codes_from_serial3($serial3);

$s = "
REM build_pool_table.sql
REM Copyright(R) Killer Cool Development 2007-2008 All Rights Reserved.
REM This code has been copyrighted for the company $company_name
REM For use in the oracle database named $database_name
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
	'N','to_number(rtrim(ltrim(substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen)||')))) ',
'D'/*was to_date but failed due to T056F */,'(substr(varkey,'||(startint+1)
      ||','||
              to_number(intlen)||')) ',
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
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag='X') startint,
(select nvl(count(*),0)+1 dataseq
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag=' ') dataseq,
(select nvl(sum(intlen),0) startint
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag != 'X') startdataint      ,
    \&code_owner..$sx_concatenate_string(\&code_owner..$sx_fieldpos_for_table(tabname,as4local,as4vers,fieldname)) fieldpos
from \&code_owner..$sx_dd03l c
) c
where c.tabname='\&view_name'
order by position;
select ',varkey from \&owner..\"'||
sqltab||'\" where tabname = ''\&view_name'';'
 from \&owner..dd02l where tabname='\&view_name';

";
$s;
}










sub generate_build_pool_debug {
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name) = @_;
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

$dbug="\nselect 'dbms_lob.substr(vardata,40,1) zhib,dataln,' from dual;";
$dbug .="\nselect \&code_owner..$sx_concatenate_string(\&code_owner..$sx_fieldpos_for_table('\&view_name',as4local,as4vers,fieldname))||'   zfp,'  
from \&code_owner..$sx_dd03l c
where c.tabname='\&view_name'
and rownum<2;";


# $dbug = ""


&generate_function_names_from_serial2($serial2);
&generate_char_codes_from_serial3($serial3);

$s = "
REM build_pool_debug.sql
REM Copyright(R) Killer Cool Development 2007-2008 All Rights Reserved.
REM This code has been copyrighted for the company $company_name
REM For use in the oracle database named $database_name
REM
REM Package Version 1.4
REM ModuleVersion 2.1.18.1
REM This program will generate a debug extract view that allows troubleshooting with any errors on accessing a pool table/
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
REM
REM note that __DEBUG will be postfixed on the view name
REM
REM This script is designed to be run by a DBA account on the database that gets the views.
REM                
define view_name=\"\&1\"
define prefix=\"\&2\"
define owner=\"\&3\"
define code_owner=\"\&4\"



select 'create or replace view \&code_owner..\"\&prefix.\&view_name.__DEBUG\" as select' from dual;$dbug

select 
decode(to_number(position),1,null,',')||
decode(keyflag,'X',
   decode(inttype,'C','substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen) ||') ',
	'N','to_number(rtrim(ltrim(substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen)||')))) ',
'D','(substr(varkey,'||(startint+1)
      ||','||
              to_number(intlen)||')) ',
'substr(varkey,'||(startint+1)
      ||','||
        to_number(intlen) ||') '	      
	),
   decode(inttype,
   'C',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||
     ''')'
,  'N',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'X', decode(datatype,
         'RAW',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT1',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT2',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT4',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         , ' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
	 )
,  'P',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'D',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'F',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  ' ',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'T',' \&code_owner..$sx_pool_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,'???unknown inttype '||inttype||'.'
	))
	   || decode(inttype,' ','\"'||fieldname||position|| '\"','\"'||fieldname||'\"')
from	   
(select c.*,(select nvl(sum(intlen),0) startint
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag='X') startint,
(select nvl(count(*),0)+1 dataseq
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag=' ') dataseq,
(select nvl(sum(intlen),0) startint
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag != 'X') startdataint      ,
    \&code_owner..$sx_concatenate_string(\&code_owner..$sx_fieldpos_for_table(tabname,as4local,as4vers,fieldname)) fieldpos
from \&code_owner..$sx_dd03l c
) c
where c.tabname='\&view_name'
order by position;


select 
','||
   decode(inttype,
   'C',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||
     ''')'
,  'N',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'X', decode(datatype,
         'RAW',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT1',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT2',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         ,'INT4',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
         , ' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
	 )
,  'P',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'D',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'F',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  ' ',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,  'T',' \&code_owner..$sx_debug_column(vardata,dataln,'||dataseq||','||fieldpos||','''||tabname||''','''||fieldname||''')'
,'???unknown inttype '||inttype||'.'
	)
	   || decode(inttype,' ','\"'||fieldname||position||'__DEBUG'||'\"','\"'||fieldname||'__DEBUG\"')
from	   
(select c.*,(select nvl(sum(intlen),0) startint
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag='X') startint,
(select nvl(count(*),0)+1 dataseq
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag=' ') dataseq,
(select nvl(sum(intlen),0) startint
      from \&code_owner..$sx_dd03l c2
      where c2.tabname = c.tabname
      and c2.as4local = c.as4local
      and c2.as4vers = c.as4vers
      and c2.position < c.position
      and keyflag != 'X') startdataint      ,
    \&code_owner..$sx_concatenate_string(\&code_owner..$sx_fieldpos_for_table(tabname,as4local,as4vers,fieldname)) fieldpos
from \&code_owner..$sx_dd03l c
) c
where c.tabname='\&view_name'
and nvl(keyflag,'Y') != 'X'
order by position;



select ',varkey from \&owner..\"'||
sqltab||'\" where tabname = ''\&view_name'';'
 from \&owner..dd02l where tabname='\&view_name';

";

$s;
}









sub generate_cretab {
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name) = @_;
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
REM cretab.sql
REM Copyright(r) KCD 2007-2008 All Rights Reserved.
REM This has the create table statements for the SAP pool data extractor
REM
REM Package Version 1.4
REM ModuleVersion 1.14.3.2
define owner=\"\&1\"
define code_owner=\"\&2\"


create table &code_owner.." . $prefix . "dd03l_patch (
tabname varchar2(90) not null,
fieldname varchar2(90) not null,
operation varchar(3) not null,
id number  not null,
the_date date not null,
notes varchar2(2000),
bugid varchar2(20),
position varchar2(12),
keyflag varchar2(3),
inttype varchar2(3),
intlen varchar2(18),
datatype varchar2(12),
leng varchar2(18),
decimals varchar2(18),
constraint " . $prefix . "dd03l_patch_pk primary key(id),
constraint " . $prefix . "dd03l_patch_uk unique (tabname,fieldname),
constraint " . $prefix . "dd03l_patch_ck1 check (operation in ('INS','UPD','DEL'))
);

create table &code_owner.." . $prefix . "dd03l_current_versions (
as4local varchar2(3) not null,
as4vers varchar2(12) not null,
constraint " . $prefix . "dd03l_current_version_pk primary key (as4local,as4vers)
);

create table &code_owner.." . $prefix . "license_entry (
entity_id number,
serial_id number not null,
daycode number not null,
mung number,
constraint " . $prefix . "license_entry_pk primary key (daycode,serial_id)
);

";

return $s;

}







sub generate_primetab {
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name) = @_;
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

# these are used to cover up the 20001 calls

$s = "
REM primetab.sql
REM Copyright(r) KCD 2007-2008 All Rights Reserved.
REM This primes the tables with data required for extraction
REM
REM Package Version 1.4
REM ModuleVersion 1.14.3.2
define owner=\"\&1\"
define code_owner=\"\&2\"

delete from  &code_owner.." . $prefix . "dd03l_patch where id<100;
delete from  &code_owner.." . $prefix . "dd03l_current_versions;

insert into  &code_owner.." . $prefix . "dd03l_current_versions(as4local,as4vers) select distinct as4local,as4vers
from &owner..dd06t;


insert into  &code_owner.." . $prefix . "dd03l_patch (
tabname,
fieldname,
operation,
id,
the_date,
notes,
bugid,
position,
keyflag,
inttype,
intlen,
datatype,
leng,
decimals
)
values (
 'TFB03T',
 'FIVOR',
 'UPD',
 1,
 to_date('01-aug-08','dd-mon-rr'),
 'Gets an ORA-01722 error on base testing.',
 'A-001',
 '0003',
 'X',
 'C',
 null,
 'CHAR',
 null,
 null
 );

insert into  &code_owner.." . $prefix . "dd03l_patch (
tabname,
fieldname,
operation,
id,
the_date,
notes,
bugid,
position,
keyflag,
inttype,
intlen,
datatype,
leng,
decimals
)
values (
 'T5D1I',
 'EHBTR',
 'UPD',
 2,
 to_date('01-aug-08','dd-mon-rr'),
 'T5D1I has three fields where the length is way bigger in the dictionary than in the raw fields: EHBTR, EMBTR and RTBTR',
 'A-002',
 null,
 null,
 null,
 '000002',
 null,
 '000001',
 null
 );

insert into  &code_owner.." . $prefix . "dd03l_patch (
tabname,
fieldname,
operation,
id,
the_date,
notes,
bugid,
position,
keyflag,
inttype,
intlen,
datatype,
leng,
decimals
)
values (
 'T5D1I',
 'EMBTR',
 'UPD',
 3,
 to_date('01-aug-08','dd-mon-rr'),
 'T5D1I has three fields where the length is way bigger in the dictionary than in the raw fields: EHBTR, EMBTR and RTBTR',
 'A-002',
 null,
 null,
 null,
 '000002',
 null,
 '000001',
 null
 );


insert into  &code_owner.." . $prefix . "dd03l_patch (
tabname,
fieldname,
operation,
id,
the_date,
notes,
bugid,
position,
keyflag,
inttype,
intlen,
datatype,
leng,
decimals
)
values (
 'T5D1I',
 'RTBTR',
 'UPD',
 4,
 to_date('01-aug-08','dd-mon-rr'),
 'T5D1I has three fields where the length is way bigger in the dictionary than in the raw fields: EHBTR, EMBTR and RTBTR',
 'A-002',
 null,
 null,
 null,
 '000001',
 null,
 '000001',
 null
 );
 
";

return $s;

}









#
# This reads the records in kcd_license_entry and generates a script that will do the insert.
#
sub generate_license_code {
local ($serial_id,$database_name,$company_name) = @_;
# Serial is a special code that we internally set.  It is not to be stored riectly

local ($mindate,$maxdate) = &sql'fetch_row("select to_char(to_date(min(daycode),'yyyymmdd'),'Month Day, YYYY')
,max(daycode) from kcd_license_entry where serial_id=$serial_id");
 



local ($s) = ("");
$s = "REM initial_license.sql
REM Copyright(R) Killer Cool Development 2007-2008 All Rights Reserved.
REM This code has been copyrighted for the company $company_name
REM For use in the oracle database named $database_name
REM
REM Package Version 1.4
REM ModuleVersion 2.1.18.1
REM 
REM This script is intended to grant a license for use of the pool table viewer software
REM from $mindate to $maxdate.
REM Additional Licensing can be purchased at http://PoolTableViewer.com
REM
REM This script will provide licensing 
REM It takes 1 parameter
REM
REM code_owner
REM This could be 
REM   SAPSR3 - If you dare to put these views. This is more convienent but less safe.
REM   SAPSR3P - A separate schema with limited access to only POOL tables and DDL tables. This is more safe.
REM   another user - If just testing.
REM owner - the owner of the SAP tables
REM 
REM NOTE: This licensing is specific to the database named $database_name
REM if you intend to use this software on a differently named database,  please contact Killer Cool Development, LLC.
REM                
";

$sel = "select entity_id,daycode,mung from kcd_license_entry where serial_id=$serial_id
  and mung is not null
  order by daycode";
$csr = &sql'open($sel);
while (@row=&sql'fetch($csr)) {
  local ($entity_id,$daycode,$mung) = @row;
  if ($entity_id eq "") {$entity_id = "NULL";}
  
  $s .= "  delete from &code_owner.." . $prefix . "license_entry where serial_id=$serial_id and daycode=$daycode;
insert into &code_owner.." . $prefix . "license_entry values ($entity_id,$serial_id,$daycode,$mung);\n";
  }
&sql'close($csr);

$s .= "
REM This is it.  If your lease time has expired,  please contact Killer Cool Development, LLC. for a new lease.
";
return $s;

}




sub generate_crecode {
local ($serial,$serial2,$serial3,$serial4,$database_name,$company_name) = @_;
# Serial is a special code that we internally set.  It is not to be stored riectly
# Database name is the name of the database
# company name is the name of the company
# serial2 is used to figure out which key field means what. Company specific
# a-i are 0-9 but the others variate
# serial3 is used to osfucitae the name of the variables
# serial4 is used for return atermarking

local ($s) = ("");


local $r1 = int(rand()*20000);
$r2 = 20001-$r1;
local $r3 = int(rand()*20000);
$r4 = 20001-$r3;

&generate_function_names_from_serial2($serial2);
&generate_char_codes_from_serial3($serial3);

$database_code = &code_to_number($database_name);
if ($database_code < 0) {$database_code = -$database_code;}
$database_code = $database_code % 1000;


$s = "
REM crecode.sql
REM Copyright(r) KCD 2007-2008 All Rights Reserved.
REM This code has been copyrighted for the company $company_name
REM For use in the oracle database named $database_name
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
REM View $sx_dd03l
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


REM &code_owner..$sx_dd03l view
REM this allows for adjustments to the data dictironary to match what is in the other stuff.
create or replace view &code_owner..$sx_dd03l
as
select d.tabname,d.fieldname,d.as4vers,d.as4local,
nvl(c.position,d.position) position,
nvl(c.keyflag,d.keyflag) keyflag,
nvl(c.inttype,d.inttype) inttype,
nvl(c.intlen,d.intlen) intlen,
nvl(c.datatype,d.datatype) datatype,
nvl(c.leng,d.leng) leng,
nvl(c.decimals,d.decimals) decimals
from &owner..dd03l d,
  &code_owner.." . $prefix . "dd03l_patch c
where c.tabname (+) = d.tabname
  and c.fieldname (+) = d.fieldname
  and nvl(c.operation,'UPD') ='UPD'
union all
select c.tabname,c.fieldname,e.as4vers,e.as4local,
c.position,
c.keyflag,
c.inttype,
c.intlen,
c.datatype,
c.leng,
c.decimals
from &code_owner.." . $prefix . "dd03l_patch c,
 &code_owner.." . $prefix . "dd03l_current_versions e
where c.operation = 'INS'
;






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
 from &code_owner..$sx_dd03l 
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
ft varchar2(2);
x1 varchar2(10);
xn varchar2(200);
wow varchar2(40);
c1 varchar2(1);
n1 number;
u number;
xfieldtypes varchar2(2000);
maxc varchar2(2);
maxn1 number;
ynumber number(10);
fieldpos number;
bur varchar2(30);
startcode varchar2(10);
fixednum number;
vskip number;
xmode number;
extra_add number;
oop varchar2(20);

begin
oop := 'License Error.';
ynumber := 1;
n1 := 0;
fieldpos := 1;
xfieldtypes := fieldtypes;

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

if xnumber = 1 then
  bur := 'Contact Killer';
  declare
   x number;
   i number;
   l number;
   s number;
   nc varchar2(60);
   begin
   select global_name into nc from sys.global_name;
   if instr(nc,'.') != 0 then
     nc := substr(nc,1,instr(nc,'.')-1);
     end if;
   l := length(nc);
   i := l;
   s := 0;
   loop
     exit when i<1;
     s := s * 26 +  mod((ascii(substr(nc,i,1)) - 65) , 26);
     i := i - 1;
     end loop;
   if (s < 0) then s  := -s; end if;
   u := mod(s,1000);
   end;
  end if;  



        
vskip := 0;
extra_add := 0;
loop
  ystart := ystart + extra_add;
  extra_add := 0;
  
  ft := substr(xfieldtypes,fieldpos,1); /* get the field type - $varv or $varf or $varp 
  $varv is for variable langth character string  and it is pretty easy.
  $varf is for a fixed length in bytes
  $varp is for a packed number that is read until there is some number where
   the lower part is not between 0-9 (0C for +, 0D for -, 0F for unsigned)*/

  maxn1 := 0;
  loop
     maxc := substr(xfieldtypes,fieldpos+1,1); /* get the number code */
     exit when nvl(maxc,'$varj') <'$from_letter' or nvl(maxc,'$varj') > '$to_letter';
     fieldpos := fieldpos +1;
     maxn1 := maxn1 * 10 + ascii(maxc) - ascii('$from_letter');
    end loop;
    
      
  if vskip >0 then
    vskip := vskip -1;
    n1 := 0;
  else 
    
    /* if $varv this is a variable field with a length.  but sometimes it does not have length
       for instance - if the field is a xmode 1 (positive length). 
       */
    if ft = '$varv' and (xmode != 2) then
      ft := '$varf';
      end if;
     
    if ft = '$varv' then
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
      
      if maxn1 >3 and xmode = 2 and
           (substr(xn,1,2) = '00') then /* skip fields packed  - does not work with 3 or less. - 4 is tested (T043G) - as is 3 is! */
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
          exit when (nvl(c1,'P') = 'C' or nvl(c1,'P') = 'D' or nvl(c1,'P') = 'P');
	  if nvl(c1,'P') > '9' then
	    /* if error */
	    raise_application_error(-20002,'Invalid packed number with character '||c1);
	    /* if not error, return null */
	    end if;
          n1 := n1 + 1;
	  exit when xmode !=2 and n1 = maxn1; /* sometimes the end will be reached without the centenniel T157T 
	                                          but only in fixed sizes */
          end loop;
        if(xmode = 1 and mod(maxn1,2) = 1) and
	    xtabname in ('T5C0P','T5DI1','T052S','T157T')
              then /* could be mod if n1 I dont know  t5C0P and T5DI1 */
	  extra_add := 1; /* do not include for return value, just skip to the lou */
	  end if;
	end if;
      end if;
    end if; /* we are not being skipped */
  ynumber := ynumber + 1;
  fieldpos := fieldpos + 1;
    
  exit when ynumber > xnumber;
 
  ystart := ystart + n1;
  end loop;

wow := 'Cool Development, LLC.';

if xnumber = 1 then
  begin
  select nvl(mung,1) into maxn1 from &code_owner.." . $prefix . "license_entry where serial_id = $serial_id
   and daycode=to_number(to_char(sysdate,'yyyymmdd'));
  exception when no_data_found then 
    raise_application_error(-($r1 + $r2),oop||' '||bur||' '||wow);
    end;
  xmode := $enc_e;
  n1 := 1;
  loop
    exit when xmode<=0;
    if (mod(xmode,2) = 1) then
      n1 := mod(n1*maxn1,$enc_n);        
      end if;
    xmode := trunc(xmode/2);
    maxn1 := mod(maxn1*maxn1,$enc_n);
  end loop;
  if mod(trunc(n1 / 100), 1000) != u
    and mod(trunc(n1/100000),100000000) != to_number(to_char(sysdate,'yyyymmdd')) then
    raise_application_error(-($r3 + $r4),oop||' '||bur||' '||wow);
  end if;
end if;

return dbms_lob.substr(xblob,n1,ystart);
end;
/



  
    
      
	
create or replace function &code_owner..$sx_debug_column(xblob in blob,
xbloblength in number,  xnumber in number,fieldtypes in varchar2,xtabname in varchar2,xcolname in varchar2)
return varchar2
is
me varchar2(2000);
buf raw(4);
ystart number;
ft varchar2(2);
x1 varchar2(10);
xn varchar2(200);
wow varchar2(40);
c1 varchar2(1);
n1 number;
xfieldtypes varchar2(2000);
maxc varchar2(2);
maxn1 number;
u number;
ynumber number(10);
fieldpos number;
bur varchar2(30);
startcode varchar2(10);
fixednum number;
vskip number;
xmode number;
extra_add number;
oop varchar2(20);

begin
oop := 'License Error.';
ynumber := 1;
n1 := 0;
fieldpos := 1;
xfieldtypes := fieldtypes;

me := '';

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
   
   

if xnumber = 1 then
  bur := 'Contact Killer';
  declare
   x number;
   i number;
   l number;
   s number;
   nc varchar2(60);
   begin
   select global_name into nc from sys.global_name;
   if instr(nc,'.') != 0 then
     nc := substr(nc,1,instr(nc,'.')-1);
     end if;
   l := length(nc);
   i := l;
   s := 0;
   loop
     exit when i<1;
     s := s * 26 +  mod((ascii(substr(nc,i,1)) - 65) , 26);
     i := i - 1;
     end loop;
   if (s < 0) then s  := -s; end if;
   u := mod(s,1000);
   end;
  end if;  

  

        
vskip := 0;
extra_add := 0;
loop
  ystart := ystart + extra_add;
  extra_add := 0;
  
  ft := substr(xfieldtypes,fieldpos,1); /* get the field type - $varv or $varf or $varp 
  $varv is for variable langth character string  and it is pretty easy.
  $varf is for a fixed length in bytes
  $varp is for a packed number that is read until there is some number where
   the lower part is not between 0-9 (0C for +, 0D for -, 0F for unsigned)*/

  maxn1 := 0;
  loop
     maxc := substr(xfieldtypes,fieldpos+1,1); /* get the number code */
     exit when nvl(maxc,'$varj') <'$from_letter' or nvl(maxc,'$varj') > '$to_letter';
     fieldpos := fieldpos +1;
     maxn1 := maxn1 * 10 + ascii(maxc) - ascii('$from_letter');
    end loop;
    
  me := me ||'|  '||ft||maxn1;    
  if vskip >0 then
    vskip := vskip -1;
    n1 := 0;
  else 
    
    /* if $varv this is a variable field with a length.  but sometimes it does not have length
       for instance - if the field is a xmode 1 (positive length). 
       */
    if ft = '$varv' and (xmode != 2) then
      me := me || '(force fixed)';
      ft := '$varf'; /* has a fake placeholder that needs to be skipped for the variable part T052S*/
      end if;
     
    if ft = '$varv' then
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
      me := me || 'a-'||maxn1||':'||xmode;
        if maxn1 >3 and xmode = 2 and
           (substr(xn,1,2) = '00') then /* skip fields packed  - does not work with 3 or less. - 4 is tested (T043G) - as is 3 is! */
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
        me := me || 'b';

        loop
          /* convert hex into a number */
          me := me || 'c';
          c1 := substr(xn,((n1-1)*2)+2,1);
          exit when nvl(c1,'P') > '9';
          me := me || 'd';
          n1 := n1 + 1;
	  exit when xmode !=2 and n1 = maxn1; /* sometimes the end will be reached without the centenniel T157T 
	                                          but only in fixed sizes */
          end loop;
        me := me || 'e';
        if(xmode = 1 and mod(maxn1,2) = 1) and
	    xtabname in ('T5C0P','T5DI1','T052S','T157T')
              then /* could be mod if n1 I dont know  t5C0P and T5DI1 */
	  extra_add := 1; /* do not include for return value, just skip to the lou */
	  me := me ||'X';
	  else
	    me := me||'v';
	  end if;
	  
        end if;
      end if;
    end if; /* we are not being skipped */
  ynumber := ynumber + 1;
  fieldpos := fieldpos + 1;
    
  exit when ynumber > xnumber;
 
  me := me || ' from '||to_char(ystart) || ' + '||to_char(n1) ||' = '||to_char(ystart+n1);

  ystart := ystart + n1;
  end loop;

wow := 'Cool Development, LLC.';

if xnumber = 1 then
  begin
  select nvl(mung,1) into maxn1 from &code_owner.." . $prefix . "license_entry where serial_id = $serial_id
   and daycode=to_number(to_char(sysdate,'yyyymmdd'));
  exception when no_data_found then 
    raise_application_error(-($r1 + $r2),oop||' '||bur||' '||wow);
    end;
  xmode := $enc_e;
  n1 := 1;
  loop
    exit when xmode<=0;
    if (mod(xmode,2) = 1) then
      n1 := mod(n1*maxn1,$enc_n);        
      end if;
    xmode := trunc(xmode/2);
    maxn1 := mod(maxn1*maxn1,$enc_n);
  end loop;
  if mod(trunc(n1 / 100), 1000) != u
    and mod(trunc(n1/100000),100000000) != to_number(to_char(sysdate,'yyyymmdd')) then
    raise_application_error(-($r3 + $r4),oop||' '||bur||' '||wow);
  end if;
end if;

me := me || ' FINAL '||to_char(ystart) || ' + '||to_char(n1) ||' = '||to_char(ystart+n1);
return me;
/*return dbms_lob.substr(xblob,n1,ystart);*/
end;
/



	    
		    	    
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
/* trim the values to handle spaces as in select sfall from sapsr3p.t156v where feldv='MARC-VKUMC' */
return to_number(rtrim(ltrim(utl_i18n.raw_to_char($sx_pool_column(xblob,xbloblength,xnumber,
  fieldtypes,xtabname,xcolname),'AL16UTF16'))));
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
