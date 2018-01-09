##############################################################################
#                             Kaggle Titanic                                 #
#                                                                            #
#                           Decision Tree Model                              #
#                                                                            #
#       Simple reproduction this tutorial, as a means of practice            #
# http://trevorstephens.com/kaggle-titanic-tutorial/getting-started-with-r   #
##############################################################################

# Read the datasets into dataFrames
train <- read.csv("~/dev/kaggle/titanic/train.csv", stringsAsFactors=FALSE)
test <- read.csv("~/dev/kaggle/titanic/test.csv", stringsAsFactors=FALSE)

# import rpart - Recursive Partitioning and Regression Trees
for (package in c("rpart")) {
  if(!require(package, character.only = TRUE, quietly = TRUE)){
    install.packages(package)
    library(package, character.only = TRUE)
  }
}



