source("load_libraries.R")
source("paths.R")
load_libraries()

############# DEFINE CONSTANTS ############

# overdose codes
NUMBER_SEQUENCES <- c("X40", "X41", "X42", "X43", "X44", "X60", "X61", "X62", "X63", "X64", "X85", "Y10", "Y11", "Y12", "Y13", "Y14")
SECONDARY_SEQUENCES <- c("T400", "T401", "T402", "T403", "T404", "T406")

# federal holidays
FEDERAL_HOLIDAYS <- as.Date(c(
  # 1999
  "1999-01-01", "1999-01-18", "1999-02-15", "1999-05-31", "1999-07-04",
  "1999-09-06", "1999-10-11", "1999-11-11", "1999-11-25", "1999-12-25",
  # 2000
  "2000-01-01", "2000-01-17", "2000-02-21", "2000-05-29", "2000-07-04",
  "2000-09-04", "2000-10-09", "2000-11-11", "2000-11-23", "2000-12-25",
  # 2001
  "2001-01-01", "2001-01-15", "2001-02-19", "2001-05-28", "2001-07-04",
  "2001-09-03", "2001-10-08", "2001-11-11", "2001-11-22", "2001-12-25",
  # 2002
  "2002-01-01", "2002-01-21", "2002-02-18", "2002-05-27", "2002-07-04",
  "2002-09-02", "2002-10-14", "2002-11-11", "2002-11-28", "2002-12-25",
  # 2003
  "2003-01-01", "2003-01-20", "2003-02-17", "2003-05-26", "2003-07-04",
  "2003-09-01", "2003-10-13", "2003-11-11", "2003-11-27", "2003-12-25",
  # 2004
  "2004-01-01", "2004-01-19", "2004-02-16", "2004-05-31", "2004-07-04",
  "2004-09-06", "2004-10-11", "2004-11-11", "2004-11-25", "2004-12-25",
  # 2005
  "2005-01-01", "2005-01-17", "2005-02-21", "2005-05-30", "2005-07-04",
  "2005-09-05", "2005-10-10", "2005-11-11", "2005-11-24", "2005-12-25",
  # 2006
  "2006-01-01", "2006-01-16", "2006-02-20", "2006-05-29", "2006-07-04",
  "2006-09-04", "2006-10-09", "2006-11-11", "2006-11-23", "2006-12-25",
  # 2007
  "2007-01-01", "2007-01-15", "2007-02-19", "2007-05-28", "2007-07-04",
  "2007-09-03", "2007-10-08", "2007-11-11", "2007-11-22", "2007-12-25",
  # 2008
  "2008-01-01", "2008-01-21", "2008-02-18", "2008-05-26", "2008-07-04",
  "2008-09-01", "2008-10-13", "2008-11-11", "2008-11-27", "2008-12-25",
  # 2009
  "2009-01-01", "2009-01-19", "2009-02-16", "2009-05-25", "2009-07-04",
  "2009-09-07", "2009-10-12", "2009-11-11", "2009-11-26", "2009-12-25",
  # 2010
  "2010-01-01", "2010-01-18", "2010-02-15", "2010-05-31", "2010-07-04",
  "2010-09-06", "2010-10-11", "2010-11-11", "2010-11-25", "2010-12-25",
  # 2011
  "2011-01-01", "2011-01-17", "2011-02-21", "2011-05-30", "2011-07-04",
  "2011-09-05", "2011-10-10", "2011-11-11", "2011-11-24", "2011-12-25",
  # 2012
  "2012-01-01", "2012-01-16", "2012-02-20", "2012-05-28", "2012-07-04",
  "2012-09-03", "2012-10-08", "2012-11-11", "2012-11-22", "2012-12-25",
  # 2013
  "2013-01-01", "2013-01-21", "2013-02-18", "2013-05-27", "2013-07-04",
  "2013-09-02", "2013-10-14", "2013-11-11", "2013-11-28", "2013-12-25",
  # 2014
  "2014-01-01", "2014-01-20", "2014-02-17", "2014-05-26", "2014-07-04",
  "2014-09-01", "2014-10-13", "2014-11-11", "2014-11-27", "2014-12-25",
  # 2015
  "2015-01-01", "2015-01-19", "2015-02-16", "2015-05-25", "2015-07-04",
  "2015-09-07", "2015-10-12", "2015-11-11", "2015-11-26", "2015-12-25",
  # 2016
  "2016-01-01", "2016-01-18", "2016-02-15", "2016-05-30", "2016-07-04",
  "2016-09-05", "2016-10-10", "2016-11-11", "2016-11-24", "2016-12-25",
  # 2017
  "2017-01-01", "2017-01-16", "2017-02-20", "2017-05-29", "2017-07-04",
  "2017-09-04", "2017-10-09", "2017-11-11", "2017-11-23", "2017-12-25",
  # 2018
  "2018-01-01", "2018-01-15", "2018-02-19", "2018-05-28", "2018-07-04",
  "2018-09-03", "2018-10-08", "2018-11-11", "2018-11-22", "2018-12-25",
  # 2019
  "2019-01-01", "2019-01-21", "2019-02-18", "2019-05-27", "2019-07-04",
  "2019-09-02", "2019-10-14", "2019-11-11", "2019-11-28", "2019-12-25",
  # 2020
  "2020-01-01", "2020-01-20", "2020-02-17", "2020-05-25", "2020-07-04",
  "2020-09-07", "2020-10-12", "2020-11-11", "2020-11-26", "2020-12-25",
  # 2021
  "2021-01-01", "2021-01-18", "2021-02-15", "2021-05-31", "2021-07-04",
  "2021-09-06", "2021-10-11", "2021-11-11", "2021-11-25", "2021-12-25"
))

# mapping from county id to human readable name
COUNTY_MAPPING <- c(
  "1" = "Alamance", "3" = "Alexander", "5" = "Alleghany", "7" = "Anson",
  "9" = "Ashe", "11" = "Avery", "13" = "Beaufort", "15" = "Bertie",
  "17" = "Bladen", "19" = "Brunswick", "21" = "Buncombe", "23" = "Burke",
  "25" = "Cabarrus", "27" = "Caldwell", "29" = "Camden", "31" = "Carteret",
  "33" = "Caswell", "35" = "Catawba", "37" = "Chatham", "39" = "Cherokee",
  "41" = "Chowan", "43" = "Clay", "45" = "Cleveland", "47" = "Columbus",
  "49" = "Craven", "51" = "Cumberland", "53" = "Currituck", "55" = "Dare",
  "57" = "Davidson", "59" = "Davie", "61" = "Duplin", "63" = "Durham",
  "65" = "Edgecombe", "67" = "Forsyth", "69" = "Franklin", "71" = "Gaston",
  "73" = "Gates", "75" = "Graham", "77" = "Granville", "79" = "Greene",
  "81" = "Guilford", "83" = "Halifax", "85" = "Harnett", "87" = "Haywood",
  "89" = "Henderson", "91" = "Hertford", "93" = "Hoke", "95" = "Hyde",
  "97" = "Iredell", "99" = "Jackson", "101" = "Johnston", "103" = "Jones",
  "105" = "Lee", "107" = "Lenoir", "109" = "Lincoln", "111" = "Macon",
  "113" = "Madison", "115" = "Martin", "117" = "McDowell", "119" = "Mecklenburg",
  "121" = "Mitchell", "123" = "Montgomery", "125" = "Moore", "127" = "Nash",
  "129" = "New Hanover", "131" = "Northampton", "133" = "Onslow", "135" = "Orange",
  "137" = "Pamlico", "139" = "Pasquotank", "141" = "Pender", "143" = "Perquimans",
  "145" = "Person", "147" = "Pitt", "149" = "Polk", "151" = "Randolph",
  "153" = "Richmond", "155" = "Robeson", "157" = "Rockingham", "159" = "Rowan",
  "161" = "Rutherford", "163" = "Sampson", "165" = "Scotland", "167" = "Stanly",
  "169" = "Stokes", "171" = "Surry", "173" = "Swain", "175" = "Transylvania",
  "177" = "Tyrrell", "179" = "Union", "181" = "Vance", "183" = "Wake",
  "185" = "Warren", "187" = "Washington", "189" = "Watauga", "191" = "Wayne",
  "193" = "Wilkes", "195" = "Wilson", "197" = "Yadkin", "199" = "Yancey"
)


# mapping between county numbers and FIPS codes
COUNTY_FIPS_MAPPING <- c(
  "1" = "37001", "2" = "37003", "3" = "37005", "4" = "37007",
  "5" = "37009", "6" = "37011", "7" = "37013", "8" = "37015",
  "9" = "37017", "10" = "37019", "11" = "37021", "12" = "37023",
  "13" = "37025", "14" = "37027", "15" = "37029", "16" = "37031",
  "17" = "37033", "18" = "37035", "19" = "37037", "20" = "37039",
  "21" = "37041", "22" = "37043", "23" = "37045", "24" = "37047",
  "25" = "37049", "26" = "37051", "27" = "37053", "28" = "37055",
  "29" = "37057", "30" = "37059", "31" = "37061", "32" = "37063",
  "33" = "37065", "34" = "37067", "35" = "37069", "36" = "37071",
  "37" = "37073", "38" = "37075", "39" = "37077", "40" = "37079",
  "41" = "37081", "42" = "37083", "43" = "37085", "44" = "37087",
  "45" = "37089", "46" = "37091", "47" = "37093", "48" = "37095",
  "49" = "37097", "50" = "37099", "51" = "37101", "52" = "37103",
  "53" = "37105", "54" = "37107", "55" = "37109", "56" = "37111",
  "57" = "37113", "58" = "37115", "59" = "37117", "60" = "37119",
  "61" = "37121", "62" = "37123", "63" = "37125", "64" = "37127",
  "65" = "37129", "66" = "37131", "67" = "37133", "68" = "37135",
  "69" = "37137", "70" = "37139", "71" = "37141", "72" = "37143",
  "73" = "37145", "74" = "37147", "75" = "37149", "76" = "37151",
  "77" = "37153", "78" = "37155", "79" = "37157", "80" = "37159",
  "81" = "37161", "82" = "37163", "83" = "37165", "84" = "37167",
  "85" = "37169", "86" = "37171", "87" = "37173", "88" = "37175",
  "89" = "37177", "90" = "37179", "91" = "37181", "92" = "37183",
  "93" = "37185", "94" = "37187", "95" = "37189", "96" = "37191",
  "97" = "37193", "98" = "37195", "99" = "37197", "100" = "37199"
)


############# END CONSTANTS ############

# normalizes and aggregates opiate death data for NC from 1999-2022

write_opiod_death_tables <- function() {
  # LOAD DATA

  # reading in data from file
  # for top three COD
  death_data_1999_2013 <- read.csv(file.path(DEATH_DATA_DIR, "1999_2013_mortality.csv"))
  death_data_2014_2021 <- read.csv(file.path(DEATH_DATA_DIR, "2014_2021_mortality.csv"))
  death_data_2022 <- read.csv(file.path(DEATH_DATA_DIR, "2022_mortality.csv"))

  # append 2022 data
  death_data_2014_2022 <- rbind(death_data_2014_2021, death_data_2022)

  ### helpful notes for understanding the data
  # COD = county
  # race: 1 = white, 2 = black, 3 = native american, 4 = indian, 5 = chinese, 6 = filipino, 7 = japanese, 8 = korean, 9 = vietnamese, 10 = other asian, 11 = hawaiin, 12 = guamanian or chamorro, 13 = samoan, 14 = other pacific islander, 15 = other



  # selecting deaths with overdose as a first, second, or third cause of death
  death_data_2014_2022 <- death_data_2014_2022 %>%
    filter((ACMECOD %in% NUMBER_SEQUENCES | COD1 %in% NUMBER_SEQUENCES)) %>%
    mutate(
      opioid_contributing = if_else(grepl(paste(SECONDARY_SEQUENCES, collapse = "|"), COD2) |
        grepl(paste(SECONDARY_SEQUENCES, collapse = "|"), COD3), "yes", "no"),
      cocaine_contributing = if_else(grepl("T405", COD2) | grepl("T405", COD3), "yes", "no"),
      other_stimi_contributing = if_else(grepl("T436", COD2) | grepl("T436", COD3), "yes", "no")
    )

  death_data_1999_2013 <- death_data_1999_2013 %>%
    filter((ACMECOD %in% NUMBER_SEQUENCES | COD1 %in% NUMBER_SEQUENCES)) %>%
    mutate(
      opioid_contributing = if_else(grepl(paste(SECONDARY_SEQUENCES, collapse = "|"), COD2) |
        grepl(paste(SECONDARY_SEQUENCES, collapse = "|"), COD3), "yes", "no"),
      cocaine_contributing = if_else(grepl("T405", COD2) | grepl("T405", COD3), "yes", "no"),
      other_stimi_contributing = if_else(grepl("T436", COD2) | grepl("T436", COD3), "yes", "no")
    )

  # add necessary id columns

  add_leading_zero <- function(date_str) {
    if (nchar(date_str) == 7) {
      date_str <- paste0("0", date_str)
    }
    return(date_str)
  }


  death_data_2014_2022$county <- COUNTY_MAPPING[as.character(death_data_2014_2022$COD)]
  death_data_2014_2022$GEOID <- COUNTY_FIPS_MAPPING[as.character(death_data_2014_2022$COD)]
  death_data_2014_2022 <- subset(death_data_2014_2022, select = -c(AGETYPE, COD))
  death_data_2014_2022$DTHDATE <- sapply(death_data_2014_2022$DTHDATE, add_leading_zero)
  # death_data_2014_2022$DTHDATE <- as.character(death_data_2014_2022$DTHDATE)
  death_data_2014_2022$DTHDATE <- as.Date(death_data_2014_2022$DTHDATE, format = "%m%d%Y")

  labels <- c(
    "White Single Race, Non-Hispanic",
    "Black or African American Single Race, Non-Hispanic",
    "American Indian or Alaska Native Single Race, Non-Hispanic",
    "Asian Single Race, Non-Hispanic",
    "Native Hawaiian Single Race, Non-Hispanic",
    "Multiple Race, Non-Hispanic",
    "Other Race, Single Race, Non-Hispanic",
    "Hispanic",
    "Unknown"
  )

  death_data_2014_2022$RACEETHCOMB <- factor(death_data_2014_2022$RACEETHCOMB, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9), labels = labels)

  death_data_1999_2013$RACE <- factor(death_data_1999_2013$RACE, levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9), labels = c(
    "Other non-White", "White", "Black", "American Indian", "Chinese", "Japanese", "Hawaiian", "Filipino", "Other Asian", "Unknown"
  ))

  file_path <- file.path(OPIOD_DEATH_DIR, "nc_opiod_deaths_2014_2022.csv")
  # Save the data frame as a .csv file
  write.csv(death_data_2014_2022, file = file_path, row.names = FALSE)


  death_data_1999_2013$GEOID <- COUNTY_FIPS_MAPPING[as.character(death_data_1999_2013$COOCC)]
  death_data_1999_2013$county <- COUNTY_MAPPING[as.character(death_data_1999_2013$COOCC)]
  death_data_1999_2013$DTHDATE <- sapply(death_data_1999_2013$DTHDATE, add_leading_zero)
  death_data_1999_2013 <- subset(death_data_1999_2013, select = -c(AGECODE, COOCC))
  death_data_1999_2013$DTHDATE <- as.Date(death_data_1999_2013$DTHDATE, format = "%m%d%Y")


  file_path <- file.path(OPIOD_DEATH_DIR, "nc_opiod_deaths_1999_2013.csv")
  write.csv(death_data_1999_2013, file = file_path, row.names = FALSE)

  death_data_2014_2022 <- death_data_2014_2022 %>%
    mutate(Ethnicity = ifelse(RACEETHCOMB == "Hispanic", "Y", "N"))

  # death_data_2014_2022 <- death_data_2014_2022 %>%
  #   mutate(sex = factor(SEX, levels = c(1, 2), labels = c("M", "F")))

  death_data_1999_2013 <- death_data_1999_2013 %>%
    mutate(SEX = factor(SEX, levels = c(1, 2), labels = c("M", "F")))

  death_data_2014_2022 <- death_data_2014_2022 %>%
    select(county, GEOID, AGE, RACEETHCOMB, DTHDATE, SEX, Ethnicity, opioid_contributing, cocaine_contributing, other_stimi_contributing) %>%
    rename(
      county = county,
      GEOID = GEOID,
      age = AGE,
      race = RACEETHCOMB,
      deathdate = DTHDATE,
      sex = SEX,
      ethnicity = Ethnicity,
      opioid_contributing = opioid_contributing,
      cocaine_contributing = cocaine_contributing,
      other_stimi_contributing = other_stimi_contributing
    )

  death_data_1999_2013 <- death_data_1999_2013 %>%
    select(county, GEOID, AGEUNITS, RACE, DTHDATE, SEX, HISP, opioid_contributing, cocaine_contributing, other_stimi_contributing) %>%
    rename(
      county = county,
      GEOID = GEOID,
      age = AGEUNITS,
      race = RACE,
      deathdate = DTHDATE,
      sex = SEX,
      ethnicity = HISP,
      opioid_contributing = opioid_contributing,
      cocaine_contributing = cocaine_contributing,
      other_stimi_contributing = other_stimi_contributing
    )

  all_deaths <- bind_rows(death_data_2014_2022, death_data_1999_2013)

  all_deaths <- all_deaths %>%
    mutate(uniqueID = str_pad(row_number(), width = 6, pad = "0"))

  all_deaths <- all_deaths %>%
    mutate(year = year(as.Date(deathdate)))

  # removing deaths that fall on federal FEDERAL_HOLIDAYS
  all_deaths <- all_deaths %>%
    mutate(deathdate = as.Date(deathdate)) %>%
    filter(!deathdate %in% FEDERAL_HOLIDAYS)

  write.csv(all_deaths, file.path(OPIOD_DEATH_DIR, "all_death_data_2022.csv"), row.names = FALSE)
}
