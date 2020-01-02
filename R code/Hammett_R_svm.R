# install and load packages
library(e1071)
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

# svm training & calculate test R^2 and RMSE
svm_m <- svm(m~., data = df_m_train, trControl = train_control)
svm.pred_m <- predict(svm_m, df_m_test)
svm.r2_m <- cor(svm.pred_m, df_m_test$m)
svm.rmse_m <- sqrt(mean((svm.pred_m - df_m_test$m)^2))
svm_p <- svm(p~., data = df_p_train, trControl = train_control)
svm.pred_p <- predict(svm_p, df_p_test)
svm.r2_p <- cor(svm.pred_p, df_p_test$p)
svm.rmse_p <- sqrt(mean((svm.pred_p - df_m_test$p)^2))
Hammett_svm_result <- data.frame(svm.r2_m, svm.r2_p, svm.rmse_m, svm.rmse_p)
Hammett_svm_result

# svm tune & calculate test R^2 and RMSE
tune.svm_m <- tune(svm, m~., data = df_m_train, trControl = train_control,
                   range=list(cost=2^(2:9)),
                   epsilon=seq(0,1,0.1))
svm.pred_m_tune <- predict( tune.svm_m$best.model, df_m_test)
svm.r2_m_tune <- cor(svm.pred_m_tune, df_m_test$m)
svm.rmse_m_tune <- sqrt(mean((svm.pred_m_tune - df_m_test$m)^2))
tune.svm_p <- tune(svm, p~., data = df_p_train, trControl = train_control,
                   range=list(cost=2^(2:9)),
                   epsilon=seq(0,1,0.1))
svm.pred_p_tune <- predict(tune.svm_p$best.model, df_p_test)
svm.r2_p_tune <- cor(svm.pred_p_tune, df_p_test$p)
svm.rmse_p_tune <- sqrt(mean((svm.pred_p_tune - df_p_test$p)^2))
Hammett_svm_result_tune <- data.frame(svm.r2_m_tune, svm.r2_p_tune,
                                 svm.rmse_m_tune, svm.rmse_p_tune)
Hammett_svm_result_tune

# scatter plot (svm tune)
svm.graph_m_tune <- plot(svm.pred_m_tune, df_m_test$m, main = "Hammett m Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.4, 1.3), ylim = c(-0.4, 1.3))
abline(a=0, b=1)
svm.graph_p_tune <- plot(svm.pred_p_tune, df_p_test$p, main = "Hammett p Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.8, 1.5), ylim = c(-0.8, 1.5))
abline(a=0, b=1)