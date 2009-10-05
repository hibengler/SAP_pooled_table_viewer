#!/usr/bin/perl
use Oraperl;
eval 'use Oraperl; 1' || die $@ if $] >= 5;
$ora_long = 1000000000;

require "sql.pl";
require "fm_tables.pl";


require "enc.pl";


  

$r = &fm_tables'login();
if ($r != 0) {
  &error_page ("Our Database is down");
  return 1;
  }
  
($serial_id) = $ARGV[0];
  
  
&ok_db_set_now_lets_build_it($serial_id);
  
      


sub ok_db_set_now_lets_build_it {
local ($serial_id) = @_;
print STDERR "Real PURCHASE!Serial $serial_id";
&build_code_silent($serial_id);
}



1;
