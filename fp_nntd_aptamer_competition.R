library(readxl)
library(tidyverse)
#Read in the 3 data csvs
df1 <- read_excel("D:/FP/Nucleocapsid/Data up to april 8th/20240404_competition-NNTD12uM_A58-10-3'FAM20nM_vs_SL14100uM_V1.xlsx")
df2 <- read_excel("D:/FP/Nucleocapsid/Data up to april 8th/20240404_competition-NNTD12uM_A58-10-3'FAM20nM_vs_SL14100uM_V2.xlsx")
df3 <- read_excel("D:/FP/Nucleocapsid/Data up to april 8th/20240404_competition-NNTD12uM_A58-10-3'FAM20nM_vs_SL14100uM_V3.xlsx")

#specify the high cold ligand concentration in M and dilution factor
high_conc <- 0.0001
dilution_factor <- 0.5

#Input Kd and nM of the hot ligand
Kd <- 6352
nM <- 20

# pull out DNA only control
control_value1 <- as.numeric(df1[59, 2])
control_value2 <- as.numeric(df2[59, 2])
control_value3 <- as.numeric(df3[59, 2])

# Create a vector containing 8*3 copies of control_value1
values1 <- rep(control_value1, each = 8*3)
values2 <- rep(control_value2, each = 8*3)
values3 <- rep(control_value3, each = 8*3)
# Reshape the vector into a matrix of dimensions 8x3
control_1 <- matrix(values1, nrow = 8, ncol = 3)
control_2 <- matrix(values2, nrow = 8, ncol = 3)
control_3 <- matrix(values3, nrow = 8, ncol = 3)

# Convert the matrix to a data frame
control_1 <- as.data.frame(control_1)
control_2 <- as.data.frame(control_2)
control_3 <- as.data.frame(control_3)

#make subset of excel file into a data frame
df1 <- subset(df1[58:65, c("...7", "...8", "...9")])
df2 <- subset(df2[58:65, c("...7", "...8", "...9")])
df3 <- subset(df3[58:65, c("...7", "...8", "...9")])
#convert data frame entries to numerics
df1 <- as.data.frame(lapply(df1, as.numeric))
df2 <- as.data.frame(lapply(df2, as.numeric))
df3 <- as.data.frame(lapply(df3, as.numeric))
#subtract out positive control, rename column names.

df_mod1 <- df1 - control_1
df_mod2 <- df2 - control_2
df_mod3 <- df3 - control_3

df_mod1 <- df_mod1 %>%
  rename(
    mp1 = ...7,
    mp2 = ...8,
    mp3 = ...9
  )
df_mod2 <- df_mod2 %>%
  rename(
    mp4 = ...7,
    mp5 = ...8,
    mp6 = ...9
  )
df_mod3 <- df_mod3 %>%
  rename(
    mp7 = ...7,
    mp8 = ...8,
    mp9 = ...9
  )
#combine data frames
df_comb <- cbind(df_mod1, df_mod2, df_mod3)

#Add in a column for log of cold ligand concentration
conc <- high_conc * (dilution_factor)^(0:7)
data <- mutate(df_comb,
             log10conc = log10(conc))

#Make columns that are the means of the replicates
data_means <- data %>%
  mutate(
    mean123 = rowMeans(select(., c("mp1", "mp2", "mp3"))),
    mean456 = rowMeans(select(., c("mp4", "mp5", "mp6"))),
    mean789 = rowMeans(select(., c("mp7", "mp8", "mp9")))
  )

#Summarize the data into the mean between replicates and the standard deviation
data_summary <- data_means %>%
  group_by(log10conc) %>%
  summarise(
    mean_y = mean(c(mean123, mean456, mean789)),
    sd_y = sd(c(mean123, mean456, mean789))
  )

#define fit, plot the data

ggplot(data_summary, aes(x = log10conc, y = mean_y)) +
  geom_point() +
  geom_errorbar(aes(ymin = mean_y - sd_y, ymax = mean_y + sd_y), width = 0.2) +
  labs(title = "A58-10-3'FAM vs SL14",
       x = "log10[SL14]",
       y = "mP change") +
  theme_minimal()
