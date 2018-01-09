##############################################################################
#                             Kaggle Titanic                                 #
#                                                                            #
#       Simple re-production ofthis tutorial as a means of practice          #
# http://trevorstephens.com/kaggle-titanic-tutorial/getting-started-with-r   #
##############################################################################


# Read the datasets into dataFrames
train <- read.csv("~/dev/kaggle/titanic/train.csv", stringsAsFactors=FALSE, header=TRUE, sep=",")
test <- read.csv("~/dev/kaggle/titanic/test.csv", stringsAsFactors=FALSE, header=TRUE, sep=",")


# breakdown of survior counts
table(train$Survived)
prop.table(table(train$Survived))


# First pass at prdiction, using heuristic (ie: majority died)
# Crate a file for our first simple prediction (kaggle asks for PassengerId as well as prediction)
test$Survived <- rep(0, 418)
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file="theyallperish.csv", row.names = FALSE)


# For our second prediction, lets investigate how the gender balance affected survival
summary(train$Sex)
prop.table(table(train$Sex, train$Survived))


# Lets update the test prediction so that it's gender based
test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
submit2 <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit2, file="genderbasedprediction.csv", row.names = FALSE)

# impute the mean age for adult males
train$Age[train$Sex == 'male' 
          & is.na(train$Age)
          & !grepl('Master.',train$Name)] <- mean(train$Age[train$Sex == 'male' 
                                                            & !is.na(train$Age)])

# impute the mean age for male children
train$Age[train$Sex == 'male' 
          & is.na(train$Age)
          & grepl('Master.',train$Name)] <- mean(train$Age[train$Sex == 'male' 
                                                           & !is.na(train$Age)
                                                           & grepl('Master.',train$Name)])

# Age is continuous, so let's create a breakdown of Children
train$Child <- '0'
train$Child[train$AgeCat == '<18'] <- '1'

# For the third iteration, include IVs gender and age
summary(train$Age)
aggregate(Survived ~ Child + Sex, data = train, FUN=sum)
aggregate(Survived ~ Child + Sex, data = train, FUN=length)
aggregate(Survived ~ Child + Sex, data = train, FUN=function(x) {sum(x)/length(x)})


# Investigate the Fare values, create binning/groups
# This will be used for entropy/info gain calculations
train$FareCat <- '30+'
train$FareCat[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$FareCat[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$FareCat[train$Fare < 10] <- '<10'

# Investigate the Age values, create binning/groups. 
# This will be used for entropy/info gain calculations
train$AgeCat <- NA
train$AgeCat[train$Age >= 60 ] <- '60+'
train$AgeCat[train$Age < 60 & train$Age >= 30] <- '30-60'
train$AgeCat[train$Age < 30 & train$Age >= 18] <- '18-30'
train$AgeCat[train$Age < 18] <- '<18'

train$FareCat <- factor(train$FareCat)
train$AgeCat <- factor(train$AgeCat)
train$Pclass <- factor(train$Pclass)
train$Child <- factor(train$Child)
train$Sex <- factor(train$Sex)
train$Survived <- factor(train$Survived)
str(train)

# Write to file for entropy/inofgain
write.csv(train, file="entropy-infogain-train.csv",row.names=FALSE)

# doesn't work with factors
#aggregate(Survived ~ FareCat + Pclass + Sex + Child, data=train, FUN=function(x) {sum(x)/length(x)})


# Updte Surived for Fare + Pclass + Sex + Child 
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >20] <- 0


# Create a csv file for our third model iteration
submit3 <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit3, file="gender_age_fare_survival.csv", row.names = FALSE)

