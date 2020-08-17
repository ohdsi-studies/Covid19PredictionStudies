Development and validation of complex and simple patient-level prediction models for predicting various outcomes in COVID patients: a rapid network study to inform the management of COVID-19
=============

<img src="https://img.shields.io/badge/Study%20Status-Results%20Available-yellow.svg" alt="Study Status: Results Available"> 

- Analytics use case(s): **Patient-Level Prediction**
- Study type: **Clinical Application**
- Tags: **Study-a-thon, COVID-19**
- Study lead: **Jenna Reps, Ross Williams, Peter Rijnbeek**
- Study lead forums tag: **[jreps](https://forums.ohdsi.org/u/jreps), [RossW](https://forums.ohdsi.org/u/RossW), [Rijnbeek](https://forums.ohdsi.org/u/Rijnbeek)**
- Study start date: **Mar 26, 2020**
- Study end date: **-**
- Protocol: **[Word docment](https://github.com/ohdsi-studies/Covid19PredictionStudies/blob/master/HospitalizationInSymptomaticPatients/docs/PLP_protocol_Q1%2BQ2_20200329.docx)**
- Publications: **[Simple Models](https://www.medrxiv.org/content/10.1101/2020.05.26.20112649v4) - [C19 Validation](https://www.medrxiv.org/content/10.1101/2020.06.15.20130328v1)**
- Results explorer: **[Simple Models](http://evidence.ohdsi.org:3838/Covid19CoverPrediction/) - [C19 Validation](http://evidence.ohdsi.org:3838/C19validation/)**

The objective of this study is to develop and validate various patient-level prediction models for COVID-19 patients. 

Background
=============
The Corona Virus Disease 2019 (COVID-19), which started in late 2019 as an epidemic in Wuhan, Hubei Province, China, has been classified as a pandemic and a public health emergency of international concern by the World Health Organisation (WHO) in January 2020.

The OHDSI community has initiated a study-athon to attempt to provide evidence to healthcare providers, governments and patients to best aid in the understanding and treatment of the pandemic. 


This specific repository contains the work of the Patient-Level Prediction group in aiding this effort.


Patient-Level Prediction Studies
=============

There are various packages contained here:

## 1) Predicting which patients with signs/diagnosis will require hospitalization ##

The objective of this study is to inform the triage and early management of patients with diagnosed or suspected COVID-19, by developing and validating a patient-level prediction model to identify adult patients at risk of hospitalization after presenting with flu or flu-like symptoms at a general practitioner (GP), outpatient (OP) or emergency room (ER) visit.  

When should this model be used? When a patient first has a diagnosis of symptom of covid-19

**Protocol:** [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/blob/master/HospitalizationInSymptomaticPatients/docs/PLP_protocol_Q1%2BQ2_20200329.docx)

### Packages ###

- OHDSI model development: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/HospitalizationInSymptomaticPatients)
- OHDSI full model validation: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/HospInOutpatientVal)
- Existing model validation: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/CovidVulnerabilityIndex)
- OHDSI simple model validation: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/CovidSimpleModels)

### Results ###

- **Shiny app:** [full model link](https://data.ohdsi.org/Covid19PredictingHospitalizationInFluPatients/)
- **Shiny app:** [Simple model link](https://data.ohdsi.org/Covid19PredictingSimpleModels/)


## 2) Predicting which patients sent home after being seen at outpatient for flu or flu-like symptoms end up in hospital 2-30 days later   ##

The objective of this study is to identify the most patients at risk of being hospitalized amongst those who have been sent home after presenting with flu and COVID-19 or symptoms.  

When should this model be used? When a patient is about to be sent home after being seen with suspected covid-19

**Protocol:** [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/blob/master/HospitalizationInSentHomePatients/docs/PLP_protocol_Q1%2BQ2_20200329.docx)

### Packages ###

- OHDSI model development: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/HospitalizationInSentHomePatients)
- OHDSI full model validation: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/SentHomeValidation)

### Results ###

- **Shiny app:** [link](https://data.ohdsi.org/Covid19PredictingHospitilizationAfterSentHome/)
  
  
## 3) Predicting which patients admitted to hospital for pneumonia will be more severe (e.g., require ventilator or ICU) ##

The objective of this study is to identify the most high risk patients amongst those who have been admitted to hospital with pneumonia and COVID-19.  

When should this model be used? When a patient is first admitted to hospital with suspected covid-19

**Protocol:** [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/blob/master/SevereInHospitalizedPatients/docs/PLP_protocol_Q3_20200329.docx)

### Packages ###

- OHDSI model development: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/SevereInHospitalizedPatients)
- OHDSI full model validation: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/SevereInHospVal)
- OHDSI simple model validation: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/CovidSimpleModels)


### Results ###

- **Shiny app:** [Full model link](https://data.ohdsi.org/Covid19PredictingSevereInHospResults/)
- **Shiny app:** [Simple model link](https://data.ohdsi.org/Covid19PredictingSimpleModels/)


## 4) Predicting survival in patients who recieve intensive care for pneumonia and ARDS ##
 
The objective of this study is to identify which critically ill COVID-19 patients are most likely to survive if provided intensive care resources.  This would be used within a prioritization scheme for resource. 

When should this model be used? When a patient is first admitted to hospital with suspected or known covid-19

**Protocol:** [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/blob/master/CovidSimpleSurvival/docs/PLP_protocol_Q4_20200416.docx)
 
### Packages ###

- OHDSI simple model validation package: [link](https://github.com/ohdsi-studies/Covid19PredictionStudies/tree/master/CovidSimpleSurvival)

### Results ###

- **Shiny app:** [Simple model link](https://data.ohdsi.org/Covid19PredictingSimpleModels/)



Instructions for participation
============
To run these studies you need the following software installed:

- [Required] R (version 3.5.0 or higher). 
- [Required] Java (Java can be downloaded from http://www.java.com)

You need to install the latest version of the PatientLevelPrediction R package (version 3.0.15):

```r
install.packages('devtools')
devtools::install_github("OHDSI/FeatureExtraction")
devtools::install_github('ohdsi/PatientLevelPrediction')
```

You need to install OhdsiSharing to send the results:

```r
devtools::install_github("OHDSI/OhdsiSharing")
```

To install and run all the validation studies run the code [here](https://github.com/ohdsi-studies/Covid19PredictionStudies/blob/master/CodeToRun.R) where you will need to enter the CDM data connection and details, the outputFolder location and sharing settings such as minCellCount.


To submit the results
============
Once you have sucessfully executed the study you will find a compressed folder in the location specified by '[outputFolder]/allExport.zip'.  The study should remove sensitive data but we encourage researchers to also check the contents of this folder.  

To send the compressed folder results please message one of the leads (**[jreps](https://forums.ohdsi.org/u/jreps) , [RossW](https://forums.ohdsi.org/u/RossW)**) and we will give you the privateKeyFileName and userName.  You can then run the following R code to share the results:

```r
# If you don't have the R package OhdsiSharing then install it using github (uncomment the line below)
# install_github("ohdsi/OhdsiSharing")

library("OhdsiSharing")
privateKeyFileName <- "message us for this"
userName <- "message us for this"
fileName <- file.path(outputFolder, 'allExport.zip')
sftpUploadFile(privateKeyFileName, userName, fileName)
```


## Result object
After running the study you will get multiple 'validationResult.rds' objects. You can load these objects using the R function readRDS:
```r
result <- readRDS('[location to rds file]/validationResult.rds')
```

the 'result' object is a list containing the following:

| Object | Description | Edited by minCellCount |
| ----------| ---------------------------------------------------| ----------------------- |
| result$inputSetting | The outcome and cohort ids and the databaseName | No | 
| result$executionSummary | Information about the R version, PatientLevelPrediction version and execution platform info | No | 
| result$model | Information about the model (name and type) | No | 
| result$analysisRef | Used to store a unique reference for the study | No | 
| result$covariateSummary | A dataframe with summary information about how often the covariates occured for those with and without the outcome | Yes | 
| result$performanceEvaluation$evaluationStatistics | Performance metrics and sizes | No | 
| result$performanceEvaluation$thresholdSummary | Operating characteristcs @ 100 thresholds | No | 
| result$performanceEvaluation$demographicSummary | Calibration per age group | Yes | 
| result$performanceEvaluation$calibrationSummary | Calibration at risk score deciles | No | 
| result$performanceEvaluation$predictionDistribution | Distribution of risk score for those with and without the outcome | No | 


When packaging the results all cell counts (that could contain sensitive data) less than minCellCount are replaced by -1.
