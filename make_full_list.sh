echo "select 'echo '||view_name||';echo \"select '''||view_name||''' view_name, x.* from SAPSR3P.\\\"'||view_name||'\\\" x\" | dsg -h -a -s 2>&1 ' from user_views order by 1"  | dsg -h -a -s | grep -v '__DEBUG'