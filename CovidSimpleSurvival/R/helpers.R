getData <- function(connectionDetails,
                    cohortId,
                    outcomeIds,
                    cdmDatabaseSchema,
                    cdmDatabaseName,
                    cohortDatabaseSchema,
                    cohortTable,
                    oracleTempSchema,
                    standardCovariates,
                    endDay,
                    firstExposureOnly,
                    sampleSize,
                    cdmVersion,
                    studyStartDate,
                    studyEndDate ){
  
  pathToCustom <- system.file("settings", 'CustomCovariates.csv', package = "CovidSimpleSurvival")
  cohortVarsToCreate <- utils::read.csv(pathToCustom)
  covSets <- list()
  length(covSets) <- nrow(cohortVarsToCreate)+1
  covSets[[1]] <- standardCovariates
  
  for(i in 1:nrow(cohortVarsToCreate)){
    covSets[[1+i]] <- createCohortCovariateSettings(covariateName = as.character(cohortVarsToCreate$cohortName[i]),
                                                      covariateId = cohortVarsToCreate$cohortId[i]*1000+456,
                                                      cohortDatabaseSchema = cohortDatabaseSchema,
                                                      cohortTable = cohortTable,
                                                      cohortId = cohortVarsToCreate$atlasId[i],
                                                      startDay=cohortVarsToCreate$startDay[i], 
                                                      endDay=endDay,
                                                      count= as.character(cohortVarsToCreate$count[i]), 
                                                      ageInteraction = as.character(cohortVarsToCreate$ageInteraction[i]))
  }
  
  result <- tryCatch({PatientLevelPrediction::getPlpData(connectionDetails = connectionDetails,
                                     cdmDatabaseSchema = cdmDatabaseSchema,
                                     oracleTempSchema = oracleTempSchema, 
                                     cohortId = as.double(as.character(cohortId)), 
                                     outcomeIds = as.double(as.character(outcomeIds)), 
                                     cohortDatabaseSchema = cohortDatabaseSchema, 
                                     outcomeDatabaseSchema = cohortDatabaseSchema, 
                                     cohortTable = cohortTable, 
                                     outcomeTable = cohortTable, 
                                     cdmVersion = cdmVersion, 
                                     firstExposureOnly = firstExposureOnly, 
                                     sampleSize =  sampleSize, 
                                     covariateSettings = covSets,
                                     studyStartDate = studyStartDate,
                                     studyEndDate =  studyEndDate)},
                     error = function(e) {
                       return(NULL)
                     })
  
  return(result)
  
}


getModel <- function(model = 'SimpleModel.csv'){
  pathToCustom <- system.file("settings", model , package = "CovidSimpleSurvival")
  coefficients <- utils::read.csv(pathToCustom)
   return(coefficients)
}

getPredict <- function(model){
  predictExisting <- function(plpData, population){
    coefficients <- model
    
    prediction <- merge(plpData$covariates, ff::as.ffdf(coefficients), by = "covariateId")
    prediction$value <- prediction$covariateValue * prediction$points
    prediction <- PatientLevelPrediction:::bySumFf(prediction$value, prediction$rowId)
    colnames(prediction) <- c("rowId", "value")
    prediction <- merge(population, prediction, by ="rowId", all.x = TRUE)
    prediction$value[is.na(prediction$value)] <- 0
    
    # add any final mapping here (e.g., add intercept and mapping)
    prediction$value <- prediction$value + model$points[model$covariateId==0]
    prediction$value <- prediction$value/10
    prediction$value <- 1/(1+exp(-1*prediction$value))
    
    scaleVal <- max(prediction$value)
    if(scaleVal>1){
      prediction$value <- prediction$value/scaleVal
    }
    
    attr(prediction, "metaData") <- list(predictionType = 'binary', scale = scaleVal)
    
    return(prediction)
  }
  return(predictExisting)
}


getSettings <- function(predictShortTermSurvival,
            predictLongTermSurvival, 
            usePackageCohorts){
  
  settingR <- c()
  
  if(predictShortTermSurvival){
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4006,
                          studyStartDate = "",
                          studyEndDate = "",
                          riskWindowStart = 0,
                          startAnchor = 'cohort start',
                          riskWindowEnd = 60,
                          endAnchor = 'cohort start',
                          model = 'ShortTermSurvival.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(1,1, 1001), 
                                   outcomeId = rep(2,3),
                                   studyStartDate = c("","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531"),
                                   riskWindowStart = rep(0,3),
                                   startAnchor = rep('cohort start',3),
                                   riskWindowEnd = rep(60,3),
                                   endAnchor = rep('cohort start',3),
                                   analysisId = c(6,1006,2006), 
                                   model = rep('ShortTermSurvival.csv',3))) 
    }
  }
  
  
  if(predictLongTermSurvival){
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4007,
                          studyStartDate = "",
                          studyEndDate = "",
                          riskWindowStart = 0,
                          startAnchor = 'cohort start',
                          riskWindowEnd = 365,
                          endAnchor = 'cohort start',
                          model = 'LongTermSurvival.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(1,1, 1001), 
                                   outcomeId = rep(2,3),
                                   studyStartDate = c("","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531"),
                                   riskWindowStart = rep(0,3),
                                   startAnchor = rep('cohort start',3),
                                   riskWindowEnd = rep(365,3),
                                   endAnchor = rep('cohort start',3),
                                   analysisId = c(7,1007,2007), 
                                   model = rep('LongTermSurvival.csv',3))) 
    }
  }
  
  settingR <- as.data.frame(settingR)
  return(settingR)

}


