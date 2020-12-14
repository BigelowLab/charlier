#' Retrieve the PBS JOBID if available
#'
#' @export
#' @param no_pbs_text character, the text to return if no jobid found
#' @return character jobid or missing_text value
get_pbs_jobid <- function(no_pbs_text = ""){
  PBS_JOBID <- Sys.getenv("PBS_JOBID")
  if (nchar(PBS_JOBID) == 0) PBS_JOBID <- no_pbs_text
  PBS_JOBID
}

#' Count the number of CPUs
#'
#' If the number of CPUS has been specified for a PBS session then retrieves the values
#' of environment variable '$NCPUS' otherwise this is wrap of \code{\link[parallel]{detectCores}}
#'
#' @export
#' @return integer count of cores
count_cores <- function(){
  ncpus <- Sys.getenv("NCPUS")
  if (nchar(ncpus) == 0){
   ncpus <- parallel::detectCores()
  } else {
    ncpus <- as.integer(ncpus[1])
  }
  ncpus
}


#' Provide an R session audit
#'
#' @export
#' @param filename character, the name of the file to dump to or "" to print to console
#' @param pbs_jobid character, the PBS jobid if known
#' @return NULL invisibly
audit <- function(filename = "", pbs_jobid = get_pbs_jobid()){
  cat("Audit date:", format(Sys.time(), "%Y-%m-%d %H:%M:%S", usetz = TRUE), "\n",
    file = filename)
  cat("System PID:", Sys.getpid(), "\n", file = filename, append = TRUE)
  cat("PBS_JOBID:", pbs_jobid, "\n", file = filename, append = TRUE)
  cat("Cores:", count_cores(), "\n", file = filename, append = TRUE)
  cat("R version:", R.version.string, "\n", file = filename, append = TRUE)
  cat("libPaths():\n", file = filename, append = TRUE)
  for (lp in .libPaths()) cat("    ", lp, "\n",
                              file = filename, append = TRUE)
  x <- installed_packages() %>%
    dplyr::select("Package", "Version",  "LibPath")
  cat("installed.packages():\n", file = filename, append = TRUE)
  if (nzchar(filename)){
    conn <- file(filename, open = 'at')
    utils::write.csv(x, file = conn, row.names = FALSE)
    close(conn)
  } else {
    print(x, row.names = FALSE)
  }
  invisible(NULL)
}

#' A wrapper around \code{installed.packages} the returns a table
#'
#' @export
#' @param ... more arguments for \code{installed.packages}
#' @return table
installed_packages <- function(...){
  dplyr::as_tibble(installed.packages(...))
}


#' A wrapper around \code{old.packages} the returns a table
#'
#' @export
#' @param ... more arguments for \code{old.packages}
#' @return table
old_packages <- function(...){
  dplyr::as_tibble(utils::old.packages(...))
}

#' Retrieve a table of packages suitable for updating
#'
#' @export
#' @param lib_pattern character, A glob pattern specification that is used to filter
#'    library locations
#' @return a table of packages identified for update
identify_upgrades <- function(lib_pattern = "^/mnt/modules/bin/dada2"){

  old_packages() %>%
    dplyr::filter(grepl(lib_pattern, .data$LibPath))
}



