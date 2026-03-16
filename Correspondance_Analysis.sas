%web_drop_table(nafld);


FILENAME REFFILE '/home/u63985153/Train/nafld.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=nafld;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=nafld; RUN;


%web_open_table(nafld);

data nafld;
    set work.nafld;
    if BMI < 25 then BMI_Group = "Normal";
    else if BMI < 30 then BMI_Group = "Overweight";
    else BMI_Group = "Obese";
run;

proc freq data=nafld noprint;
    tables BMI_Group*Fibrosis / out=FreqTable;
run;

proc corresp data=FreqTable all dimens=2 outc=Coord short;
    tables BMI_Group, Fibrosis;
    weight count;
run;

proc sgplot data=Coord;
    scatter x=Dim1 y=Dim2 / datalabel=_NAME_;
    xaxis label="Dimension 1";
    yaxis label="Dimension 2";
    title "Correspondence Analysis Biplot";
run;

proc print data=coords;
run;
