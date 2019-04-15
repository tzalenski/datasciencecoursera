library(shiny)
library(dplyr)
library(e1071)

#-------------------------------------------------------------------------------
# This function trims the outliers until one or more of these conditions are
# satisfied:
#  1. kurtosis    <= 1.0
#  2. data length <= 20
removeOutliers <- function( originalData )   # where X = data vector
{
    X <- sort( originalData )   # sort data in ascending order
    
    while( length(X) > 20 && kurtosis(X) > 1.0 )
    {
        if( skewness(X) < -0.0 )
            X <- X[ 2: length(X) ]   # remove max negative (first) element
        else 
            X <- X[ 1: length(X)-1 ] # remove max positive (last) value
    }
    X  # return winsorized data
}


#-------------------------------------------------------------------------------
#  This function plots a histogram of the data 
plotHistogram <- function( X, title )   # where X = data vector
{
    hist( X, density=20, col="green", breaks=50, freq=FALSE,
          main = paste("Histogram of ", title))
    
    curve( dnorm(x, mean=mean(X), sd=sd(X)),
           col="darkblue", lwd=2, add=TRUE, yaxt="n")
}

#-------------------------------------------------------------------------------
#  This function plots a QQ plot 
plotQQ <- function( X, title )   # where X = data vector
{
    qqnorm( X, main = paste("QQ Plot of ", title) )
    qqline( X, col = "red")    
}

#-------------------------------------------------------------------------------
# This function outputs a block of text showing statistics of data vector X
stats <- function( X, title )
{
    df <- data.frame( c("length", "mean", "stdev", "skew", "kurtosis"), 1:5)
    colnames(df)[1] <- "statistic"
    colnames(df)[2] <- paste( title, "value" )
    df[1,2] <- sprintf("%d", length(X) ) 
    df[2,2] <- mean(X) 
    df[3,2] <- sd(X) 
    df[4,2] <- skewness(X) 
    df[5,2] <- kurtosis(X) 

    df   # return data frame
}    

#-------------------------------------------------------------------------------
# Define server logic required to draw original and winsorized data plots
shinyServer(function(input, output)
{
    # this section of code is run whenever the input filename changes
    observeEvent( input$file1,
    {
        # abort if invalid filename
        if (is.null( input$file1 ))
            return(NULL)
        
        # attempt to read data file
        df <- read.csv( input$file1$datapath, stringsAsFactors=FALSE, header=FALSE )

        output$origDataTable <- renderTable( df[1:50,], bordered = TRUE)
        
        original_Data   <- df[,1] 
        winsorized_Data <- removeOutliers( original_Data )  
        
        origStats_df <- stats( original_Data, "Original Data" )
        output$originalHistogram    <- renderPlot( plotHistogram( original_Data,   "Original Data"   ))
        output$originalQqPlot       <- renderPlot( plotQQ(        original_Data,   "Original Data"   ))
        output$origStatsTable       <- renderTable( origStats_df, bordered = TRUE)
        
        winsorizedStats_df <- stats( winsorized_Data, "Winsorized Data" )
        output$winsorizedHistogram  <- renderPlot( plotHistogram( winsorized_Data, "Winsorized Data" ))
        output$winsorizedQqPlot     <- renderPlot( plotQQ(        winsorized_Data, "Winsorized Data" ))
        output$winsorizedStatsTable <- renderTable( winsorizedStats_df, bordered = TRUE)
    })
    
    
    # this section of code is rund whenever the output filename changes
    observeEvent( input$saveDataToFile,
    {
        # abort if invalid filename
        if (is.null( input$file1 ) || is.null( input$outputFilename ))
            return(NULL)
        
        # attempt to read data file
        df <- read.csv( input$file1$datapath, stringsAsFactors = FALSE )
        
        original_Data   <- df[,1] 
        winsorized_Data <- removeOutliers( original_Data )  
                     
        # attempt to write data file
        tablstr <- vector()
        for(i in 1:length(winsorized_Data))
        {
            tablstr[i] <- sprintf("%7.3f", winsorized_Data[i] )
        }
        write( tablstr, input$outputFilename )
    })
})
