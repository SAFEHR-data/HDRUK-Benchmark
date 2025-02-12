druglist <- CodelistGenerator::getDrugIngredientCodes(
  cdm = cdm, name = c("acetaminophen", "warfarin"), nameStyle = "{concept_code}_{concept_name}")
t <- tictoc::toc()
task_name <- "Get ingredient codes with CodelistGenerator"
#res <- new_rows(res, task_name = task_name, time = t, iteration = i)

druglist <- check_int64(druglist)
#this needed to get it to cope with column names starting with numbers
druglist$`161_acetaminophen`

# 9) Instantiate acetaminophen and metformin cohorts
tictoc::tic()
cdm <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm,
  name = "drug_cohorts",
  conceptSet = druglist[c("161_acetaminophen", "11289_warfarin")],
  #conceptSet = druglist[c("11289_warfarin")], #works
  #conceptSet = druglist[c("161_acetaminophen")],#fails
  gapEra = 30
)

cdm$drug_exposure |>
  dplyr::filter(drug_concept_id %in% !!druglist[["161_acetaminophen"]]) |>
  dplyr::summarise(
    n = dplyr::n(),
    missing_start = sum(as.integer(is.na(drug_exposure_start_date))),
missing_end = sum(as.integer(is.na(drug_exposure_end_date))),
end_before_start = sum(as.integer(drug_exposure_end_date < drug_exposure_start_date)))

