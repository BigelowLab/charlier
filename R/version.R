#' Parse a version string
#'
#' Versions have the format vMajor.Minor.Release
#'
#' @export
#' @param x version string to parse
#' @param sep character, by default '.' but any single character will do 
#' @return named character vector
parse_version <- function(x = 'v2.123.1', sep = "."){
    xx = strsplit(x, sep[1], fixed = TRUE)[[1]]
    c(major = xx[1], minor = xx[2], release = ifelse(length(xx) == 3, xx[3], NA))
}

#' Build a version string from components
#'
#' Versions have the format vMajor.Minor.Release
#'
#' @export
#' @param major string, like 'v3' or a named vector with (major, minor, [release])
#' @param minor string, like '13', ignored if major has length > 1
#' @param release string, optional like '002', ignored if major has length > 1
#' @param sep character, by default '.' but any single character will do 
#' @return version string like 'v3.13.002'
build_version <- function(major, minor, release, sep = "."){
    if(missing(major)) stop("major is required")
    if (length(major) >= 2){
        v = paste(major, collapse = sep[1])
    } else {
        if(missing(minor)) stop("minor is required")
            v = paste(major, minor[1], sep  = sep[1])
        if(!missing(release)) v = paste(v, release[1], sep  = sep[1])
    }
    v
}