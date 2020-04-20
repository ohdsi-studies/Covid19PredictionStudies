SevereInHospVal
======================

Introduction
============
This package contains code to externally validate models for the prediction quesiton <add question> developed on the database <add database>.

Features
========
  - Applies models developed using the OHDSI PatientLevelPrediction package
  - Evaluates the performance of the models on new data
  - Packages up the results (after removing sensitive date) to share with study owner

Technology
==========
  SevereInHospVal is an R package.

System Requirements
===================
  * Requires: OMOP CDM database and connection details
  * Requires: Java runtime enviroment (for the database connection)
  * Requires: R (version 3.3.0 or higher).
  * Sometimes required: Python 

Dependencies
============
  * PatientLevelPrediction
  
Guide
============
A general guide for running a valdiation study package is available here: [Skeleton Validation Study guide](https://github.com/OHDSI/SevereInHospVal/tree/master/inst/doc/UsingSkeletonValidationPackage.pdf)
  
  
Instructions To Install and Run Package From Github


- Make sure you have PatientLevelPrediction installed:

```r
  # get the latest PatientLevelPrediction
  install.packages("devtools")
  devtools::install_github("OHDSI/PatientLevelPrediction")
  # check the package
  PatientLevelPrediction::checkPlpInstallation()
```

- Then install the study package:
```r
# To install the package from github:
install.packages("devtools")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/SevereInHospVal")
```
- Execute the study by running the code in (extras/CodeToRun.R) but make sure to edit the settings:

```r
library(SevereInHospVal)

# add details of your database setting:
databaseName <- 'add a shareable name for the database you are currently validating on'

# add the cdm database schema with the data
cdmDatabaseSchema <- 'your cdm database schema for the validation'

# add the work database schema this requires read/write privileges 
cohortDatabaseSchema <- 'your work database schema'

# if using oracle please set the location of your temp schema
oracleTempSchema <- NULL

# the name of the table that will be created in cohortDatabaseSchema to hold the cohorts
cohortTable <- 'SevereInHospValCohortTable'

# the location to save the prediction models results to:
# NOTE: if you set the outputFolder to the 'Validation' directory in the 
#       prediction study outputFolder then the external validation will be
#       saved in a format that can be used by the shiny app 
outputFolder <- '../Validation'

# add connection details:
options(fftempdir = 'T:/fftemp')
dbms <- "pdw"
user <- NULL
pw <- NULL
server <- Sys.getenv('server')
port <- Sys.getenv('port')
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Now run the study:
SevereInHospVal::execute(connectionDetails = connectionDetails,
                 databaseName = databaseName,
                 cdmDatabaseSchema = cdmDatabaseSchema,
                 cohortDatabaseSchema = cohortDatabaseSchema,
                 oracleTempSchema = oracleTempSchema,
                 cohortTable = cohortTable,
                 outputFolder = outputFolder,
                 createCohorts = T,
                 runValidation = T,
                 packageResults = F,
                 minCellCount = 5,
                 sampleSize = NULL)
                 
# If the validation study runs to completion and returns results, package it up ready to share with the study owner (but remove counts less than 10) by running:
SevereInHospVal::execute(connectionDetails = connectionDetails,
                 databaseName = databaseName,
                 cdmDatabaseSchema = cdmDatabaseSchema,
                 cohortDatabaseSchema = cohortDatabaseSchema,
                 oracleTempSchema = oracleTempSchema,
                 cohortTable = cohortTable,
                 outputFolder = outputFolder,
                 createCohorts = F,
                 runValidation = F,
                 packageResults = T,
                 minCellCount = 10,
                 sampleSize = NULL)
                 
                 
# If your target cohort is large use the sampleSize setting to sample from the cohort:
SevereInHospVal::execute(connectionDetails = connectionDetails,
                 databaseName = databaseName,
                 cdmDatabaseSchema = cdmDatabaseSchema,
                 cohortDatabaseSchema = cohortDatabaseSchema,
                 oracleTempSchema = oracleTempSchema,
                 cohortTable = cohortTable,
                 outputFolder = outputFolder,
                 createCohorts = T,
                 runValidation = T,
                 packageResults = F,
                 minCellCount = 10,
                 sampleSize = 1000000)
                 
```

Submitting Results
===================

Once you have sucessfully executed the study you will find a compressed folder in the location specified '[outputFolder]/[databaseName].zip'.  The study should remove sensitive data but we encourage researchers to also check the contents of this folder (it will contain an rds file with the results which can be loaded via readRDS('[file location]').  

To send the compressed folder results please message one of the leads (**[jreps](https://forums.ohdsi.org/u/jreps) , [RossW](https://forums.ohdsi.org/u/RossW)**) and we will give you the privateKeyFileName and userName.  You can then run the following R code to share the results:

```r
# If you don't have the R package OhdsiSharing then install it using github (uncomment the line below)
# install_github("ohdsi/OhdsiSharing")

library("OhdsiSharing")
privateKeyFileName <- "message us for this"
userName <- "message us for this"
fileName <- file.path(outputFolder, paste0(databaseName,'.zip'))
sftpUploadFile(privateKeyFileName = privateKeyFileName, 
               userName = userName, 
               fileName = fileName,
               remoteFolder = file.path("./covid19PredSevereInHospVal", databaseName)
```

License
=======
  SevereInHospVal is licensed under Apache License 2.0

Development
===========
  SevereInHospVal is being developed in R Studio.
