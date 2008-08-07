REM step2 - this generates the create view scripts
set heading off feedback off verify off pagesize 0 linesize 400


define owner=SAPSR3
define code_owner=SAPSR3


spool build_all_pool_tables.sql
select '@build_pool_table "'||tabname||'" "&prefix" "&owner" "&code_owner"'  
from &owner..dd02l
  where tabclass='POOL' order by tabname,sqltab;
spool off
spool all_pool_tables.sql
@build_all_pool_tables.sql
spool off
@all_pool_tables.sql




spool build_all_debug_pool_tables.sql
select '@build_pool_debug "'||tabname||'" "&prefix" "&owner" "&code_owner"'  
from &owner..dd02l
  where tabclass='POOL' order by tabname,sqltab;
spool off
spool all_debug_pool_tables.sql
@build_all_debug_pool_tables.sql
spool off
@all_debug_pool_tables.sql


 
