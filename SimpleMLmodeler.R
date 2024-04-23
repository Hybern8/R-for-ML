library(randomForest)
library(caret)
library(openxlsx)
library(dplyr)

# import the data
EL <- read.csv('Datasets/EL.csv') #insurance subscribers dataset

# convert relevant columns as factors for easy build with the model
converT <- c('Occupation', 'Gender', 'Product.Type', 'MaritalStatus', 'Location', 'Buy.Status')
EL <- EL %>% 
  mutate_at(vars(converT), factor)
  
# perform split
set.seed(1133)
training_index <- createDataPartition(EL$Buy.Status, p = 0.8, list = F)
train_set <- EL[training_index, ] # train set
test_set <- EL[-training_index, ] # test set

# build a randomForest model
model <- randomForest(`Buy.Status` ~ ., data = train_set, ntree = 1500, mtry = 7, importance = T)

# make prediction
prediction <- predict(model, test_set)

# check model's accuracy using a confusion matrix
confusionMatrix(test_set$Buy.Status, prediction)

# convert the predictions as a dataframe
predictions <- data.frame(prediction) 

# attach predictions to test/live dataset
final <- cbind(test_set, predictions) 

# write file into Excel spreadsheet for further use
write.xlsx(final, 'Result.xlsx') 
# save model as .rds
saveRDS(model, 'ELmodel.rds')
