#================================
#  INSTALL
#================================
# Install PatientLevelPrediction and OhdsiSharing
install.packages('devtools')
devtools::install_github("OHDSI/FeatureExtraction")
devtools::install_github('ohdsi/PatientLevelPrediction')
devtools::install_github("OHDSI/OhdsiSharing")

# Install all the repos:
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/CovidVulnerabilityIndex")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/CovidSimpleModels")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/CovidSimpleSurvival")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/HospInOutpatientVal")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/SentHomeValidation")
devtools::install_github("ohdsi-studies/Covid19PredictionStudies/SevereInHospVal")


#================================
# SPECIFY THE INPUTS
#================================
# Specify where the temporary files (used by the ff package) will be created:
fftempdir <- 'location with plenty of space'

# The folder where the study intermediate and result files will be written:
outputFolder <- "./CovidPlpStudies"

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
cdmDatabaseName <- 'friendly name of cdm data'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'
oracleTempSchema <- NULL

# use all data (sampleSize <- NULL) or only validate the model on a sample (sampleSize <- 1500000)
sampleSize <- NULL
# Min cell count when sharing the results - any value less than minCellCount will be replaced with -1
minCellCount <- 10


#================================
# DO NOT EDIT AFTER HERE
#================================

options(fftempdir = fftempdir)
if(!dir.exists(fftempdir)){
  dir.create(fftempdir)
}

# Existing Model: Run Covid Vulnerablity Index
library(CovidVulnerabilityIndex)
CovidVulnerabilityIndex::execute(connectionDetails = connectionDetails,
                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                 cdmDatabaseName = cdmDatabaseName,
                                 cohortDatabaseSchema = cohortDatabaseSchema,
                                 oracleTempSchema = oracleTempSchema,
                                 cohortTable = 'CovidVulnerabilityIndexCohort',
                                 sampleSize = sampleSize,
                                 outputFolder = file.path(outputFolder,'CovidVulnerabilityIndexResults'),
                                 createCohorts = T,
                                 runAnalyses = T,
                                 viewShiny = F,
                                 packageResults = T,
                                 minCellCount= minCellCount,
                                 verbosity = "INFO",
                                 cdmVersion = 5)

# Simple Models Q1-3
library(CovidSimpleModels)
CovidSimpleModels::execute(connectionDetails = connectionDetails,
        usePackageCohorts = T,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        oracleTempSchema = oracleTempSchema,
        cohortTable = 'CovidSimpleModelsCohort',
        sampleSize = sampleSize,
        outputFolder = file.path(outputFolder,'CovidSimpleModelsResults'),
        createCohorts = T,
        predictSevereAtOutpatientVisit = T,
        predictCriticalAtOutpatientVisit = T,
        predictDeathAtOutpatientVisit = T,
        predictCriticalAtInpatientVisit = T,
        predictDeathAtInpatientVisit = T,
        packageResults = T,
        minCellCount = minCellCount,
        verbosity = "INFO",
        cdmVersion = 5)


# Simple model Q4
library(CovidSimpleSurvival)
CovidSimpleSurvival::execute(connectionDetails = connectionDetails,
        usePackageCohorts = T,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        oracleTempSchema = oracleTempSchema,
        cohortTable = 'CovidSimpleSurvivalCohort',
        sampleSize = sampleSize,
        outputFolder = file.path(outputFolder,'CovidSimpleSurvivalResults'),
        createCohorts = T,
        predictShortTermSurvival = T,
        predictLongTermSurvival = T,
        packageResults = T,
        minCellCount = minCellCount,
        verbosity = "INFO",
        cdmVersion = 5)

# Q1 full and benchmark
library(HospInOutpatientVal)
HospInOutpatientVal::execute(connectionDetails = connectionDetails,
                             databaseName = cdmDatabaseName,
                             cdmDatabaseSchema = cdmDatabaseSchema,
                             cohortDatabaseSchema = cohortDatabaseSchema,
                             oracleTempSchema = oracleTempSchema,
                             cohortTable = 'HospInOutpatientValCohort',
                             outputFolder = file.path(outputFolder,'HospInOutpatientValResults'),
                             createCohorts = T,
                             runValidation = T,
                             packageResults = T,
                             minCellCount = minCellCount,
                             sampleSize = sampleSize)

# Q2 full and benchmark
library(SentHomeValidation)
SentHomeValidation::execute(connectionDetails = connectionDetails,
                            databaseName = cdmDatabaseName,
                            cdmDatabaseSchema = cdmDatabaseSchema,
                            cohortDatabaseSchema = cohortDatabaseSchema,
                            oracleTempSchema = oracleTempSchema,
                            cohortTable = 'SentHomeValidationCohort',
                            outputFolder = file.path(outputFolder,'SentHomeValidationResults'),
                            createCohorts = T,
                            runValidation = T,
                            packageResults = T,
                            minCellCount = minCellCount,
                            sampleSize = sampleSize)

# Q3 full and benchmark
library(SevereInHospVal)
SevereInHospVal::execute(connectionDetails = connectionDetails,
                         databaseName = cdmDatabaseName,
                         cdmDatabaseSchema = cdmDatabaseSchema,
                         cohortDatabaseSchema = cohortDatabaseSchema,
                         oracleTempSchema = oracleTempSchema,
                         cohortTable = 'SevereInHospValCohort',
                         outputFolder = file.path(outputFolder,'SevereInHospValResults'),
                         createCohorts = T,
                         runValidation = T,
                         packageResults = T,
                         minCellCount = minCellCount,
                         sampleSize = sampleSize)


packageStudy <- function(outputFolder,cdmDatabaseName){


   if(!dir.exists(file.path(outputFolder, 'allExport'))){
    dir.create(file.path(outputFolder, 'allExport'))
               }

   for(studyName in c('SevereInHospValResults','SentHomeValidationResults',
                    'HospInOutpatientValResults','CovidSimpleModelsResults',
                    'CovidVulnerabilityIndexResults', 'CovidSimpleSurvivalResults')){
   # for each folder in expected analyses, find zipped file and move into  outputFolder/allExport/studyNameDatabaseName
   zipLoc <- file.path(outputFolder,studyName, paste0(cdmDatabaseName, '.zip'))
   newLoc <- file.path(outputFolder, 'allExport', paste0(studyName,'_',cdmDatabaseName, '.zip'))
   # move zip file to main output file.path(outputFolder,'allExport'):
   file.copy(from = zipLoc, to = newLoc, overwrite = T, recursive = F)
}
   # compress file.path(outputFolder,'allExport')
  OhdsiSharing::compressFolder(file.path(outputFolder, 'allExport'),
                               file.path(outputFolder, 'allExport.zip'))
   # remove file.path(outputFolder,'allExport')
  unlink(file.path(outputFolder, 'allExport'), recursive = T)
   # all results have been process: removing sensitive date and compressed into file.path(outputFolder,'allExport.zip')
   return(file.path(outputFolder,'allExport.zip'))
}
# Package the results:
packageStudy(outputFolder = outputFolder,
             cdmDatabaseName = cdmDatabaseName)

