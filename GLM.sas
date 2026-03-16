%web_drop_table(nafld);
FILENAME REFFILE '/home/u63985153/Train/nafld.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=nafld;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=nafld;
RUN;

%web_open_table(WORK.IMPORT);

proc surveyselect data=WORK.import out=work.split seed=12345 samprate=0.7 
		outall;
run;

data train test;
	set work.split;

	if selected=1 then
		output train;
	else
		output test;
run;

/*
PROC LOGISTIC DATA=WORK.IMPORT;
CLASS Gender(ref='1') / PARAM=REF;
MODEL "Advanced Fibrosis"n (EVENT='1') = Age Gender BMI "Systolic Blood Pressure"n "Diastolic Blood Pressure"n
Diyabetes Hypertension Hyperlipidemia
AST ALT GGT "Total Cholesterol"n Triglycerides
HDL LDL Glucose Insulin HOMA
/ Rsquare;
RUN;

PROC LOGISTIC DATA=WORK.IMPORT;
CLASS Gender(ref='1') / PARAM=REF;
MODEL "Advanced Fibrosis"n (EVENT='0') = Age Gender BMI "Systolic Blood Pressure"n "Diastolic Blood Pressure"n
Diyabetes Hypertension Hyperlipidemia
AST ALT GGT "Total Cholesterol"n Triglycerides
HDL LDL Glucose Insulin HOMA
/ Rsquare;
RUN;
\*/
ods graphics on;
ods output ROCcurve=rocdata;

PROC LOGISTIC DATA=Train;
	CLASS Gender(ref='1') / PARAM=REF;
	MODEL Cirrhosis (EVENT='1')=Age Gender BMI "Systolic Blood Pressure"n 
		"Diastolic Blood Pressure"n Diyabetes Hypertension Hyperlipidemia AST ALT GGT 
		"Total Cholesterol"n Triglycerides HDL LDL Glucose Insulin / Rsquare;
	
RUN;

ods graphics off;



proc sgplot data=rocdata;
	series x=_1MSPEC_ y=_SENSIT_ / lineattrs=(thickness=2 color=blue);
	lineparm x=0 y=0 slope=1 / lineattrs=(pattern=shortdash color=red);
	xaxis label="1 - Specificity" grid;
	yaxis label="Sensitivity" grid;
	title "ROC Curve – Binary Logistic Model for Cirrhosis";
run;

