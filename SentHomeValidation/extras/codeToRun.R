library(SentHomeValidation)

# add details of your database setting:
databaseName <- 'add a shareable name for the database you are currently validating on'

# add the cdm database schema with the data
cdmDatabaseSchema <- 'your cdm database schema for the validation'

# add the work database schema this requires read/write privileges
cohortDatabaseSchema <- 'your work database schema'

# if using oracle please set the location of your temp schema
oracleTempSchema <- NULL

# the name of the table that will be created in cohortDatabaseSchema to hold the cohorts
cohortTable <- 'SentHomeValidationCohortTable'

# the location to save the prediction models results to:
outputFolder <- './SentHomeValidation'

# Min cell count in final results, values less than this are replaced by -1
minCellCount <- 10

# add connection details:
# NOTE: make sure the folder you set for fftempdir exists or you will get an error
options(fftempdir = 'T:/fftemp')
dbms <- "pdw"
user <- NULL
pw <- NULL
server <- Sys.getenv('server')
port <- Sys.getenv('port')
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)


# Pick what parts of the study to run (all need to be run so recommend to not edit between ===)
#======
createCohorts <- TRUE
runValidation <- TRUE
packageResults <- TRUE
#=====

# Now run the study
SentHomeValidation::execute(connectionDetails = connectionDetails,
                                 databaseName = databaseName,
                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                 cohortDatabaseSchema = cohortDatabaseSchema,
                                 oracleTempSchema = oracleTempSchema,
                                 cohortTable = cohortTable,
                                 outputFolder = outputFolder,
                                 createCohorts = createCohorts,
                                 runValidation = runValidation,
                                 packageResults = packageResults,
                                 minCellCount = minCellCount,
                                 sampleSize = NULL)
# the results will be saved to outputFolder.  If you set this to the
# predictionStudyResults/Validation package then the validation results
# will be accessible to the shiny viewer

