

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Create a panel containing an application title
    titlePanel("Rejecting Long-Tailed Outliers from Gaussian Distributed Data"),

    # Layout a sidebar and main area
    sidebarLayout
    (
        # file open diaglog box
        sidebarPanel
        (
            fileInput("file1", "Enter input filename containing numeric data (in first column) with outliers. Example: 'DataWithOutliers.txt'",
                   accept = c(
                           "text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),

            textInput("outputFilename", "Enter filename to save output (without outliers) numeric data vector"),
            actionButton("saveDataToFile", "Save Output Data To File"),
            
            h5("-----------------------------------------------"),
            h5("Note: Outliers are removed until one or more of the follwing conditions is true:"),
            h5("a. data length <= 20"),
            h5("b. kurtosis <= 1.0"),
            
            h5("-----------------------------------------------"),
            h5("First 50 values in input file"),
            tableOutput( "origDataTable" )
        ),

        # Show a plot of the generated distribution
        mainPanel
        (
            tableOutput("origStatsTable"),
            plotOutput( "originalHistogram"),
            plotOutput( "originalQqPlot"),
            
            tableOutput("winsorizedStatsTable" ),
            plotOutput( "winsorizedHistogram"),
            plotOutput( "winsorizedQqPlot")
        )
    )
))
