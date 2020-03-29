A Package For Developing Models Predicting Patients Requiring Hospitalization After Being Sent Home From An Outpatient Visit Presenting with Flu or Flu like symptoms (To be investigated for the use on Patients, with or suspected to have, Covid-19)
========================================================

This package will develop models that predict hospitalization due to pneumonia within 2 days to 30 days after being seen in an outpatient setting for flu or flu symptoms (but no symptoms in the prior 60 days) but being sent home using the OHDSI PatientLevelPrediction framework and tools.

At initial disease presentation it is difficult to determine which suspected COVID-19 patients are likely to develop secondary infections, such as pneumonia or acute respiratory distress syndrome (ARDS), and therefore require hospitalization. Currently, patients are admitted based on a simple age and health risk assessment. The WHO Risk Communication Guidance distinguishes two distinct categories of patients at high risk of severe disease: those older than 60 years and those with “underlying medical conditions” which is non-specific (5). Early identification of patients who will require hospital care will ensure these patients have the best chance of receiving optimal care. Further interventions assessed earlier on can reduce the severity of symptoms and as such reduce the resources required for each patient. Moreover, reducing hospital admissions that are not strictly necessary avoids burden on the already stressed healthcare system and prevents unnecessary medical interventions.

The objective of this study is to inform the triage and early management of patients with diagnosed or suspected COVID-19 by developing and validating patient-level prediction models. In particular, we aim to identify adult patients who are at risk of hospitalization after being sent home first with flu or flu-like symptoms at a GP/OP or ER visit.


Suggested Requirements
===================
- R studio (https://rstudio.com)
- Java runtime environment
- Python
- Data in the OMOP CDM

Instructions To Install Package
===================

- Share the package by adding it to the 'ohdsi-studies' GitHub repo and get people to install by:
```r
  # get the latest PatientLevelPrediction
  install.packages("devtools")
  devtools::install_github("OHDSI/PatientLevelPrediction")
  # check the package (optional)
  ## PatientLevelPrediction::checkPlpInstallation()
  
  # install the network package
  devtools::install_github("ohdsi-studies/Covid19PredictionStudies/HospitalizationInSentHomePatients")
```


Instructions To Run Study
===================
- Execute the study by running the code in (extras/CodeToRun.R) :
```r
  library(HospitalizationInSentHomePatients)
  # USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./HospitalizationInSentHomePatientsResults"

# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "location with space to save big data")

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
# Add a shareable name for the database containing the OMOP CDM data
cdmDatabaseName <- 'a friendly shareable  name for your database'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'HospitalizationInSentHomePatientsCohort'
#=======================

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        createProtocol = F,
        runDiagnostic = F,
        viewDiagnostic = F,
        createCohorts = T,
        runAnalyses = T,
        createResultsDoc = F,
        packageResults = F,
        createValidationPackage = F,
        minCellCount= 5)
```

The 'createCohorts' option will create the target and outcome cohorts into cohortDatabaseSchema.cohortTable if set to T.  The 'runAnalyses' option will create/extract the data for each prediction problem setting (each Analysis), develop a prediction model, internally validate it if set to T.  The results of each Analysis are saved in the 'outputFolder' directory under the subdirectories 'Analysis_1' to 'Analysis_N', where N is the total analyses specified.  After running execute with 'runAnalyses set to T, a 'Validation' subdirectory will be created in the 'outputFolder' directory where you can add the external validation results to make them viewable in the shiny app or journal document that can be automatically generated.


- You can then easily transport all the trained models into a network validation study package by running:
```r
  
  execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createValidationPackage = T)
  

```

- To pick specific models (e.g., models from Analysis 1 and 3) to export to a validation study run:
```r
  
  execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createValidationPackage = T, 
        analysesToValidate = c(1,3))
```  
This will create a new subdirectory in 'outputFolder' that has the name <yourPredictionStudy>Validation.  For example, if your prediction study package was named 'bestPredictionEver' and you run the execute with 'createValidationPackage' set to T with 'outputFolder'= 'C:/myResults', then you will find a new R package at the directory: 'C:/myResults/bestPredictionEverValidation'.  This package can be executed similarly but will validate the developed model/s rather than develop new model/s.  If you set the validation package outputFolder to the Validation directory of the prediction package results (e.g., 'C:/myResults/Validation'), then the results will be saved in a way that can be viewed by shiny.


- To create the shiny app and view the results, run the following after successfully developing the models:
```r
  
execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createShiny = T,
        minCellCount= 5)
PatientLevelPrediction::viewMultiplePlp(outputFolder)

```

If you saved the validation results into the validation folder in the directory you called 'outputFolder' in the structure: '<outputFolder>/Validation/<newDatabaseName>/Analysis_N' then shiny and the journal document creator will automatically include any validation results.  The validation package will automatically save the validation results in this structure if you set the outputFolder for the validation results to: '<outputFolder>/Validation'.

- To create the journal document for the Analysis 1:
```r
  
execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createJournalDocument = F,
        analysisIdDocument = 1
        minCellCount= 5)

```



# Development status
Under development. Do not use
