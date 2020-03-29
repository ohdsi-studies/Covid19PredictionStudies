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


Instructions To Install Package
===================

To install the study package run:
```r
  # get the latest PatientLevelPrediction
  install.packages("devtools")
  devtools::install_github("OHDSI/PatientLevelPrediction")
  # check the package (optional)
  ## PatientLevelPrediction::checkPlpInstallation()
  
  # install the network package
  devtools::install_github("ohdsi-studies/Covid19PredictionStudies/SevereInHospitalizedPatients")
```



Instructions To Run Study
===================
- Execute the study by running the code in (extras/CodeToRun.R) :
```r
  library(SevereInHospitalizedPatients)
  # USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./SevereInHospitalizedPatientsResults"

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
cohortTable <- 'SevereInHospitalizedPatientsCohort'
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
