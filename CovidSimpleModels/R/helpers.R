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
                    studyEndDate){
  
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
                                     studyEndDate = studyEndDate)},
                     error = function(e) {
                       return(NULL)
                     })
  
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
    
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4001, 
                          model = 'SevereAtOutpatientVisit.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(1001,1001,1002,1003), 
                                   outcomeId = rep(2001,4),
                                   studyStartDate = c("","20200101","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531","20200531"),
                                   analysisId = c(1,1001,2001,3001), 
                                   model = rep('SevereAtOutpatientVisit.csv',4))) 
    }
    
    
    
  }
  if(predictCriticalAtOutpatientVisit){
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4002, 
                          model = 'CriticalAtOutpatientVisit.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(1001,1001,1002,1003), 
                                   outcomeId = rep(3001,4),
                                   studyStartDate = c("","20200101","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531","20200531"),
                                   analysisId = c(2,1002,2002,3002), 
                                   model = rep('CriticalAtOutpatientVisit.csv',4))) 
    }
  }
  
  
  if(predictDeathAtOutpatientVisit){
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4003, 
                          model = 'DeathAtOutpatientVisit.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(1001,1001,1002,1003), 
                                   outcomeId = rep(4001,4),
                                   studyStartDate = c("","20200101","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531","20200531"),
                                   analysisId = c(3,1003,2003,3003), 
                                   model = rep('DeathAtOutpatientVisit.csv',4))) 
    }
  }
  
  
  if(predictCriticalAtInpatientVisit){
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4004, 
                          model = 'CriticalAtInpatientVisit.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(2001,2001,2002,2003), 
                                   outcomeId = rep(3001,4),
                                   studyStartDate = c("","20200101","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531","20200531"),
                                   analysisId = c(4,1004,2004,3004), 
                                   model = rep('CriticalAtInpatientVisit.csv',4))) 
    }
  }
  
  
  
  if(predictDeathAtInpatientVisit){
    if(!usePackageCohorts){
      settingR <- rbind(settingR, 
                        c(cohortId = 1, 
                          outcomeId = 2,
                          analysisId = 4005, 
                          model = 'DeathAtInpatientVisit.csv'))  
    } else{
      settingR <- rbind(settingR, 
                        data.frame(cohortId = c(2001,2001,2002,2003), 
                                   outcomeId = rep(4001,4),
                                   studyStartDate = c("","20200101","20200101","20200101"),
                                   studyEndDate =c("","20200531","20200531","20200531"),
                                   analysisId = c(5,1005,2005,3005), 
                                   model = rep('DeathAtInpatientVisit.csv',4))) 
    }
  }
  
  
  settingR <- as.data.frame(settingR)
  return(settingR)
  
}


