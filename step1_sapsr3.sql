REM step1_sapsr3.sql - this creates the framework in the SAPSR3 user.
REM Copyright 2008 Killer Computer Development, LLC.
REM http://kcd.com
REM 
set heading off feedback off verify off pagesize 0 linesize 400

define owner=SAPSR3
define code_owner=SAPSR3
define prefix=""






prompt Creating the database tables
@cretab "&owner" "&code_owner"

prompt Creating the database code
@crecode "&owner" "&code_owner"

prompt Priming the database tables
@primetab "&owner" "&code_owner"



prompt we are now ready for step2_sapsr3.sql

 
