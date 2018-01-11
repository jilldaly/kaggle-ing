##############################################################################
#                             Kaggle Titanic                                 #
#                                                                            #
#                           Decision Tree Model                              #
#                                                                            #
#       Simple reproduction of this tutorial as a means of practice          #
# http://trevorstephens.com/kaggle-titanic-tutorial/getting-started-with-r   #
##############################################################################

# Read the datasets into dataFrames
train <- read.csv("~/dev/kaggle/titanic/train.csv", stringsAsFactors=FALSE)
test <- read.csv("~/dev/kaggle/titanic/test.csv", stringsAsFactors=FALSE)

# If you're having trouble installing rattle (on a mac) due to RGtk issues, then follow this blog:
# https://gist.github.com/zhiyzuo/a489ffdcc5da87f28f8589a55aa206dd

install.packages('rpart')
install.packages("https://togaware.com/access/rattle_5.0.14.tar.gz", repos=NULL, type="source")
install.packages('rpart.plot')
install.packages('RColorBrewer')
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Lets update the test prediction so that it's gender based
test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1

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



fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
             data=train,
             method='class')

# Make sure that the RStudio Viewer is big enough so that this command works
fancyRpartPlot(fit)

# Make a new file for a new Kaggle submission
Prediction <- predict(fit, test, type = "class")
submit_dt <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit_dt, file = "myfirstdtree.csv", row.names = FALSE)
