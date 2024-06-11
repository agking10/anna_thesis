source("load_libraries.R")
source("paths.R")

load_libraries()

# data: a dataframe containing the following columns:
#  - "Date"
#  - "county"
#  - "GEOID"
#  - "MinTemperature"
#  - "MaxTemperature"
#  - "MeanTemperature"
#  - "HeatIndex"
#  - "uniqueID"
#  - "case_control"
#  - "opioid_contributing"
#  - "cocaine_contributing"
#  - "other_stimi_contributing"
#  - "year"
#  - "total_population"
#  - "simple_race"
#  - "sex"
#  - "ethnicity"
#  - "simple_age"
#  - "block"
#  - "lag0"
#  - "lag1"
#  - "lag2"
#  - "lag3"
#  - "lag4"
#  - "lag5"
#  - "lag6"
#
# The rows in this dataframe represent either a death or control date.
dlnm <- function(data) {
  data <- data %>%
    mutate(Year = year(Date)) %>%
    filter(year(Date) >= 2000 & Year <= 2022) %>%
    dplyr::select(-Year)

  data <- data %>%
    arrange(county, Date) %>%
    group_by(county) %>%
    mutate(
      lag0 = MaxTemperature,
      lag1 = lag(MaxTemperature, 1),
      lag2 = lag(MaxTemperature, 2),
      lag3 = lag(MaxTemperature, 3),
      lag4 = lag(MaxTemperature, 4),
      lag5 = lag(MaxTemperature, 5),
      lag6 = lag(MaxTemperature, 6)
    ) %>%
    ungroup()


  # creating the exposure histories martrix
  Qdata <- data %>%
    dplyr::select(lag0:lag6)

  range <- range(data$MaxTemperature, na.rm = T)
  nknots <- 4
  nlagknots <- 2
  ktemp <- range[1] + (range[2] - range[1]) / (nknots + 1) * 1:nknots
  klag <- exp((log(6)) / (nlagknots + 2) * 1:nlagknots)
  cbnest <- crossbasis(Qdata, lag = 6, argvar = list("ns", df = 3), arglag = list(fun = "ns", knots = klag), compare = "median")

  # # regression model
  mnest <- clogit(binary ~ cbnest + strata(uniqueID), data, method = "exact")

  # # predicting specific effect summaries
  cenvalue <- median(warm_season_matched_data_blocks_edited$MaxTemperature)
  range <- range(warm_season_matched_data_blocks_edited$MaxTemperature)
  pnest <- crosspred(cbnest, mnest, cen = cenvalue, at = 10:40, cumul = TRUE)

  pnest
}

# matched_data_file is a dataframe containing temperature data for each death date.
# This function concatenates the death data with temperature data for all dates to create
# a dataframe on which we can invoke dlnm().
dlnm_season <- function(matched_data_file) {
  matched_data_blocks <- read.csv(matched_data_file)
  combined_temp_data <- read.csv(file.path(TEMPERATURE_DATA_DIR, "combined_temp_data.csv"))
  combined_temp_data$Date <- as.Date(combined_temp_data$Date)

  matched_data_blocks_edited <- matched_data_blocks %>%
    filter(block %in% c(1, 2, 3, 4, 5, 6, 7))

  matched_data_blocks_edited <- matched_data_blocks_edited %>%
    filter(opioid_contributing == "yes")

  matched_data_blocks_edited$Date <- as.Date(matched_data_blocks_edited$Date)

  final_dataframe <- bind_rows(matched_data_blocks_edited, combined_temp_data %>%
    select(-SatVapPres, -MinVPDeficit, -VaporPressure, -RelHum, -MaxTemperatureF))

  dlnm(final_dataframe)
}

warm_season_dlnm <- dlnm_season(file.path(MISC_DATA_DIR, "warm_season_matched_data_blocks.csv"))
