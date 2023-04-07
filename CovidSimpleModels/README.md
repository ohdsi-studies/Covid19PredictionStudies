A Package for Validating the OHDSI Covid-19 Simple Models
========================================================

Instructions To Install Strategus and Run Studies
===================

- Install Strategus:
```r

# Install Strategus
install.packages('remotes')
remotes::install_github('ohdsi/Strategus')

```

- Execute the study by running the following (but make sure to edit the connection and output settings):
```r
##=========== START OF INPUTS ==========

cohortTable <- "plp_covid_simple"
outputLocation <- './covidSimpleModels'
minCellCount <- 10

connectionDetailsReference <- 'database name'

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
moduleLocation <- file.path(outputLocation, 'modules')


##=========== END OF INPUTS ==========

library(Strategus)

# Note: this environmental variable should be set once for each compute node
Sys.setenv("INSTANTIATED_MODULES_FOLDER" = file.path(moduleLocation, "StrategusInstantiatedModules"))

for(type in c('outpatient_severe','outpatient_critical', 'outpatient_death', 'inpatient_crit', 'inpatient_death')){

url <- (
paste0(
'https://raw.githubusercontent.com/ohdsi-studies/',
'Covid19PredictionStudies/develop/CovidSimpleModels/',
type,
'_simple_validation.json'
)
)
json <- readLines(file(url))
json2 <- paste(json, collaplse = '\n')
analysisSpecifications <- ParallelLogger::convertJsonToSettings(json2)


cohortTableName <- paste0(cohortTable,'_', type)
outputLocation <- file.path(outputLocation, type)

storeConnectionDetails(
  connectionDetails = connectionDetails,
  connectionDetailsReference = connectionDetailsReference
)

executionSettings <- createCdmExecutionSettings(
  connectionDetailsReference = connectionDetailsReference,
  workDatabaseSchema = workDatabaseSchema,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = cohortTableName),
  workFolder = file.path(outputLocation, "strategusWork"),
  resultsFolder = file.path(outputLocation, "strategusOutput"),
  minCellCount = minCellCount
)

Strategus::execute(
  analysisSpecifications = analysisSpecifications,
  executionSettings = executionSettings,
  executionScriptFolder = file.path(outputLocation, "strategusExecution")
)
}

```


Submitting Results
===================

Once you have sucessfully executed the study you will find five folders inside your specified outputLocation named: 

* 'outpatient_severe'
* 'outpatient_critical'
* 'outpatient_death'
* 'inpatient_crit'
* 'inpatient_death'

inside each of these folders you will find a folder named "strategusOutput" containing each of the OHDSI analysis modules used in the study (DatabaseMetaData, CohortGeneratorModule_1, ModelTransferModule_2 and PatientLevelPredictionValidationModule_3).  The folder 'PatientLevelPredictionValidationModule_3' will contain a set of csv files with the validation results.  The csv of particular interest is 'evaluation_statistics.csv'.  







