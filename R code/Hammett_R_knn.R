# install and load packages
install.packages("FNN")
library(FNN)
install.packages("pacman")
pacman::p_load(ggplot2, caret, ModelMetrics, scales)
library(caret)

# load files from local drives (m and p in 2 separate files)
df_m <- read.csv('C:/My File/Chem ML/data/Hammett_m.csv')
df_p <- read.csv('C:/My File/Chem ML/data/Hammett_p.csv')

# test-train split (20/80)
set.seed(1988)
size_m <- round(0.80*nrow(df_m))
training_m <- sample(nrow(df_m), size = size_m, replace=FALSE)
df_m_train <- df_m[training_m, ]
df_m_test <- df_m[-training_m, ]
set.seed(1990)
size_p <- round(0.80*nrow(df_p))
training_p <- sample(nrow(df_p), size = size_p, replace=FALSE)
df_p_train <- df_p[training_p, ]
df_p_test <- df_p[-training_p, ]

# set up the grid search
grid <- expand.grid(k = c(3:25))
train_control <- trainControl(method='cv', number=10, savePredictions=TRUE,
                              search = "grid")

# knn training
knn_m <- train(m~., data = df_m_train, method = "knn",
               trControl = train_control, tuneGrid = grid)
knn_p <- train(p~., data = df_p_train, method = "knn",
               trControl = train_control, tuneGrid = grid)

# calculate test R^2 and RMSE
knn.pred_m <- predict(knn_m, newdata = df_m_test)
knn.pred_p <- predict(knn_p, newdata = df_p_test)
knn.r2_m <- cor(knn.pred_m, df_m_test$m)
knn.rmse_m <- RMSE(knn.pred_m, df_m_test$m)
knn.r2_p <- cor(knn.pred_p, df_p_test$p)
knn.rmse_p <- RMSE(knn.pred_p, df_m_test$p)
Hammett_knn_result <- data.frame(knn.r2_m, knn.r2_p, knn.rmse_m, knn.rmse_p)
Hammett_knn_result

# scatter plot
knn.graph_m <- plot(knn.pred_m, df_m_test$m, main = "Hammett m Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.4, 1.3), ylim = c(-0.4, 1.3))
abline(a=0, b=1)
knn.graph_p <- plot(knn.pred_p, df_p_test$p, main = "Hammett p Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.8, 1.5), ylim = c(-0.8, 1.5))
abline(a=0, b=1)