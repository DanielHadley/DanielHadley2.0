+++
# Date this page was created.
date = "2014-11-02"

# Project title.
title = "Can Machine Learning Tell Two Fictional Characters Apart?"

# Project summary to display on homepage.
summary = "I wanted to see if it was possible to train a model to detect the difference between two fictional authors created by the same novelist based only on the frequency of common stop words, e.g., the, at, is"

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "/Gone-Girl.JPG"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["machine-learning", "R"]

# Optional external URL for project (replaces project detail page).
external_link = "http://danielphadley.com/Gone-Girl-Prediction/"

# Does the project detail page use math formatting?
math = false

+++


I wanted to see if it was possible to train a model to detect the difference between two fictional authors created by the same novelist based only on the frequency of common stop words, e.g., "the." It worked: The randomForest model correctly selected Nick 93% of the time and Amy 91%. 

### Background
When I first started using R for data analysis, I was mesmerized by all of the packages and what they made possible. This piece of analysis was one of my first experiments in text processing, machine learning and [stylometry](http://en.wikipedia.org/wiki/Stylometry) - all made accessible to me because of the open source work of thousands of people who came before me. The reason I selected this challenge in particular is because I once read an article that seemed to suggest that an author's "wordprint" - that is, the statistical variation in how frequently he or she uses common words - is similar to a finger print in the sense that it can be used to identify the author. I wanted to see if a clever author could create more than one linguistic "finger print" for her characters. 

Gone Girl, the bestselling novel that was recently adapted into a [film](http://www.rottentomatoes.com/m/gone_girl/) starring Ben Affleck, was the perfect proof of concept. The book is divided evenly into chapters narrated by the two leading characters, Nick and Amy. Could an ML algorithm differentiate between the two using only stop words? That mystery was just as intriguing to me as what happened to Amy.


### Results
As I mentioned in the opening paragraph, the randomForest model correctly selected Nick 93% of the time and Amy 91%. This was even better than I expected at the outset. It essentially means that if you were to strip the novel of all of its text, except for the ten or so filler words I trained on, a computer could still tell the fictional authors apart. It seems that the "wordprint" is not an immutable characteristic of the novel's actual author, Gillian Flynn, but rather something that changes in subtle, yet detectable ways, when the author is channeling her different characters. 

My code is available [here](https://github.com/DanielHadley/WordprintAuthorPrediction) for replication.     
