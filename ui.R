###########################################################################
##R Shiny App to visualize normal approximations distributions
##Justin Post - Fall 2015 (updated 2017)
###########################################################################
  
#Load package
library(shiny)
library(shinydashboard)

# Define UI for application that displays an about page and the app itself

dashboardPage(skin="red",
  
  #add title
  dashboardHeader(title="Normal Approximation Application",titleWidth=700),

  #define sidebar items
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "about", icon = icon("archive")),
    menuItem("Application", tabName = "app", icon = icon("laptop"))
  )),

  #define the body of the app
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "about",
        fluidRow(
          #add in latex functionality if needed
          withMathJax(),

          #two columns for each of the two items
          column(6,
            #Description of App
            h1("What does this app do?"),
            #box to contain description
            box(background="red",width=12,
              h4("A commonly used technique when finding discrete probabilities is to use a Normal approximation to find the probability.  This app is designed to display differences between probability calculations using the exact probability from the probability mass funciton, using a Normal approximation, and using a Normal approximation with a continuity correction."),
              h4("These differences are found numerically and displayed graphically for either the Binomial distribuiton or the Poisson distribution.")
           )
          ),
          
          column(6,
            #How to use the app
            h1("How to use the app?"),
            #box to contain description
            box(background="red",width=12,
                h4("The controls for the app are located to the left and the visualization and probability calculations (if requested) are available on the right."),
                h4("To choose the exact distribution you can use the drop down menu under the distribution heading.  If you choose the Binomial distribution, you are then able to change the sample size and probability of success below.  If you choose the Poisson distribution, you can choose the mean parameter."),
                h4("On the bottom left you can ask for a probability calculation to be performed.  Both the lower and upper limit must be given for a calculation to be done."),
                h4("A checkbox below the lower left of the graph allows you to add a normal approximation to the graph.  This will display the normal curve as assumed by large-sample theory."),
                h4("If you have the overlay selected and a probability calculation requested you can also shade in regions of the graph corresponding to the normal approximation and/or the normal approximation with a continuity correction.")
            )
          )
        )
      ),

      #actual app layout      
      tabItem(tabName = "app",
        
        fluidRow(
          #This will be the left side of the app (3 of 12 width)
          column(3,br(),
            #Input for distribution
            selectizeInput("dist",label=h3("Distribution"),selected="Binomial",choices=sort(c("Binomial","Poisson"))),

            #Input for parameters depending on which distribution
            numericInput("param1","Sample Size, n",value=30,step=1,min=1),
            conditionalPanel(condition= "(input.dist=='Binomial')",
              numericInput("param2","Probability of Success, p",value=0.5,step=0.01,min=0,max=1)
            ),
            
            #Finding probability section
            h3("Find Probability"),
            h5("P(Lower <= Y <= Upper)"),
            numericInput("probL","Lower limit",value=NULL),
            numericInput("probU","Upper limit",value=NULL)
          ),

          #Right side of app (9 of 12 width)
          column(9,
            fluidRow(
              #Show a plot of the distribution
              plotOutput("distPlot")
            ),
            fluidRow(
              #Place checkboxes for overlays with probability calculations to the right
              #Check boxes take up 4 of 12
              column(4,
                fluidRow(
                  #Add checkboxes
                  checkboxInput("overlay","Overlay Normal Distribution",value=FALSE),
                  conditionalPanel(condition="(input.overlay)",
                    checkboxInput("color","Shade Normal Approximation to Probability",value=FALSE),
                    checkboxInput("color2","Shade Continuity Correction",value=FALSE)
                  )
                )
              ),
              #spacer column (need total of 12)
              column(2),
              #probability table output section
              column(6,
                fluidRow(
                  tableOutput("probTable")
                )
              )
            )
          )
        )
      )
    )
  )
)

