## Function contains a list of functions which allow to:
## 1. Set the value of matrix
## 2. Get the value of matrix
## 3. Set the value of inverse matrix
## 4. Get the value of inverse matrix

makeCacheMatrix <- function(x = matrix()) {
	inv <- NULL
	set <- function(y){
		x <<- y
		inv <<- NULL
	}
	get <- function() x
	setInv <- function(inverse) inv <<- inverse
	getInv <- function() inv
	list(set = set, get = get,
		setInv = setInv, getInv = getInv)
}


## Checks if given list x has calculated value of inverse matrix. 
## If yes, returns it
## If no, calculates inverse matrix with solve function and caches it into x

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
	inv <- x$getInv()
	if(!is.null(inv)){
		message('getting cached data')
		return(inv)
	}
	data <- x$get()
	inv <- solve(data, ...)
	x$setInv(inv)
	inv
}
