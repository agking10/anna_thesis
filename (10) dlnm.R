source("(2) load_libraries.R")
source("(3) paths.R")

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
dlnm <- function(data, matched_data_file) {
   matched_data_blocks <- read.csv(matched_data_file)
   
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
  cenvalue <- median(matched_data_blocks$MaxTemperature)
  range <- range(matched_data_blocks$MaxTemperature)
  pnest <- crosspred(cbnest, mnest, cen = cenvalue, at = 10:40, cumul = TRUE)

  pnest
}

# matched_data_file is a dataframe containing temperature data for each death date (cases) and controls.
# This function concatenates the death data with temperature data for all dates to create
# a dataframe on which we can invoke dlnm().
dlnm_season <- function(matched_data_file) {
  matched_data_blocks <- read.csv(matched_data_file)
  matched_data_blocks <- matched_data_blocks %>%
    mutate(binary = ifelse(case_control == "case", 1, 0))
  
  combined_temp_data <- read.csv(file.path(TEMPERATURE_DATA_DIR, "combined_temp_data.csv"))
  combined_temp_data$Date <- as.Date(combined_temp_data$Date)

  matched_data_blocks_edited <- matched_data_blocks %>%
    filter(block %in% c(1, 2, 3, 4, 5, 6, 7))

  matched_data_blocks_edited <- matched_data_blocks_edited %>%
    filter(opioid_contributing == "yes")

  matched_data_blocks_edited$Date <- as.Date(matched_data_blocks_edited$Date)

  final_dataframe <- bind_rows(matched_data_blocks_edited, combined_temp_data %>%
    select(-SatVapPres, -MinVPDeficit, -VaporPressure, -RelHum, -MaxTemperatureF))

  dlnm(final_dataframe, file.path(MISC_DATA_DIR, "warm_season_matched_data_blocks.csv"))
}

warm_season_dlnm <- dlnm_season(file.path(MISC_DATA_DIR, "warm_season_matched_data_blocks.csv"))






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
