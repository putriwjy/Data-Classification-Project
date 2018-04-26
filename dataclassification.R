
install.packages("e1071")
library(e1071)
install.packages("tree")
library(tree)
install.packages("adabag")``
library(adabag)
install.packages("rpart")
library(rpart)
install.packages("ROCR")
library(ROCR)
install.packages("randomForest")
library(randomForest)

PBRead <- read.csv("PBData.csv")

#1
#check if a factor has NA 
sum(is.na(PBRead))

#remove all NA rows
PBRead = PBRead[complete.cases(PBRead),]

#get sample of 1000
set.seed(27159280)
PBD <- PBRead[sample(nrow(PBRead),1000),]
PBD <- as.data.frame(PBD)

#perform analysis
## get ratio of "yes" and "no" for subscribed
## get summary of numerical data using summary()
summary(PBD)
sd(PBD$age)
sd(PBD$balance)
sd(PBD$duration)
sd(PBD$campaign)
sd(PBD$pdays)
sd(PBD$previous)
sd(PBD$day)
SuccessYes <- PBD[PBD$subscribed=="yes",]
SuccessNo <- PBD[PBD$subscribed=="no",]
YesRatio = nrow(SuccessYes)/1000
YesRatio
NoRatio = nrow(SuccessNo)/1000
NoRatio

########################################################
#2
# create training data (70%) and test data (30%)
set.seed(27159280)
train.row <- sample(1:nrow(PBD), 0.7*nrow(PBD))
PBD.train <- PBD[train.row,]
PBD.test <- PBD[-train.row,]

##########################################################
# 3,4,5
# Decision tree
# create decision tree
itree = tree(subscribed~.,data=PBD.train)
plot(itree)
text(itree,pretty=0)
# do prediction as classes and draw a table
ipredict = predict(itree,PBD.test,type="class")
confmatrix_dt = table(Predicted_class=ipredict, Actual_class=PBD.test$subscribed)
cat("\n#Decision tree confusion matrix\n")
print(confmatrix_dt)
# confusion matrix accuracy
accuracy_dt = (confmatrix_dt[1]+confmatrix_dt[4])/
              (confmatrix_dt[1]+confmatrix_dt[2]+
               confmatrix_dt[3]+confmatrix_dt[4])

# do prediction as probabilities and draw ROC
PBDpred.tree <- predict(itree,PBD.test,type="vector")
PBDpred <- prediction(PBDpred.tree[,2],PBD.test$subscribed)
PBDperf <- performance(PBDpred,"tpr","fpr")

# plot curve
plot(PBDperf, col="purple")
abline(0,1)

# get area under the curve
PBDauc <- performance(PBDpred,"auc")
auc_dectree <- print(as.numeric(PBDauc@y.values))

##############################################################

# naive bayes
my.model = naiveBayes(subscribed~., data=PBD.train)
my.predict = predict(my.model, PBD.test)
confmatrix_nb = table(Predicted_class=my.predict, Actual_class=PBD.test$subscribed)
cat("\n#naive bayes confusion matrix\n")
print(confmatrix_nb)

# confusion matrix accuracy
accuracy_nb = (confmatrix_nb[1]+confmatrix_nb[4])/
              (confmatrix_nb[1]+confmatrix_nb[2]+
              confmatrix_nb[3]+confmatrix_nb[4])     

# output as confidence intervals
mynb.predict = predict(my.model,PBD.test,type="raw")
PBDnb.pred <- prediction(mynb.predict[,2],PBD.test$subscribed)
PBDnb.perf <- performance(PBDnb.pred,"tpr","fpr")

# plot curve
plot(PBDnb.perf,add=TRUE,col="red")

# get area under curve
PBDnb.auc <- performance(PBDnb.pred,"auc")
auc_nb <- print(as.numeric(PBDnb.auc@y.values))

###########################################################
# bagging
mybag <- bagging(subscribed~.,data=PBD.train,mfinal=5)
mybpred <- predict.bagging(mybag,PBD.test)
cat("\n#Bagging confusion matrix\n")
print(mybpred$confusion)

# confusion matrix accuracy
accuracy_bag = (mybpred$confusion[1]+mybpred$confusion[4])/
               (mybpred$confusion[1]+mybpred$confusion[2]+
                mybpred$confusion[3]+mybpred$confusion[4])

#mybpred
PBDbag.pred <- prediction(mybpred$prob[,2],PBD.test$subscribed)
PBDbag.perf <- performance(PBDbag.pred,"tpr","fpr")

# plot curve
plot(PBDbag.perf,add=TRUE,col="orange")

# area under the curve
PBDbag.auc <- performance(PBDbag.pred,"auc")
auc_bag <- print(as.numeric(PBDbag.auc@y.values))

##############################################################

# boosting
myboost <- boosting(subscribed~., data=PBD.train,mfinal=10)
myboost.pred <- predict.boosting(myboost,newdata=PBD.test)
cat("\n#Boosting confusion matrix\n")
print(myboost.pred$confusion)

# confusion matrix accuracy
accuracy_boost = (myboost.pred$confusion[1]+myboost.pred$confusion[4])/
                 (myboost.pred$confusion[1]+myboost.pred$confusion[2]+
                  myboost.pred$confusion[3]+myboost.pred$confusion[4])

# myboost.pred
PBDboost.pred <- prediction(myboost.pred$prob[,2],PBD.test$subscribed)
PBDboost.perf <- performance(PBDboost.pred,"tpr","fpr")

# plot curve
plot(PBDboost.perf,add=TRUE,col="blue")

# get area under the curve
PBDboost.auc <- performance(PBDboost.pred,"auc")
auc_boost <- print(as.numeric(PBDboost.auc@y.values))

################################################################

# random forest
myrf<- randomForest(subscribed~., data=PBD.train, na.action=na.exclude)
myrf.pred <- predict(myrf,PBD.test)
confmatrix_rf = table(Predicted_Class=myrf.pred, Actual_Class=PBD.test$subscribed)
cat("\n#Random Forest confusion matrix\n")
print(confmatrix_rf)

# confusion matrix accuracy
accuracy_rf = (confmatrix_rf[1]+confmatrix_rf[4])/
              (confmatrix_rf[1]+confmatrix_rf[2]+
              confmatrix_rf[3]+confmatrix_rf[4])

mypred.rf <- predict(myrf,PBD.test,type="prob")

# mypred.rf
PBDrf.pred <- prediction(mypred.rf[,2],PBD.test$subscribed)
PBDrf.perf <- performance(PBDrf.pred,"tpr","fpr")

# plot curve
plot(PBDrf.perf,add=TRUE,col="darkgreen")

# get area under curve
PBDrf.auc <- performance(PBDrf.pred,"auc")
auc_rf <- print(as.numeric(PBDrf.auc@y.values))

# add legend
legend(0.65, 0.6, legend=c("decision tree", "naive bayes", "bagging",
      "boosting","random forest"),col=c("purple", "red", "orange",
      "blue","darkgreen"), lty=1, cex=0.8)

#####################################################################

#6
#create table for confusion matrix and AUC curve
#Area under the curve
Alltable <-matrix(c(auc_dectree,auc_nb,auc_bag,auc_boost,auc_rf,
                    accuracy_dt,accuracy_nb,accuracy_bag,
                    accuracy_boost,accuracy_rf),ncol=2)
rownames(Alltable) <- c("Decision Tree","Naive Bayes","Bagging","Boosting","Random Forest")
colnames(Alltable) <- c("AUC","Accuracy(Confusion Matrix)")
Alltable <- as.table(Alltable)
Alltable

############################################################################################

#7
# attribute importance
cat("\n#Decision tree attribute importance\n")
print(summary(itree))
cat("\n#Bagging attribute importance\n")
print(mybag$importance)
cat("\n#Boosting attribute importance\n")
print(myboost$importance)
cat("\n#Random forest attribute importance\n")
print(myrf$importance)


###############################################################

#8
# pruning decision tree
datafit <- cv.tree(itree,FUN=prune.misclass)
print(datafit)
plot(datafit)

prune.itree <- prune.misclass(itree, best=5)
print(summary(prune.itree))
plot(prune.itree)
text(prune.itree, pretty=0)

# test accuracy after pruning
afterprune.predict <- predict(prune.itree, PBD.test, type="class")
confusionMatrix(afterprune.predict, PBD.test$subscribed)
prunetable = table(Predicted_class=afterprune.predict,Actual_class=PBD.test$subscribed)
cat("\n#Decision tree confusion matrix after pruning\n")
print(prunetable)
newaccuracy_dt = (prunetable[1]+prunetable[4])/
                 (prunetable[1]+prunetable[2]+
                  prunetable[3]+prunetable[4])
# new accuracy after pruning
newaccuracy_dt
# old accuracy before pruning
accuracy_dt


