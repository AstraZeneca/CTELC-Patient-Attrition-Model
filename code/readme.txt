Modeling Clinical Trial Patient Attrition Using Machine Learning: A case study using 1,325 Respiratory Trials.
---------------------------------------------------------------------------------------------------------------
This file is the readme.txt file for the code folder that contains the R code that was used in the model


TABLE OF CONTENTS
-----------------

* Full Author List 

* Introduction

* Folder Contents

* Contact



Full Author List
----------------
Shameer Khader, Youyi Zhang, Imran Khan A.N, 
Sreenath Nampally, Emmette Hutchison, Jim Weatherall, Faisal Khan.


Introduction
------------
Patient attrition, also referred to as dropout or patient withdrawal, occurs when patients enrolled 
in a clinical trial either withdraw or are lost to follow-up by the clinical site and trial sponsor.


Folder Contents
----------------
This folder contains the data files that were used in the analysis. The file descriptions are listed below:

|--code
    |
    |---- readme.txt:  readme file for the data folder
    |
    |---- 1_Data_Cleaning_Code.R: This is the data preprocessing code which uses the raw data from "raw" folder that is present 
    |                        in "data" folder and creates analysis ready data.  This file should be executed before the 
    |                        "2_Model_Code.R" file. This file can be opened and executed in RStudio by setting the
    |                        appropriate directory path to the "raw" folder of this package
    |                       
    |
    |---- 2_Model_Code.R: This is the main modeling R code that is developed to perform the random forest predictive model. It uses the 	  
    |                        Indexed_Analysis_Ready.csv file from the data/raw folder for model  
    |                        and for the generation of charts and statistics. This file can be opened and executed from 
    |                        the in the RStudio by setting the appropriate working directory path to the 'raw' folder 
    |                        of this package
    |
    |---- 2_Model_Code.ipynb: This file contains R code run on Ananconda instance/Jupyter notebook, this is similar to the code " 2_Model_Code.R"
								the output of both codes will remain the same.



Contact
--------
shameer.khader@astrazeneca.com
