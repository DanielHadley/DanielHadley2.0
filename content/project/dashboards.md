+++
# Date this page was created.
date = "2016-10-15"

# Project title.
title = "A Dashboard with Weak AI"

# Project summary to display on homepage.
summary = "Most dashboards display the same variables each day. I wanted something that was fresh - that changed based on spikes in the data."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "/dashboard.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["machine-learning", "R", "dashboard"]

# Optional external URL for project (replaces project detail page).
external_link = "http://www.somervillema.gov/dashboard/daily.html"

# Does the project detail page use math formatting?
math = false

+++

R has been the perfect language for the back end of [this](http://www.somervillema.gov/dashboard/daily.html) government data dashboard I am developing. 

+ It has excellent packages to pipe in data from every significant source 
+ Tools like dplyr and tidyr make cleaning and munging data trivial
+ It is ideal for automating analysis

In the R script that powers my dashboard, I have everything from simple averages and frequency tables, to a complex algorithm that converts timeseries figures to Z-Scores and then selects the top 3 variables to display based on standard scores from the last 7 days. (Today that happens to include an uptick in reports of dead animals on the streets and sidewalks, which is disgusting but useful to know).   

This blogpost describes the technical details, and the dashboard's repository is [here](https://github.com/cityofsomerville/SomervilleSystems).