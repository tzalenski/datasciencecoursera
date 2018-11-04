## This function creates a special "matrix" object that can cache its inverse by
## creating a special "matrix", which is really a list containing a function to
##
##    set the value of the original matrix
##    get the value of the original matrix
##    set the value of the inverse matrix
##    get the value of the inverse matrix
##
makeCacheMatrix <- function( matrx = matrix() ) {
    # initialize inverse to NULL  
    invrsMatrx <- NULL

	  # define function to save original matrix
    setMatrix <- function(y)
	  {
        matrx      <<- y
        invrsMatrx <<- NULL
    }
  
    # define function to retrieve original matrix  
    getMatrix <- function() { matrx }
	
	  # define function to save inverse of matrix
    setInverse <- function( invrs ) { invrsMatrx <<- invrs }
    
	  # define function to retrieve inverse of matrix
    getInverse <- function() { invrsMatrx }

    # return list of internal functions    
    list( setMatrix = setMatrix, getMatrix = getMatrix,
          setInverse = setInverse, getInverse = getInverse )
}


## This function computes the inverse of the special "matrix" returned by
## makeCacheMatrix above. If the inverse has already been calculated (and the
## matrix has not changed), then the cachesolve should retrieve the inverse from
## the cache.
cacheSolve <- function( cacheMatrx, ... ) {
	  invrse <- cacheMatrx$getInverse()

    # test for NULL    
    if( !is.null(invrse) )
	  {
        message("getting cached inverse")
        return( invrse )
    }
	
	  # calculate inverse
    matrx  <- cacheMatrx$getMatrix()
    invrse <- solve( matrx, ...)
    
	  # save inverse
    cacheMatrx$setInverse( invrse )
    invrse
}



