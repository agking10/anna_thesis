source("load_libraries.R")
source("population_data.R")
source("paths.R")
load_libraries()

# Cleans and aggregates temperature data used at various points in our analysis

write_cleaned_temp_data <- function() {
  max_temperature_data <- read.csv(file.path(TEMPERATURE_DATA_DIR, "max_temperature_per_county_per_day_20002022.csv"))
  min_temperature_data <- read.csv(file.path(TEMPERATURE_DATA_DIR, "min_temperature_per_county_per_day_20002022.csv"))
  mean_temperature_data <- read.csv(file.path(TEMPERATURE_DATA_DIR, "mean_temperature_per_county_per_day_20002022.csv"))
  vpdmax_data <- read.csv(file.path(TEMPERATURE_DATA_DIR, "vpdmax_per_county_per_day_20002022.csv"))

  vpdmin_data <- vpdmax_data

  reshape_data <- function(data) {
    data %>%
      gather(Date, Temperature, starts_with("X"), -GEOID, -county) %>%
      rename(county = "county")
  }

  max_temperature_data_long <- reshape_data(max_temperature_data)
  min_temperature_data_long <- reshape_data(min_temperature_data)
  mean_temperature_data_long <- reshape_data(mean_temperature_data)
  vpdmin_data_long <- vpdmin_data %>%
    gather(Date, MinVPDeficit, starts_with("X"), -GEOID, -county) %>%
    rename(county = "county")

  convert_date <- function(date) {
    as.Date(sub("X", "", date), format = "%Y.%m.%d")
  }

  max_temperature_data_long$Date <- convert_date(max_temperature_data_long$Date)
  min_temperature_data_long$Date <- convert_date(min_temperature_data_long$Date)
  mean_temperature_data_long$Date <- convert_date(mean_temperature_data_long$Date)
  vpdmin_data_long$Date <- convert_date(vpdmin_data_long$Date)

  max_temperature_data_long$year <- year(max_temperature_data_long$Date)
  min_temperature_data_long$year <- year(min_temperature_data_long$Date)
  mean_temperature_data_long$year <- year(mean_temperature_data_long$Date)
  vpdmin_data_long$year <- year(vpdmin_data_long$Date)

  renamed_county_pop <- county_pop %>%
    rename(GEOID = fips)

  join_with_county <- function(data) {
    data %>%
      left_join(renamed_county_pop, by = c("year", "county", "GEOID"))
  }

  max_temperature_data_long <- join_with_county(max_temperature_data_long)
  min_temperature_data_long <- join_with_county(min_temperature_data_long)
  mean_temperature_data_long <- join_with_county(mean_temperature_data_long)
  vpdmin_data_long <- join_with_county(vpdmin_data_long)



  max_temperature_data_long <- max_temperature_data_long %>%
    rename(MaxTemperature = Temperature)

  min_temperature_data_long <- min_temperature_data_long %>%
    rename(MinTemperature = Temperature)

  mean_temperature_data_long <- mean_temperature_data_long %>%
    rename(MeanTemperature = Temperature)


  max_temperature_data_long <- max_temperature_data_long %>%
    mutate(
      SatVapPres = ifelse(MaxTemperature > 0,
        exp(34.494 - (4924.99 / (MaxTemperature + 237.1))) / ((MaxTemperature + 105)^1.57),
        exp(43.494 - (6545.8 / (MaxTemperature + 278))) / ((MaxTemperature + 868)^2)
      )
    )



  combined_temp_data <- max_temperature_data_long
  combined_temp_data <- left_join(combined_temp_data, min_temperature_data_long %>% dplyr::select(county, Date, GEOID, MinTemperature), by = c("county", "Date", "GEOID"))
  combined_temp_data <- left_join(combined_temp_data, mean_temperature_data_long %>% dplyr::select(county, Date, GEOID, MeanTemperature), by = c("county", "Date", "GEOID"))
  combined_temp_data <- left_join(combined_temp_data, vpdmin_data_long %>% dplyr::select(county, Date, GEOID, MinVPDeficit), by = c("county", "Date", "GEOID"))


  combined_temp_data$MinVPDeficit <- combined_temp_data$MinVPDeficit * 100
  combined_temp_data$VaporPressure <- combined_temp_data$SatVapPres - combined_temp_data$MinVPDeficit
  combined_temp_data$RelHum <- ((combined_temp_data$VaporPressure) / combined_temp_data$SatVapPres) * 100

  combined_temp_data$MaxTemperatureF <- (combined_temp_data$MaxTemperature * (9 / 5)) + 32

  combined_temp_data$HeatIndex <- heat.index(
    t = combined_temp_data$MaxTemperatureF,
    rh = combined_temp_data$RelHum,
    temperature.metric = "fahrenheit"
  )

  write.csv(combined_temp_data, file.path(TEMPERATURE_DATA_DIR, "combined_temp_data.csv"), row.names = FALSE)
}

write_cleaned_temp_data()
