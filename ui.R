
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(

  # Application title
  titlePanel("Red Butte Urban Water Quality Data"),
  

  # Sidebar with user input controls
  sidebarLayout( 
    sidebarPanel(
      selectInput(inputId='site', 
                  label ='Site', 
                  choices = list(sitename_900[1], sitename_1300[1]), 
                  selected = NULL, 
                  multiple = FALSE,
                  selectize = TRUE,
                  width = NULL, 
                  size = NULL),
      selectInput(inputId='param1', 
                  label ='Select Independent Variable (x-axis) to Plot', 
                  choices = list("Dissolved Oxygen" = 'Dissolved_Oxygen_mg/L',"Time" = 'time',
                                 "Temperature" = 'Temperature_C'),
                  selected = NULL), 
      selectInput(inputId='param2', 
                  label ='Select Dependent Variable (y-axis) to Plot', 
                  choices = list("Temperature" = 'Temperature_C', 
                                 "Dissolved Oxygen" = 'Dissolved_Oxygen_mg/L', "Time" = 'time'),
                  selected = NULL), 
      dateRangeInput("dates", label = h3("Date Range"), start = "2017-04-01 07:00:00", end = "2017-05-01 07:00:00"),
     
      selectInput(inputId='param3', 
                  label ='Select Variable for Comparison Plot From Red Butte Creek 1300 E and 1300 S 900W Site', 
                  choices = list("Temperature" = 'Temperature_C',
                                 "Dissolved Oxygen" = 'Dissolved_Oxygen_mg/L'),
                  selected = NULL),
      tableOutput("table"),
      hr(),
      fluidRow(column(4, verbatimTextOutput("value")))
      
    ),
    # Show outputs, text, etc. in the main panel
    mainPanel(
      textOutput("selected_var"),
      plotOutput("plot1"),
      textOutput("modelresults"),
      leafletOutput("mymap"),
      textOutput("selected_var2"),
      plotOutput("plot2"),
      plotOutput("plot3")
      
    )
  )
))
