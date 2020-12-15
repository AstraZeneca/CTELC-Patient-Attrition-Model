# Clinical Trial Patient Attrition Modeling Using Machine Learning

# Full Authors List
# Nampally, Sreenath; Zhang, Youyi; Khan A.N, Imran; Hutchison, Emmette; 
# Khader, Shameer; Khan, Faisal

# Code Authors
# Nampally, Sreenath; Zhang, Youyi; Khan A.N, Imran;

# Contact
# shameer.khader@astrazeneca.com.

# Description of Project
# This work assembled the first large-scale sponsor independent clinical 
# trial dataset for the purpose of enabling a data-driven approach to 
# elucidate the drivers of patient attrition in clinical trials.

# Description of Code
# This code splits the data into training and testing, multiple machine learning 
# models were trained to predict patient attrition

library("SuperLearner")
library("MASS")
library("ranger")
library("ipred")
library("kernlab")
library("arm")
library("dplyr")
library("caret")
library("glmnet")
library("parallel")
library("randomForest")
library("party")

# Set the data directories to the place where analysis ready data is stored

ds1 <- read.csv("./Indexed_Analysis_Ready.csv")

# training set by nct_id
ds2 <- unique(ds1[,c("nct_id","Disease")])
#Split training and testing into 80:20 split
set.seed(234)
NCTIndex <-createDataPartition(ds2$Disease, p = .8,  list = F, times = 1)
# TRAINING set
ds3<- ds1[ds1$nct_id %in% ds2$nct_id[NCTIndex]  ,]
# TEST set
ds4<- ds1[!(ds1$nct_id %in% ds2$nct_id[NCTIndex])  ,]

# Convert Character columns to numeric in the training data set ds3
# ***remove numerics ****
ds3$Disease_n <- as.numeric(as.factor(ds3$Disease))
ds3$Phase_n <- as.numeric(as.factor(ds3$Phase))
ds3$Industry_n <- as.numeric(as.factor(ds3$Industry))

# Remove the character columns and other un necessary columns 
ds3 <- ds3[, !(names(ds3) %in% c("nct_id","dwp_wo_ae","dwp_sub", "Disease", "Phase", "Industry") )] 

# Convert Character columns to numeric in the test data set ds4
ds4$Disease_n <- as.numeric(as.factor(ds4$Disease))
ds4$Phase_n <- as.numeric(as.factor(ds4$Phase))
ds4$Industry_n <- as.numeric(as.factor(ds4$Industry))

# Remove the character columns and other target columns 
ds4 <- ds4[, !(names(ds4) %in% c("nct_id","dwp_wo_ae","dwp_sub", "dwp_all_res", "dwp_all_pred", "Disease", "Phase", "Industry") )] 

# Create a test and training data set from ds3 and ds4
superlearner_train <- ds3
superlearner_test <- ds4

# Separate the predictors in to its own data frame for training data set
x.train <- subset(superlearner_train, select = -dwp_all)
y.train <- superlearner_train$dwp_all


# Separate the predictors in to its own data frame for test data set
x.test <- subset(superlearner_test, select = -dwp_all)
y.test <- superlearner_test$dwp_all


cf1 <- cforest(y.train ~ . , data= x.train, control=cforest_unbiased(mtry=2,ntree=50))

test <- varimp(cf1) # get variable importance, based on mean decrease in accuracy

# List Wrapper algorithms available in SuperLearner
listWrappers()

# Create a new function that changes just the ntree argument for RandomForest
# "..." means "all other arguments that were sent to the function"

SL.rf.better <- function(...){
  SL.randomForest(..., num.trees=5000)
}

# Fit the CV.SuperLearner with the tuned randomforest along with others.  

system.time({
  # Set the seed
  set.seed(150)
  
  # Create a library of algorithms
  SL.library <- c("SL.ranger", "SL.rf.better", "SL.randomForest", "SL.ksvm", "SL.ipredbagg", "SL.bayesglm", "SL.glm", "SL.lm", "SL.glmnet", "SL.ridge", "SL.mean")
  
  
  # Tune the model
  # The outercross-validation is the sample spliting for evaluating the SuperLearner.
  # The inner cross-validation are the valuesnpassed to each of the V SuperLearner calls.
  # V is the number of folds for CV.SuperLearner
  cv.model.tune <- CV.SuperLearner(Y = y.train, X = x.train, family=gaussian(), SL.library = SL.library, 
                                   verbose = TRUE, method = "method.NNLS", cvControl = list(V = 10, shuffle = FALSE),
                                   innerCvControl = list(list(V = 5)))
})

# Get summary statistics
summary(cv.model.tune)

df <- summary(cv.model.tune)
newdf <- df$Table
mse <- newdf[,1:2]
mse$rmse ='^'(mse$Ave,1/2) # square root of mse to calculate rmse
finaltable <- mse[c(1,2,5,6,7,8,9,10),c(1,3)] # subset only few algorithms
standardnames <- c('Super Learner', 'Discrete Super Learner', 'Random Forest', 'Support Vector Machines', 'Bagging Classification', 'Bayesian Generalized Linear Models
', 'Generalized Linear Models', 'Ordinary least squares' ) # standardize the names
final_stats_with_rmse <- data.frame("Algorithms" = standardnames, "RMSE" = finaltable[,2]) # subset the data
final_stats_with_rmse %>% mutate_at(vars(RMSE), funs(round(., 2))) # round columns values to two decimal places

## Selecting top 8 features based on variable importance

x.train_selected_vars <- x.train %>% dplyr::select(Duration.Trial, Duration.Treatment, Disease_n, AE_total_serious, N_total, GDP_weighted, AA_fraction, Age_mean)

# Fit the CV.SuperLearner with the tuned randomforest along with lm on final selected variables  

system.time({
  # Set the seed
  set.seed(250)
  
  # Create a library of algorithms
  SL.library <- c("SL.randomForest", "SL.lm")
  
  
  # Tune parameters for SL : stratifyCV, shuffle and validRows
  # The outercross-validation is the sample spliting for evaluating the SuperLearner.
  # The inner cross-validation are the valuesnpassed to each of the V SuperLearner calls.
  # V is the number of folds for CV.SuperLearner
  # A list of parameters to control the outer cross-validation process. cvControl set to 3
  cv.model.tune.8predictors <- CV.SuperLearner(Y = y.train, X = x.train_selected_vars, family=gaussian(), SL.library = SL.library, 
                                               verbose = TRUE, method = "method.NNLS", cvControl = list(V = 3, shuffle = FALSE),
                                               innerCvControl = list(list(V = 5)))
})

# Get summary statistics
summary(cv.model.tune.8predictors)

df <- summary(cv.model.tune.8predictors)
newdf <- df$Table
mse <- newdf[,1:2]
mse$rmse ='^'(mse$Ave,1/2) # square root of mse to calculate rmse
finaltable <- mse[c(3,4),c(1,3)] # subset only few algorithms
standardnames <- c('Random Forest','Ordinary least squares' ) # standardize the names
final_stats_with_rmse <- data.frame("Algorithms" = standardnames, "RMSE" = finaltable[,2]) # subset the data
final_stats_with_rmse %>% mutate_at(vars(RMSE), funs(round(., 2))) # round columns values to two decimal places
