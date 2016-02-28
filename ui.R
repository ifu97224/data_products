library(shiny)

shinyUI(navbarPage("Feature Explorer",
                   tabPanel("Import Data",
                            headerPanel("",
                                        tags$head(
                                          tags$img(src="coursera_logo.png", height=50, width = 200)
                                        )
                            ),
                            
                            fluidRow(
                              
                              column(12,
                                     h4("Import the data to explore..."),
                                     p("NOTE:  Meta data file should have the following column headers: variable, variable_label, type.  See help section for more details."),
                                     p('The tool has been set up to work with the mtcars dataset for demo purposes.  To view sample .csv files and demo the file upload 
                                        part of the tool you can download a main data file (cars_data.csv) and a meta data (cars_meta_data.csv)',
                                       a(href = 'https://github.com/ifu97224/data_products', 'from my Github'),
                                       'and upload them.'),
                                     br())
                            ),
                            
                            hr(),
                            
                            fluidRow(
                              
                              column(4,
                                     wellPanel(fileInput('main_data', 'Choose main data file to upload',
                                                         accept = c(
                                                           'text/csv',
                                                           'text/comma-separated-values',
                                                           'text/tab-separated-values',
                                                           'text/plain',
                                                           '.csv',
                                                           '.tsv'
                                                         )
                                     ),
                                     tags$hr(),
                                     checkboxInput('header1', 'Header', TRUE),
                                     radioButtons('sep1', 'Separator',
                                                  c(Comma=',',
                                                    Semicolon=';',
                                                    Tab='\t'),
                                                  ','),
                                     radioButtons('quote1', 'Quote',
                                                  c(None='',
                                                    'Double Quote'='"',
                                                    'Single Quote'="'"),
                                                  '"'),
                                     tags$hr())),
                              
                              column(8,
                                
                                h4("Data Preview:"),
                                tableOutput("main_data_preview")
                                
                              )),
                              
                              fluidRow(
                                
                              column(4,
                                     wellPanel(fileInput('metadata', 'Choose the metadata file to upload',
                                                         accept = c(
                                                           'text/csv',
                                                           'text/comma-separated-values',
                                                           'text/tab-separated-values',
                                                           'text/plain',
                                                           '.csv',
                                                           '.tsv'
                                                         )
                                     ),
                                     tags$hr(),
                                     checkboxInput('header2', 'Header', TRUE),
                                     radioButtons('sep2', 'Separator',
                                                  c(Comma=',',
                                                    Semicolon=';',
                                                    Tab='\t'),
                                                  ','),
                                     radioButtons('quote2', 'Quote',
                                                  c(None='',
                                                    'Double Quote'='"',
                                                    'Single Quote'="'"),
                                                  '"'),
                                     tags$hr())),
                              
                              column(8,
                                     
                                     h4("Data Preview:"),
                                     tableOutput("meta_data_preview")
                              
                              ))),
                            
                   tabPanel("Feature Plots",
                              
                             fluidRow(
                                
                             column(12,
                                    h4("Create plots of the data..."),
                                    p("Choose between Scatterplots, Boxplots and Histograms"))
                                    ),
                              
                              hr(),
                            
                              fluidRow(
                                column(5,
                                       wellPanel(
                                         
                                         radioButtons('plot_type', 'Choose Plot Type:',
                                                      c(Scatterplot='scatter',
                                                        Boxplot='boxplot',
                                                        Histogram='hist'),
                                                        inline = TRUE,
                                                        selected = 'scatter'))
                                       )
                              ),
                              
                              fluidRow(
                                
                                column(4,
                                       wellPanel(
                                         
                                         uiOutput("ui1")
                                         
                                )),
                                
                                column(8,
                                       plotOutput('explore_plot')
                                )
                              )
                            ),
                   
                   tabPanel("Help",
                            
                            fluidRow(
                              
                              column(12,
                                     h4("About the Feature Explorer App"),
                                     p("The Feature Explorer App allows a user to import a data file and create presentation quality visualizations
                                       including Scatterplots, Boxplots and Histograms.  The App also alows a user to import a meta data file so that 
                                       chart titles are displayed correctly and the variables used as factors can be defined."),
                                     br(),
                                     p('The tool has been set up to work with the mtcars dataset for demo purposes.  To view sample .csv files and demo the file upload 
                                        part of the tool you can download a main data file (cars_data.csv) and a meta data (cars_meta_data.csv)',
                                       a(href = 'https://github.com/ifu97224/data_products', 'from my Github'),
                                       'and upload them.'),
                                     br(),
                                     h4("Importing the Data"),
                                     p("Two files are required to be imported in order for the App to function:"),
                                     p("1.  Main Data File:  The file containing the data to be plotted"),
                                     p("2.  Meta Data File:  The file containing the meta data controlling which variables are to be used as factors as the descriptions to be used as chart titles"),
                                     br(),
                                     p("The meta data file must have the following columns (can be upper or lower case):"),
                                     p("variable = The variable name (column header of the main data file)"),
                                     p("variable_label = The variable description to be used for the chart titles"),
                                     p("type = Takes the values 'continuous' or 'factor'"),
                                     br(),
                                     p("Below is a sample of the meta data file from the mtcars dataset:"),
                                     tags$img(src="sample_meta_data.png", height=350, width = 450),
                                     br(),
                                     h4("Creating Plots"),
                                     p("The App allows the users to choose between three different plot types:"),
                                     p("1.  Scatterplots"),
                                     p("2.  Boxplots"),
                                     p("3.  Histograms"),
                                     br(),
                                     h5("1.  Scatterplots"),
                                     p("The App allows the user to choose any continuous X and Y variable, a factor color variable and a factor facet variable.  A linear smoother line can also be added"),
                                     h5("2.  Boxplots"),
                                     p("The App allows the user to choose any factor X variable and any continuous Y variable"),
                                     h5("3.  Histograms"),
                                     p("The App allows the user to choose any continuous variable to plot, set the number of bins and add a density curve")
                                     ))
                   
                   )))
