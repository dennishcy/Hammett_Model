# install and load packages
install.packages("randomForest")
library(ramdomForest)
install.packages("pacman")
pacman::p_load(ggplot2, caret, ModelMetrics, scales)
library(caret)

# load files from local drives (m and p in 2 separate files)
df_m <- read.csv('C:/My File/Chem ML/data/Hammett_m.csv')
df_p <- read.csv('C:/My File/Chem ML/data/Hammett_p.csv')

# test-train split (20/80)
set.seed(1223)
size_m <- round(0.80*nrow(df_m))
training_m <- sample(nrow(df_m), size = size_m, replace=FALSE)
df_m_train <- df_m[training_m, ]
df_m_test <- df_m[-training_m, ]
set.seed(1768)
size_p <- round(0.80*nrow(df_p))
training_p <- sample(nrow(df_p), size = size_p, replace=FALSE)
df_p_train <- df_p[training_p, ]
df_p_test <- df_p[-training_p, ]
train_control <- trainControl(method='cv', number=10, savePredictions=TRUE)

# rf training
set.seed(677)
rffit_m <- train(m~., data=df_m_train, trControl=train_control,
                 method='rf', importance=TRUE)
set.seed(789)
rffit_p <- train(p~., data=df_p_train, trControl=train_control,
                 method='rf', importance=TRUE)

# calculate test R^2 and RMSE
rf.pred_m <- predict(rffit_m, df_m_test)
rf.pred_p <- predict(rffit_p, df_p_test)
rf.r2_m <- cor(rf.pred_m, df_m_test$m)
rf.rmse_m <- RMSE(rf.pred_m, df_m_test$m)
rf.r2_p <- cor(rf.pred_p, df_p_test$p)
rf.rmse_p <- RMSE(rf.pred_p, df_p_test$p)
Hammett_rf_result <- data.frame(rf.r2_m, rf.r2_p, rf.rmse_m, rf.rmse_p)
Hammett_rf_result

# scatter plot
rf.graph_m <- plot(rf.pred_m, df_m_test$m, main = "Hammett m Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.4, 1.3), ylim = c(-0.4, 1.3))
abline(a=0, b=1)
rf.graph_p <- plot(rf.pred_p, df_p_test$p, main = "Hammett p Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.8, 1.5), ylim = c(-0.8, 1.5))
abline(a=0, b=1)