
#' A tidy wrapper around \code{\link[base]{saveRDS}}
#'
#' @export
#' @param object the R object to be saved
#' @param file character or file connection
#' @param ... other arguments for \code{\link[base]{saveRDS}}
#' @return the original object invisibly
#' @examples
#' \dontrun{
#'   x <- my_big_process() %>%
#'     write_RDS("my_big_data.rds") %>%
#'     dplyr::filter(foo <= 7) %>%
#'     readr::write_csv("my_smaller_data.csv")
#' }
write_RDS <- function(object, file = "", ...){

  saveRDS(object, file = file, ...)
  invisible(object)
}

#' A wrapper around \code{\link[base]{readRDS}}
#'
#' @export
#' @param file the filename to read
#' @param ... other arguments for \code{\link[base]{readRDS}}
#' @return R object
read_RDS <- function(file, ...){

  readRDS(file, ...)
}