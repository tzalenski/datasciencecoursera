Description:

This webpage is designed to:

1. Read a data file containing a numeric vector in the first column. Data in other columns will
   be ignorged. See example "TestDataWithOutliers.txt"

2. Remove outliers as needed to reduce the kurtosis <= 1.0. The algorithm will stop when one or more of 
   the following conditions are true:
   a. Kurtosis <= 1.0
   b. number of values <= 20
   c. Skewness <= 0.001
   
3. Save the winsorized vector (only) to a user-specified output file