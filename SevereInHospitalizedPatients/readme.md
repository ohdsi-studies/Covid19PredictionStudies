A Package For Developing Models Predicting Severely Ill Patients In Those Admitted To Hospital For Pneumonia (To be investigated for the use on Patients, with or suspected to have, Covid-19)
========================================================

This package will develop and externally validate models that predict which patients hospitalized due to pneumonia will experience complications or require the ICU within 0 days to 30 days after initial hospitalization using the OHDSI PatientLevelPrediction framework and tools.

There is a lack of data and evidence on the factors associated with disease severity and/or mortality of patients diagnosed with COVID-19. While the number of infected patients continues to increase globally, the pressure on healthcare systems increases as well. The rapid increase in severely ill patients has resulted in an immense shortage of resources and available ICU beds. Due to this scarcity, knowledge on which patients are at high risk and should therefore require close monitoring is valuable. This knowledge may also be used to project future demand of ICU care. Early reports on COVID-19 cases have shown that it takes on average about 5 days from having symptoms to developing severe illness, with pneumonia as the most common diagnosis. In the same vein, it generally takes about 10 days from having symptoms to develop critical illness, which is defined as acute respiratory distress syndrome (ARDS) or sepsis with acute organ dysfunction. Correctly identifying which patients will benefit most from close monitoring will ensure these patients have the best chance of receiving optimal care at the right time and enhance their chances of recovery.  This may prevent further progress to complications associated with critical illness and consequently reduce the number of ICU admissions.

The objective of this study is to inform the management of adult patients who are hospitalized with COVID-19 by developing and validating a patient-level prediction model. In particular, we aim to use medical history information prior to admission to identify which patients are at high risk of developing complications associated with critical illness and/or mortality. However, due to the rapid onset of the COVID-19 pandemic, a current barrier to producing a patient-level prediction model for patients with COVID-19 is the still limited numbers of patients that are readily available to study. Since pneumonia appears to be the most common serious manifestation of COVID-19 infection, we have chosen to use pneumonia as a proxy for COVID-19, although pneumonia caused by COVID-19 may be particularly severe. After developing a model on patients who are admitted to hospital with pneumonia, we will then validate in the COVID-19 patient datasets as they become available. If the models are shown to be transportable then this will increase the speed at which they can be disseminated and as such have a greater impact on the attempt to control the most negative impacts of the pandemic.


Suggested Requirements
===================
- R studio (https://rstudio.com)
- Java runtime environment
- Python
- Data in the OMOP CDM


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

cohortTable <- "plp_covid_severe_hosp"
outputLocation <- './covidSevereHosp'
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

url <- "https://raw.githubusercontent.com/ohdsi-studies/Covid19PredictionStudies/develop/SevereInHospitalizedPatients/inpatient_severe_development.json"
json <- readLines(file(url))
json2 <- paste(json, collaplse = '\n')
analysisSpecifications <- ParallelLogger::convertJsonToSettings(json2)

cohortTableName <- cohortTable
outputLocation <- outputLocation

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

```


# Development status
Under development. Do not use
