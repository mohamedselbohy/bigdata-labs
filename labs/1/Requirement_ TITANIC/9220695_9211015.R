### 1
rm(list = ls())
setwd("/home/mohamed/uni/big-data/labs/1/Requirement_ TITANIC") # set it to the dir containing titanic.csv
getwd()

### 2
titanic <- read.csv("titanic.csv") 

### 3
dim(titanic)
str(titanic)
head(titanic, 10)
tail(titanic, 10)
summary(titanic)

### 4
summary(titanic$Age)

# first quartile: 20.12
# third quartile: 38.00
# This means that 25% of the passengers are below 20 years old
# and 75% of passengers are below 38 years old

anyNA(titanic$Age) 
# [1] True
# Age variable appear to have missing values.

typeof(titanic$Embarked) # [1] "character"
levels(as.factor(titanic$Embarked)) # [1] "" "C" "Q" "S"
# It was expected to have the values C,Q,S only. But it appears to also include an empty string
# Extra: find the rows having empty strings by the following
# titanic[which(titanic$Embarked == ""), ] ### PassengerIds -> 62 and 830

# 4.e: The next step should be to clean the data and preprocess it handling rows with empty values and such.

### 5
titanic <- titanic[!is.na(titanic$Age),]

titanic <- titanic[which(titanic$Embarked != ""),]

anyNA(titanic$Age) # [1] False
levels(as.factor(titanic$Embarked)) # [1] "C" "Q" "S"

titanic$Cabin <- NULL
titanic$Ticket <- NULL

### 6
table(titanic$Gender)
# female   male 
# 259    453 

passengers_plot = pie(table(titanic$Gender), main = "Passenger Gender Distribution", col = c("red", "blue"))
table(titanic$Gender, titanic$Survived)

survivors_plot = pie(table(titanic[titanic$Survived == 1,]$Gender), main = "Survivor Gender Distribution", col = c("red", "blue"))

# Most of the survivors were females, even though most of the passengers were males.

table(titanic$Survived, titanic$Pclass)

barplot(table(titanic$Survived, titanic$Pclass), main = "Survivor Social Class Distribution", legend.text = c("deceased", "survived"), col = c("red", "blue"))

# The majority of class 1 survived, while class 2 almost half of them survived, but the slight majority are survivors, and most class 3 didn't make it.

boxplot(titanic$Age, main = "Age Distribution", ylab = "Age")

# It means that the average age is around late 20s (~29 y.o.). And 25% are younger than 20 while 75% are younger than ~28.
# There are outliers to the distribution starting from around ~64 y.o.

plot(density(titanic$Age, na.rm = TRUE), main = "Age Density Distribution", xlab = "Age")


### 7
cleaned_df <- titanic[, c("Name", "Survived")]
write.csv(cleaned_df, "titanic_survival.csv", row.names = FALSE)
