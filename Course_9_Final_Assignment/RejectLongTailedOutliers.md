Reject Long Tailed Outliers From Gaussian Distributed Data
========================================================
author: Tom Zalenski
date: April 15, 2019
autosize: true

Overview
========================================================
For many sensors, it's common for data to have gaussian noise. However, occasionally spurious/erroneous values are collected that must be removed prior to analysis.
This application provides a simple algorithm to remove the extreme values in the tails, while preserving the gaussian distribution.

After sorting the input data vector in ascending order, the algorithm starts deleting the extreme most negative value if the skewness is negative, or the extreme most positive value if the skewness is positive.

This algorithm works best when:
- Number of samples > 100
- Percentage of ouliers < 50%
- Outliers are uncorrelated
- Kurtosis > 1.0

Outlier Reject Algorithm
========================================================


```r
library(e1071)
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
            X <- X[ 2: length(X) ]  # remove max negative (first) element
        else 
            X <- X[ 1: length(X)-1 ] # remove max positive (last) value
    }
    X  # return winsorized data
}
```

Histograms of original and winsorized data
========================================================

![plot of chunk unnamed-chunk-2](RejectLongTailedOutliers-figure/unnamed-chunk-2-1.png)

QQ-Plots of original and winsorized data
========================================================

![plot of chunk unnamed-chunk-3](RejectLongTailedOutliers-figure/unnamed-chunk-3-1.png)
