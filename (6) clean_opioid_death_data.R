source("(2) load_libraries.R")
source("(3) paths.R")
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
COUNTY_MAPPING_2014 <- c(
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

# county mapping for 1999-2013 data
COUNTY_MAPPING_1999 <- c(
  "1" = "Alamance", "2" = "Alexander", "3" = "Alleghany", "4" = "Anson",
  "5" = "Ashe", "6" = "Avery", "7" = "Beaufort", "8" = "Bertie",
  "9" = "Bladen", "10" = "Brunswick", "11" = "Buncombe", "12" = "Burke",
  "13" = "Cabarrus", "14" = "Caldwell", "15" = "Camden", "16" = "Carteret",
  "17" = "Caswell", "18" = "Catawba", "19" = "Chatham", "20" = "Cherokee",
  "21" = "Chowan", "22" = "Clay", "23" = "Cleveland", "24" = "Columbus",
  "25" = "Craven", "26" = "Cumberland", "27" = "Currituck", "28" = "Dare",
  "29" = "Davidson", "30" = "Davie", "31" = "Duplin", "32" = "Durham",
  "33" = "Edgecombe", "34" = "Forsyth", "35" = "Franklin", "36" = "Gaston",
  "37" = "Gates", "38" = "Graham", "39" = "Granville", "40" = "Greene",
  "41" = "Guilford", "42" = "Halifax", "43" = "Harnett", "44" = "Haywood",
  "45" = "Henderson", "46" = "Hertford", "47" = "Hoke", "48" = "Hyde",
  "49" = "Iredell", "50" = "Jackson", "51" = "Johnston", "52" = "Jones",
  "53" = "Lee", "54" = "Lenoir", "55" = "Lincoln", "56" = "Macon",
  "57" = "Madison", "58" = "Martin", "59" = "McDowell", "60" = "Mecklenburg",
  "61" = "Mitchell", "62" = "Montgomery", "63" = "Moore", "64" = "Nash",
  "65" = "New Hanover", "66" = "Northampton", "67" = "Onslow", "68" = "Orange",
  "69" = "Pamlico", "70" = "Pasquotank", "71" = "Pender", "72" = "Perquimans",
  "73" = "Person", "74" = "Pitt", "75" = "Polk", "76" = "Randolph",
  "77" = "Richmond", "78" = "Robeson", "79" = "Rockingham", "80" = "Rowan",
  "81" = "Rutherford", "82" = "Sampson", "83" = "Scotland", "84" = "Stanly",
  "85" = "Stokes", "86" = "Surry", "87" = "Swain", "88" = "Transylvania",
  "89" = "Tyrrell", "90" = "Union", "91" = "Vance", "92" = "Wake",
  "93" = "Warren", "94" = "Washington", "95" = "Watauga", "96" = "Wayne",
  "97" = "Wilkes", "98" = "Wilson", "99" = "Yadkin", "100" = "Yancey"
)

# mapping between county numbers and FIPS codes
COUNTY_FIPS_MAPPING_1999 <- c(
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


COUNTY_FIPS_MAPPING_2014 <- c(
  "1" = "37001", "3" = "37003", "5" = "37005", "7" = "37007", "9" = "37009",
  "11" = "37011", "13" = "37013", "15" = "37015", "17" = "37017", "19" = "37019",
  "21" = "37021", "23" = "37023", "25" = "37025", "27" = "37027", "29" = "37029",
  "31" = "37031", "33" = "37033", "35" = "37035", "37" = "37037", "39" = "37039",
  "41" = "37041", "43" = "37043", "45" = "37045", "47" = "37047", "49" = "37049",
  "51" = "37051", "53" = "37053", "55" = "37055", "57" = "37057", "59" = "37059",
  "61" = "37061", "63" = "37063", "65" = "37065", "67" = "37067", "69" = "37069",
  "71" = "37071", "73" = "37073", "75" = "37075", "77" = "37077", "79" = "37079",
  "81" = "37081", "83" = "37083", "85" = "37085", "87" = "37087", "89" = "37089",
  "91" = "37091", "93" = "37093", "95" = "37095", "97" = "37097", "99" = "37099",
  "101" = "37101", "103" = "37103", "105" = "37105", "107" = "37107", "109" = "37109",
  "111" = "37111", "113" = "37113", "115" = "37115", "117" = "37117", "119" = "37119",
  "121" = "37121", "123" = "37123", "125" = "37125", "127" = "37127", "129" = "37129",
  "131" = "37131", "133" = "37133", "135" = "37135", "137" = "37137", "139" = "37139",
  "141" = "37141", "143" = "37143", "145" = "37145", "147" = "37147", "149" = "37149",
  "151" = "37151", "153" = "37153", "155" = "37155", "157" = "37157", "159" = "37159",
  "161" = "37161", "163" = "37163", "165" = "37165", "167" = "37167", "169" = "37169",
  "171" = "37171", "173" = "37173", "175" = "37175", "177" = "37177", "179" = "37179",
  "181" = "37181", "183" = "37183", "185" = "37185", "187" = "37187", "189" = "37189",
  "191" = "37191", "193" = "37193", "195" = "37195", "197" = "37197", "199" = "37199"
)


############# END CONSTANTS ############

# normalizes and aggregates opiate death data for NC from 1999-2022

write_opioid_death_tables <- function() {
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


  death_data_2014_2022$county <- COUNTY_MAPPING_2014[as.character(death_data_2014_2022$COD)]
  death_data_2014_2022$GEOID <- COUNTY_FIPS_MAPPING_2014[as.character(death_data_2014_2022$COD)]
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

  file_path <- file.path(OPIOID_DEATH_DIR, "nc_opioid_deaths_2014_2022.csv")
  # Save the data frame as a .csv file
  write.csv(death_data_2014_2022, file = file_path, row.names = FALSE)


  death_data_1999_2013$GEOID <- COUNTY_FIPS_MAPPING_1999[as.character(death_data_1999_2013$COOCC)]
  death_data_1999_2013$county <- COUNTY_MAPPING_1999[as.character(death_data_1999_2013$COOCC)]
  death_data_1999_2013$DTHDATE <- sapply(death_data_1999_2013$DTHDATE, add_leading_zero)
  death_data_1999_2013 <- subset(death_data_1999_2013, select = -c(AGECODE, COOCC))
  death_data_1999_2013$DTHDATE <- as.Date(death_data_1999_2013$DTHDATE, format = "%m%d%Y")


  file_path <- file.path(OPIOID_DEATH_DIR, "nc_opioid_deaths_1999_2013.csv")
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
    mutate(Date = as.Date(deathdate)) %>%
    filter(!deathdate %in% FEDERAL_HOLIDAYS) %>%
    select(-deathdate)
  
  combined_temp_data = read.csv(file.path(TEMPERATURE_DATA_DIR, "combined_temp_data.csv"))
  
  selected_temp_data <- combined_temp_data[c("Date", "county", "MinTemperature", "MeanTemperature", "MaxTemperature", "HeatIndex")]
  
  # Merging selected columns with all_deaths
  all_deaths <- merge(all_deaths, selected_temp_data, by = c("Date", "county"), all.x = TRUE)
  
  all_deaths <- all_deaths %>%
    mutate(
      race = case_when(
        grepl("White", race) & !grepl("Other", race) ~ "White Non-Hispanic",
        grepl("Black", race) & ethnicity == "N" ~ "Black Non-Hispanic",
        grepl("Asian|Japanese|Chinese|Filipino", race) & ethnicity == "N" ~ "Asian Non-Hispanic",
        grepl("American Indian|Native Hawaiian", race) & ethnicity == "N" ~ "Native American Non-Hispanic",
        ethnicity != "N" ~ "Any Race - Hispanic",
        TRUE ~ "Other"
      )
    )
  
  # setting as warm and cool season
  season_vector <- character(nrow(all_deaths))
  
  # Assign seasons based on the criteria
  season_vector[months(all_deaths$Date) %in% c("May", "June", "July", "August", "September", "October")] <- "warm"
  season_vector[months(all_deaths$Date) %in% c("December", "January", "February", "March")] <- "cool"
  season_vector[months(all_deaths$Date) %in% c("April", "November")] <- "shoulder"
  
  # Add the season column to the dataframe
  all_deaths$season <- season_vector
  
  warm_season_start <- as.Date("05-01", format = "%m-%d")
  warm_season_end <- as.Date("10-14", format = "%m-%d")
  
  # Mutate block column
  all_deaths <- all_deaths %>%
    mutate(
      block = cut(
        Date, 
        breaks = seq(warm_season_start, warm_season_end, by = "21 days"), 
        labels = FALSE,
        right = FALSE
      )
    )
  
  all_deaths <- all_deaths %>%
    mutate(
      month_day = format(Date, "%m-%d"),
      block = case_when(
        month_day %in% c("12-01", "12-02", "12-03", "12-04", "12-05", "12-06", "12-07", "12-08", "12-09", "12-10", "12-11", "12-12", "12-13", "12-14", "12-15", "12-16", "12-17", "12-18", "12-19", "12-20", "12-21") ~ 1,
        month_day %in% c("12-22", "12-23", "12-24", "12-25", "12-26", "12-27", "12-28", "12-29", "12-30", "12-31", "01-01", "01-02", "01-03", "01-04", "01-05", "01-06", "01-07", "01-08", "01-09", "01-10", "01-11") ~ 2,
        month_day %in% c("01-12", "01-13", "01-14", "01-15", "01-16", "01-17", "01-18", "01-19", "01-20", "01-21", "01-22", "01-23", "01-24", "01-25", "01-26", "01-27", "01-28", "01-29", "01-30", "01-31", "02-01") ~ 3,
        month_day %in% c("02-02", "02-03", "02-04", "02-05", "02-06", "02-07", "02-08", "02-09", "02-10", "02-11", "02-12", "02-13", "02-14", "02-15", "02-16", "02-17", "02-18", "02-19", "02-20", "02-21") ~ 4,
        month_day %in% c("02-22", "02-23", "02-24", "02-25", "02-26", "02-27", "02-28", "02-29", "03-01", "03-02", "03-03", "03-04", "03-05", "03-06", "03-07", "03-08", "03-09", "03-10", "03-11", "03-12", "03-13", "03-14") ~ 5,
        TRUE ~ 6 # Default case, assign a block for any remaining dates
        # Add more cases if needed
      )
    )

  write.csv(all_deaths, file.path(OPIOID_DEATH_DIR, "all_death_data_2022.csv"), row.names = FALSE)
  
  warm_deaths <- all_deaths %>%  
    filter(season == "warm")
  
  cool_deaths <- all_deaths %>%  
    filter(season == "cool")
  
  write.csv(warm_deaths, file.path(DEATH_DATA_DIR, "warm_season_deaths.csv"), row.names = FALSE)
  write.csv(cool_deaths, file.path(DEATH_DATA_DIR, "cool_season_deaths.csv"), row.names = FALSE)
  
  
}
