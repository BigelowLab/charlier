#' Scan a file or character vector for one or more tokens.  This is a wrapper around \code{mgrepl}.
#'
#' @export
#' @param x character, either a character vector to scan or a filename
#' @param tokens character, vector of one or more tokens - if fixed then provide \code{fixed=TRUE} 
#'  otherwise a regular expression is expected ad then set \code{fixed = FALSE}
#' @param token character or NA, if character, remove lines starting with the comment character before scanning
#' @param ... other arguments for \code{mgrepl} and \code{\link[base]{grepl}}, in particular see fixed = TRUE 
#' @return logical vector, one per input value of x where TRUE indicates one or more tokens were found
scan_for_tokens <- function(x, tokens = "^.*\\$", 
  comment = c("#", NA)[1], 
  ...){
    
  scan_for_comments <- function(x, symb = "#"){
    x <- trimws(x, "left")
    ix <- grepl("^#", x)
  }
    
  if (length(x) == 1 && file.exists(x[[1]])){
    x <- readLines(x[[1]])
  }
  r <- mgrepl(tokens, x, ...)
  if (!is.na(comment[1])) {
    ix <- scan_for_comments(x, symb = comment[1])
    r[ix] <- FALSE
  }
  r
}

#' Tests that an object is NULL nor NA
#'
#' \code{NULL} always returns TRUE.  Multiple element non-\code{NULL} objects always return FALSE.  If you are not
#' sure if your object might be length > 1 then use as \code{is.nullna(x[1])}.
#' 
#' @export
#' @param x an object
#' @return logical, TRUE if \code{x} is NULL or NA
is.nullna <- function(x) {
  is.null(x) || ifelse(length(x) == 1, is.na(x), FALSE)
}

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

#' Split a vector into groups of MAX (or possibly fewer)
#'
#' @param v vector or list to split
#' @param MAX numeric the maximum size per group
#' @return a list of the vector split into groups
split_vector <- function(v, MAX = 200){
    nv <- length(v)
    if (nv <= MAX) return(list('1' = v))
    split(v, findInterval(seq_len(nv), seq(from = 1, to = nv, by = MAX)))
}
