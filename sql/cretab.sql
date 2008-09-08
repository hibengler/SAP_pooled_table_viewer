create table kcd_product (
product_id number not null primary key,
description varchar2(200) not null unique,
url varchar2(200) not null)
/

create table kcd_business_entity (
entity_id number not null primary key,
entity_name varchar2(200) not null unique
)
/

create table kcd_purchased_product (
serial_id number not null primary key,
entity_id number not null references kcd_business_entity(entity_id),
product_id number not null references kcd_product(product_id),
p number,
q number,
totient number,
n number,
e number,
d number,
serial varchar2(100),
database_name varchar2(20),
owner varchar2(30),
company_name varchar2(40),
serial2 varchar2(16),
serial3 varchar2(5),
serial4 varchar2(3),
notes varchar2(2000)
)
/

create table kcd_license_entry (
entity_id number references kcd_business_entity(entity_id),
serial_id number references kcd_purchased_product(serial_id),
daycode number,
primary key (daycode,serial_id),
mung number)
/
create unique index kcd_license_entry_u1 on kcd_license_entry(serial_id,daycode);
create index kcd_license_entry_i1 on kcd_license_entry(entity_id);


create sequence kcd_seq;

