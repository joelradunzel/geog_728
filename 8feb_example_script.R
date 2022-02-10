library(tidyverse)

bea <- read.csv("KS_BEA.csv")

glimpse(bea)
head(bea)
tail(bea)

# ""Year", which should be a variable, is spread out across multiple columns

# Also, some somes have footnotes (marked as "...")

bea <- bea %>%
  slice(1:3604) # removes the last four rows (the ones with footnotes)

# Now lets get "Year" where it's supposed to be

bea_tidy <- bea %>%
  pivot_longer(cols = X2001:X2019,
               names_to = "Year",
               values_to = "Value",
               names_prefix = "X") # removes the X from before the year

glimpse(bea_tidy)

# "Description" has many variables in it that need to be parsed out


bea_tidier <- bea_tidy %>%
  pivot_wider(id_cols = c("GeoFIPS", "Year"),
              names_from = Description,
              values_from = Value)

glimpse(bea_tidier)

colSums(is.na(bea_tidier))

str(bea_tidier)

bea_clean <- bea_tidier %>%
  mutate_at(vars(Year:"Private services-providing industries 3/"),
                 ~as.numeric(.))

glimpse(bea_clean)

# remaming things

bea_clean <- bea_clean %>%
  rename(Mining = `  Mining, quarrying, and oil and gas extraction`, 
         Ag = `  Agriculture, forestry, fishing and hunting`)


bea_clean <- bea_clean %>%
  filter(GeoFIPS != " \"20000\"")

head(bea_clean)

