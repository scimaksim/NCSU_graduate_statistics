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
  numericG1 = input(G1, 8.);
  numericG2 = input(G2, 8.);
RUN;

*Calculate the mean of final grades (G3);
PROC MEANS DATA = ST513.RecastStudentData;
  VAR G3;
RUN;

*Histogram to show distribution of final grades. Include REFLINE with the mean calculated in previous step;
PROC SGPLOT DATA = ST513.RecastStudentData;
  HISTOGRAM G3 / DATALABEL = count;
  REFLINE 10.42 / AXIS = x
                  LINEATTRS = (Pattern = 4 Thickness = 3);
RUN;

*Calculate correlation between first period grades, second period grades, and final grades;
PROC CORR DATA = ST513.RecastStudentData;
  VAR numericG1 numericG2 G3;
RUN;


