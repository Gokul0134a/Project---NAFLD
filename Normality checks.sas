/* Generated Code (IMPORT) */
/* Source File: NAFLD_imputed.csv */
/* Source Path: /home/u63985153/Train */
/* Code generated on: 9/11/25, 6:55 PM *

%web_drop_table(NAFLD);


FILENAME REFFILE '/home/u63985153/Train/NAFLD_imputed.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=NAFLD;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=NAFLD; RUN;


%web_open_table(NAFLD);



%macro check_normality(data=);
    
    proc contents data=&data out=vars(keep=name type) noprint; run;

    proc sql noprint;
        select cats("'", strip(name), "'n")
        into :numvars separated by " "
        from vars
        where type=1;
    quit;

    
    ods output TestsForNormality=normality_results;
    proc univariate data=&data normal plot;
        var &numvars;
    run;
    ods output close;
%mend;


%check_normality(data=NAFLD);

proc print data=normality_results; run;







