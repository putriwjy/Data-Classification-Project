# Data-Classification-Project

## The classification goal is to predict whether a client will subscribe (yes or no).

The Bank Marketing Data Set is a summary of the direct marketing campaigns of a
Portuguese banking institution. The data used is a modified version of the original data
set, which is part of the UCI Machine Learning Repository:
https://archive.ics.uci.edu/ml/datasets/bank+marketing

_________________________________________________________________________________

## Results

## Introduction

The purpose of this assignment is to create classification models for a data set
containing summary of the direct marketing campaigns of a Portuguese Bank. The
classification models will predict if a client will subscribe or not.

## Data Analysis
### Data Cleaning

The data is checked to see if it is complete and found that there are 6756 missing
cells. I removed the rows containing NA values because they would not add
anything valuable to the data sets. I chose not to replace the missing values because
for categorical data, choosing mode or mean to replace NA is biased toward the
data that appeared most. Also, even when other methods such as predictive mean
matching or classification and regression trees are used to impute the missing
values, it is still not 100% accurate. I think it is better to work with data set that I
know for certain is 100% accurate.

### Data Summary
Based on a sample of 1000 containing 17 variables the proportion of client who
subscribed is 123 while proportion of client who do not subscribed is 877

![Screenshot](/img/summary.png)

The average age of clients of the bank is 40.65, and deviates from the mean by
10.64. The average number of contacts performed during a campaign for each client
is 2 contacts, rounding off the value. The mean balance for clients is 1362 euros, and
deviates from the mean by 3326.68 euros.

## Classification Models
The sample data is divide into training set (70% of data) and test set (30% of data) to
create classification models.

### Decision Tree

![Screenshot](/img/summary.png)

The decision tree in figure 1 has 24 branch with 8 of them are “yes” for subscribed and 16
are “no” for subscribed.

### Accuracy of Models using Confusion Matrix

![Screenshot](/img/modelaccuracy.png)

Accuracy is the ratio of correct predictions and total predictions made. Based on table 2,
random forest has the highest accuracy, followed by naive bayes. Boosting and bagging have
the same accuracy while decision tree has the lowest accuracy

### ROC Curve for All Models

![Screenshot](/img/ROCcurve.png)

From the ROC curve, random forest has the highest curve, followed by naïve bayes,
boosting and bagging. Decision tree has the lowest curve. The result of all five models are
better than a ‘random’ classifier.

![Screenshot](/img/ROCarea.png)

AUC shows the ability of the model to discriminate between clients who subscribed and do
not subscribed. Table 2 shows the AUC of each model and random forest has the highest AUC,
which is 0.8972. AUC of naïve bayes and boosting are similar, while decision tree has the lowest
AUC, which is 0.7469

### Comparison of Results from Confusion Matrix Accuracy and AUC

![Screenshot](/img/comparison.png)

From table 4, decision tree has the lowest accuracy, 0.8233, compared to the rest which are higher.
Decision tree also has the lowest AUC among the models. Random forest has the highest Accuracy
and AUC. The AUC of decision tree is still in the range of acceptable discrimination while AUC of the
other four models are in the range of excellent discrimination.

### Most Important Variables for Each Models

![Screenshot](/img/attributes.png)

For bagging, boosting, and random forest, I assume the variables are important if the value is 10 or
more.

### Pruning Decision Tree

I decided to prune my decision tree to reduce the complexity of my original tree and improve the
accuracy.

![Screenshot](/img/afterpruning.png)

Figure 3 shows the decision tree after pruning. It has 5 branches, compared to the original one which
contains 24 branches. The reason I choose 5 is because it has the least number of misclass to
improve accuracy

![Screenshot](/img/confusionmatrix.png)

The original accuracy is 0.8233
The accuracy of decision tree after pruning is
= (246+9)/(246+9+11+34)
= 0.85
Which is higher than the original accuracy by 0.0267. The variables used for pruning are duration,
month, balance, and job.

## Conclusion

All the classification models have good accuracy and AUC, with some obviously better than
others. Random forest has the highest accuracy and AUC while decision tree has the lowest
accuracy and AUC. The AUC of decision tree is in the range of acceptable discrimination while
AUC for the rest are in the range of excellent discriminant.
One reason decision tree has the lowest accuracy and AUC might be overfitting (model Is
excessively complex). To reduce the complexity, the decision tree is pruned, reducing the
branches from 24 to 5. The accuracy increased from 0.8233 to 085, meaning that pruning
improves the accuracy by a bit


