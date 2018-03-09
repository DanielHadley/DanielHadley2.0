---
layout: post
title: How to Build a Data Dashboard using R (knitr), HTML, and Javascript (e.g., Highcharts)
visible: 1
---

R has been the perfect language for the back end of [this](http://www.somervillema.gov/dashboard/daily.html) government data dashboard I am developing. 

+ It has excellent packages to pipe in data from every significant source 
+ Tools like dplyr and tidyr make cleaning and munging data trivial
+ It is ideal for automating analysis

In the R script that powers my dashboard, I have everything from simple averages and frequency tables, to a complex algorithm that converts timeseries figures to Z-Scores and then selects the top 3 variables to display based on standard scores from the last 7 days. (Today that happens to include an uptick in reports of dead animals on the streets and sidewalks, which is disgusting but useful to know).    

The reason I am writing this tutorial is to outline a method in the "knitr" package that I want to share because it opens up dozens of new tech stack combinations. The basic idea is to perform all of the data manipulations and analysis in R, and then "weave" it into popular Javascript visualization tools, like Highcharts, D3, and Leaflet. This is in contrast to the more traditional way of developing an R dashboard using Shiny. 

Here is an example in its simplest form. First, I will show some analysis in R, and then I will show how that fits into a .Rhtml file, which can be "woven" into HTML/Javascript and finally uploaded to your web server.  

{% highlight R %}
library(knitr)


# Load Data
dates <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
Tokyo <- c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)
London <- c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8)

# Calculate an average
mean_of_Tokyo <- mean(Tokyo)
mean_of_London <- mean(London)


## Now knit together the data and HTML ##
knit("./index.Rhtml", output = "./index.html")

# Now you can upload index.html to your server 

{% endhighlight %}

Now this is what your index.Rhtml file will look like, in it's most basic form. Here I am using Highcharts, but this could just as easily be D3 or any other charting library.

{% highlight HTML %}

<!DOCTYPE html>
<html>
<head>
<title>Page Title: Daily Dashboard</title>

<!-- Highcharts scripts -->
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

<script>
$(function() {
    $('#container').highcharts({
        title: {
            text: 'Monthly Average Temperature',
            x: -20 //center
        },
        subtitle: {
            text: 'Source: WorldClimate.com',
            x: -20
        },
        xAxis: {
            categories: [<!--rinline I(shQuote(dates)) -->]
        },
        yAxis: {
            title: {
                text: 'Temperature (°C)'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            valueSuffix: '°C'
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        series: [{
            name: 'Tokyo',
            data: [<!--rinline I(Tokyo) -->]
        }, {
            name: 'London',
            data: [<!--rinline I(London) -->]
        }]
    });
});  
</script>

</head>
<body>

<h1>This is a Heading: Check out These Average Temperatures!</h1>
<p>This is a paragraph. Check out this timeseries. Over the last 12 months, London had an average temperature of <!--rinline I(mean_of_London) --> while Tokyo had an average of <!--rinline I(mean_of_Tokyo) -->. Now here is a chart:</p>

<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

</body>
</html>

{% endhighlight %}

The parts to pay attention to are the ones in the HTML that say ```rinline I(X)```. These are the values from your R analysis that will get "woven in" to regular HTML using the Rhtml file. [Yihui Xie](http://yihui.name/knitr/), knitr's heroic creator, describes this method [here](http://yihui.name/knitr/demo/output/).

I created a repository [here](https://github.com/DanielHadley/DashboardTutorialR) that contains the simple example outlined above, plus the slightly redacted files that I use to power [our dashboard](http://www.somervillema.gov/dashboard/daily.html). The great thing is that Yihui has created a system where you can easily combine the analytical horsepower of R with virtually any charting library. 


## Bonus: Automate It

So now you have an R file for the analysis, which ends by creating HTML and uploading it to your web server. There are, of course, dozens of ways to set things up so that your R script gets called each day, hour, or however often you want your dashboard to update. At home, I use cron on a Raspberry Pi. But at work, I have found that the Task Scheduler program on Windows accomplishes this painlessly. I just schedule it to run the following .bat file every night at around 2 am: "C:\Program Files\R\R-3.1.2\bin\R.exe" CMD BATCH --vanilla --slave "C:\Users\myPath\DailyChartMaker.R" 




