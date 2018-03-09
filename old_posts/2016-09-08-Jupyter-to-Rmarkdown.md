---
layout: post
title: From Jupyter Notebooks to R Markdown 
visible: 1
---

I started using Jupyter Notebooks back when they were called IPython. I even remember having to set up a virtual Linux environment because they were not available on Windows. As much as I have enjoyed their functionality, I recently switched entirely to R Markdown in an RStudio environment. Here's why. 

### Exporting to Github 
The [github_document](http://rmarkdown.rstudio.com/github_document_format.html) option in R Markdown is the perfect way to share your analysis over the web. Just write the markdown with R chunks, "knit" it, and commit everything to a repository, and RStudio will create a directory with all plots and outputs ready to view. One advantage Jupyter Notebooks used to hold was the aesthetic formatting of tables and dataframes on Github. But with the kable function in the knitr package, I have been able to output HTML tables that look just as clean.

I updated a previous Gist to show how this works [on Github](https://github.com/DanielHadley/Example-R-Markdown-on-Github/blob/master/Example.md). Compare that finished product with the raw code [here](https://raw.githubusercontent.com/DanielHadley/Example-R-Markdown-on-Github/master/Example.Rmd). 

### Exporting to Word is a breeze 
A lot of my analysis is for non-technical clients, many of whom are most comfortable with a Word doc. I have found the process of translating code to .docx to be exquisitely easy. The hardest part was inserting page breaks, but thankfully someone come up with a [clever hack](https://scriptsandstatistics.wordpress.com/2015/12/18/rmarkdown-how-to-inserts-page-breaks-in-a-ms-word-document/).  

### Version control
As [others](http://opiateforthemass.es/articles/why-i-dont-like-jupyter-fka-ipython-notebook/) have pointed out, version control of a Jupyther Notebook is not a straightforward process. R Markdown is all plain text, so changes are easy to track in Git. For the first time, I feel in control of changes made to my Word documents.

### RStudio 
I had the R kernel working nicely in Jupyter Notebooks. I did not encounter a lot of errors. But the entire time I was developing, I missed all of the features of RStudio. In particular, I missed having tab completion and the correct indentation on dplyr chains. But I also missed the layout with my environment, history, console, etc., not to mention the View() function on dataframes, and running code line-by-line. RStudio has become an amazing, feature-rich IDE, which I am not anxious to trade for another environment.

### Python is here (sort of)
At least since [2004](https://ironholds.org/blog/python-now-in-rstudio/), it is possible to run Python scripts in RStudio. There is even syntax highlighting and other IDE features. The nice thing is, the knitr library has support for [other languages](http://yihui.name/knitr/demo/engines/), so you can include Python chunks in, for example, your Word doc.

There are problems with this, as [u/_Wintermute noted](https://www.reddit.com/r/rstats/comments/51tzcb/why_i_switched_from_jupyter_notebooks_to_r/d7k3zvd). Apparently, the variables do not transfer between "chunks," let alone languages. The docs for the Python [language engine](http://rmarkdown.rstudio.com/authoring_knitr_engines.html) describe a data exchange, which is exciting, but it looks like you have to write the dataframe in one language and then read it in the other. These are not exactly seamless transitions. 

### Unknown Unknowns
I'm certain there are a lot of great features of both platforms that I am totally unaware of. And I still think Jupyter is doing more to integrate the various data science languages. It's possible I will switch back, but for now I seem to be getting more locked in to RStudio. At the moment I am researching how to convert my website into R Markdown. It just works really well.  

