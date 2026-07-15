library(rio)
library(stargazer)
library(dplyr)
setwd("C:/Users/cdvo/OneDrive - University of South Florida/Classes/Spring 25/ISM 6137 Adv Stat/Pew")
#setwd("C:/Users/cdvo/OneDrive - University of South Florida/Classes/Spring 25/ISM 6137 Adv Stat")

#install.packages("vtable")
library(vtable)
#vtable(master)  # view data description

df2023= import("W130_July23/ATP W130.sav")
df2022= import("W104_Mar22/ATP W104.sav")
df2021= import("W91_Jun21/ATP W91.sav")
df2020= import("W71_Jul20/ATP W71.sav")
               

# remove '998' values from 2021 and 2022 (people that refused to answer)
df2021 = df2021[df2021$THERMO_a_W91 <= 100, ]
df2021 = df2021[df2021$THERMO_b_W91 <= 100, ]
df2022 = df2022[df2022$THERMREP_W104 <= 100, ]
df2022 = df2022[df2022$THERMDEM_W104 <= 100, ]
table(df2021$THERMO_a_W91); table(df2021$THERMO_b_W91)
table(df2022$THERMREP_W104); table(df2022$THERMDEM_W104)

cols21 <- c("THERMO_a_W91", "THERMO_b_W91")
cols22 <- c("THERMREP_W104", "THERMDEM_W104")

# rescale DVs of 2021 and 2022 to match the 1-4 scale of the other years.
# 2021 and 2022 range from 0-100 (after removing '998' above). Assign 1-4 based on quartiles.
for (col in cols21) {
  df2021[[col]] <- ifelse(df2021[[col]] >= 0 & df2021[[col]] <= 25, 4,
                          ifelse(df2021[[col]] >= 26 & df2021[[col]] <= 50, 3,
                                 ifelse(df2021[[col]] >= 51 & df2021[[col]] <= 75, 2, 1)))}

for (col in cols22) {
  df2022[[col]] <- ifelse(df2022[[col]] >= 0 & df2022[[col]] <= 25, 4,
                          ifelse(df2022[[col]] >= 26 & df2022[[col]] <= 50, 3,
                                 ifelse(df2022[[col]] >= 51 & df2022[[col]] <= 75, 2, 1)))}


# subset dfs to only include relevant variables
df2023 <- df2023[, c("INSTFAV_a_W130", "INSTFAV_b_W130", "F_AGECAT", "F_GENDER", "F_EDUCCAT", "F_RACECMB", 
                 "F_PARTYSUM_FINAL", "F_INC_SDT1", "F_INTFREQ")]
df2022 = df2022[,c("THERMREP_W104", "THERMDEM_W104", "F_AGECAT", "F_GENDER", "F_EDUCCAT", "F_RACECMB", 
                   "F_PARTYSUM_FINAL", "F_INC_SDT1", "F_INTFREQ")]
df2021 = df2021[,c("THERMO_a_W91", "THERMO_b_W91", "F_AGECAT", "F_GENDER", "F_EDUCCAT", "F_RACECMB", 
                   "F_PARTYSUM_FINAL", "F_INC_SDT1", "F_INTFREQ")]
df2020 = df2020[,c("INSTFAV_a_W71", "INSTFAV_b_W71", "F_AGECAT", "F_SEX", "F_EDUCCAT", "F_RACECMB", 
                   "F_PARTYSUM_FINAL", "F_INCOME", "F_ACSWEB")]


# rename all columns for easier interpretation
new.names = c("rep", "dem", "age", "gender", "edu", "race", 
              "party", "income", "internet")
names(df2020) <- new.names
names(df2021) <- new.names
names(df2022) <- new.names
names(df2023) <- new.names


# per guidance, approximate age into median values of each age category. 77 is the average age of
# death in the US and is used as the upper limit for the last age category.
df2023$age = ifelse(df2023$age == 1, round((18+29)/2, digits=0),
                    ifelse(df2023$age == 2, round((30+49)/2, digits=0),
                           ifelse(df2023$age == 3, round((50+64)/2, digits=0), round((65+77)/2, digits=0))))
df2022$age = ifelse(df2022$age == 1, round((18+29)/2, digits=0),
                    ifelse(df2022$age == 2, round((30+49)/2, digits=0),
                           ifelse(df2022$age == 3, round((50+64)/2, digits=0), round((65+77)/2, digits=0))))
df2021$age = ifelse(df2021$age == 1, round((18+29)/2, digits=0),
                    ifelse(df2021$age == 2, round((30+49)/2, digits=0),
                           ifelse(df2021$age == 3, round((50+64)/2, digits=0), round((65+77)/2, digits=0))))
df2020$age = ifelse(df2020$age == 1, round((18+29)/2, digits=0),
                    ifelse(df2020$age == 2, round((30+49)/2, digits=0),
                           ifelse(df2020$age == 3, round((50+64)/2, digits=0), round((65+77)/2, digits=0))))


# per guidance, approximate income into median values of each income category.
# $200,000 is assumed as the upper limit for the last category.
median_income_values <- c(
  `1` = 15000,      # Median of less than $30,000
  `2` = 35000,      # Median of $30,000 to less than $40,000
  `3` = 45000,      # Median of $40,000 to less than $50,000
  `4` = 55000,      # Median of $50,000 to less than $60,000
  `5` = 65000,      # Median of $60,000 to less than $70,000
  `6` = 75000,      # Median of $70,000 to less than $80,000
  `7` = 85000,      # Median of $80,000 to less than $90,000
  `8` = 95000,      # Median of $90,000 to less than $100,000
  `9` = 150000      # Median of $100,000 or more (making an assumption)
)
df2023$income <- median_income_values[df2023$income]
df2022$income <- median_income_values[df2022$income]
df2021$income <- median_income_values[df2021$income]

# same with 2020 data but the categories are different range so must update medians.
# $200,000 is assumed as the upper limit for the last category.
median_income_values <- c(
  `1` = 5000,      # Median of less than $10,000
  `2` = 15000,     # Median of $10,000 to less than $20,000
  `3` = 25000,     # Median of $20,000 to less than $30,000
  `4` = 35000,     # Median of $30,000 to less than $40,000
  `5` = 45000,     # Median of $40,000 to less than $50,000
  `6` = 62500,     # Median of $50,000 to less than $75,000
  `7` = 87500,     # Median of $75,000 to less than $100,000
  `8` = 125000,    # Median of $100,000 to less than $150,000
  `9` = 175000     # Median of $150,000 or more (making an assumption)
)
df2020$income <- median_income_values[df2020$income]


# check and drop missing values
colSums(is.na(df2020))
colSums(is.na(df2021))
colSums(is.na(df2022))
colSums(is.na(df2023))
df2020 = df2020[complete.cases(df2020), ]
df2021 = df2021[complete.cases(df2021), ]
df2022 = df2022[complete.cases(df2022), ]
df2023 = df2023[complete.cases(df2023), ]


summary(df2023)
# remove all don't know/refused answers
cols <- setdiff(names(df2023), c("age", "income"))
df2023 <- df2023[apply(df2023[, cols], 1, function(row) all(row <= 8)), ]
df2022 <- df2022[apply(df2022[, cols], 1, function(row) all(row <= 8)), ]
df2021 <- df2021[apply(df2021[, cols], 1, function(row) all(row <= 8)), ]
df2020 <- df2020[apply(df2020[, cols], 1, function(row) all(row <= 8)), ]

# only include male and female in this analysis
df2023 <- df2023[df2023$gender <= 2, ]
df2022 <- df2022[df2022$gender <= 2, ]
df2021 <- df2021[df2021$gender <= 2, ]
df2020 <- df2020[df2020$gender <= 2, ]


# convert categorical variables to factors. keep DVs as numeric for correlation analysis.
df2023= df2023 %>% mutate_at(c('gender','edu','race','party','internet'), as.factor)
df2022= df2022 %>% mutate_at(c('gender','edu','race','party','internet'), as.factor)
df2021= df2021 %>% mutate_at(c('gender','edu','race','party','internet'), as.factor)
df2020= df2020 %>% mutate_at(c('gender','edu','race','party','internet'), as.factor)


#-------------------------------------------------------------------------------
#-----------------------------Data Exploration----------------------------------
#-------------------------------------------------------------------------------

# Create barplot for dependent Variables
par(mfrow = c(2, 4)) 

barplot(table(df2020$rep),  
        main = "Public Opinion on the Republican Party (2020)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "red",        
              border = "white")
barplot(table(df2021$rep),  
        main = "Public Opinion on the Republican Party (2021)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "red",         
        border = "white")
barplot(table(df2022$rep),  
        main = "Public Opinion on the Republican Party (2022)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "red",         
        border = "white")
barplot(table(df2023$rep),  
        main = "Public Opinion on the Republican Party (2023)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "red",         
        border = "white")

barplot(table(df2020$dem),  
        main = "Public Opinion on the Democratic Party (2020)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "blue",        
        border = "white")
barplot(table(df2021$dem),  
        main = "Public Opinion on the Democratic Party (2021)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "blue",        
        border = "white")
barplot(table(df2022$dem),  
        main = "Public Opinion on the Democratic Party (2022)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "blue",        
        border = "white")
barplot(table(df2023$dem),  
        main = "Public Opinion on the Democratic Party (2023)",
        xlab = "Opinion",
        ylab = "Number of Respondents",
        col = "blue",        
        border = "white")
par(mfrow = c(1, 1)) 

library(PerformanceAnalytics)
temp1 <- df2020[, c(1, 2, 3, 8)]
chart.Correlation(temp1) 

temp2 <- df2021[, c(1, 2, 3, 8)]
chart.Correlation(temp2) 

temp3 <- df2022[, c(1, 2, 3, 8)]
chart.Correlation(temp3) 

temp4 <- df2023[, c(1, 2, 3, 8)]
chart.Correlation(temp4) 


# Box Plots

par(mfrow = c(2, 4)) 

# REP and DEM by INTERNET
boxplot(rep ~ internet, data = df2020,main = "2020 Republican Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Republican Favorability (1–4)",col = "red", border = "darkred")
boxplot(rep ~ internet, data = df2021,main = "2021 Republican Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Republican Favorability (1–4)",col = "red", border = "darkred")
boxplot(rep ~ internet, data = df2022,main = "2022 Republican Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Republican Favorability (1–4)",col = "red", border = "darkred")
boxplot(rep ~ internet, data = df2023,main = "2023 Republican Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Republican Favorability (1–4)",col = "red", border = "darkred")

boxplot(dem ~ internet, data = df2020,main = "2020 Democratic Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Democratic Favorability (1–4)",col = "blue", border = "darkblue")
boxplot(dem ~ internet, data = df2021,main = "2021 Democratic Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Democratic Favorability (1–4)",col = "blue", border = "darkblue")
boxplot(dem ~ internet, data = df2022,main = "2022 Democratic Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Democratic Favorability (1–4)",col = "blue", border = "darkblue")
boxplot(dem ~ internet, data = df2023,main = "2023 Democratic Favorability by Internet Use",xlab = "Internet Use Frequency",ylab = "Democratic Favorability (1–4)",col = "blue", border = "darkblue")

# REP and DEM by AGE
boxplot(rep ~ age, data = df2020, col = "red", border = "darkred", main = "2020 Republican Favorability by Age", xlab = "Age", ylab = "Republican Favorability (1–4)")
boxplot(rep ~ age, data = df2021, col = "red", border = "darkred", main = "2021 Republican Favorability by Age", xlab = "Age", ylab = "Republican Favorability (1–4)")
boxplot(rep ~ age, data = df2022, col = "red", border = "darkred", main = "2022 Republican Favorability by Age", xlab = "Age", ylab = "Republican Favorability (1–4)")
boxplot(rep ~ age, data = df2023, col = "red", border = "darkred", main = "2023 Republican Favorability by Age", xlab = "Age", ylab = "Republican Favorability (1–4)")

boxplot(dem ~ age, data = df2020, col = "blue", border = "darkblue", main = "2020 Democratic Favorability by Age", xlab = "Age", ylab = "Democratic Favorability (1–4)")
boxplot(dem ~ age, data = df2021, col = "blue", border = "darkblue", main = "2021 Democratic Favorability by Age", xlab = "Age", ylab = "Democratic Favorability (1–4)")
boxplot(dem ~ age, data = df2022, col = "blue", border = "darkblue", main = "2022 Democratic Favorability by Age", xlab = "Age", ylab = "Democratic Favorability (1–4)")
boxplot(dem ~ age, data = df2023, col = "blue", border = "darkblue", main = "2023 Democratic Favorability by Age", xlab = "Age", ylab = "Democratic Favorability (1–4)")


# REP and DEM by RACE
boxplot(rep ~ race, data = df2020, col = "red", border = "darkred", main = "2020 Republican Favorability by Race", xlab = "Race", ylab = "Republican Favorability (1–4)")
boxplot(rep ~ race, data = df2021, col = "red", border = "darkred", main = "2021 Republican Favorability by Race", xlab = "Race", ylab = "Republican Favorability (1–4)")
boxplot(rep ~ race, data = df2022, col = "red", border = "darkred", main = "2022 Republican Favorability by Race", xlab = "Race", ylab = "Republican Favorability (1–4)")
boxplot(rep ~ race, data = df2023, col = "red", border = "darkred", main = "2023 Republican Favorability by Race", xlab = "Race", ylab = "Republican Favorability (1–4)")

boxplot(dem ~ race, data = df2020, col = "blue", border = "darkblue", main = "2020 Democratic Favorability by Race", xlab = "Race", ylab = "Favorability")
boxplot(dem ~ race, data = df2021, col = "blue", border = "darkblue", main = "2021 Democratic Favorability by Race", xlab = "Race", ylab = "Democratic Favorability (1–4)")
boxplot(dem ~ race, data = df2022, col = "blue", border = "darkblue", main = "2022 Democratic Favorability by Race", xlab = "Race", ylab = "Democratic Favorability (1–4)")
boxplot(dem ~ race, data = df2023, col = "blue", border = "darkblue", main = "2023 Democratic Favorability by Race", xlab = "Race", ylab = "Democratic Favorability (1–4)")

par(mfrow = c(1, 1)) 

#-------------------------------------------------------------------------------
#-----------------------------Data Modeling-------------------------------------
#-------------------------------------------------------------------------------

# Convert 'rep' and 'dem' to factors for each dataset
df2020$rep <- factor(df2020$rep, ordered = TRUE)
df2020$dem <- factor(df2020$dem, ordered = TRUE)

df2021$rep <- factor(df2021$rep, ordered = TRUE)
df2021$dem <- factor(df2021$dem, ordered = TRUE)

df2022$rep <- factor(df2022$rep, ordered = TRUE)
df2022$dem <- factor(df2022$dem, ordered = TRUE)

df2023$rep <- factor(df2023$rep, ordered = TRUE)
df2023$dem <- factor(df2023$dem, ordered = TRUE)

# Models: Ordinal Logistic Regression (polr)
library("MASS")
# Answer this research question: Does more frequent internet use increase the likelihood of strong partisan affiliation among US adults?
# Answer this research question: Does the effect of internet use on partisan affiliation vary by age or race?
# Model for "rep" with interaction terms
model1_rep_2020 <- polr(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2020, Hess = TRUE)
model1_rep_2021 <- polr(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2021, Hess = TRUE)
model1_rep_2022 <- polr(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2022, Hess = TRUE)
model1_rep_2023 <- polr(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2023, Hess = TRUE)

# Stargazer summary
stargazer(model1_rep_2020, model1_rep_2021, model1_rep_2022, model1_rep_2023,
          type = "text", single.row = TRUE, title = "Interaction Effects of Internet Use on Republican Affiliation",
          column.labels = c("2020", "2021", "2022", "2023"),
          column.separate = c(1, 1, 1, 1))

# Model for "dem" with interaction terms
model1_dem_2020 <- polr(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2020, Hess = TRUE)
model1_dem_2021 <- polr(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2021, Hess = TRUE)
model1_dem_2022 <- polr(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2022, Hess = TRUE)
model1_dem_2023 <- polr(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2023, Hess = TRUE)

# Stargazer summary
stargazer(model1_dem_2020, model1_dem_2021, model1_dem_2022, model1_dem_2023,
          type = "text", single.row = TRUE, title = "Interaction Effects of Internet Use on Democratic Affiliation",
          column.labels = c("2020", "2021", "2022", "2023"),
          column.separate = c(1, 1, 1, 1))

# Assumptions: Do not test for multicollinearity since models have interaction terms.
# Tried testing for Independence using DW test but it does not work on ordinal logit.


#-----------------------------------------------------------------------------------
#------------------------------------OR---------------------------------------------
# ----------------------------------------------------------------------------------

# Convert 'rep' and 'dem' to numeric for each dataset
df2020$rep <- as.numeric(as.character(df2020$rep))
df2020$dem <- as.numeric(as.character(df2020$dem))

df2021$rep <- as.numeric(as.character(df2021$rep))
df2021$dem <- as.numeric(as.character(df2021$dem))

df2022$rep <- as.numeric(as.character(df2022$rep))
df2022$dem <- as.numeric(as.character(df2022$dem))

df2023$rep <- as.numeric(as.character(df2023$rep))
df2023$dem <- as.numeric(as.character(df2023$dem))

# Models: Linear Models

# Interaction Models for Republican Affiliation
model1_rep_2020 <- lm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2020)
model1_rep_2021 <- lm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2021)
model1_rep_2022 <- lm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2022)
model1_rep_2023 <- lm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2023)

# Stargazer summary
stargazer(model1_rep_2020, model1_rep_2021, model1_rep_2022, model1_rep_2023,
          type = "text", single.row = TRUE, title = "Interaction Effects of Internet Use on Republican Affiliation",
          column.labels = c("2020", "2021", "2022", "2023"),
          column.separate = c(1, 1, 1, 1))


# Interaction Models for Democratic Affiliation
model1_dem_2020 <- lm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2020)
model1_dem_2021 <- lm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2021)
model1_dem_2022 <- lm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2022)
model1_dem_2023 <- lm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2023)

# Stargazer summary
stargazer(model1_dem_2020, model1_dem_2021, model1_dem_2022, model1_dem_2023,
          type = "text", single.row = TRUE, title = "Interaction Effects of Internet Use on Democratic Affiliation",
          column.labels = c("2020", "2021", "2022", "2023"),
          column.separate = c(1, 1, 1, 1))

#-----------------------------------------------------------------------------------
#Linear Assumptions

#Correlation/Multicollinearity
library("car")
vif(model_rep_2020)
vif(model_rep_2021)
vif(model_rep_2022)
vif(model_rep_2023)


# Linearity
plot(model_rep_2020$fitted.values, resid(model_rep_2020),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "2020 Rep Residuals vs Fitted - Linearity Check")
abline(h = 0, col = "red", lwd = 2)

plot(model_rep_2021$fitted.values, resid(model_rep_2021),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "2021 Rep Residuals vs Fitted - Linearity Check")
abline(h = 0, col = "red", lwd = 2)

plot(model_rep_2022$fitted.values, resid(model_rep_2022),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "2022 Rep Residuals vs Fitted - Linearity Check")
abline(h = 0, col = "red", lwd = 2)

plot(model_rep_2023$fitted.values, resid(model_rep_2023),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "2023 Rep Residuals vs Fitted - Linearity Check")
abline(h = 0, col = "red", lwd = 2)


#Independence
library(lmtest)
dwtest(model_rep_2020)
dwtest(model_rep_2021) 
dwtest(model_rep_2022) 
dwtest(model_rep_2023) 


# Normality
qqnorm(df2020$rep)                          
qqline(df2020$rep, col="red")

qqnorm(df2021$rep)                          
qqline(df2021$rep, col="red")

qqnorm(df2022$rep)                          
qqline(df2022$rep, col="red")

qqnorm(df2023$rep)                          
qqline(df2023$rep, col="red")
                     

# Equality of Variances
library("car")
library(lmtest)
# since data is not normal, using Levene Test
leveneTest(resid(model_rep_2020) ~ fitted(model_rep_2020)) #not working

# Residual Plots
plot(model_rep_2020$fitted.values,
     scale(model_rep_2020$residuals),
     pch=19,main="Residuls vs. Fitted")
abline(0,0,lwd=3,col="red")

plot(model_rep_2021$fitted.values,
     scale(model_rep_2021$residuals),
     pch=19,main="Residuls vs. Fitted")
abline(0,0,lwd=3,col="red")

plot(model_rep_2022$fitted.values,
     scale(model_rep_2022$residuals),
     pch=19,main="Residuls vs. Fitted")
abline(0,0,lwd=3,col="red")

plot(model_rep_2023$fitted.values,
     scale(model_rep_2023$residuals),
     pch=19,main="Residuls vs. Fitted")
abline(0,0,lwd=3,col="red")


#-----------------------------------------------------------------------------------
#------------------------------------OR---------------------------------------------
# ----------------------------------------------------------------------------------

# Models: Generalized Linear Models - Poisson

# Interaction Models for Republican Affiliation
model1_rep_2020 <- glm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2020, family = poisson(link = "log"))
model1_rep_2021 <- glm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2021, family = poisson(link = "log"))
model1_rep_2022 <- glm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2022, family = poisson(link = "log"))
model1_rep_2023 <- glm(rep ~ internet * age + internet * race + party + gender + edu + log(income), data = df2023, family = poisson(link = "log"))

# Stargazer summary
stargazer(model1_rep_2020, model1_rep_2021, model1_rep_2022, model1_rep_2023,
          type = "text", single.row = TRUE, title = "Interaction Effects of Internet Use on Republican Affiliation",
          column.labels = c("2020", "2021", "2022", "2023"),
          column.separate = c(1, 1, 1, 1))


# Interaction Models for Democratic Affiliation
model1_dem_2020 <- glm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2020, family = poisson(link = "log"))
model1_dem_2021 <- glm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2021, family = poisson(link = "log"))
model1_dem_2022 <- glm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2022, family = poisson(link = "log"))
model1_dem_2023 <- glm(dem ~ internet * age + internet * race + party + gender + edu + log(income), data = df2023, family = poisson(link = "log"))

# Stargazer summary
stargazer(model1_dem_2020, model1_dem_2021, model1_dem_2022, model1_dem_2023,
          type = "text", single.row = TRUE, title = "Interaction Effects of Internet Use on Democratic Affiliation",
          column.labels = c("2020", "2021", "2022", "2023"),
          column.separate = c(1, 1, 1, 1))

#-----------------------------------------------------------------------------------
# GLM Assumptions Poisson

#Correlation/Multicollinearity
# Not testing since models have interaction terms.

#Independence
library(lmtest)
dwtest(model_rep_2020)
dwtest(model_rep_2021) 
dwtest(model_rep_2022) 
dwtest(model_rep_2023) 

dwtest(model_dem_2020)
dwtest(model_dem_2021)
dwtest(model_dem_2022)
dwtest(model_dem_2023)

# Testing for Collinearity with interaction models doen't make sense

#-----------------------------------------------------------------------------------
# Overdispersion test
library(AER)
dispersiontest(model_rep_2020)
dispersiontest(model_rep_2021)
dispersiontest(model_rep_2022)
dispersiontest(model_rep_2023)

dispersiontest(model_dem_2020)
dispersiontest(model_dem_2021)
dispersiontest(model_dem_2022)
dispersiontest(model_dem_2023)

dispersiontest(model1_rep_2020)
dispersiontest(model1_rep_2021) 
dispersiontest(model1_rep_2022) 
dispersiontest(model1_rep_2023) 

dispersiontest(model1_dem_2020)
dispersiontest(model1_dem_2021) 
dispersiontest(model1_dem_2022) 
dispersiontest(model1_dem_2023)
