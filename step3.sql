REM step3.sql - licensing 
REM This loads up the appropriate license codes so that the Pool Table Viewer logic works.
REM
set heading off feedback off verify off pagesize 0 linesize 400


define owner=SAPSR3
define code_owner=SAPSR3P
define prefix=""
define code_password=secret95




prompt Installing initial license.;

@initial_license "&code_owner"
commit;

prompt All done with step3;
