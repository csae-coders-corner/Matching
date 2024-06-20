###########################################
# Purpose:          Fuzzy Match Village Names

# Author:           Prabhmeet

# Date Created:     30/11/2023

# Date Modified:    15/12/2023
###########################################
# Clear the global workspace
rm(list=ls())

# Get the username
username <- Sys.getenv("USER")

# Get the user's operating system
os <- Sys.info()["sysname"]

# Set the working directory based on username (No Linux, add if someone has a Linux)
# MBK to add working directory here
if (os == "Windows") {
  # Set the working directory for Windows users
  working_dir <- paste("C:/Users/", username, "/OneDrive - Nexus365/Desktop/CSAE/Data", sep="")
}  else if (os == "Darwin") {
  # Set the working directory for macOS users
  working_dir <- paste("/Users/", username, "/Dropbox/Data", sep="")
} else {
  # Set a default working directory if the operating system is not recognized
  setwd("~/my_project")
}

# Set the working directory
setwd(working_dir)

# Print the working directory
print(getwd())

# Load and install packages 
installation_needed  <- TRUE
loading_needed <- TRUE
package_list <- c('foreign', 'xtable', 'plm','gmm', 'AER','stargazer','readstata13', 'dplyr', 'readxl', 'tidyr', 'sf', 'stringdist', 'openxlsx')
# Comment out if installation is needed. Don't want it to take so long so commented this
if(installation_needed){install.packages(package_list, repos='http://cran.us.r-project.org')}
if(loading_needed){lapply(package_list, require, character.only = TRUE)}


###########################################
# Load all data
###########################################
# GIS joined layer(Humanitarian Exchange)
layer_join <- paste(working_dir, "/data/geocoded_villages/geocoded_villages_humexchange.shp", sep = "")
layer_data <- st_read(layer_join)

# Data including all
to_match_data <- paste(working_dir, "/Processed/All_New_Data_for_Matches.dta", sep = "")
to_match_data <- read.dta13(to_match_data)

# Function to find the closest match and its distance
find_closest_match <- function(name, candidate_names) {
  # Calculating the string distances
  distances <- stringdist::stringdistmatrix(name, candidate_names, method = "jw")
  
  # Identifying the index of the name with the smallest distance
  min_index <- which.min(distances)
  
  # Closest match and its distance
  closest_match <- candidate_names[min_index]
  match_distance <- distances[min_index]
  
  return(list(match = closest_match, distance = match_distance))
}

# Add New Cols
to_match_data$Closest_uc <- character(nrow(to_match_data))
to_match_data$MatchDistance_uc <- numeric(nrow(to_match_data))


# Loop through each row
for (i in 1:nrow(to_match_data)) {
  # Current village and tehsil
  current_uc <- to_match_data$uc_name[i]
  current_tehsil <- to_match_data$tehsil_name[i]
  
  # Subset geo_sindh by the current tehsil
  subset_data <- layer_data[layer_data$tehsil == current_tehsil, ]
  
  # # Find the closest match and its distance
  match_info3 <- find_closest_match(current_uc, unique(subset_data$uc))
  to_match_data$Closest_uc[i] <- match_info3$match
  to_match_data$MatchDistance_uc[i] <- match_info3$distance
}


expl = to_match_data %>%
  dplyr::select(uc, Closest_uc)


#0.2 seems like a good threshold

good = expl %>%
  filter(MatchDistance <= 0.2) #712/1079 matched (66 percent)

#Lets now calculate the error rate here
#Lets get 50 random UC names & see if any crazy matches.

ran = sample_n(good[, 1:2], 50)
#looks exciting, error rate less than 1 percent for sure! as I found no crazy matches in two random samples.

