---
layout: post
title: Data Science vs City Rats
visible: 1
---

*Somerville, MA has been fighting a war against rats for months, and now we have the data to show that it's working: reported sightings have dropped 66% year-to-date; some of that is due to weather patterns and random fluctuation, but a Bayesian model of the data estimates that the City's policies have reduced calls by 40%.*

Three years ago, the city where I work was dealing with an onslaught of rats. Like its neighbor Boston, Somerville had just emerged from one of its mildest winters in history. [Winter Storm Juno](http://en.wikipedia.org/wiki/January_2015_North_American_blizzard) alone dumped more than three times as much snow on the region than was recorded during the entire winter of 2011-2012. And as a result, the rodent population seemed to grow out of hand that spring. 

At the time, I directed the Mayor's Office of Innovation and Analytics. Calls to Somerville's 311 line complaining about rodents were up 65%. Residents looked to Mayor Curtatone for help.

![_config.yml](https://raw.githubusercontent.com/DanielHadley/2015_Rats_Boston_Somerville/master/plots/Fig1_Somerville_Calls.png) 

I recall riding in the back seat of a vehicle while the Mayor rode shotgun. He would say things like, "My friend John told me they have a problem on Pearl Street." And, "my barber saw an infested dumpster over there." 

With each stop, we would compare our findings with maps from the 311 calls, making note of the hot spots.

## RAT

Having data from the 311 line made a huge difference. The calls don't tell you everything; but when we combined that data with information from our health inspectors, a clearer picture emerged. 

We convened a group we called the Rodent Action Taskforce (yes, "RAT"). There were public health professionals, data analysts, ISD and DPW workers, and strong support from the Mayor and other elected officials. Data was central to these meetings. 

As Denise Taylor the communications director put it, "every city has a rat problem. We have a rat plan."

## Some Solutions that Worked

At RAT meetings, participants would look at maps and charts to determine where the problem properties were located.

It was clear we had to cut off food supplies. The inspectional services director ramped up trash tickets, and made a case for adding new personnel to inspect and certify dumpsters more often. This alone seems to have had a significant impact. Private dumpsters that once remained unchecked for weeks or even months were now being issued tickets for overflowing trash. 

In addition, we purchased [specialized 64-gallon barrels](https://thesomervillenewsweekly.files.wordpress.com/2014/05/20140515-144539.jpg) for every property in the City. Before, trash day meant seeing a hodgepodge of cans and barrels, many too small for the amount of trash they were holding. We did a visual survey of random streets on trash day, and then used that along with data on total tonnage to model the distribution of gallons per household. We estimated that while the average load is more like 33 gallons, there were enough outliers (~ 10% of households > 65) that we needed larger barrels to accommodate everyone. The estimates proved correct, and we were glad that we chose 64-gallon barrels as the default. 

We even considered testing a rat sterilization program. But between the trash inspections, cleaning, and a major outreach effort, it was difficult to find infested sites by the time a team of sterilization experts had arrived. 

## The Results

In an ideal world, we would have been able to choose neighborhoods at random and perform controlled trials of our interventions. There is a maxim, often associated with the [Rubin causal model](http://en.wikipedia.org/wiki/Rubin_causal_model), "no causation without manipulation." And while I agree in principal, in practice this was a case where it was more important to act on a citywide scale and hope to see results. 

Fortunately, we had an excellent counterfactual. They were right across the river, and subject to many of the same variables, creating time-series data that was closely correlated. In the absence of an RCT, the best way to test whether our program worked or not was to compare our data to that of Boston. 

![_config.yml](https://raw.githubusercontent.com/DanielHadley/2015_Rats_Boston_Somerville/master/plots/Fig2_Somerville_v_Boston_Calls.png) 

I used a specialized tool developed by data scientists at Google called "CausalImpact." Using Bayesian structural time-series models, this R package predicts what the data would have looked like in the absence of an intervention (in this case, our policies). I'm not certain the assumptions were strictly met, but I think we came as close [as possible](http://google-opensource.blogspot.com/2014/09/causalimpact-new-open-source-package.html).       

The results were amazing. After implementing our new programs, calls dropped by an estimated 40%. There is a large confidence interval, meaning it's possible the effect was much larger or smaller, but it does appear very likely that the set of policies Somerville enacted were effective.  

![_config.yml](https://raw.githubusercontent.com/DanielHadley/2015_Rats_Boston_Somerville/master/plots/Fig3_CausalImpact.png) 


## Takeaways

Like every city in the region, Somerville will always have a rat problem. But these results show that a city can fight back by using data-informed policies. 

Because we did not test individual interventions, we cannot be certain which one of our policies had the greatest impact. My colleague Skye Stewart and I think that dumpster enforcement and certification along with the uniform trash barrels played the largest part. But outreach efforts from the elected officials and city communications department were also critical. Either way, we feel one lesson is clear for cities who wish to get rid of rodents: try to eliminate food sources.  

You can view the data and code I used [here](https://github.com/DanielHadley/2015_Rats_Boston_Somerville).
