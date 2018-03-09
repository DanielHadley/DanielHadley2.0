---
layout: post
title: Data Analysis of the 2014 Mass. Gubernatorial Election
visible: 1
---

Coakley received a lot of votes from residents of Massachusetts's major cities. This is evident in the maps I posted [last week]({{ site.baseurl }}/Mass-Election-Maps/), and in the charts below. What may be surprising is how many votes Baker received in cities, including Boston:

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot24.png)

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot23.png)

Baker received nearly 10,000 more votes in Boston than he did in 2010. If those had gone to Coakley instead, the spread between them would have been cut roughly in half.

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot09.png)

That is the raw vote count, here are the places where Baker saw the largest increase in percentage points:

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot12.png)

It's interesting that Quincy is the second highest in the Commonwealth on this measure. That is probably due in large part to Tim Cahill dropping from the 2014 race, although it may also have something to do with the democratic mayor's endorsement of Baker:   

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot10.png)

The only places where Baker lost percentage points relative to 2010 are in the northwest where Lively grabbed some votes, and on the Vineyard.   

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot11.png)

### Partisan Cities and Towns

Baker received a plurality of votes in the majority of towns. 

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot01.png)

But it was still a close call because Coakley won big in certain places, including a few where she received close to 80% of the vote. This histogram is the inverse of Baker's (above), but the bins are weighted by population:

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot05.png)

Nearly eight in ten people in Cambridge voted for Coakley. That is remarkable for such a large, diverse city.   

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot03.png)

In order to analyze this divide, I came up with a naive measure of each city and town's partisanship. I did this by taking the absolute value of the divide between Coakley and Baker, multiplying it by -1, and then adding the average percentage points for all independent candidates from the last two elections. There are probably more commonly used methods that work better, but this gives an idea of where the most "independent" cities and towns are (and, conversely, which places are the most partisan.)

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot13.png)

Here are the top 15 by population:

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot14.png)

You can see that this is just as much a measure of a strong divide within the place as it is a measure of "independence." Nonetheless, it does shed some light on which places could be said to be the most partisan:

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot15.png)

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot16.png)

The top republican strongholds all have populations under 20,000, while democratic places are a mix of inner cities and small towns. Interestingly, Boston did not make the top 15. 

### Aside: Social Qualities that Correlate   

Just for fun, I checked results against census data. There are not too many qualities of a municipality that have a detectable correlation to how that place votes, but here are a couple that I noticed.

Baker tended to do better in places with a high percentage of households with children under 18 ...

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot17.png)

... and in wealthier municipalities:

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot20.png)

But higher education was not correlated at all on the municipal level (sorry to anyone who wanted to ascribe the election results to education levels of towns and cities):

![_config.yml]({{ site.baseurl }}/images/2014_Elections/plot19.png)


### Conclusion

Election data is always enjoyable to analyze. There is nothing too novel in these results. I believe that most of the nuanced, actionable analysis comes from drilling deeper into surveys and trends at the local level. But it is still fun to see how the Commonwealth breaks down along party and class lines. Code and data to replicate my results can be found [here](https://github.com/DanielHadley/MassElections).    




