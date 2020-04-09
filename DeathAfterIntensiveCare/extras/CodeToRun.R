library(DeathAfterIntensiveCare)
# USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./DeathAfterIntensiveCareResults"

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
cdmDatabaseSchema <- 'your cdm database'

# Add a sharebale name for the database containing the OMOP CDM data
cdmDatabaseName <- 'cdm database name'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'your cohort database'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'DeathAfterIntensiveCareCohort'
#=======================

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
		oracleTempSchema = oracleTempSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createProtocol = F,
        createCohorts = T,
        runAnalyses = T,
        createResultsDoc = F,
        packageResults = F,
        createValidationPackage = F,  
        #analysesToValidate = 1,
        minCellCount= 5,
        createShiny = F,
        createJournalDocument = F,
        analysisIdDocument = 1)

# Uncomment and run the next line to see the shiny results:
# PatientLevelPrediction::viewMultiplePlp(outputFolder)
