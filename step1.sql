set heading off feedback off verify off pagesize 0 linesize 400


define owner=SAPSR3
define code_owner=SAPSR3P
define prefix=""
define code_password=secret95


create user sapsr3p identified by &code_password;
grant connect,create view,create procedure to sapsr3p;
grant resource to sapsr3p;




spool x.sqld
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
@x.sqld  



@crecode "&owner" "&code_owner"

spool y.sqld
select '@build_pool_table "'||tabname||'" "&prefix" "&owner" "&code_owner"'  
from &owner..dd02l
  where tabclass='POOL' order by tabname,sqltab;
spool off
spool z.sqld
@y.sqld
spool off
@z.sqld




spool v.sqld
select '@build_pool_debug "'||tabname||'" "&prefix" "&owner" "&code_owner"'  
from &owner..dd02l
  where tabclass='POOL' order by tabname,sqltab;
spool off
spool w.sqld
REM @v.sqld
spool off
REM @w.sqld


 
