---
layout: post
title: Branding and Automating with R Markdown
visible: 1
description: summary of my rstudio conference talk  
tags:
- rstats
- rstudio::conf
- R
- markdown
---

Last week was the 2018 RStudio conference in San Diego, where my colleague Jon and I gave a talk about how we use R Markdown to quickly go from nothing, to analysis, to a branded report that we can pass off to clients. This workflow took some time to set up, but like most automation tasks, has ultimately saved us more time and headache than it cost. If you want to skip to the talk,

* [Here](http://rpubs.com/jzadra/rconf2018) are the slides
* [Here](https://github.com/Sorenson-Impact/rmarkdown-branding-talk/) is the repo with a short and long version
* [Here](https://www.youtube.com/watch?time_continue=21329&v=ogy7rHWlsQ8) is a video (complete with my cringeworthy Hadley joke)
* And [here](https://github.com/Sorenson-Impact/sorensonimpact) is the package we describe

## Ten Years Ago

These talks describe our current workflow, but I like to compare the present to the past. I have no way to quantify this, but I feel like R is uniqe in how quickly its packages and IDE have evolved the last few years. I'm sure there are other examples of this, but R must be in the upper quartile of ancillary developments, e.g., the Tidyverse, RStudio v1, Shiny, and our topic, R Markdown. In evolutionary terms, we skipped from Nintendo to Xbox One. 

![Alt Text](https://media.giphy.com/media/l41YlnP9H2SFPCdPi/giphy.gif)

When I began as an analyst in local government, there was no easy way to go from code to output. It was common to create a bunch of graphs with a vanilla R script and then painstakingly add them to either a word document or powerpoint. There were, of course, those who mastered LaTeX as part a painful dissertation writing process, but most people divided workflows between coding and presentation. 

Then came Knitr. Yihui's work to integrate R with HTML, LaTeX, Markdown and other formats opened up a plethora of possiblities. For instance, [I found a way](http://danielphadley.com/How-To-Dashboard-R/) to create a dashboard by knitting analysis into Rhtml. It was difficult to integrate the two, writing `<!--rinline I(data) -->` everywhere that took a vector. But that simple method has sustained a [city dashboard](http://archive.somervillema.gov//dashboard/daily.html) for years now. Without Yihui, I don't think any of this would have been possible.

Simultaneously, data science was advancing with iPython notebooks. For the first time, the notebook format closely integrated code and output, allowing analysts to see results in-line and easily share their work as HTML files. Modeled after the scientific process, notebooks took off, despite their challenges. When R Markdown Notebooks came along and [solved things](http://danielphadley.com/Jupyter-to-Rmarkdown/) like version control, it was a monumental improvement.      



We recently wanted to brand several of our plots for publication in the local press. I looked around and found a [couple](https://stackoverflow.com/questions/12463691/inserting-an-image-to-ggplot-outside-the-chart-area) [suggestions](https://stackoverflow.com/questions/41574732/how-to-add-logo-on-ggplot2-footer) on how to add images to plots, but nothing that seemed modular or customizable. My colleague reccomended the relatively new [Magick package](https://cran.r-project.org/web/packages/magick/vignettes/intro.html), which provided all of the functionality I needed (plus a lot more). Here is a simple example along with the code to replicate it:

![_config.yml]({{ site.baseurl }}/images/Cars.png)     


{% highlight R %}
library(ggplot2)
library(magick)
library(here) # For making the script run without a wd
library(magrittr) # For piping the logo

# Make a simple plot and save it
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point() + 
  ggtitle("Cars") +
  ggsave(filename = paste0(here("/"), last_plot()$labels$title, ".png"),
         width = 5, height = 4, dpi = 300)

# Call back the plot
plot <- image_read(paste0(here("/"), "Cars.png"))
# And bring in a logo
logo_raw <- image_read("http://hexb.in/hexagons/ggplot2.png") 

# Scale down the logo and give it a border and annotation
# This is the cool part because you can do a lot to the image/logo before adding it
logo <- logo_raw %>%
  image_scale("100") %>% 
  image_background("grey", flatten = TRUE) %>%
  image_border("grey", "600x10") %>%
  image_annotate("Powered By R", color = "white", size = 30, 
                 location = "+10+50", gravity = "northeast")

# Stack them on top of each other
final_plot <- image_append(image_scale(c(plot, logo), "500"), stack = TRUE)
# And overwrite the plot without a logo
image_write(final_plot, paste0(here("/"), last_plot()$labels$title, ".png"))
{% endhighlight %}

You can see that this creates a logo centered on a grey background with an annotation originating in the northwest of the band. I wanted to put our logo on the bottom right, 538 style, so I added some superfulous canvas on the right of the png and then croped it to fit our plots with Magick. The point is, Magick is highly customizable and opens up a lot of options that were previously closed to all but the undaunted photoshoppers. Want Vincent Vega to point at your x-axis? Go for it! Now, if you'll excuse me, I'm going to go home and have a heart attack.  

![_config.yml]({{ site.baseurl }}/images/Cars_Travolta.gif) 

{% highlight R %}
# Now call back the plot
background <- image_read(paste0(here("/"), "Cars.png"))
# And bring in a logo
logo_raw <- image_read("https://i.imgur.com/e1IneGq.jpg") 

frames <- lapply(logo_raw, function(frame) {
  image_composite(background, frame, offset = "+70+800")
})

animation <- image_animate(image_join(frames))


image_write(animation, "~/Cars_Travolta.gif")
{% endhighlight %}






