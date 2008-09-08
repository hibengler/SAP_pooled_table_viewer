set serveroutput on size 1000000
insert into kcd_product values (1002,'Pool Table Viewer SAPSR3 using Oracle DB','http://www.pooltableviewer.com')
/
begin
 kcd_new_purchased_product(1,1002,'Killer Cool Development, LLC.','ERNIE');
end;
/

