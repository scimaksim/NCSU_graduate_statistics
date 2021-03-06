**********
SAS program to process StudentData for ST513 mini-project 1

Authored by Maksim Nikiforov and Bobby Warren
February, 2021

**********;

*Create ST513 library;
LIBNAME ST513 '/folders/myfolders/ST513/project1';

*Import data into the ST513 library (from file, rather than URL)
G1 and G2 are imported as character variable, while G3 is imported as a numerical variable;
FILENAME REFFILE '/folders/myfolders/ST513/project1/StudentData.txt';

PROC IMPORT DATAFILE=REFFILE
	DBMS=DLM
	OUT=ST513.StudentData;
	DELIMITER=";";
	GETNAMES=YES;
RUN;

*Copy dataset with G1 and G2 recast as numeric values 
(numeric type expected from the description of the original data at https://archive.ics.uci.edu/ml/datasets/Student+Performance#);
DATA ST513.RecastStudentData;
  SET ST513.StudentData;
  numG1 = input(G1, 8.);
  numG2 = input(G2, 8.);
RUN;

*One-way tables to summarize frequency of additional support (extra educational support, family educational support, extra paid classes);
PROC FREQ DATA = ST513.RecastStudentData;
  TABLES schoolsup famsup paid;
RUN;

*Histogram with a smoothed overlay - gender and final grades;
PROC SGPANEL DATA = ST513.RecastStudentData;
  PANELBY sex;
  HISTOGRAM G3;
  DENSITY G3 / TYPE = kernel;
  REFLINE 10.42 / AXIS = x 
            LINEATTRS = (Pattern = 4 
                         Thickness = 3);
RUN;

*Histogram with a smoothed overlay - extra paid classes and final grades;
PROC SGPANEL DATA = ST513.RecastStudentData;
  PANELBY paid;
  HISTOGRAM G3;
  DENSITY G3 / TYPE = kernel;
  REFLINE 10.42 / AXIS = x 
            LINEATTRS = (Pattern = 4 
                         Thickness = 3);
RUN;

*Histogram with a smoothed overlay - romantic relationships and final grades;
PROC SGPANEL DATA = ST513.RecastStudentData;
  PANELBY romantic;
  HISTOGRAM G3;
  DENSITY G3 / TYPE = kernel;
  REFLINE 10.42 / AXIS = x 
            LINEATTRS = (Pattern = 4 
                         Thickness = 3);
RUN;

PROC SGPANEL DATA = ST513.RecastStudentData;
  PANELBY romantic;
  VBAR G3;
RUN;

PROC SGPLOT DATA = ST513.RecastStudentData;
  VBAR G3 / GROUP = romantic
             GROUPDISPLAY = cluster;
RUN;



*************************************************************************************
Numerical correlations
*************************************************************************************;

*Calculate the mean of final grades (G3);
PROC MEANS DATA = ST513.RecastStudentData MEAN STD MEDIAN;
  VAR G3;
RUN;

*Histogram to show distribution of final grades. Include REFLINE with the mean calculated in previous step;
PROC SGPLOT DATA = RecastStudentData;
  HISTOGRAM G3 / DATALABEL = count;
  REFLINE 10.42 / AXIS = x
                  LINEATTRS = (Pattern = 4 Thickness = 3);
RUN;

*Calculate correlation between first period grades, second period grades, and final grades;
PROC CORR DATA = ST513.RecastStudentData;
  VAR numericG1 numericG2 G3;
RUN;


PROC CORR DATA = ST513.RecastStudentData;
  VAR numG1 numG2 G3;
RUN;