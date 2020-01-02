# install and load packages
install.packages("pacman")
pacman::p_load(ggplot2, caret, ModelMetrics, scales)
library(caret)

# load files from local drives (m and p in 2 separate files)
df_m <- read.csv('C:/My File/Chem ML/data/Hammett_m.csv')
df_p <- read.csv('C:/My File/Chem ML/data/Hammett_p.csv')

# test-train split (20/80)
train_control <- trainControl(method='cv', number=10, savePredictions=TRUE)
set.seed(1334)
size_m <- round(0.80*nrow(df_m))
training_m <- sample(nrow(df_m), size = size_m, replace=FALSE)
df_m_train <- df_m[training_m, ]
df_m_test <- df_m[-training_m, ]
set.seed(1679)
size_p <- round(0.80*nrow(df_p))
training_p <- sample(nrow(df_p), size = size_p, replace=FALSE)
df_p_train <- df_p[training_p, ]
df_p_test <- df_p[-training_p, ]

# linear regression model
lmfit_m <- lm(m~., df_m_train, trControl = train_control)
lmfit_m
lmfit_p <- lm(p~., df_p_train, trControl = train_control)
lmfit_p
summary(lmfit_m)
summary(lmfit_p)

# calculate test R^2 and RMSE
lm.pred_m <- predict(lmfit_m, df_m_test)
lm.pred_p <- predict(lmfit_p, df_p_test)
lm.r2_m <- cor(lm.pred_m, df_m_test$m)
lm.r2_p <- cor(lm.pred_p, df_p_test$p)
lmrmse_m <- sqrt(mean(residuals(lmfit_m)^2))
lmrmse_p <- sqrt(mean(residuals(lmfit_p)^2))
Hammett_lm_result <- data.frame(lm.r2_m, lm.r2_p, lmrmse_m, lmrmse_p)
Hammett_lm_result

# scatter plot
lm.graph_m <- plot(lm.pred_m, df_m_test$m, main = "Hammett m Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.2, 1.3), ylim = c(-0.2, 1.3))
abline(a=0, b=1)
lm.graph_p <- plot(lm.pred_p, df_p_test$p, main = "Hammett p Values",
                  xlab = "Predicted Values",
                  ylab = "Actual Values",
                  xlim = c(-0.8, 1.5), ylim = c(-0.8, 1.5))
abline(a=0, b=1)