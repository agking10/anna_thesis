source("load_libraries.R")

GEOGRAPHIC_RESOLUTION <- "county"

GetCensusData <- function(geography) {
  state_code <- 37
  census_data <- get_decennial(
    geography = geography,
    variables = c(
      "Total_pop" = "P001001"
    ),
    year = 2010,
    output = "wide",
    geometry = TRUE,
    state = state_code
  ) %>%
    st_transform(crs = st_crs(4326)) %>%
    filter(!st_is_empty(.))

  return(census_data)
}

extract_svi_data <- function() {
  census_data <- GetCensusData(GEOGRAPHIC_RESOLUTION)

  tif_file <- file.path(file.path("svi_2020_tract_overall_nad83.tif"))

  raster_data <- rast(tif_file)

  census_data$SVI <- exact_extract(raster_data, census_data[1], fun = "mean")

  census_data$SVI_tertile <- ntile(census_data$SVI, 3)
  census_data <- st_drop_geometry(census_data)
  census_data <- as.data.frame(census_data)
  census_data <- census_data[, !names(census_data) %in% "Total_pop"]
  write.csv(census_data, file.path(MISC_DATA_DIR, "SVI_data.csv"), row.names = FALSE)
}
