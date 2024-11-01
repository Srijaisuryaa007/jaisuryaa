library(caret)
library(randomForest)
library(ROSE)
library(dplyr)
dataset <- read.csv("fraud_data.csv")
str(dataset)
summary(dataset)
dataset$Category <- as.factor(dataset$Category)
sum(is.na(dataset))
set.seed(123)
trainIndex <- createDataPartition(dataset$Fraud, p = 0.7, list = FALSE)
trainData <- dataset[trainIndex, ]
testData <- dataset[-trainIndex, ]
balancedData <- ROSE(Fraud ~ ., data = trainData, seed = 123)$data
model <- randomForest(Fraud ~ ., data = balancedData, ntree = 100)
predictions <- predict(model, newdata = testData)
confusionMatrix(predictions, testData$Fraud)
precision <- posPredValue(predictions, testData$Fraud, positive = "1")
recall <- sensitivity(predictions, testData$Fraud, positive = "1")
F1 <- (2 * precision * recall) / (precision + recall)
cat("Precision: ", precision, "\n")
cat("Recall: ", recall, "\n")
cat("F1 Score: ", F1, "\n")