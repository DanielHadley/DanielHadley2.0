---
layout: post
title: The Prison Analyst's Dilemma - Using R to Model Recidivism
visible: 1
---

Recidivism, the rate at which those released from incarceration return or commit new crimes, is one of society’s most difficult social problems. The official estimate is that 55% of former prisoners will return within 60 months.

![_config.yml](https://static1.squarespace.com/static/57e1fc9c20099e1414dc6070/t/592890393e00bedb90f8b8da/1495830599102/?format=1000w)  

Recidivism is also, I discovered, one of the most challenging things to model and understand statistically. In this blog post, I describe our efforts to build [this simulation](https://daniel-hadley.shinyapps.io/Recidivism_App/), including how we settled on some fairly basic control structures (for loops) without giving up too much in terms of efficiency and readability. 

### A Common Problem
Recidivism is similar to many other types of social and ecological trends. There is a basic measurement - return to prison in our case, but it could also be website visits, weather patterns, bankruptcy, etc. But unlike, say, mortality rates, which can be modeled using [survivorship curves](https://en.wikipedia.org/wiki/Survivorship_curve), a return to prison is not the end. The vast majority of people who recidivate will return to society, and then a portion of that group will return to prison again, and so on for many cycles. 

If this phenomenon sounds familiar, you may have thought of some type of model you have used in the past. And we looked at many of these, from [Markov chains](http://setosa.io/ev/markov-chains/) to state-based models. What we settled on is similar to an agent-based model, but is as simple as two for loops. In pseudocode, it looks like,


{% highlight R %}

for(agent in 1:number_of_agents) {
  for(month in 1:number_of_months) {
    Keep track of how long the person has been free
    Calculate the odds of recidivating conditional on months free
    If the agent recidivates, assign a prison sentence 
  }
}

{% endhighlight %}

As you can see, this oversimplifies a lot. The “agents” don’t interact, and the probability of recidivating is conditional only on the time someone is free. But it does allow for multiple states, from freedom to prison and back again. And this - combined with the legibility of for loops - makes it easy to add complexity. In another variant of this model, for example, we also added parole sentences, adverse health outcomes, and many other variables.

The basic functionality can be visualized in this tweenr plot created by my colleague, Sam Nelson:

![_config.yml](https://raw.githubusercontent.com/Sorenson-Impact/Recidivism_App/master/www/model_output.gif)  

### For Hate
For loops are often pooh-poohed in the R community. They are thought of as slow and inferior to vectorized alternatives. Initially, I could see why. One of our more complex versions with 10,000 agents had build times of “let’s go out to lunch and see where it is when we get back.” When I wanted to do sensitivity analysis with multiple iterations, it was more like, “let’s sleep on it.” Even pared down, our initial version took 13 seconds.

That’s why I was grateful for Grolemund and Wickham’s chapter on iteration in “R for Data Science.” First, they eased my [r]eligious guilt about our model structure: “Some people will tell you to avoid for loops because they are slow. They’re wrong! (Well at least they’re rather out of date, as for loops haven’t been slow for many years).” 

Then they provided some useful tips that allowed me to reduce the build time from 13 seconds to 3, without which we could not have built an interactive app. These were simple, but effective: preallocate the output, declare the type of the vector, and save the results in a list, waiting to combine them into a single vector until after the loop is done.

### From Simple to Complex
I like this quote by the abolitionist Elizur Wright, “while nothing is more uncertain than a single life, nothing is more certain than the average duration of a thousand lives.” Recidivism trends are not as predictable, but I think that the same principle applies. That is why I like to build models that begin with very simple and uncertain functions, but that build to more tangible outcomes. 

I know that for loops do not come close to capturing the complexity inherent in social systems, but I like that that they mimic the hierarchy, from agents to averages. 

[Code](https://github.com/Sorenson-Impact/Recidivism_App)