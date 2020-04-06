library(CovidSimpleModels)
# USER INPUTS
#=======================
# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "location with space to save big data")

# The folder where the study intermediate and result files will be written:
outputFolder <- "./CovidSimpleModelsResults"

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
cohortTable <- 'CovidSimpleModelsCohort'

#============== Pick Study Parts To Run: ===========
createCohorts = TRUE
predictSevereAtOutpatientVisit = TRUE
predictCriticalAtOutpatientVisit = TRUE
predictDeathAtOutpatientVisit = TRUE
predictCriticalAtInpatientVisit = TRUE
predictDeathAtInpatientVisit = TRUE
packageResults = TRUE

minCellCount <- 5
sampleSize <- NULL


#============== Pick T and O cohorts ===========

# [option 1] use default cohorts (same as those used to develop the models)
usePackageCohorts <- TRUE
newTargetCohortId <- NULL
newOutcomeCohortId <- NULL
newCohortDatabaseSchema <- NULL
newCohortTable <- NULL

# [option 2] use your own specified cohorts (these must be created already)
# uncomment the line below to set usePackageCohorts as False
# usePackageCohorts <- FALSE
# newTargetCohortId = 'the cohort definition id for the new target' 
# newOutcomeCohortId = 'the cohort definition id for the new outcome' 
# newCohortDatabaseSchema = 'the database schema containing the cohorts' 
# newCohortTable = 'the table name of the table containing the cohorts' 

#=======================
# TAR settings - recommended to not edit
#=======================
riskWindowStart <- 0
startAnchor <- 'cohort start'
riskWindowEnd <- 30
endAnchor <- 'cohort start'
firstExposureOnly <- F
removeSubjectsWithPriorOutcome <- F
priorOutcomeLookback <- 99999
requireTimeAtRisk <- F
minTimeAtRisk <- 1
includeAllOutcomes <- T

standardCovariates <- FeatureExtraction::createCovariateSettings(useDemographicsAge= T, 
                                                                 useDemographicsGender = T, 
                                                                 useVisitConceptCountLongTerm = T,
                                                                 excludedCovariateConceptIds = 8532 )

execute(connectionDetails = connectionDetails,
        usePackageCohorts = usePackageCohorts,
        newTargetCohortId = newTargetCohortId,
        newOutcomeCohortId = newOutcomeCohortId,
        newCohortDatabaseSchema = newCohortDatabaseSchema,
        newCohortTable = newCohortTable,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        sampleSize = sampleSize,
        riskWindowStart = riskWindowStart,
        startAnchor = startAnchor,
        riskWindowEnd = riskWindowEnd,
        endAnchor = endAnchor,
        firstExposureOnly = firstExposureOnly,
        removeSubjectsWithPriorOutcome = removeSubjectsWithPriorOutcome,
        priorOutcomeLookback = priorOutcomeLookback,
        requireTimeAtRisk = requireTimeAtRisk,
        minTimeAtRisk = minTimeAtRisk,
        includeAllOutcomes = includeAllOutcomes,
        standardCovariates = standardCovariates,
        outputFolder = outputFolder,
        createCohorts = createCohorts,
        predictSevereAtOutpatientVisit = predictSevereAtOutpatientVisit,
        predictCriticalAtOutpatientVisit = predictCriticalAtOutpatientVisit,
        predictDeathAtOutpatientVisit = predictDeathAtOutpatientVisit,
        predictCriticalAtInpatientVisit = predictCriticalAtInpatientVisit,
        predictDeathAtInpatientVisit = predictDeathAtInpatientVisit,
        packageResults = packageResults,
        minCellCount = minCellCount,
        verbosity = "INFO",
        cdmVersion = 5)