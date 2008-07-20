REM find large namdom numbers p and q - can be done outside.
REM
create or replace package body hsra is


  function expmod(a number,b number,n number) 
  return number
  is 
  x number;
  y number;
  accum number;
  begin
      x := b mod n;
      y := a mod n;
      accum := 1
      loop
        exit when  x <= 0
          if (x mod 2) = 1 then
              accum := (accum * y) mod n;
          end if;
          y := (y*y) mod n;
          x := trunc(x / 2);
      end loop;
      return accum;
  end;
  


procedure x is
declare
  p number;
  q number;
  n number;
  toilent_n number; /* toilent = lcm(p-1)*(q-1)  or just (p-1)*(q-1)
  e number; /* normally 65537 */
  d number; /* de = 1 (mod toilent)  = 1 + k * toilent  for some k  */
  
  /* d is private,  so is p and q.  E, n is public 
  d mod (p-1) and d mod (q-1) is also privately computed
  so is q -1 mod (p) ?
  
  
  */
end;






function gcd(a in number, b in number)
     while b  0
         t := b
         b := a mod b
         a := t
     return a


function n2c(x in number) return varchar2
is
y varchar2(4000);
z varchar2(4000);
l number;
i number;
begin
z := to_char(abs(trunc(x));
if (x >=0) then
  y := '+';
else
  y := '-';
end if;
l := length(y);
loop
exit when l=0
  
function modpow (number b,number e,number m)
is
number result;
result := 1;
begin
loop
  exit when e <= 0;
    if (mod(e,2) = 1) then
      result := mod(result*b,m);
    end if;
    e := trunc(e/2);
    b := mod(b * b);
    end loop;
 return result;
end;
/
  
create or replace function encrypt (
  n,e,m)
 is
mm number;
c number;
begin
mm := m + n/2;
c:= modpow(m,e,n);
end;


create or replace function decrypt (
c,d,n)
is
nn number;
c number;
begin
e := modpow(c,d,n);
end;


