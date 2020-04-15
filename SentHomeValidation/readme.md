SentHomeValidation
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
  SentHomeValidation is an R package.

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
A general guide for running a valdiation study package is available here: [Skeleton Validation Study guide](https://github.com/OHDSI/SentHomeValidation/tree/master/inst/doc/UsingSkeletonValidationPackage.pdf)
  
  
A1. Installing the package from GitHub
===============
```r
# To install the package from github:
install.packages("devtools")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/SentHomeValidation")
```

B. Getting Started
===============
  1. Make sure to have either: installed (A1) or built (A2) the package 
  2. In R, run the code in 'extras/codeToRun.R' (see [Skeleton Validation Study guide](https://github.com/OHDSI/SentHomeValidation/tree/master/inst/doc/UsingSkeletonValidationPackage.pdf) for guideance)


C. Example Code
===============
```r
library(SentHomeValidation)

# add details of your database setting:
databaseName <- 'add a shareable name for the database you are currently validating on'

# add the cdm database schema with the data
cdmDatabaseSchema <- 'your cdm database schema for the validation'

# add the work database schema this requires read/write privileges 
cohortDatabaseSchema <- 'your work database schema'

# if using oracle please set the location of your temp schema
oracleTempSchema <- NULL

# the name of the table that will be created in cohortDatabaseSchema to hold the cohorts
cohortTable <- 'SentHomeValidationCohortTable'

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
SentHomeValidation::execute(connectionDetails = connectionDetails,
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
SentHomeValidation::execute(connectionDetails = connectionDetails,
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
SentHomeValidation::execute(connectionDetails = connectionDetails,
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

License
=======
  SentHomeValidation is licensed under Apache License 2.0

Development
===========
  SentHomeValidation is being developed in R Studio.
