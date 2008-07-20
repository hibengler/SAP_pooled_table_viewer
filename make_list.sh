echo "select 'echo \"select '''||view_name||''' view_name, x.* from \\\"'||view_name||'\\\" x where rownum<2000\" | dsg -h -a -s 2>&1 ' from user_views order by 1"  | dsg -h -a -s
