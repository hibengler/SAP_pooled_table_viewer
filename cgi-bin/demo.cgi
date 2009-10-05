#!/usr/bin/perl
use Oraperl;
eval 'use Oraperl; 1' || die $@ if $] >= 5;
$ora_long = 1000000000;

require "sql.pl";
require "fm_tables.pl";


require "work.pl";


&work();



