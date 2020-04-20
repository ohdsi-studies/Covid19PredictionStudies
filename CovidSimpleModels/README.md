A Package for Validating the OHDSI Covid-19 Simple Models
========================================================
Instructions on the inputs and outputs of the package: 
Vignette: [Using the package skeleton for validating exisitng prediction studies](https://raw.githubusercontent.com/OHDSI/SkeletonExistingPredictionModelStudy/master/inst/doc/UsingSkeletonPackage.pdf)


Instructions To Install and Run Package From Github
===================

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
  # install the network package
  devtools::install_github("ohdsi-studies/Covid19PredictionStudies/CovidSimpleModels")
```

- Execute the study by running the code in (extras/CodeToRun.R) but make sure to edit the settings:
```r
library(CovidSimpleModels)
# USER INPUTS
#=======================
# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "location with space to save big data")

# The folder where the study intermediate and result files will be written:
outputFolder <- "./CovidSimpleModelsResults"

# Details for connecting to the server:
dbms <- "you dbms"
user <- 'your username'
pw <- 'your password'
server <- 'your server'
port <- 'your port'

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- 'cdm database schema'
# Add the name of database containing the OMOP CDM data
cdmDatabaseName <- 'cdm database name'

# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'
oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'CovidSimpleModelsCohort'

#============== Pick Study Parts To Run: ===========
createCohorts = TRUE
predictSevereAtOutpatientVisit = TRUE
predictCriticalAtOutpatientVisit = TRUE
predictDeathAtOutpatientVisit = TRUE
predictCriticalAtInpatientVisit = TRUE
predictDeathAtInpatientVisit = TRUE
packageResults = TRUE

minCellCount <- 5
sampleSize <- NULL


#============== Pick T and O cohorts ===========

# [option 1] use default cohorts (same as those used to develop the models)
usePackageCohorts <- TRUE

# [option 2] use your own specified cohorts (these must be created already)
# uncomment the line below to set usePackageCohorts as False
## usePackageCohorts <- FALSE
newTargetCohortId = 'the cohort definition id for the new target' 
newOutcomeCohortId = 'the cohort definition id for the new outcome' 
newCohortDatabaseSchema = 'the database schema containing the cohorts' 
newCohortTable = 'the table name of the table containing the cohorts' 
                    
#=======================
# TAR settings - recommended to not edit
#=======================
riskWindowStart <- 0
startAnchor <- 'cohort start'
riskWindowEnd <- 30
endAnchor <- 'cohort start'
firstExposureOnly <- F
removeSubjectsWithPriorOutcome <- F
priorOutcomeLookback <- 99999
requireTimeAtRisk <- F
minTimeAtRisk <- 1
includeAllOutcomes <- T

execute(connectionDetails = connectionDetails,
        usePackageCohorts = usePackageCohorts,
        newTargetCohortId = newTargetCohortId,
        newOutcomeCohortId = newOutcomeCohortId,
        newCohortDatabaseSchema = newCohortDatabaseSchema,
        newCohortTable = newCohortTable,
                                    cdmDatabaseSchema = cdmDatabaseSchema,
                                    cdmDatabaseName = cdmDatabaseName,
                                    cohortDatabaseSchema = cohortDatabaseSchema,
                                    cohortTable = cohortTable,
                                    sampleSize = sampleSize,
                                    riskWindowStart = riskWindowStart,
                                    startAnchor = startAnchor,
                                    riskWindowEnd = riskWindowEnd,
                                    endAnchor = endAnchor,
                                    firstExposureOnly = firstExposureOnly,
                                    removeSubjectsWithPriorOutcome = removeSubjectsWithPriorOutcome,
                                    priorOutcomeLookback = priorOutcomeLookback,
                                    requireTimeAtRisk = requireTimeAtRisk,
                                    minTimeAtRisk = minTimeAtRisk,
                                    includeAllOutcomes = includeAllOutcomes,
                                    outputFolder = outputFolder,
                                    createCohorts = createCohorts,
                                    predictSevereAtOutpatientVisit = predictSevereAtOutpatientVisit,
                                    predictCriticalAtOutpatientVisit = predictCriticalAtOutpatientVisit,
                                    predictDeathAtOutpatientVisit = predictDeathAtOutpatientVisit,
                                    predictCriticalAtInpatientVisit = predictCriticalAtInpatientVisit,
                                    predictDeathAtInpatientVisit = predictDeathAtInpatientVisit,
                                    packageResults = packageResults,
                                    minCellCount = minCellCount,
                                    verbosity = "INFO",
                                    cdmVersion = 5)
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
               remoteFolder = file.path("./covid19PredCovidSimpleModels", cdmDatabaseName)
```

# Development status
Under development.
