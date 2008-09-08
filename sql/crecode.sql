create or replace function kcd_is_prime(xx in number)
/* determines if a number is prima and not - not an estimate */
return number
is
p number; q number;
m number;
n number;
begin
if mod(xx,2) = 0 then return 0; end if;
n := 0;
loop
  exit when n+n > xx;
  
  m := sqrt(n*n+xx);
  if m = trunc(m) then
    p := m+n;
    q :=m-n;
    if (q=1) then return 1;
      else 
    return(0);
    end if;
    end if;
    
  n := n+1;
  end loop;
return(1);
end;
/
create or replace function kcd_find_prime(min_value number,max_value number)
return number
is
xx number;
begin
xx := trunc(dbms_random.value * (max_value - min_value))+min_value;
if mod(xx,2) = 0 then xx := xx + 1; end if;
loop
  exit when kcd_is_prime(xx)=1;
  xx := xx + 2;
end loop;
return(xx);
end;
/
create or replace function kcd_gcd(xa in number,xb in number)
return number
is
a number;
b number;
t number;
begin
a := xa;
b := xb;
loop
  exit when b<=0;
  t := b;
  b := mod(a,b);
  a := t;
  end loop;
return(a);
end;
/
create or replace function kcd_lcm(xa in number,xb in number)
return number
is
a number;
begin
a := xa / kcd_gcd(xa,xb);
return(a*xb);
end;
/
create or replace function kcd_extended_gcd(xb number,xn number)
return number
is
b0 number;
n0 number;
t0 number;
t number;
q number;
r number;
b number;
n number;
temp number;

begin
b := xb;
n := xn;
b0 := b;
n0 := n;
/* from http://www-fs.informatik.uni-tuebingen.de/~reinhard/krypto/English/2.2.e.html*/
t0 := 0;
t := 1;
q := trunc(n0/b0);
r := n0 - q * b0;

loop
  exit when r <=0;
  temp := t0 - q * t;
  if temp >= 0 then temp := mod(temp,n); end if;
  if temp < 0 then temp := n - mod(( -temp), n); end if;
  t0 := t;
  t := temp;
  n0 := b0;
  b0 := r;
  q := trunc(n0 / b0);
  r := n0 - q * b0;
  end loop;
  
  if b0 != 1 then
     return null;
  else
    return t;
    end if;

end;
/






create or replace function kcd_modpow(xb number, xe number, m number)
return number
is
result number;
b number;
e number;
begin
b := xb;
e := xe;
result := 1;
loop
  exit when e<=0;
    if (mod(e,2) = 1) then
      result := mod(result*b,m);
      end if;
    e := trunc(e/2);
    b := mod(b*b,m);
  end loop;
return result;
end;
/      






create or replace procedure kcd_set_key_purchased_product (xserial_id in number)
is

from_range number;
to_range number;
p number;
q number;
totient number;
e number;
n number;
d number;
da number;
source number;
sign number;
xresource number;

begin
from_range := 12800000;
to_range   := 65534009;

loop
  loop
p := kcd_find_prime(from_range,to_range);
q := kcd_find_prime(from_range,to_range); 
  exit when p != q;
  end loop;
/* testing */
dbms_output.put_line('p '||p);
dbms_output.put_line('q '||q);
n := p*q;

totient := kcd_lcm(p-1,q-1);
/*totient := (p-1)*(q-1);*/
dbms_output.put_line ('totient  '||totient);
e := 65537; 
  exit when  kcd_gcd(totient,e) = 1;
 end loop;

d := kcd_extended_gcd(e,totient);
dbms_output.put_line ('d '||d);
dbms_output.put_line ('test ' || mod(e*d,totient));
source := trunc(dbms_random.value(11,81))*10000000000+ to_number(to_char(sysdate,'yyyymmdd'))*100 + trunc(dbms_random.value(11,81));
/*source := to_number(to_char(sysdate,'yyyymmdd'));*/
dbms_output.put_line ('source '||source);
sign := kcd_modpow(source,d,n);
dbms_output.put_line('sign '||sign);
xresource := kcd_modpow(sign,e,n);
dbms_output.put_line ('resource '||xresource);

declare
  xp number;
  xq number;
  xtotient number;
  xn number;
  xe number;
  xd number;
begin
 xp := p;
 xq := q;
 xtotient := totient;
 xn := n;
 xe := e;
 xd := d;
 update kcd_purchased_product
 set p=xp,q=xq,totient=xtotient,n=xn,
   e=xe,d=xd where serial_id=xserial_id;
 end;

end;
/






create or replace procedure kcd_build_license_entries(xserial_id in number,xentity_id in number,
xfrom_date in date,xto_date in date)
is
xdate date;
xn number;
xd number;
xdatabase_name varchar2(20);
xdatabase_code number;
source number;
begin
select n,d,database_name into xn,xd,xdatabase_name from kcd_purchased_product where serial_id=xserial_id;
xdate := trunc(xfrom_date);
/* figure out the database code from the database name
This is pivotal in the security, as the database code is added to the number we are encrypting.
It will be RRYYYYMMDDCCCRR Where CCC is the database code 
This is duplicated in enc.pl - code_to_number
and it is imperfect - underscores and other characters could return negative or out of scope results
we make it positive and module by 100.  good enough.
*/
if xdatabase_name is null then
  raise_application_error(-20003,'need database name');
  end if;
dbms_output.put_line('database name is '||xdatabase_name);

declare
 x number;
 i number;
 l number;
 s number;
 begin
 l := length(xdatabase_name);
 i := l;
 s := 0;
 loop
   exit when i<1;
   s := s * 26 +  mod((ascii(substr(xdatabase_name,i,1)) - 65) , 26);
   i := i - 1;
   dbms_output.put_line('i '||i||' s '||s);
   end loop;
 if (s < 0) then s  := -s; end if;
 xdatabase_code := mod(s,1000);
 end;
 
dbms_output.put_line('database code is '||xdatabase_code);
loop
  exit when xdate+1 > xto_date;
  delete from kcd_license_entry where serial_id=xserial_id and daycode=to_number(to_char(xdate,'YYYYMMDD'));
  source := trunc(dbms_random.value(11,81))*10000000000000+ 
            to_number(to_char(xdate,'yyyymmdd'))*100000 +
	    xdatabase_code*100 + 
            trunc(dbms_random.value(11,81));
  insert into kcd_license_entry values (xentity_id,xserial_id,to_number(to_char(xdate,'YYYYMMDD')),kcd_modpow(source,xd,xn));
  xdate := xdate + 1;
  end loop;
end;
/



create or replace procedure kcd_set_purchase_param (
  xserial_id number,
  xdatabase_name varchar2,
  xowner varchar2,
  xcompany_name varchar2)
is
xserial varchar2(5);
xserial2 varchar2(16);
xserial3 varchar2(5);
xserial4 varchar2(3);
j varchar2(1);
begin
xserial := dbms_random.string('',5);
xserial2 := dbms_random.string('',16);
xserial4 :=  dbms_random.string('',3);

/* serial3 is special - because the first random character needs to be between a-Q - and then then other random characters
  need to be around a 10 character block 
  Also - the next set of letters need to be random */
loop 
  xserial3 := dbms_random.string('',1);
  exit when xserial >='A' and xserial3 <='Q';
end loop;

loop
  j := dbms_random.string('',1);
  exit when j< substr(xserial3,1,1) or j >  chr(ascii(substr(xserial3,1,1))+10);
  /* if outside the 10 character range */
end loop;
xserial3 := xserial3 || j;

loop
  j := dbms_random.string('',1);
  exit when (j< substr(xserial3,1,1) or j >  chr(ascii(substr(xserial3,1,1))+10))
      and j != substr(xserial3,2,1);
  /* if outside the 10 character range */
end loop;
xserial3 := xserial3 || j;

loop
  j := dbms_random.string('',1);
  exit when (j< substr(xserial3,1,1) or j >  chr(ascii(substr(xserial3,1,1))+10))
      and j != substr(xserial3,2,1)
      and j != substr(xserial3,3,1);
  /* if outside the 10 character range */
end loop;
xserial3 := xserial3 || j;

loop
  j := dbms_random.string('',1);
  exit when (j< substr(xserial3,1,1) or j >  chr(ascii(substr(xserial3,1,1))+10))
      and j != substr(xserial3,2,1)
      and j != substr(xserial3,3,1)
      and j != substr(xserial3,4,1);
  /* if outside the 10 character range */
end loop;
xserial3 := xserial3 || j;


update kcd_purchased_product 
  set serial=nvl(serial,xserial),
      database_name=xdatabase_name,
      owner=xowner,
      company_name=xcompany_name,
      serial2=nvl(serial2,xserial2),
      serial3=nvl(serial3,xserial3),
      serial4=nvl(serial4,xserial4)
where serial_id = xserial_id;
end;
/

      
 

create or replace procedure kcd_new_purchased_product
(xserial_id in number,
xproduct_id in number,
xcompany_name in varchar2,
xdatabase_name in varchar2)
is
xt number;
xentity_id number;

cursor a1 is select serial_id from kcd_purchased_product where serial_id=xserial_id;

cursor a2 is select entity_id from kcd_business_entity where entity_name = xcompany_name;

cursor a3 is select product_id from kcd_product where product_id = xproduct_id;
begin

/* test to see if it is already done */
xt := null;
open a1;
fetch a1 into xt;
close a1;
if xt is not null then
  raise_application_error(-20004,'The serial number '||xserial_id||' is already set and licensed.');
  end if;

if xcompany_name is null then
  raise_application_error(-20005,'A Unique Company Name must be filled in.');
  end if;

if xdatabase_name is null then
  raise_application_error(-20006,'A database name must be given for licensing.');
  end if;


/* test to see if the product is valid */
xt := null;
open a3;
fetch a3 into xt;
close a3;
if xt is null then
  raise_application_error(-20007,'The Product '||xproduct_id||' is not for sale.');
  end if;



/* OK - ready to work. */

/*1. make or find the entity */
xentity_id := null;
open a2;
fetch a2 into xentity_id;
close a2;
if xentity_id is null then 
  select kcd_seq.nextval into xentity_id from dual;
  insert into kcd_business_entity(entity_id,entity_name)
    values (xentity_id,xcompany_name);
  end if;



/* 2 - make a purchased product */
insert into kcd_purchased_product(serial_id,entity_id,product_id)
 values (xserial_id,xentity_id,xproduct_id);



kcd_set_key_purchased_product(xserial_id);



kcd_set_purchase_param(xserial_id,xdatabase_name,null,xcompany_name);

kcd_build_license_entries(xserial_id,xentity_id,trunc(sysdate),add_months(trunc(sysdate),13));

end;
/

