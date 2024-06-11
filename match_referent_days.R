source("load_libraries.R")
source("paths.R")
# source("clean_opiod_death_data.R")
# source("extract_SVI.R")

# write_opiod_death_tables()
# extract_svi_data()


# Function to match deaths to referent days within the same month and day of the week
match_referent_days <- function(data, temp_data, months) {
  matched_data <- data.frame()

  unique_counties <- unique(data$county)
  unique_years <- unique(data$year)

  for (County in unique_counties) {
    county_data <- data %>% filter(county == County)

    print(paste(County))

    for (Year in unique_years) {
      year_data <- county_data %>% filter(year == Year)
      # print(paste(Year))

      # Filter data to include only May, June, July, August, and September
      year_data_filtered <- year_data %>%
        filter(months(Date) %in% months)

      # Check if year_data_filtered is empty
      if (nrow(year_data_filtered) == 0) {
        warning(paste("No valid dates for year:", Year))
        next # Skip to the next year
      }

      for (i in seq_len(nrow(year_data_filtered))) {
        case_date <- year_data_filtered$Date[i]
        case_min_temp <- year_data_filtered$MinTemperature[i]
        case_max_temp <- year_data_filtered$MaxTemperature[i]


        case_mean_temp <- year_data_filtered$MeanTemperature[i]
        case_heat_index <- year_data_filtered$HeatIndex[i]
        case_opioid <- year_data_filtered$opioid_contributing[i, months]
        case_cocaine <- year_data_filtered$cocaine_contributing[i]
        case_stimi <- year_data_filtered$other_stimi_contributing[i]
        case_day_of_week <- weekdays(case_date)
        case_year <- year(year_data_filtered$Date[i])
        case_county <- year_data_filtered$county[i]
        case_GEOID <- year_data_filtered$GEOID[i]
        case_uniqueID <- year_data_filtered$uniqueID[i]
        case_sex <- year_data_filtered$sex[i]
        case_race <- year_data_filtered$simple_race[i]
        case_age <- year_data_filtered$simple_age[i]
        case_ethnicity <- year_data_filtered$simple_ethnicity[i]
        case_block <- year_data_filtered$block[i]

        referent_days <- temp_data %>%
          filter(
            year == case_year,
            months(Date) %in% months,
            weekdays(Date) == case_day_of_week,
            county == case_county,
            Date != case_date,
            block == case_block
          )

        if (nrow(referent_days) == 0) {
          warning(paste("No referent days for case at Date:", case_date))
          next
        }

        case_data <- data.frame(
          Date = case_date,
          county = case_county,
          GEOID = case_GEOID,
          MinTemperature = year_data_filtered$MinTemperature[i],
          MaxTemperature = year_data_filtered$MaxTemperature[i],
          MeanTemperature = year_data_filtered$MeanTemperature[i],
          HeatIndex = year_data_filtered$HeatIndex[i],
          uniqueID = case_uniqueID,
          case_control = "case",
          opioid_contributing = case_opioid,
          cocaine_contributing = case_cocaine,
          other_stimi_contributing = case_stimi,
          year = case_year,
          total_population = referent_days$total_population[1],
          simple_race = case_race,
          sex = case_sex,
          ethnicity = case_ethnicity,
          simple_age = case_age,
          block = case_block
        )

        control_data <- referent_days %>%
          mutate(
            uniqueID = case_uniqueID,
            case_control = "control",
            simple_race = case_data$simple_race,
            sex = case_data$sex,
            ethnicity = case_data$ethnicity,
            simple_age = case_data$simple_age,
            block = case_block,
            opioid_contributing = case_data$opioid_contributing,
            cocaine_contributing = case_data$cocaine_contributing,
            other_stimi_contributing = case_data$other_stimi_contributing
          ) %>%
          select(
            Date, county, GEOID, MinTemperature, MaxTemperature, MeanTemperature, HeatIndex, uniqueID, case_control, opioid_contributing, cocaine_contributing, other_stimi_contributing,
            year, total_population, simple_race, sex, ethnicity, simple_age, block
          )

        matched_case_referent <- bind_rows(case_data, control_data)

        matched_case_referent$Date <- as.Date(matched_case_referent$Date)
        matched_data$Date <- as.Date(matched_data$Date)

        matched_data <- bind_rows(matched_data, matched_case_referent)
      }
    }
  }

  matched_data
}

match_referent_days <- function() {
  warm_season_deaths <- read.csv(file.path(DEATH_DATA_DIR, "warm_season_deaths.csv"))
  cool_season_deaths <- read.csv(file.path(DEATH_DATA_DIR, "cool_season_deaths.csv"))

  data_warm_season <- read.csv(file.path(TEMPERATURE_DATA_DIR, "data_warm_season.csv"))
  data_cool_season <- read.csv(file.path(TEMPERATURE_DATA_DIR, "data_cool_season.csv"))


  warm_months <- c("May", "June", "July", "August", "September", "October")
  cold_months <- c("December", "January", "February", "March")

  matched_data_warm_blocks <- match_referent_days(warm_season_deaths, data_warm_season, warm_months)
  matched_data_cool_blocks <- match_referent_days(cool_season_deaths, data_cool_season, cool_months)


  write.csv(matched_data_warm_blocks, file.path(MISC_DATA_DIR, "warm_season_matched_data_blocks.csv"), row.names = FALSE)
  write.csv(matched_data_cool_blocks, file.path(MISC_DATA_DIR, "cool_season_matched_data_blocks.csv"), row.names = FALSE)
}

# Work in progress
# plot_dlnm <- function(pnest) {
#   temp_values <- data.frame(pnest$predvar)
#   matfit_df <- data.frame(pnest$matRRfit)
#   matlow_df <- data.frame(pnest$matRRlow)
#   mathigh_df <- data.frame(pnest$matRRhigh)

#   # List to store the plots
#   plot_list <- list()

#   # Iterate over column indices
#   for (i in 0:6) {
#     # Create plot data for the current column index
#     plot_data <- data.frame(
#       temp = temp_values,
#       fit = matfit_df[, paste0("lag", i)], # Values from the current row of matRRfit
#       low = matlow_df[, paste0("lag", i)], # Values from the current row of matRRlow
#       high = mathigh_df[, paste0("lag", i)] # Values from the current row of matRRhigh
#     )

#     # Create the plot for the current column index
#     plot_list[[paste0("OMTp", i)]] <- ggplot(plot_data, aes(x = pnest.predvar)) +
#       geom_line(aes(y = fit), color = "red") +
#       geom_ribbon(aes(ymin = low, ymax = high), fill = "red", alpha = 0.3) +
#       labs(x = NULL, y = NULL) +
#       geom_hline(yintercept = 1, linetype = "dashed", color = "black") + # Add horizontal line
#       scale_x_continuous(breaks = seq(10, 40, by = 5)) +
#       coord_cartesian(ylim = c(0.5, 1.75)) + # Set y-axis limits
#       theme_minimal()
#   }


#   # Combine plots
#   combined_plot <- plot_grid(plotlist = plot_list, nrow = 3) # Combine plots in a grid layout

#   OMTp0 <- plot_list$OMTp0
#   OMTp1 <- plot_list$OMTp1
#   OMTp2 <- plot_list$OMTp2
#   OMTp3 <- plot_list$OMTp3
#   OMTp4 <- plot_list$OMTp4
#   OMTp5 <- plot_list$OMTp5
#   OMTp6 <- plot_list$OMTp6



#   library(cowplot) # Load the cowplot package

#   # Combine the plots
#   # combined_plot <- plot_grid(plotlist = plot_list, align = "hv", ncol = 3)

#   # Display the combined plot

#   combined_plot <- (plot_list$OMTp0 / plot_list$OMTp1 / plot_list$OMTp2) +
#     plot_layout(guides = "collect")
# }
