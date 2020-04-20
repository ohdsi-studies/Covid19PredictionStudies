# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of CovidSimpleSurvival
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Package the results for sharing with OHDSI researchers
#'
#' @details
#' This function packages the results.
#'
#' @param outputFolder        Name of folder containing the study analysis results 
#'                            (/)
#' @param minCellCount        The minimum number of subjects contributing to a count before it can be included in the results.
#'
#' @export
packageResults <- function(outputFolder, 
                           cdmDatabaseName,
                           minCellCount = 5) {
  if(missing(outputFolder)){
    stop('Missing outputFolder...')
  }
  
  # for each analysis copy the requested files...
  folders <- list.dirs(path = file.path(outputFolder,cdmDatabaseName), recursive = F, full.names = F)
  folders <- folders[grep('Analysis_', folders)]
  
  #create export subfolder in workFolder
  exportFolder <- file.path(outputFolder,cdmDatabaseName, "export")
  dir.create(exportFolder, recursive = T)
  
  for(folder in folders){
    #copy all plots across
    if (!file.exists(file.path(exportFolder,folder))){
      dir.create(file.path(exportFolder,folder), recursive = T)
    }
    
    # loads analysis results
    if(file.exists(file.path(outputFolder,cdmDatabaseName,folder, 'validationResult.rds'))){
      plpResult <- readRDS(file.path(outputFolder,cdmDatabaseName,folder, 'validationResult.rds'))
      plpResult$model$predict <- NULL
      if(minCellCount!=0){
        plpResult <- PatientLevelPrediction::transportPlp(plpResult,
                                             save = F, 
                                             n=minCellCount,
                                             includeEvaluationStatistics=T,
                                             includeThresholdSummary=T, 
                                             includeDemographicSummary=T,
                                             includeCalibrationSummary =T, 
                                             includePredictionDistribution=T,
                                             includeCovariateSummary=T)
      } else {
        plpResult <- PatientLevelPrediction::transportPlp(plpResult,
                                                          save = F, 
                                             n=NULL,
                                             includeEvaluationStatistics=T,
                                             includeThresholdSummary=T, 
                                             includeDemographicSummary=T,
                                             includeCalibrationSummary =T, 
                                             includePredictionDistribution=T,
                                             includeCovariateSummary=T)
      }
      
      saveRDS(plpResult, file.path(exportFolder,folder, 'validationResult.rds'))
      
    }
  }
  
  
  ### Add all to zip file ###
  zipName <- file.path(outputFolder,paste0(cdmDatabaseName, '.zip'))
  OhdsiSharing::compressFolder(exportFolder, zipName)
  # delete temp folder
  unlink(exportFolder, recursive = T)
  
  writeLines(paste("\nStudy results are compressed and ready for sharing at:", zipName))
  return(zipName)
}
