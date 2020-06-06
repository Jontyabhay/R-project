setwd("/Users/apynn/Maynooth University/ST661 Mini Project - Documents/Raw Data Files")

#Read in raw csv, replacing most appropriate NA values
marathon <- read.csv("dublin2018marathon.csv", header = TRUE, as.is = TRUE, na.strings=c(""," ","NA"))

#Remove unwanted/unused columns
marathon <- subset(marathon, select = -c(X, YouTube, Your.Race.Video, Share))

#Rename certain columns for consistent naming scheme
colnames(marathon)[6] <- "Age.Bracket"
colnames(marathon)[9] <- "Ten.K.Time"
colnames(marathon)[10] <- "Ten.K.Position"
colnames(marathon)[11] <- "Halfway.Time"
colnames(marathon)[12] <- "Halfway.Position"
colnames(marathon)[13] <- "Thirty.K.Time"
colnames(marathon)[14] <- "Thirty.K.Position"

#Factorize appropriate columns
marathon$Gender <- as.factor(marathon$Gender)
marathon$Club <- as.factor(marathon$Club)

#Age group must be made an ordered factor for easy sorting
marathon$Age.Bracket <- ordered(marathon$Age.Bracket, levels = c("FU19", "MU19", "FS", "MS", "F35", "M35", "F40", "M40", "F45", "M45", "F50", "M50", "F55", "M55", "F60", "M60", "F65", "M65", "F70", "M70", "F75", "M75", "M80", "M85"))
levels(marathon$Age.Bracket) <- c("U19", "U19", "19-34", "19-34", "35-39", "35-39", "40-44", "40-44", "45-49", "45-49", "50-54", "50-54", "55-59", "55-59", "60-64", "60-64", "65-69", "65-69", "70-74", "70-74", "75-79", "75-79", "80-84", "85+")

#Create new columsn for if the racer was in a club, if they didn't finish, or if they were disqualified
marathon <- mutate(marathon, In.Club = !is.na(Club))
marathon$Did.Not.Finish <- marathon$Chip.Time == "DNF"
marathon$Disqualified <- marathon$Chip.Time == "DQ"

#Change all DNF and DQ values to null string so they can be handled in the below statements
marathon[marathon == "DNF" | marathon == "DQ"] <- ""

#Clean up all racer position columns
marathon <- mutate_at(marathon, vars(contains("Position")), na_if, "0") %>%
  mutate_at(vars(contains("Position")), na_if, "") %>%
  mutate_at(vars(contains("Position")), as.integer)

#Clean up all racer time columns
marathon <- mutate_at(marathon, vars(contains("Time")), na_if, "0") %>%
  mutate_at(vars(contains("Time")), na_if, "") %>%
  mutate_at(vars(contains("Time")), times)

save(marathon, file = "/Users/apynn/Desktop/marathon.Rda")

