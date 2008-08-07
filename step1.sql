REM step1.sql - this creates the new user,   makes specific grants from the SAP arena,  and creates the framework
set heading off feedback off verify off pagesize 0 linesize 400

define owner=SAPSR3
define code_owner=SAPSR3P
define prefix=""
define code_password=secret95



prompt creating the SAPSR3P user
create user sapsr3p identified by &code_password;
grant connect,create view,create procedure to sapsr3p;
grant resource to sapsr3p;



prompt Granting access on the SAP pool tables and Data Dictionary tables
spool grant_base_tables.sql
select 'GRANT select on &owner.."'||
table_NAME||'" to &code_owner with grant option'
||';'
from dba_tables
where  owner='&owner'
  and table_name in (select sqltab from &owner..dd02l
where tabclass='POOL'
union
select tabname from &owner..dd02l
where tabname like 'DD%');
spool off
@grant_base_tables.sql




prompt Creating the database tables
@cretab "&owner" "&code_owner"

prompt Creating the database code
@crecode "&owner" "&code_owner"

prompt Priming the database tables
@primetab "&owner" "&code_owner"



prompt we are now ready for step2

 
