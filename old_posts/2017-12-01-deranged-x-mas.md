---
layout: post
title: Deranged X-Mas - a Gift Exchange Puzzle
visible: 1
description: The solution to a puzzle using derangements in R. 
tags:
- Derangements
- Probability
- R
---

While planning a holiday gift exchange this week, my wife casually challenged me with a sort of tricky probability puzzle:

> Sara and I were talking today and realized that we were off by one on the rotation because last year we went sledding instead of buying gifts. 

> It should actually be:
> * Sara gives to Jonny
> * Jimmy gives to Thurop
> * Amy gives to Lisa
> * Jonny gives to Sara
> * Thurop gives to Jimmy
> * Lisa gives to Amy 

> So everyone is giving to the same person that is giving to them. How often will this phenomenon happen? Dan, give us a statistical analysis ASAP!

(Note: they do a rotation, but we will pretend it's random. Also, names *not* changed for privacy. I actually have a brother-in-law named Thurop, which is pretty cool.)

I fumbled around with permutations for a while before reading that situations like these are actually [derangements](http://mathworld.wolfram.com/Derangement.html) - permutations of sets where no element appears in its original position. In the case of a six sibling gift exchange, there are 265 derangements. So now we have the denominator.

The question is, of these derangements (I will never get tired of using that word, now that I know it), how many contain combinations where the siblings are mirrored, where each is assigned to the same person? To solve the puzzle, my friend Andrew and I took a three phase approach that we often use:

1. I try analytically and fail 
2. Andrew succeeds
3. I confirm his answer with brute-force programming

Andrew wrote, "I think the answer is 15/265. The denominator is a derangement, which are confusing as hell, but it is a type of permutation that is calculated: n! * Sum i = 0 -> n of ((-i)^n)/i!. The numerator I'm less sure about.I just counted the total ways that the matches would be mirrored. For person 1 and 6  to be matched there are 3 possibilities, and then there are 5 different people 1 could be matched with, so 5*3." 

The combinations with person 1, aka Sara, and person 6, aka Lisa, look like this:

* [(1,6)(2,5)(3,4)] 
* [(1,6)(2,4)(3,5)] 
* [(1,6)(2,3)(4,5)]

You can then repeat that chain with siblings 2, 3, 4, and 5.

To confirm, I started with all derangements and wrote a nested for-loop that looked for cases where the siblings are mirrored. The answer: 15/265, or approximately 5% of the time the gift exchange will work out the way it did this year. It's another festivus miracle!! 

{% highlight R %}
library(gtools)
library(tidyverse)

# First we get the derangements from the permutations
r <- 6
S <- 1:r
ders <- permutations(r, r, S)  
ders <- ders[apply(ders, 1, function(x) !any(x==S)),]

# This df is like a table 
# where the column name recieves from the row
ders <- as.data.frame(ders)
names(ders) <- c(1,2,3,4,5,6)

# start the counter
sibling_mirror <- 0

# iterate over rows of derangements
# and columns representing the recipient
for (giver in 1:nrow(ders)) {
  
  all_pairs <- list()
  
  for (recipient in names(ders)) {
    
    pair <- sort(c(ders[giver, recipient], recipient))
    
    all_pairs[[recipient]] <- pair
    
  }
  
  unique_pairs <- length(unique(all_pairs))
  
  # because I sort the pairs, 
  # if there are only 3 unique ones, that's a mirror
  if (unique_pairs == 3) {
    sibling_mirror = sibling_mirror + 1
  }
  
}

sibling_mirror / nrow(ders)

{% endhighlight %} 






