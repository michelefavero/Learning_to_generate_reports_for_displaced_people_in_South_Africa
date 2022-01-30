install.packages("tidyverse") # Collection of R packages related to design philosophy, grammar, and data structures
install.packages("dplyr") # Data management
install.packages("ggplot2") # Data visualization
install.packages("rhdx") # Humanitarian data 
install.packages("remotes")
remotes::install_github("dickoa/rhdx")

library(tidyverse)
library(dplyr)
library(ggplot2)
library(rhdx)




# Connect to HDX
set_rhdx_config()
get_rhdx_config()

search_datasets("Africa Displaced")
H1 <- search_datasets("South Africa Displaced People") %>%
  pluck(1) %>% # pick the first dataset
  get_resource(1) %>%
  read_resource() 

search_datasets("South Africa Displaced People") %>%
  pluck(1) %>% # pick the first dataset
  get_resource(1) %>%
  read_resource() %>%
  ggplot(aes(Year, `Disaster New Displacements`)) +
  geom_line() +
  geom_point() +
  theme_minimal()



install.packages("flextable") # It provides a framework to create tables for reporting and publications
library(flextable)


search_datasets("Africa Funding")
H2 <- search_datasets("Africa Funding") %>%
  pluck(1) %>% # pick the first dataset
  get_resource(1) %>%
  read_resource() 

pull_dataset("fts-requirements-and-funding-data-for-south-africa") %>%
  get_resource(1) %>%
  read_resource() %>%
  select(budgetYear, srcOrganizationTypes, amountUSD) %>%
  filter(budgetYear %in% 2016:2021) %>%
  drop_na() %>%
  flextable()

pull_dataset("fts-requirements-and-funding-data-for-south-africa") %>%
  get_resource(1) %>%
  read_resource() %>%
  select(description, srcOrganizationTypes, amountUSD, decisionDate) %>%
  drop_na() %>%
  flextable()



# GIS Spatial data
install.packages("readr") # Uploading data
library(readxl)
Humanitarian_and_Social_Protection_Support <- read_excel("Desktop/Humanitarian and Social Protection Support.xlsx")
View(Humanitarian_and_Social_Protection_Support)

?map_data
map_data("world") 

World_data <- map_data("world") %>%
  as_tibble() %>%
  rename(Region = region, Longitude = long, Latitude = lat)

World_data_1 <- left_join(world_data, Humanitarian_and_Social_Protection_Support, by="Region")

World_data_2 <- World_data_1 %>%
  filter(!is.na(World_data_1$`Increasing humanitarian support (% for every year).x`))


Map_1 <- ggplot(World_data_2, aes( x = Longitude, y = Latitude, group = group)) +
  geom_polygon(aes(fill = `Increasing humanitarian support (% for every year).x`))

Map_1 +
  labs(
    title = "Inclusive Growth",
    fill = "% of Humanitarian Support"
  ) +
  theme(plot.title = element_text(size = 20, face = "bold", color = "black"),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank(),
        legend.position = "bottom"
  ) 

  
Map_2 <- ggplot(World_data_2, aes( x = Longitude, y = Latitude, group = group)) +
  geom_polygon(aes(fill = `Enhancing social protection programs (from 1 to 5).x`))

Map_2 +
  labs(
    title = "Inclusive Growth",
    x = "Longitude", 
    y = "Latitude",
    fill = "Enhancing social protection programs (from 1 to 5)"
  ) +
  theme_minimal()
  

