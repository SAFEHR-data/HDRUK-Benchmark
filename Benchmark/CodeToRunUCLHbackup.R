#backup of UCLH code with db & user names removed
#run the local version & copy updates to this backup
#andy south
#repo is forked from Oxford & this local script added

# to restore renv environment
renv::restore()

# acronym to identify the database
# beware dbName identifies outputs, dbname is UCLH db
# here different outputs can be created for each UCLH schema which is a different omop extract

#dbName <- "UCLH-EHDEN"
#cdmSchema <- "ehden_001"

dbName <- "UCLH-6months"
cdmSchema <- "data_catalogue_003" #6 months


# create a DBI connection to your database
user <- rstudioapi::askForPassword("user")
host <- rstudioapi::askForPassword("host")
port <- 15432
dbname <- "omop_reservoir"
pwd <- rstudioapi::askForPassword("Password for omop_db")
con <- DBI::dbConnect(RPostgres::Postgres(),user = user, host = host, port = port, dbname = dbname, password=pwd)

#get this if not connected to VPN
#Error: could not translate host name "uclvlddpragae06" to address: Unknown host


# schema in the database where you have writing permissions
writeSchema <- "_other_andsouth" #"data_catalogue_003"

# created tables will start with this prefix
prefix <- "uclh_hdruk_benchmark"

# minimum cell counts used for suppression
minCellCount <- 5

# to create the cdm object
cdm <- CDMConnector::cdmFromCon(
  con = con,
  cdmSchema = cdmSchema,
  writeSchema =  writeSchema,
  writePrefix = prefix,
  cdmName = dbName,
  .softValidation = TRUE
)

#ehden_001 : works
#data_catalogue_003 :
#Error in `validateCdmReference()`: overlap between observation_periods, 2642 overlaps detected
#if don't have permsissions get : Error in `cdm_from_con()`: ! There were no cdm tables found in the cdm_schema!
#contact Baptiste to rectify

# run study code
#source("Benchmark/R/RunBenchmark.R")
source("R/RunBenchmark.R")

# initial renv error
# Error: This project does not contain a lockfile.
# Have you called `snapshot()` yet?
# renv::snapshot() not CDMConnector::snapshot() :-)
#
# error when I was running from home folder
# In file(file, ifelse(append, "a", "w")) :
# cannot open file 'HDRUK-Benchmark/Results//log_UCLH-6months_11_12_2024_18_35_54.txt': No such file or directory

