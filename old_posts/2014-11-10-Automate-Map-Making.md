---
layout: post
title: How To Automate Map Making in R
visible: 1
---

In my [last post]({{ site.baseurl }}/Mass-Election-Maps/), I displayed a series of maps from the 2014 Massachusetts midterm election. In all, I created 17 maps, all with fewer than 20 lines of code. Here's how...

The basic idea is to use a For Loop with ggmap to iterate through columns of a data frame. In my example, the code for which can be found [here](https://github.com/DanielHadley/MassElections/blob/master/MassElectionsFourteen.R), I first read shapefiles from MassGIS into R, and then combine them with election data. The rationale for these steps can be seen in Hadley's excellent [shapefile tutorial](https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles).  

{% highlight R %}

# First prepare the parcel df
mass <- readOGR(dsn="./shapefiles", layer="GISDATA_CENSUS2010TOWNS_POLY")
mass@data$id = rownames(mass@data)
names(mass)
mass.points <- fortify(mass, region="id")
mass.df <- join(mass.points, mass@data, by="id")


# Prepare data to match with MassGis layer
d$TOWN <- toupper(d$Municipality)

# Combine data
mass.df <- merge(mass.df, d, by="TOWN")

# Map
map <- get_map(location = "Grafton, Massachusetts", zoom=8, maptype="roadmap", color = "bw")
ggmap(map)

{% endhighlight %}

Now we have merged election data to the shapefile and prepared a Google base map in black and white that is focused on Grafton, MA (which happens to be close to the center of Massachusetts). Next, we will use this to make multiple choropleth maps of the election data.  

### Iteration: Let 1,000 maps flourish

This next part may not be too novel to people who are used to writing for loops, but by the time I had created my 5th map, I was glad it occurred to me. 27:46 are all columns (with descriptive names - you'll see why that is important in a moment) that I would like to see visualized on a map. The following loop uses the index from the column number to fill each city and town with a color representing the percent of votes received by the candidate. The gradient is chosen by ggmap based on the distribution of datapoints, but I set the color palette with the package RColorBrewer. 

For the title, the loop pastes the description along with the column names from the index number: {% raw %} colnames(mass.df)[[i]] {% endraw %}. Thus, the map is generated automatically for all columns from 27 to 46. It replaces "i" with the relevant number.  

{% highlight R %}

for(i in 27 : 46){
  ggmap(map) +
    geom_polygon(data=mass.df, aes(x=long, y=lat, group=group, fill=mass.df[,i]), colour=NA, alpha=0.7) +
    scale_fill_gradientn(colours=(brewer.pal(9,"YlGnBu")),labels=percent) +
    labs(fill="") +
    theme_nothing(legend=TRUE) + ggtitle(paste("Percent of Votes for ",colnames(mass.df)[[i]],sep=""))
  
  ggsave(paste("./plots/Map",i,".png",sep=""), dpi=300, width=6, height=5)
}

{% endhighlight %}

The final step in this loop is to save the map to a "plots" subdirectory, again with "i" to index the column number. 

#### Scalability 

I have done this with choropleth maps using ggmap, but in theory you could do it with point maps, heat maps, density maps, or any type of map that can take data from a column and iterate through subsequent columns. My next plan is to see whether I could make hundreds of maps of time-series data and combine them into a gif. I have always wanted to see how crime trends have shifted throughout the city over the last several years. 

I hope you also find this helpful.  


