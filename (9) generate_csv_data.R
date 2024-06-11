# Runs all the csv generation scripts used to produce data for
# analysis and plotting in the R markdown notebooks

source("(5) clean_temperature_data.R")
source("(7) extract_SVI.R")
source("(8) match_referent_days.R")

write_cleaned_temp_data()
extract_svi_data()
match_referent_days()
