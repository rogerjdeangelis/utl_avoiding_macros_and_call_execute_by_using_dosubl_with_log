Avoiding macros and call execute by using dosubl with log

see github
https://tinyurl.com/y7ruehzq
https://github.com/rogerjdeangelis/utl_avoiding_macros_and_call_execute_by_using_dosubl_with_log

see
https://tinyurl.com/ycw42mu5
https://communities.sas.com/t5/Base-SAS-Programming/GROUP-BY-a-macro-variable-list-except-one-variable/m-p/488678

Manipulating a macro list of datastep variables prior to executing SQL

INPUT
=====

 %let categ = %str(make,model,type,excl);

 sashelp.cars

 SASHELP.CARS total obs=428

  MAKE   MODEL            TYPE      MSRP

  Acura  MDX              SUV      36945
  Acura  RSX Type S 2dr   Sedan    23820
  Acura  TSX 4dr          Sedan    26990
  Acura  TL 4dr           Sedan    33195
  ...

 RULES
 -----
   Exclude variable 'excl' it is not in sashelp.cars

   Sum msrp by make,model,type

 EXAMPLE OUTPUT
 --------------

  WORK.LOG total obs=1

         STR          RC    CC     STATUS

   make,model,type     0     0    Completed


   MAKE      MODEL                        TYPE       sumCost
   ---------------------------------------------------------
   Acura      3.5 RL 4dr                  Sedan        43755
   Acura      3.5 RL w/Navigation 4dr     Sedan        46100
   Acura      MDX                         SUV          36945
   Acura      NSX coupe 2dr manual S      Sports       89765
   Acura      RSX Type S 2dr              Sedan        23820
   Acura      TL 4dr                      Sedan        33195
   Acura      TSX 4dr                     Sedan        26990
   Audi       A4 1.8T 4dr                 Sedan        25940
   Audi       A4 3.0 4dr                  Sedan        31840
   ...


PROCESS
=======

%symdel cc / nowarn;
data log;
  str=substr("&categ",1,15);
  call symputx("str",str);
  rc=dosubl('
     proc sql;
       select
           &str
          ,sum(msrp) as sumCost
       from
          sashelp.cars
       group
          by &str
     ;quit;
      %let cc=&sysrc;
  ');
  cc=symgetn('cc');
  if cc=0 then status="Completed";
  else status="Failed";
  output;
  stop;
run;quit;

/* see above */


