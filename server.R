#server.r for Course Project
library(shiny)
data(ChickWeight)
#Columns weight, Time, Chick, Diet
#subset data with only all 12 time datapoints and times 0, 10 21 (beg, mid, end)
df <- ChickWeight[!ChickWeight$Chick %in% c("18", "16", "15", "13", "8","44"),]
df <- df[df$Time %in% c(0, 10, 21),]
df$StudyTime <- ifelse(df$Time == 0, 1, ifelse(df$Time == 10,2,3))

#Create plots across StudyTime by Diet
shinyServer(
    function(input, output) {
        output$LineBoxPlot <- renderPlot({
            Diet <- input$DietChoice
            Chart <- input$ChartChoice
            dfsub <- df[df$Diet==Diet,]
            if (input$ChartChoice == "l") {
                   plot(dfsub$weight ~ dfsub$StudyTime, type="l", 
                        main=paste("Diet:",Diet), ylim=c(0,400), 
                        xlab="Study Timeline (1=beg, 2=middle, 3=end)",
                        sub="Each line is a Chick",
                        ylab = "Weight of Chick", xaxp=c(1,3,2))
                    }
            if (input$ChartChoice == "b") {
                boxplot(dfsub$weight ~ dfsub$StudyTime,  
                        main=paste("Diet:",Diet), ylim=c(0,400), 
                        xlab="Study Timeline (1=beg, 2=middle, 3=end)",
                        ylab = "Weight of Chick")
                    }
            })
        output$AllPlot <- renderPlot({
            #Create Line plots across StudyTime by Diet
            par(mfcol=c(1,4))
            for (i in 1:4) {
                idiet <- i
                dfsub <- df[df$Diet==idiet,]
                plot(dfsub$weight ~ dfsub$StudyTime, type="l", 
                     main=paste("Diet:",idiet), ylim=c(0,400), xlab="Study Timeline (1=beg, 2=middle, 3=end)",
                     ylab = "Weight of Chick",xaxp=c(1,3,2), sub="Each line is a Chick")
            }
            par(mfcol=c(1,1))
            
        })
        output$TestPlot <- renderPlot({
            #create t test and ANOVA functions for plot output
            #Determine if 2 or 3 Diets - summing values for Diet checks (1:1, 2:2, 3:5, 4:9)
            DietSum <- sum(as.numeric(input$Diets))
            Diets <- input$Diets
            Diets <- replace(Diets, Diets=="5", "3") #recode the 5 to be Diet 3
            Diets <- replace(Diets, Diets=="9", "4") #recode the 9 to be Diet 4
            Time <- input$Time
            alpha <- input$alpha
            
            if (DietSum %in% c(1,2,5,9)) 
                {plot(1, type='n',axes=F, xlab='', ylab='',main='Check at least 1 more Diet')}
            if (DietSum %in% c(8,12,15,16,17)) {
                #ANOVA
                #if only 3 Diets, need to remove one Diet from df
                if (DietSum == 16) {dfsub <- df[!df$Diet == "1" & df$StudyTime == Time,]}
                if (DietSum == 15) {dfsub <- df[!df$Diet == "2" & df$StudyTime == Time,]}
                if (DietSum == 12) {dfsub <- df[!df$Diet == "3" & df$StudyTime == Time,]}
                if (DietSum == 8) {dfsub <- df[!df$Diet == "4" & df$StudyTime == Time,]}
                if (DietSum == 17) {dfsub <- df[df$StudyTime == Time,]}
                
                fitaov<-aov(dfsub$weight~dfsub$Diet)
                x <- summary(fitaov)
                p <- round(as.numeric(x[[1]][5][[1]][1]), 4)
                F <- round(as.numeric(x[[1]][4][[1]][1]), 2)
                if (p < alpha) {maintitle <- "ANOVA: At Least One Pair Is Different"
                } else {maintitle <- "ANOVA: All Same"}
                maintitle <- paste(maintitle, "\n Study Time:",Time,"  F:",F,"  p-value:",p, sep="")
                y <- sort(by(dfsub$weight, dfsub$Diet, mean))
                #TukeyHSD(fitaov)
                # number of levels of x
                length <- length(y)
                # list of levels and their means
                list <- paste(names(y[1]),":",round(y[1],2),sep="")
                for(i in 2:length)
                {list <- append(list, paste(names(y[i]),":",round(y[i],2),sep=""))}
                ordDiet<-ordered(dfsub$Diet,levels=names(y))
                boxplot(dfsub$weight~ordDiet, col=c(2:(length+1)),
                        main=maintitle, xlab='Diet Means', ylab='Chick Weight',names=list)
                }
            if (DietSum %in% c(3,6,7,10,11,14)) {
                #Two-Sample t test
                #create col1 1st Diet and col2 2nd Diet
                col1 <- df$weight[df$Diet==Diets[1] & df$StudyTime == Time]
                col2 <- df$weight[df$Diet==Diets[2] & df$StudyTime == Time]
                
                #COMPARE TWO VARIANCES - F Test
                vtest <- var.test(col1,col2)
                if (vtest$p.value < alpha) {
                    vtestresult = FALSE
                }else vtestresult = TRUE 
                
                #COMPARE TWO MEANS - t Test
                ttest <- t.test(col1,col2,data=mpgam, var.equal = vtestresult)
                if (ttest$p.value < alpha) {
                    ttestresult = "Difference in Means"
                }else ttestresult = "No Difference in Means"
                
                boxplot(col1,col2, col=c("red","green"),
                        main=paste("Welch Two-Sample Test ( Variances Equal:",vtestresult,")\n","Study Time:",Time,"  Result:",ttestresult),
                        xlab=paste("Chick Weights  95% CI Diff:",round(ttest$conf.int[1],2),
                                   "to",round(ttest$conf.int[2],2)), ylab="Chick Weight",
                        sub=paste("t=",round(ttest$statistic,2), "p-val=",
                                  round(ttest$p.value,4)), names=c(paste('Diet', Diets[1],"Mean:",
                                    round(ttest$estimate[1],2)),paste('Diet', Diets[2],"Mean:",round(ttest$estimate[2],2))))
     
                }
        })
    }
)

