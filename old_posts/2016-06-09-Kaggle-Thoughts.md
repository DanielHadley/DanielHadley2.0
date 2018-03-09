---
layout: post
title: Lessons From My First Kaggle Contest
visible: 1
---

[Kaggle](https://www.kaggle.com) is a forum for interacting with other data scientists and competing to see who can write code that will best predict features of data. It's a way to test your skills at statistics and machine learning, and to do a lot of human learning in the process (sorry, bad pun). 

When I entered the contest to categorize crimes that occurred in San Francisco, my initial goal was to do better than random chance. I had some domain expertise from my time working with the Somerville Police Department, but I still worried that I would not be able to beat basic benchmarks for crime prediction. Over time, my goals shifted from making it out of the bottom quartile, to scoring above the median, until I finally made it into the top 10% and set my sights on winning. In the end, I ranked 7th out of 2,335 competitors. 

There was no prize money in this contest, and I borrowed liberally from others' ideas, so more than the ranking, I got involved to learn new things about data science.     

### Feature Engineering

Put simply, this is the process of taking rows and columns of data, and making new ones that make the predictive models more powerful.  For example, one of the most important features in the contest to categorize crime is when it was reported. Did it take place on a week, or weekend? Was it reported at the same time as another crime? Did it occur during the day, or at night? Answers to these questions were hiding in rows and columns of data, and my most productive time was spent discovering them. 

It's cliche, but feature engineering ended up mattering much more than model selection or parameter tuning. This is also where I had a slight edge, having sat through dozens of CompStat meetings with the Chief, his command staff, and a really good crime analyst.      

### Models

In the end, I broke my task up into two R scripts: 

1) engineer_features.R
2) build_models.R

XGBoost (which a work friend pointed out sounds like a bad energy drink) ended up being every bit as powerful and simple as many data scientists describe it. From the time I started to use it instead of other popular algorithms, my errors started to decrease significantly.  

I created a method of iterating through a list of each crime and building a separate model to predict only that crime. This would often work better than the models that I trained on the entire set of categories. Here is some pseudocode to demonstrate the concept: 


{% highlight R %}

# The list to iterate over
crime_categories <- c(levels(train$Category))

for (crime in 1:length(crime_categories)) {
  
  category_to_model <- crime_categories[crime]
  
  # Get it ready for the model
  train_final %>% 
    mutate(category_binary = ifelse(Category == category_to_model, 1, 0))
    
  
  xgboost_model <- xgboost(param = param, data = train_final[, -c(26)], label = train_final[, c(26)], 
                           nrounds = nrounds_vector[crime])
  
  # Predict
  pred <- predict(xgboost_model, test_final)
  
  prob <- matrix(pred, ncol = 1, byrow = T)
  prob <- as.data.frame(prob)
  colnames(prob)  <- category_to_model
  prob$Id <- as.numeric(seq(1 : 884262) -1)
  
  final_predictions[,crime + 1] <- prob[,1]
  
}

{% endhighlight %}


In the final hours of the contest, I also combined the results of several different submissions. Together, they did better than any single submission. 

I made a lot of mistakes along the way, from overfitting dozens of models to accidentally purchasing a surfeit of storage on Amazon Web Services. These were instructive, though, and I feel that the process gave me a more nuanced view of how computers learn from the code and data that we feed them.  

