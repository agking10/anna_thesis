# Runs all the csv generation scripts used to produce data for
# analysis and plotting in the R markdown notebooks

source("clean_temperature_data.R")
source("extract_SVI.R")
source("match_referent_days.R")

write_cleaned_temp_data()
extract_svi_data()
match_referent_days()
