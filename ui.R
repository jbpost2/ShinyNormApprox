###########################################################################
##R Shiny App to visualize normal approximations distributions
##Justin Post - Fall 2015
###########################################################################
  
#Load package
library(shiny)

# Define UI for application that draws the prior and posterior distributions given a value of y
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Normal Approximation App"),
  
  # Sidebar with a slider input for the number of successes
  fluidRow(
    column(3,br(),
      selectizeInput("dist",label=h3("Distribution"),selected="Binomial",choices=sort(c("Binomial","Poisson"))),
      numericInput("param1","Sample Size, n",value=30,step=1,min=1),
      conditionalPanel(condition= "(input.dist=='Binomial')",
      numericInput("param2","Probability of Success, p",value=0.5,step=0.01,min=0,max=1)),
      checkboxInput("overlay","Overlay Normal Distribution",value=FALSE),
     h3("Find Probability"),
     h5("P(Lower <= Y <= Upper)"),
     numericInput("probL","Lower limit",value=NULL),
     numericInput("probU","Upper limit",value=NULL),
     conditionalPanel(condition="(input.overlay)",
     checkboxInput("color","Shade Norm Approx",value=FALSE),
     checkboxInput("color2","Shade Continuity Correction",value=FALSE)
     )
      ),

    #Show a plot of the distribution  
    column(9,
           fluidRow(
           plotOutput("distPlot")
         ),
         fluidRow(
           tableOutput("probTable")
         )
    )
    )
))

