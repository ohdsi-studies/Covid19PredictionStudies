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
                    cdmVersion){
  
  pathToCustom <- system.file("settings", 'CustomCovariates.csv', package = "CovidSimpleModels")
  cohortVarsToCreate <- utils::read.csv(pathToCustom)
  covSets <- list()
  length(covSets) <- nrow(cohortVarsToCreate)+1
  covSets[[1]] <- standardCovariates
  
  for(i in 1:nrow(cohortVarsToCreate)){
    covSets[[1+i]] <- createCohortCovariateSettings(covariateName = as.character(cohortVarsToCreate$cohortName[i]),
                                                      covariateId = cohortVarsToCreate$cohortId[i]*1000+456,
                                                      cohortDatabaseSchema = cohortDatabaseSchema,
                                                      cohortTable = cohortTable,
                                                      cohortId = cohortId,
                                                      startDay=cohortVarsToCreate$startDay[i], 
                                                      endDay=endDay,
                                                      count= ifelse(is.null(cohortVarsToCreate$count), F, cohortVarsToCreate$count[i]), 
                                                      ageInteraction = ifelse(is.null(cohortVarsToCreate$ageInteraction), F, cohortVarsToCreate$ageInteraction[i]))
  }
  
  result <- PatientLevelPrediction::getPlpData(connectionDetails = connectionDetails,
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
                                     covariateSettings = covSets)
  
  return(result)
  
}


getModel <- function(model = 'SimpleModel.csv'){
  pathToCustom <- system.file("settings", model , package = "CovidSimpleModels")
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


getSettings <- function(predictSevereAtOutpatientVisit,
            predictCriticalAtOutpatientVisit,
            predictDeathAtOutpatientVisit,
            predictCriticalAtInpatientVisit,
            predictDeathAtInpatientVisit,
            usePackageCohorts){
  
  settingR <- c()
  
  if(predictSevereAtOutpatientVisit){
    settingR <- rbind(settingR, c(cohortId = ifelse(usePackageCohorts, 1, 1), 
                             outcomeId = ifelse(usePackageCohorts, 2, 2),
                             analysisId = 1, 
                             model = 'SevereAtOutpatientVisit.csv'))
  }
  if(predictCriticalAtOutpatientVisit){
    settingR <- rbind(settingR, c(cohortId = ifelse(usePackageCohorts, 1, 1), 
                             outcomeId = ifelse(usePackageCohorts, 3, 2),
                             analysisId = 2, 
                             model = 'CriticalAtOutpatientVisit.csv'))
  }
  if(predictDeathAtOutpatientVisit){
    settingR <- rbind(settingR, c(cohortId = ifelse(usePackageCohorts, 1, 1), 
                             outcomeId = ifelse(usePackageCohorts, 4, 2),
                             analysisId = 3, 
                             model = 'DeathAtOutpatientVisit.csv'))
  }
  if(predictCriticalAtInpatientVisit){
    settingR <- rbind(settingR, c(cohortId = ifelse(usePackageCohorts, 2, 1), 
                             outcomeId = ifelse(usePackageCohorts, 3, 2),
                             analysisId = 4, 
                             model = 'CriticalAtInpatientVisit,.csv'))
  }
  if(predictDeathAtInpatientVisit){
    settingR <- rbind(settingR, c(cohortId = ifelse(usePackageCohorts, 2, 1), 
                             outcomeId = ifelse(usePackageCohorts, 4, 2),
                             analysisId = 5, 
                             model = 'DeathAtInpatientVisit.csv'))
  }
  
  settingR <- as.data.frame(settingR)
  return(settingR)

}


