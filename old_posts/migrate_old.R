# This script will convert all old .md files from DH 1.0 into .Rmd ready for the new blog
# It transforms the existing files rather than making new ones, so I only ran this once 
# And then moved everything to the content folder of 2.0

library(blogdown)
library(tidyverse)

files = list.files(
  'old_posts', '[.](md|markdown)$', full.names = TRUE,
  recursive = TRUE
)

for (f in files) {
  blogdown:::process_file(f, function(x) {
    
    # Replace beginning R highlight
    # Remember to escape those special characters
    x = str_replace(x, "\\{% highlight R %\\}", "```\\{r eval=FALSE\\}")
    
    # And End
    x = str_replace(x, "\\{% endhighlight %\\}", "```")
    
    # Captions I can change later
    x = str_replace(x, "_config.yml", "")
    
    # site base url
    x = str_replace(x, "\\{\\{ site.baseurl \\}\\}", "")
    
    # site base url 2
    x = str_replace(x, "\\{\\{ site.baseurl \\}\\}", "")
    
    x 
  })
  
  # Just keep the title:
  # Tags are too hard and everything else is unneccessary
  blogdown:::modify_yaml(f,function(yaml) {
  }, .keep_fields = c(
    'title'
  ), .keep_empty = FALSE)
  
  # turn md to Rmd
  file.rename(from = f, to = str_replace(f, ".md", ".Rmd"))
  
}