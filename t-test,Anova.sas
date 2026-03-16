%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u63985153/Train/nafld.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);


proc anova data=WORK.IMPORT;
   class Fibrosis;
   model BMI = Fibrosis;
   means Fibrosis / tukey cldiff;
run;

proc anova data=WORK.import;
   class Fibrosis;
   model Age = Fibrosis;
   means Fibrosis / tukey cldiff;
run;

proc ttest data=WORK.IMPORT;
   class Gender; 
   var BMI;       
run;



