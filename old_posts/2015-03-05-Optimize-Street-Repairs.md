---
layout: post
title: How to Optimize Street Repair Spending
visible: 1
---

Here's a problem governments are faced with every day: you have a limited amount of resources to maintain aging infrastructure, in this case streets. Do you spend more on crack sealing and preventive maintenance, or full depth reclamation? Which streets should you fix first? 

I am not an engineer (in fact, part of the reason I am writing this post is to get feedback from engineers); but I have thought a lot about this, and I think I have a decent method for prioritizing roadway repairs that anyone could implement using the open-source program [R](http://en.wikipedia.org/wiki/R_%28programming_language%29). The only prerequisites are that you have reliable data on the Pavement Condition Index (PCI) for the streets you want to optimize, and an estimate of what it would cost to do the repairs. Here is what the data I am using looks like:

![_config.yml]({{ site.baseurl }}/images/2015/StreetData.png) 

PCI is the current condition. New PCI is an estimate of the street's condition if we were to do the "PlanActivity," i.e., repair. The "value" column is just the delta between the old and new PCIs multiplied by the square yards of the street; And cost is total cost - not normalized by square yards. 

The basic idea is that we have an estimate of how much PCI will improve if we do the planned work, and a cost associated with that improvement. So all we have to do is select streets that will maximize the new PCI subject to an overall budget constraint.      

## MIP

In this case, the constraints and objectives are linear, but the selection variable is binary: whether you will fix the street or not. So to solve this problem we will use something called Mixed-Integer Programing (MIP). There are other possible solutions, such as an [0-1 Knapsack algorithmm](http://en.wikipedia.org/wiki/Knapsack_problem), but the advantage of MIP is that you can add constraints like "I need at least 2 streets to be full-depth reclamation."

Here is the code in R using a package called "Rglpk"

{% highlight R %}

library(Rglpk)

# number of variables
num.streets <- length(d$STREETNAME) 

# objective:
f <- d$value
# the variables are booleans:
# Either yes we pave the street, or no we don't
var.types <- rep("B", num.streets)
# the constraints
# Leaving out flex for now
A <- rbind(as.numeric(d$Functional == "CO - Collector"), # num collectors
           as.numeric(d$PlanActivi == "(BR) Recon/Reclaim Local w/ramps"), # num full-depth
           d$cost)                    # total cost

dir <- c(">=",
         ">=",
         "<=")

b <- c(32,
       3,
       3000000)


sol <- Rglpk_solve_LP(obj = f, mat = A, dir = dir, rhs = b,
                      types = var.types, max = TRUE)
sol

d$STREETNAME[sol$solution == 1]

toPave <- d[which(sol$solution == 1),]       

{% endhighlight %}

In this example, the algorithm takes three constraints: 

+ We must fix at least 32 collectors (arbitrary, I know)
+ We must reconstruct at least 3 streets
+ The total cost cannot exceed $3 million

Subject to those, it maximizes the new PCI.  

## Potential pitfalls

The upsides to this approach are obvious. A government agency can save millions by using PCI data to minimize costs and maximize repairs. There are at least two potential problems I see (apart from political ones). First, the new PCI is only an estimate. Prediction in this case is difficult, because data is somewhat scarce. I looked around forever to find good estimates of how different treatments increase PCI, but ultimately settled on some rules-of-thumb that a lot of engineers use - e.g., crack sealing increases by 25%. 

The first problem can be solved by more data. The second problem is more challenging. 

This approach returns an optimal strategy in year x. But what about year x + 1, and so on? It could be that by selecting a street for maintenance because it is optimal in x, you fail to pave a street that is on the verge of entering a new treatment band. This can be overcome by adding constraints like "at least N streets should be on the verge of needing more significant repairs." But ultimately there may be a more scientific method using time-series optimization. 

## Conclusion

That is a summary of my theoretical approach to street paving decisions. I would be very curious what real engineers have to say. 

You can follow along by downloading the data and code from my [Github account](https://github.com/DanielHadley/PCI_Code).  