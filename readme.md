![Maturity level-0](https://img.shields.io/badge/Maturity%20Level-ML--0-red)

Modeling Clinical Trial Patient Attrition Using Machine Learning: A case study using 1,325 Respiratory Trials.
---------------------------------------------------------------------------------------------------------------
This file is the readme.txt file for the code folder that contains the R code that was used in the model


TABLE OF CONTENTS
-----------------

* Full Author List

* Introduction

* Requirements

* Folder Contents

* Contact

Full Author List
----------------
Emmette Hutchison, Youyi Zhang, Sreenath Nampally, Imran Khan Neelufer, Vlad Malkov, Jim Weatherall, Faisal Khan and Khader Shameer 


Introduction
------------
Patient attrition, also referred to as dropout or patient withdrawal, occurs when patients enrolled 
in a clinical trial either withdraw or are lost to follow-up by the clinical site and trial sponsor.


Requirements
------------
This was performed using RStudio and R. The versions of RStudio and R are listed below:
RStudio 1.0.44, which can be downloaded from from https://rstudio.com/products/rstudio/download/ 
R 3.5.2 (2018-12-20). RStudio can be installed from https://cran.r-project.org/mirrors.html

The project requires the following R packages. The version numbers indicate the version of the packages 
that were used in the analysis. Please install the following packages using the command below in your R
Environment

	SuperLearner==2.0-26
	MASS==7.3-51.5
	ranger==0.12.1
	ipred==0.9-9
	kernlab==0.9-29
	arm==1.10-1
	dplyr==1.4.2
	caret==6.0-84
	parallel==3.5.2

Folder Contents
----------------
This folder contains the data files that was used in the analysis. The file descriptions are listed below:

```
|---- readme.md :  readme file for the data folder
|
|---- code : This folder contains the code required for the preprocessing of raw data and running the predictive model results,
|			 further explaination is available in a readme file within this folder
|
|---- data:  This folder contains two sub-folders, another readme file in the folder will explain the overview on each folder content.
		|---- analysis_ready
|---- requirments.txt : is a file which lists the libraries used in the model building exercise, this file can be used to install the packages needed.
|		
|		Using command "Install.Packages("package name") one can easily install the required packages
```

Add lines on installation

Contact
--------
shameer.khader@astrazeneca.com
