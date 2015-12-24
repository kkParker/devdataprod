#Course Project
#ui.R file
library(shiny)
navbarPage(
    title='Course Project - Chick Weight Data - 12/24/15',
    tabPanel('Documentation', 
             h3('PURPOSE'),
             h5('The purpose of this Shiny App is to allow the user to do some exploratory
                viewing of the weights of chickens related to different diets they were on. 
                The App also allows for testing of differences in weights across Diets over time.'),
             h3('DATA'),
             h5('The data used for this example Shiny App is from the ChickWeights dataset in base R. The dataset has 578 observations of 4 variables. 
                The variables are: Weight, Time, Chick ID, and one of 4 Diets.'),
             h5('In order to help with the comparison of the data, observations were removed that did not have all
                of the data points.  In particular, it is limited to Chicks who had weight measurements at 3 different time 
                periods: beginning of the study, middle of the study, and end of the study. Therefore, there are 44 chicks left in the data set.'),
             h3('HOW TO USE'),
             h5('Click on one of the tabs to perform the following tasks with the Chick Weight data:'),
             h4('Documentation'),
             h5('This tab gives you information about and how to use the Shiny App.'),
             h4('Overview'),
             h5('This tab allows you to see a line graph for each Diet for all Chicks across the 3 Study time 
                periods: Beginning, Middle, and End.'),
             h4('Explore Diets'),
             h5('This tab allows you to drill-down in more detail to explore the chicken weights over time. 
                Choose a radio button for the Diet you want to view.  Also choose a radio button for the Chart Type (Box or Line) and then 
                click the Submit button.  The chart will update according to the options chosen.'),
             h4('Test Diets'),
             h5("This tab allows you to perform either a two-sample t-test or an ANOVA test.  
                The App will automatically perform the appropriate test based on the number of Diets
                that you choose to compare."),
             h5('Click the checkbox by each Diet that you want in your comparison. (If you only pick one Diet,
                it will ask you to choose at least one more when you hit Submit). Next choose the Study Time that you want to use to
                compare the Chicken Weights.  Since it will perform a statistical two-sample t test or an ANOVA
                choose the alpha level. It will allow you to choose a value between 0.01 and 0.25. Finally,
                click the Submit button. The chart will update according to the options chosen.
                Note that the Diet Means will be sorted from low to high in the graph.')
              ),
    tabPanel('Overview', plotOutput('AllPlot')),
    tabPanel('Explore Diets',
         sidebarPanel(
             radioButtons("DietChoice","Choose a Diet",
                           selected=1,
                           choices=c("Diet 1" = "1",
                                     "Diet 2" = "2",
                                     "Diet 3" = "3",
                                     "Diet 4" = "4")
                          ),
             radioButtons("ChartChoice","Choose a Chart Type",
                          selected="l",
                          choices=c("Line Plot" = "l",
                                    "Box Plot" = "b")
                          ),
             submitButton('Submit')
                     ),
          mainPanel(
              plotOutput('LineBoxPlot')
                    )
            ),
    tabPanel('Test Diets',
         sidebarPanel(
             h5('Compare the Weights of Chicks across 2, 3 or all 4 Diets'),
             checkboxGroupInput("Diets","Choose 2, 3 or 4 Diets",
                                c("Diet 1" = 1,
                                  "Diet 2" = 2,
                                  "Diet 3" = 5,
                                  "Diet 4" = 9)),
             radioButtons("Time","Choose a Study Time Period to Compare",
                      selected=1,
                      choices=c("Beginning: 1" = 1,
                                "Middle: 2" = 2,
                                "End: 3" = 3)
                      ),
             numericInput('alpha','Enter an alpha value for t-test/ANOVA',value=0.05, min=.01, max=.25, step=.01),
             submitButton('Submit')       
             ),
        mainPanel(
             plotOutput('TestPlot')
                )
        )
)

