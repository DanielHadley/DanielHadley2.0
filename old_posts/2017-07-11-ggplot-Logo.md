---
layout: post
title: How to Add a Logo to ggplot by Magick
visible: 1
---

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






