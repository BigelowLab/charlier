#' Given a path - make it if it doesn't exist
#' 
#' @export
#' @param path character, the path to check and/or create
#' @param recursive logical, create paths recursively?
#' @param ... other arguments for \code{\link[base]{dir.create}}
#' @return logical, TRUE if the path exists or is created
make_path <- function(path, recursive = TRUE, ...){
  ok <- dir.exists(path[1])
  if (!ok){
    ok <- dir.create(path, recursive = recursive, ...)
  }
  ok
}

#' Strip the extension(s) off of one or more filenames
#'
#' Note if ext is ".fastq" then ".fastq.gz" and ".fastq.tar.gz" will also be stripped
#'
#' @export
#' @param filename character one or more filenames
#' @param segments integer, by default 1, ignored if pattern is not NA
#' @param pattern character, a pattern to strip. If not NA then 
#'   \code{segments} is ignored.
#' @return filename with extension stripped
strip_extension <- function(
  filename = c("BR2_2016_S216_L001_R2_001.fastq", "foobar.fastq.gz", "fuzzbaz.txt"),
  segments = 1,
  pattern = c(".fastq", NA)[2]){

  if (!is.na(pattern[1])) {
    fname <- basename(filename)
    ix <- gregexpr(pattern[1], fname, fixed = TRUE)
    r <- sapply(seq_along(ix),
      function(i){
        if (ix[[i]] != -1) {
          s <- substring(fname[i], 1, ix[[i]]-2)
        } else {
          s <- fname[i]
        }
        s
      })
  } else {
    ss <- strsplit(basename(filename), ".", fixed = TRUE)
    r <- sapply(ss,
      function(s, n = 1){
        ns <- length(s)
        if (ns <= n) return(s)
        paste(s[seq(from = 1, to = ns-n, by = 1)], collapse = ".")
      }, n = as.integer(segments))
     
  }
  file.path(dirname(filename), r) 
}


#' Retrieve file extensions
#'
#' @export
#' @param filename character, vector of one or more filenames
#' @param segments integer, by default the last (1) segement, but use this to 
#'   to retrieve the last n segments (like you want the 'tar.gz' not just 'gz')
#' @return character vector of the last \code{segments} of the filename(s). If no 
#'   extension then NA_character_ is returned.
get_extension <- function(
  filename = c("BR2_2016_S216_L001_R2_001.fastq", "foobar.fastq.gz", "fuzzbaz"),
  segments = 1){
    
    ss <- strsplit(basename(filename), ".", fixed = TRUE)
    sapply(ss,
      function(s, n = 1){
        ns <- length(s)
        if (ns <= n) return(NA_character_)
        paste(s[seq(from = ns-n + 1, to = ns, by = 1)], collapse = ".")
      }, n = as.integer(segments))
  }


#' Add an extension to a filename
#'
#' @export
#' @param filename character, vector of one or more filenames
#' @param ext character, the extension to add
#' @param no_dup logical if TRUE then check first to determine if the filenames already
#'        have the extension, if they do have it do not add it again
#' @return the input filenames, possibly with the spcified extension added
add_extension <- function(
  filename = c("BR2_2016_S216_L001_R2_001.fastq", "foobar.fastq.gz", "fuzzbaz.txt"),
  ext = ".gz",
  no_dup = TRUE){


  if (no_dup){
    pat <- paste0("^.*\\", ext[1], "$")
    ix <- grepl(pat, filename)
    filename[!ix] <- paste0(filename[!ix], ext[1])
  } else {
    filename <- paste0(filename, ext[1])
  }

  filename
}
