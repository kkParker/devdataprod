---
title       : Course Project
subtitle    : Examining Chicken Weights Tool
author      : KKParker
logo        : Poltava_chicken_breed_male2.png
framework   : revealjs        # {io2012, html5slides, shower, dzslides, ...}
revealjs    : {theme: sky, transition: cube}
mode        : standalone # {standalone, draft}
knit        : slidify::knit2slides
---

## Course Project
### Examining Chicken Weights Shiny App Tool
KKParker - 12/24/2015

<div style='text-align: center;'>
    <img height='100' src='Poltava_chicken_breed_male2.png' />
</div>

---
## PURPOSE
- The purpose of this Shiny App is to allow the user to do some exploratory viewing of the weights of chickens related to different diets they were on. The App also allows for testing of differences in weights across Diets over time.
- This App is useful because it is an example of the type of analysis and graphing capabilities you can do with R and it is implemented as a Shiny App.

- Shiny App: https://kkparker.shinyapps.io/CourseProject
- server.R and ui.R Code: https://github.com/kkParker/devdataprod
- Chicken picture from Wikipedia: https://en.wikipedia.org/wiki/Poltava_(chicken)

--- .class #id 

## Chick Weight Overview
- The data used for the project is from ChickWeight in base R. The data is processed as follows for this App.

```r
data(ChickWeight) #Records with 3 Study Times (Beg:0, Middle:10, End:21)
df <- ChickWeight[!ChickWeight$Chick %in% c("18", "16", "15", "13", "8","44"),] 
df <- df[df$Time %in% c(0, 10, 21),]
df$StudyTime <- ifelse(df$Time == 0, 1, ifelse(df$Time == 10,2,3))
```
- Note that the data tracks Chicks on 4 different diets. You can see the number of Chicks in each Diet

```r
table(df$Diet)
```

```
## 
##  1  2  3  4 
## 45 30 30 27
```
- The Overview tab shows a line chart of the Chick's weights over time. This gives you an idea of what you might want to compare in the other tabs.


--- 
## Explore Diets

- On this tab, you can view line or box plots of the data based on your choice of Diet. This is a box plot.

```r
dfsub <- df[df$Diet==4,]
boxplot(dfsub$weight ~ dfsub$StudyTime,  main="Diet 4",
 ylim=c(0,400), xlab="Study Timeline (1=beg, 2=middle, 3=end)",
 ylab = "Weight of Chick")
```

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3-1.png) 


--- 
## Test Diets

- On this tab, you can perform two-sample t tests or ANOVA comparing Diets at a certain Study Time. This shows an example of the ANOVA analysis.
![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-4-1.png) 



