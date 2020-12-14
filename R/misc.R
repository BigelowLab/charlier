#' Perform grepl on multiple patterns; it's like  AND-ing or OR-ing successive grepl statements.
#' 
#' Adapted from https://stat.ethz.ch/pipermail/r-help/2012-June/316441.html
#'
#' @param pattern character vector of patterns
#' @param x the character vector to search
#' @param op logical vector operator back quoted, defaults to `|`
#' @param ... further arguments for \code{grepl} like \code{fixed} etc.
#' @return logical vector
mgrepl <- function(pattern, x, op = `|`, ... ){
   Reduce(op, lapply(pattern, grepl, x, ...))
}

#' Compute the union of a list of vectors
#' 
#' @param x a list of zero or more vectors
#' @return a vector of the union or NULL is the input is empty
munion <- function(x){
    if (!is.list(x)) stop("input must be a list")
    
    n <- length(x)
    if (n == 0) return(NULL)
    if (n == 1) return(x[[1]])
    
    s <- x[[1]]
    for (i in 2:n) s <- union(s, x[[i]])
    s
}

#' Compute the intersection of a list of vectors
#' 
#' @param x a list of zero or more vectors
#' @return a vector of the intersection or NULL is the input is empty
mintersect <- function(x){
    n <- length(x)
    if (n == 0) return(NULL)
    if (n == 1) return(x[[1]])
    
    s <- x[[1]]
    for (i in 2:n) s <- intersect(s, x[[i]])
    s
}