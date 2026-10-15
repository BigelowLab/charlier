#' Retrieve the output of "whoami" if available
#'
#' @export
#' @return data frame of object names, 
whoami = function(){
  system("whoami", intern = TRUE)
}

#' Retrieve a tally of objects and memory used
#' 
tally_memory = function(verbose = TRUE){
  
  name = ls(sorted = FALSE, envir = globalenv())
  o = lapply(name,
    function(nmx){
      object.size(get(nmx))
    })
  f = sapply(o, format)
  
  x = dplyr::tibble(name = name,
                    object.size = o,
                    size = f)
  s = sapply(x$object.size, as.numeric)
  x = dplyr::slice(x, order(s, decreasing = TRUE))
  
  if (verbose){
    s = sapply(x$object.size, as.numeric) |>
      sum()
    cat(sprintf("%s: %gMB", whoami(), s/(1000^2)), "\n")
  }
  
  x
}
