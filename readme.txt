This is the pool data extractor installation code. Revision 1.2.

The pool data extractor converts the raw Cobol based record structures in pool tables to database views, allowing any oracle 
database compatible application the ability to easily retrieve the pool table information.  
This is done by a combination of perceiving the structure through the data definition 
(stored in the DD03 table) and by parsing the raw data.  It is designed wither to be a stand alone product,  or to be 
combined with the nicer reporting system, in a way to bring product compatibility.








Installation.

There are two ways to install this code.  One is to install as a DBA,  which creates the database schema SAPSR3P and puts 
all the pool views and code separate from the SAP tables.

The other method is to and inside the SAPSR3 user, which requires only the SAPSR3 credentials.


The DBA method is probably cleaner, because it is easier to uninstall.
The other method is convienent, as all the tables and views are in the same database schema.

This should work from the windows platform,  or the unix platform the same way.



DBA method:
1. get to a command prompt
2. ensure that the environment is set up so that sqlplus can be accessed.
3. sqlplus -s <somedba>/<somepass>@<dblink>
	This should enter you into sqlplus
4. @step1
	This creates the database user SAPSR3P, and ensures that it has the minimal grants to the SAP tables in order
	to extract pool tables.  It also creates some tables and base code for the extraction.
5. @step2
	This generates the build_all_pool_tables.sql and build_all_debug_pool_tables.sql code dynamically.  This is dynamic
	in order to capture any custom pool tables in your businesses SAP environment.  It then runs these scripts, 
	which in turn generate many create view statements.  These views will allow regular oracle SQL to see the 
	previously unacessable values.  This also makes debug views in case there is a problem decoding the raw data
	from a particular pool table. The process takes about 15 minutes to complete.
	Note - this step can be re-run if there are changes to the database structure of the pool tables.
6. @step3
	This step loads the initial licensing for the pool table viewers DRM.  Without this step,  the views would return
	errors when selected.
	Note - this step can be re-run at any time.
7. alter user sapsr3p identified by <some_secret_password>;
	This will change the password on the sapsr3p from the default (secret95) password to one that is secure.
8. exit
	This exits sqlplus.
9. Exit the command prompt.


	
Inside SAPSR3 schema method:
1. get to a command prompt
2. ensure that the environment is set up so that sqlplus can be accessed.
3. sqlplus -s sapsr3/<somepass>@<dblink>
	This should enter you into sqlplus
4. @step1_sapsr3
	This creates some tables and base code for the extraction.
5. @step2_sapsr3
	This generates the build_all_pool_tables.sql and build_all_debug_pool_tables.sql code dynamically.  This is dynamic
	in order to capture any custom pool tables in your businesses SAP environment.  It then runs these scripts, 
	which in turn generate many create view statements.  These views will allow regular oracle SQL to see the 
	previously unacessable values.  This also makes debug views in case there is a problem decoding the raw data
	from a particular pool table. The process takes about 15 minutes to complete.
	Note - this step can be re-run if there are changes to the database structure of the pool tables.
6. @step3_sapsr3
	This step loads the initial licensing for the pool table viewers DRM.  Without this step,  the views would return
	errors when selected.
	Note - this step can be re-run at any time.
7. exit
	This exits sqlplus.
8. Exit the command prompt.
			
	


Testing.

The following tests can be done from SQL*Plus:


DBA method:
select * from sapsr3p.t340;


Inside SAPSR3 method:
select * from t340;




In a base install of SAP,  the following should be returned:













Licensing.
An initial purchase contains 360 days of licensing. A free trial contains 30 days of licensing.
If licensing runs out,  the following error is apt to occur when querying from any pool table:

ORA-20001: License Error. Contact Killer Cool Development, LLC.


Additional license rows can be purchased separately.
















Copyright 2008 Killer Cool Development, LLC.
http://kcd.com
