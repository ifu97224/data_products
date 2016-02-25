require(shiny)
require(rCharts)
require(datasets)
library(ggplot2)


shinyServer(function(input, output) {

  Data <- reactive({
          inFile1 <- input$main_data
           if (is.null(inFile1)) {
             return(null)
            }
    
    main_data <- read.csv(inFile1$datapath, header = input$header1,
                          sep = input$sep1, quote = input$quote1)
    
    inFile2 <- input$metadata
    if (is.null(inFile2)) {
      return(NULL)
    }
    
    meta_data <- read.csv(inFile2$datapath, header = input$header2,
                          sep = input$sep2, quote = input$quote2, stringsAsFactors = F)
    
    # extract the factor variables from the main data and convert to factor
    factor_vars <- subset(meta_data, toupper(type) == "FACTOR") 
    factor_vars2 <- as.character(factor_vars$variable)
    factor_vars3 <- as.data.frame(sapply(main_data[factor_vars2],as.factor))
    
    # extract the continuous variables
    continuous_vars <- subset(meta_data, toupper(type) == "CONTINUOUS") 
    continuous_vars2 <- as.character(continuous_vars$variable)
    continuous_vars3 <- as.data.frame(main_data[continuous_vars2])
    main_data <- cbind(factor_vars3,continuous_vars3)
    
    # set the data frames back together
    
    # add a factor row so that the facet and color variables can be none
    variable <- "none"
    variable_label <- "None"
    type <- "factor"
    add_none <- data.frame(variable,variable_label,type)
    meta_data <- rbind(meta_data,add_none)
    
    # create dataset to feed drop downs with continuous variables
    continuous_vars <- subset(meta_data, toupper(type) == "CONTINUOUS")
    continuous_choices <- setNames(continuous_vars$variable,continuous_vars$variable_label)
    
    # create dataset to feed drop downs with factor variables
    factor_vars <- subset(meta_data, toupper(type) == "FACTOR") 
    factor_choices <- setNames(factor_vars$variable,factor_vars$variable_label)
    
    all_data <- list(main_data = main_data,
                     meta_data = meta_data,
                     continuous_choices = continuous_choices,
                     factor_choices = factor_choices) 
    return(all_data)
                 
  })
  
  output$main_data_preview <- renderTable({
    
    inFile1 <- input$main_data
    if (is.null(inFile1)) {
      return(NULL)
    }
    
    main_data <- read.csv(inFile1$datapath, header = input$header1,
                          sep = input$sep1, quote = input$quote1,nrows = 10)
    
  })  
  
  output$meta_data_preview <- renderTable({
    
    inFile2 <- input$metadata
    if (is.null(inFile2)) {
      return(NULL)
    }
    
    meta_data <- read.csv(inFile2$datapath, header = input$header2,
                          sep = input$sep2, quote = input$quote2,nrows = 10)
  })  
  
  output$ui1 <- renderUI({
    
    # render UI for scatterplots
    if (input$plot_type == "scatter"){
      wellPanel( 
        selectInput("x_var", label = h5("Choose X Axis Variable"),  
                    choices = Data()$continuous_choices),
        selectInput("y_var", label = h5("Choose Y Axis Variable"),  
                    choices = Data()$continuous_choices),
        selectInput("color_var", label = h5("Choose Color"),  
                    choices = Data()$factor_choices),
        selectInput("facet_var", label = h5("Choose Facet Variable"),  
                    choices = Data()$factor_choices),
        checkboxInput("smooth", "Add Linear Smoothing Line", value = FALSE)
    )}
    
    # render UI for boxplots
    else if (input$plot_type == "boxplot"){
      wellPanel( 
        selectInput("box_x", label = h5("Choose X Axis Variable"),  
                    choices = Data()$factor_choices),
        selectInput("box_y", label = h5("Choose Y Axis Variable"),  
                    choices = Data()$continuous_choices)
      )}
    
    # render UI for histograms
    else if (input$plot_type == "hist"){
      wellPanel( 
        selectInput("hist_x", label = h5("Choose Variable to Plot"),  
                    choices = Data()$continuous_choices),
        sliderInput("hist_bins", h5("Select Number of Bins"), 2, 50, 5, step = 1, ticks = FALSE),
        checkboxInput("density", "Add Density", value = FALSE)
      )}
  })
    
  output$explore_plot <- renderPlot({
    
    # render scatterplot
    if (input$plot_type == "scatter"){
      
      nice_x <- subset(Data()$meta_data, variable == input$x_var)
      nice_y <- subset(Data()$meta_data, variable == input$y_var)
      nice_legend <- subset(Data()$meta_data, variable == input$color_var)
        
      title <- paste("Scatterplot of",nice_x$variable_label,"by",nice_y$variable_label,sep = " ")
      
      g <- ggplot(Data()$main_data,aes_string(input$x_var,input$y_var)) +
           geom_point() +  
           theme_bw(base_family = "Arial") + 
           ggtitle(title) + 
           xlab(nice_x$variable_label) + 
           ylab(nice_y$variable_label) +
           theme(axis.title.y=element_text(vjust=1), 
                 axis.title.x=element_text(vjust=-0.5),
                 plot.title=element_text(vjust=1))
    
           facets <- paste('.', '~', input$facet_var)
           if (input$facet_var != "none")
               g <- g + facet_grid(facets) +
                    theme(strip.background = element_rect(fill="orange"))
           
           if (input$color_var != 'none')
               g <- g + aes_string(color=input$color_var) +
                        theme(legend.position="bottom") +
                        scale_color_discrete(name=nice_legend$variable_label)
           
           if (input$color_var == 'none')
             g <- g + aes(color="orange") +
                      theme(legend.position = "none")
           
           if (input$smooth == TRUE)
               g <- g + geom_smooth(size = 1, linetype = 2, method = "lm", se = FALSE, color = "red") 
    }
    
    # render boxplot
    if (input$plot_type == "boxplot"){
      
      nice_x <- subset(Data()$meta_data, variable == input$box_x)
      nice_y <- subset(Data()$meta_data, variable == input$box_y)
      title <- paste("Boxplot of",nice_x$variable_label,"by",nice_y$variable_label,sep = " ")
      
      g <- ggplot(Data()$main_data,aes_string(input$box_x,input$box_y)) +
        geom_boxplot(fill="orange") +
        theme_bw(base_family = "Arial") + 
        ggtitle(title) +
        xlab(nice_x$variable_label) + 
        ylab(nice_y$variable_label) +
        theme(axis.title.y=element_text(vjust=1), 
              axis.title.x=element_text(vjust=-0.5),
              plot.title=element_text(vjust=1))
    }
    
    # render histogram
    if (input$plot_type == "hist"){
      
      nice_x <- subset(Data()$meta_data, variable == input$hist_x)
      title <- paste("Histogram of",nice_x$variable_label,sep = " ")
      
      g <- ggplot(Data()$main_data,aes_string(input$hist_x)) +
        geom_histogram(aes(y=..density..),fill = "orange", bins = input$hist_bins) +
        theme_bw(base_family = "Arial") + 
        ggtitle(title) +
        xlab(nice_x$variable_label) + 
        ylab("Count") +
        theme(axis.title.y=element_text(vjust=1), 
              axis.title.x=element_text(vjust=-0.5),
              plot.title=element_text(vjust=1))
      
      if (input$density == TRUE)
        g <- g + geom_density(color="black")
      
    }
    return(g)
  })
  
})
