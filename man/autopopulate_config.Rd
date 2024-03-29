% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/config.R
\name{autopopulate_config}
\alias{autopopulate_config}
\title{Autopopulate one or more values within the config with values drawn from the config.}
\usage{
autopopulate_config(
  x = read_config(example = TRUE, autopopulate = FALSE),
  fields = list(NULL, list(foo = "foo", paths = c("input_path", "output_path")))[[1]],
  rootname = "global"
)
}
\arguments{
\item{x}{configuration list}

\item{fields}{named list or NULL, provides the identifiers within the config to be used as 
source for placeholders - please don't make very deeply nested lists. If NULL (default) then all of 
the fields in the \code{rootname} section are used.  NOTE that not every element must be
a candidate for replacing $PLACEHOLDERS}

\item{rootname}{the name of the element in \code{x} that contains the fields}
}
\value{
an updated version of the input, \code{x}, that is autpopulated with the fields 
 identified
}
\description{
The second argument, \code{fields}, identifies the variables that may be found as $PLACEHOLDERS within the config file. For example, if \code{fields = list(io = c("input_directory", "output_directory"))} then we first find those values in the config file, and then search for $IO_INPUT_DIRECTORY and $IO_OUTPUT_DIRECTORY placeholders throughout the config file and replace the specified fields values. This doesn't handle very complex placeholder sections, but for most purposes it should work well.
}
