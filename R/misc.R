#' Perform grepl on multiple patterns; it's like  AND-ing or OR-ing successive grepl statements.
#' 
#' Adapted from https://stat.ethz.ch/pipermail/r-help/2012-June/316441.html
#'
#' @seealso \code{\link[base]{grepl}}
#' @export
#' @param pattern character vector of patterns
#' @param x the character vector to search
#' @param op logical vector operator back quoted, defaults to `|`
#' @param ... further arguments for \code{grepl} like \code{fixed} etc.
#' @return logical vector
#' @examples
#' \dontrun{
#'  x <- c("dog", "canine", "squirrel", "fish", "banana")
#'  pattern <- c("nine", "ana")
#'  mgrepl(pattern, x, fixed = TRUE)
#'  # [1] FALSE  TRUE FALSE FALSE  TRUE
#'}
mgrepl <- function(pattern, x, op = `|`, ... ){
   Reduce(op, lapply(pattern, grepl, x, ...))
}

#' Compute the union of a list of vectors
#' 
#' @seealso \code{\link[base]{union}}
#' @export
#' @param x a list of zero or more vectors
#' @return a vector of the union or NULL is the input is empty
#' @examples
#' \dontrun{
#    x <- c(1, 5, 7, 9)
#    y <- c(3, 5, 8, 9, 11, 42)
#    z <- c(0, 5, 6, 9, 11)
#'   munion(list(x,y,z))
#'   # [1]  1  5  7  9  3  8 11 42  0  6  
#'} 
munion <- function(x){
  if (!is.list(x)) stop("input must be a list")
  n <- length(x)
  if (n == 0) return(NULL)
  if (n == 1) return(x[[1]])
  
  Reduce(union, x)
}

#' Compute the intersection of a list of vectors
#' 
#' @seealso \code{\link[base]{intersect}}
#' @export
#' @param x a list of zero or more vectors
#' @return a vector of the intersection or NULL is the input is empty
#' @examples
#' \dontrun{
#'    x <- c(1, 5, 7, 9)
#'    y <- c(3, 5, 8, 9, 11, 42)
#'    z <- c(0, 5, 6, 9, 11)
#'    mintersect(list(x,y,z))
#'    # [1]  5  9 
#'} 
mintersect <- function(x){
  if (!is.list(x)) stop("input must be a list")
  n <- length(x)
  if (n == 0) return(NULL)
  if (n == 1) return(x[[1]])
  
  Reduce(intersect, x)
}