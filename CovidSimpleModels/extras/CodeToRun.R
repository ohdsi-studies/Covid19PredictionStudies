library(CovidVulnerabilityIndex)
# USER INPUTS
#=======================
# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "location with space to save big data")

# The folder where the study intermediate and result files will be written:
outputFolder <- "./CovidVulnerabilityIndexResults"

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
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'CovidVulnerabilityIndexCohort'


createCohorts <- T
runAnalyses <- T
viewShiny <- F
packageResults <- F
minCellCount <- 5

sampleSize <- 150000


#========== NOT RECOMMENDED TO CHANGE   =========
# TAR settings

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
#=======================

CovidVulnerabilityIndex::execute(connectionDetails = connectionDetails,
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
                                    runAnalyses = runAnalyses,
                                    viewShiny = viewShiny,
                                    packageResults = packageResults,
                                    minCellCount= minCellCount,
                                    verbosity = "INFO",
                                    cdmVersion = 5)
