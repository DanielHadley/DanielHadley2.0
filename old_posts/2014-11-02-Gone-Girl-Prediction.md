---
layout: post
title: Using Machine Learning to Detect Stylometric Differences Between Nick and Amy in Gone Girl
visible: 1
---

I wanted to see if it was possible to train a model to detect the difference between two fictional authors created by the same novelist based only on the frequency of common stop words, e.g., "the." It worked: The randomForest model correctly selected Nick 93% of the time and Amy 91%. 

### Background
When I first started using R for data analysis, I was mesmerized by all of the packages and what they made possible. This piece of analysis was one of my first experiments in text processing, machine learning and [stylometry](http://en.wikipedia.org/wiki/Stylometry) - all made accessible to me because of the open source work of thousands of people who came before me. The reason I selected this challenge in particular is because I once read an article that seemed to suggest that an author's "wordprint" - that is, the statistical variation in how frequently he or she uses common words - is similar to a finger print in the sense that it can be used to identify the author. I wanted to see if a clever author could create more than one linguistic "finger print" for her characters. 

Gone Girl, the bestselling novel that was recently adapted into a [film](http://www.rottentomatoes.com/m/gone_girl/) starring Ben Affleck, was the perfect proof of concept. The book is divided evenly into chapters narrated by the two leading characters, Nick and Amy. Could an ML algorithm differentiate between the two using only stop words? That mystery was just as intriguing to me as what happened to Amy.

![_config.yml]({{ site.baseurl }}/images/Gone-Girl.JPG) 

### Preparing the Data
Fortunately for me, a [group of scholars](https://sites.google.com/site/computationalstylistics/) from Europe had created a terrific R script (now a package) that allowed me to do some initial analysis and divide the novel into a document-term dataframe, with rows for each chapter and columns for the frequency of each word. That is [authorship.txt](https://github.com/DanielHadley/WordprintAuthorPrediction/blob/master/GoneGirl%20/authorship.txt).

### Training the model
It was important to avoid using proper nouns or other words that would immediately give away the fictional author's identity. For instance, including "Nick" in the model would produce results that are blatantly obvious, even without an ML algorithm.

{% highlight R %}

library(randomForest)

setwd("~/Documents/Git/WordprintAuthorPrediction/GoneGirl ")

authorship <- read.delim("./authorship.txt")

# Set seed and divide the data into training and test
set.seed(123)
authorship$randu <- runif(63, 0,1)
authorship.train <- authorship[authorship$randu < .4,]
authorship.test <- authorship[authorship$randu >= .4,]

# The model: I tried to avoid all words that would be too predictive prima facie
authorship.model.rf = randomForest(author ~ the + a + to + and + of + it + was + in. + 
                                     that + on + for. + with + is + but + like + be + at + 
                                     so + this + have + what + not + as,
                                   data=authorship.train, ntree=5000, mtry=15, importance=TRUE)

# Make a prediction variable and tables of the outcome
authorship.test$pred.author.rf = predict(authorship.model.rf, authorship.test, type="response")
table(authorship.test$author, authorship.test$pred.author.rf)
prop.table(table(authorship.test$author, authorship.test$pred.author.rf),1)  

{% endhighlight %}

### Results
As I mentioned in the opening paragraph, the randomForest model correctly selected Nick 93% of the time and Amy 91%. This was even better than I expected at the outset. It essentially means that if you were to strip the novel of all of its text, except for the ten or so filler words I trained on, a computer could still tell the fictional authors apart. It seems that the "wordprint" is not an immutable characteristic of the novel's actual author, Gillian Flynn, but rather something that changes in subtle, yet detectable ways, when the author is channeling her different characters. 

My code is available [here](https://github.com/DanielHadley/WordprintAuthorPrediction) for replication.      