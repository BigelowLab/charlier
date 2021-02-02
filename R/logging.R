#' Retrieve an integer vector of known logger levels for \code{futile.logger}
#'
#' We rely on \href{https://CRAN.R-project.org/package=futile.logger}{futile.logger}, but that is subject to change.
#'
#' @export
#' @return a named integer vector
logger_levels <- function(){
  c(FATAL = 1L, ERROR = 2L, WARN = 4L, INFO = 6L, DEBUG = 8L, TRACE = 9L)
}

#' Start a \code{\link[futile.logger]{flog.logger}}
#'
#' We rely on \href{https://CRAN.R-project.org/package=futile.logger}{futile.logger}, but that is subject to change.
#'
#' This doesn't actually start the logger, but it might feel like it.  Here you can simply
#' set an optional filename to echo the output to, and you can set the logging level. There
#' are a lot of things you can control about logging, and using this function doesn't prevent
#' you from using all of those other features.
#'
#' @export
#' @param filename character, NA or NULL  If not NULL or NA, then the name of the 
#'   loging file to write to in addition to console logging
#' @param level character, by default "info" but complete options include 
#'   trace, debug, info, warn, error, fatal  Setting the level to info allows for 
#'   messages \code{flog.info(...)} through \code{flog.fatal(...)} to be printed.
#'   Set it to lower values just for debugging.  Not that if the level is "info" then
#'   you can still put a \code{flog.debug("blah")} in your script - it just won't print.
#' @return NULL invisibly
#' @examples
#'  \dontrun{
#'    library(futile.logger)
#'    start_logger(filename = "~/my_log_file")
#'    who <- "World"
#'    flog.info("Hello, %s!", who)
#'  } 
start_logger <- function(filename = "./log", level = "info"){
  futile.logger::flog.threshold(getFromNamespace(toupper(level[1]),"futile.logger"))
  if (!is.null(filename) & !is.na(filename)){
    futile.logger::flog.appender(futile.logger::appender.tee(filename[1]))
  }  
  invisible(NULL)
}


#' A wrapper around the logging informational level messaging.
#'
#' We rely on \href{https://CRAN.R-project.org/package=futile.logger}{futile.logger}, but that is subject to change.
#'
#' @export
#' @param ... arguments for \code{\link[futile.logger]{flog.info}}
info <- function(...){
  futile.logger::flog.info(...)
}

#' A wrapper around the logging warning level messaging
#'
#' We rely on \href{https://CRAN.R-project.org/package=futile.logger}{futile.logger}, but that is subject to change.
#'
#' @export
#' @param ... arguments for \code{\link[futile.logger]{flog.warn}}
warn <- function(...){
  futile.logger::flog.warn(...)
}


#' A wrapper around the logging error level messaging
#'
#' We rely on \href{https://CRAN.R-project.org/package=futile.logger}{futile.logger}, but that is subject to change.
#'
#' @export
#' @param ... arguments for \code{\link[futile.logger]{flog.error}}
error <- function(...){
  futile.logger::flog.error(...)
}
