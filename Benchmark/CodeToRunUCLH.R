#backup of UCLH code with db & user names removed
#probably don't run this version, run the local version & copy updates to this backup
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


# create a DBI connection to UCLH database
# using credentials in .Renviron or you can replace with hardcoded values here
user <- Sys.getenv("user")
host <- Sys.getenv("host")
port <- Sys.getenv("port")
dbname <- Sys.getenv("dbname")
# schema in database where you have writing permissions
writeSchema <- "_other_andsouth"

if("" %in% c(user, host, port, dbname, writeSchema))
  stop("seems you don't have (all?) db credentials stored in your .Renviron file, use usethis::edit_r_environ() to create")
pwd <- rstudioapi::askForPassword("Password for omop_db")

con <- DBI::dbConnect(RPostgres::Postgres(),user = user, host = host, port = port, dbname = dbname, password=pwd)

#you get this if not connected to VPN
#Error: could not translate host name ... to address: Unknown host

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

