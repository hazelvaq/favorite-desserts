library(tidyverse)
library(rvest)  # use to scrape website content
library(here)
library(janitor)

# Check if that data folder exists and creates it if not
dir.create("data", showWarnings = FALSE)

# Read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>% 
  html_text2() %>%             # extracting the text associated with this type of elements of the webpage
  as_tibble() %>%              # make it a data frame
  rename(dessert = value) %>%  # better name for the column
  head(.,-3) %>%               # 3 last ones were not desserts 
  rowid_to_column("rank") %>%  # adding a column using the row number as proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv
## Read csv

iconic_desserts <- read_csv(here("data","iconic_desserts.csv"))

favorite_desserts <- read_csv("favorite_desserts.csv") %>% clean_names()
favorite_desserts <- favorite_desserts %>% rename(dessert = favorite_dessert)

inner_join(iconic_desserts,favorite_desserts, by = 'dessert')


