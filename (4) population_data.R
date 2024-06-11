source("(3) paths.R")
source("(2) load_libraries.R")
load_libraries()

# population data
# from https://www.osbm.nc.gov/facts-figures/population-demographics/state-demographer/county-population-estimates/county-population-estimates

population_data <- read.csv(file.path(DEATH_DATA_DIR, "NCprojectionsbyage2022.csv"))

county_pop <- population_data %>%
  group_by(year, county, fips) %>%
  summarize(total_population = sum(total))
