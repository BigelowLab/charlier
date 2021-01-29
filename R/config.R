#' Read a configuration file
#'
#' @export
#' @param filename character, the full path and name of the config file to read
#' @param autopopulate logical, if TRUE then call \code{autopopulate_config}
#' @param example logical, if TRUE then ignore the filename and read the example configuration
#' @param ... other arguments for \code{autopopulate_config}
#' @return a named list of configuration elements or a character vector
read_config <- function(filename, autopopulate = FALSE, example = FALSE, ...){

  if (example) filename <- system.file("example.yaml", package = "charlier")
  if (!file.exists(filename[1])) stop("config file not found:", filename[1])

  x <- yaml::read_yaml(filename[1])
  
  if (autopopulate) x <- autopopulate_config(x, ...)
  
  x
}

#' Write a configuration file
#'
#' @export
#' @param x a named list - ala yaml
#' @param filename character, the full path and filename to write to
#' @param ... other arguments for \code{\link[yaml]{write_yaml}}
#' @return the input named list, \code{x}
write_config <- function(x, filename, ...){
  ok <- yaml::write_yaml(x, filename[1], ...)
  invisible(x)
}


#' Autopopulate one or more values within the config with values drawn from the config.
#'
#' The second argument, \code{fields}, identifies the variables that may be found as $PLACEHOLDERS within the config file. For example, if \code{fields = list(io = c("input_directory", "output_directory"))} then we first find those values in the config file, and then search for $IO_INPUT_DIRECTORY and $IO_OUTPUT_DIRECTORY placeholders throughout the config file and replace the specified fields values. This doesn't handle very complex placeholder sections, but for most purposes it should work well.
#'
#' @export
#' @param x configuration list
#' @param fields named list or NULL, provides the identifiers within the config to be used as 
#'  source for placeholders - please don't make very deeply nested lists. If NULL (default) then all of 
#'  the fields in the \code{rootname} section are used.  NOTE that not every element must be
#'  a candidate for replacing $PLACEHOLDERS 
#' @param rootname the name of the element in \code{x} that contains the fields
#' @return an updated version of the input, \code{x}, that is autpopulated with the fields 
#'  identified
autopopulate_config <- function(
  x = read_config(example = TRUE, autopopulate = FALSE),
  fields = list(
     NULL,
     list(
     foo = "foo",
     paths = c("input_path", "output_path")))[[1]],
  rootname = "global"){
  
  stopifnot(rootname %in% names(x))
  
  if (is.null(fields)){
    v <- lapply(names(x[[rootname]]),
      function(xname){
        if (length(x[[rootname]][[xname]]) == 1){
          val <- x[[rootname]][[xname]][[1]]
          names(val) <- toupper(xname)
        } else {
          val <- sapply(names(x[[rootname]][[xname]]),      # <- difference here (see below)
                      function(yname){
                        z <- x[[rootname]][[xname]][[yname]]
                        names(z) <- toupper(yname)
                        z
                      }, USE.NAMES = FALSE)
        names(val) <- sprintf("%s_%s", toupper(xname), names(val))
        }
        val
      })
  } else {
    v <- lapply(names(x[[rootname]]),
        function(xname){
          if (length(x[[rootname]][[xname]]) == 1){
            val <- x[[rootname]][[xname]][[1]]
            names(val) <- toupper(xname)
          } else {
            val <- sapply(fields[[xname]],                 # <- difference here (see above)
                        function(yname){
                          z <- x[[rootname]][[xname]][[yname]]
                          names(z) <- toupper(yname)
                          z
                        }, USE.NAMES = FALSE)
          names(val) <- sprintf("%s_%s", toupper(xname), names(val))
          }
          val
      })
    }
    v <- unlist(v)    
    names(v) <- paste0("$", toupper(rootname), "_", names(v))

    tmp_file <- tempfile()
    yaml::write_yaml(x, tmp_file)
    txt <-  readLines(tmp_file)
    unlink(tmp_file)
    
    for (nm in names(v)){
      txt <- stringr::str_replace(txt, stringr::coll(nm), v[[nm]])
    }    

    y <- yaml::read_yaml(text = paste(txt, collapse = "\n"))

    y
}