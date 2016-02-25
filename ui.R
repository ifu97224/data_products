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
                                     p("NOTE:  Meta data file should have the following column headers: variable, variable_label, type"),
                                     p('To view sample .csv files and demo the tool',
                                       'you can download cars_data.csv and cars_meta_data.csv',
                                       a(href = 'https://github.com/ifu97224/', 'from my Github'),
                                       'and upload them'))
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
                            )))