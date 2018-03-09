---
layout: post
title: How a New MIT Professor Spent His Year
visible: 1
---

Last year, [my friend](http://web.mit.edu/polisci/people/faculty/rich-nielsen.html) pulled 34 all-nighters, surfed 37 days, swam 62, helped to raise two kids, did 12,920 push ups, worked a total of 3,008 hours as a new poli-sci professor, and tracked all of it in a spreadsheet. He averaged 8.2 hours of work per day, including weekends and holidays. As this heatmap shows, though, his hours varied a lot compared to us regular nine-to-fivers:

![_config.yml](https://raw.githubusercontent.com/DanielHadley/TimeProfessor/master/plotsForBlog/weeklyHeat.png)

It's interesting to read this chart both left to right, as an indicator of what weekdays he works hardest, and top to bottom, to see the days when he would push hard against a deadline and then give himself some time off to surf. It's also interesting to compare this to [other academics](http://www.reddit.com/r/dataisbeautiful/comments/2omblc/a_year_ago_today_i_started_my_phd_i_have_kept/) who have kept track of their hours. It seems like a profession with high variance in the workload.  
 
![_config.yml](https://raw.githubusercontent.com/DanielHadley/TimeProfessor/master/plotsForBlog/weekly.png)

Fortunately, he also found time to go camping and relax a bit over the summer. Nonetheless, 'summer break' included a fair amount of research and reading. And when he started teaching in the fall, things really picked up (despite the fact that he received an offer with a relatively light teaching load). On top of that, departmental 'service,' which is a catchall for everything from peer review to committee meetings and advising grad students, was also very time intensive.    

![_config.yml](https://raw.githubusercontent.com/DanielHadley/TimeProfessor/master/plotsForBlog/weeklyThree.png)

Naturally my friend did his own analysis before giving the data to me. In the comments to code he used to create a linear model testing his burnout factor, I found this gem:

{% highlight R %}

## interesting -- no evidence that big weeks tire me out.  Seems that low hour weeks are random
## but big weeks are associated with big weeks following them.  

{% endhighlight %}

Sometimes I worry I will lose my surf buddy to the all-nighters. But it may be too early to know, because as one of his other friends pointed out, "too much observational data, not enough experimentation." 