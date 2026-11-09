#' Send a mail message where \code{mail} binary is available
#' 
#' @export
#' @param to character, vector of one or more email addresses
#' @param subject character subject line
#' @param message character, vector of one or more lines of text
#' @param attachment NULL or character, file path to optional attachment
#' @param from character, sender address (used only when relaying via \code{smtp}).
#'   Defaults to \code{getOption("charlier.from")}, else \code{<user>@bigelow.org}
#' @param smtp character, "host:port" of the SMTP relay, or NULL to use the local MTA.
#'   Defaults to \code{getOption("charlier.smtp", "mail.bigelow.org:25")}
#' @param verbose logical, if TRUE print the command generated
#' @return integer success code (0) or some non-zero if an error
#' @examples
#' \dontrun{
#' cat(LETTERS, sep = "\n", file = "letters.txt") 
#' sendmail(to = "foo@bar.com", 
#'          subject = "Facts", 
#'          message = c("Fact: dogs start out as puppies.", "Not sure about cats."),
#'          attachment = "letters.txt")
#'}
sendmail <- function(to = 'btupper@bigelow.org',
  subject = "mail from charlier",
  message = "It's so wonderful to get mail, ain't it?",
  attachment = NULL,
  from = getOption("charlier.from", default = paste0(whoami(), "@bigelow.org")),
  smtp = getOption("charlier.smtp", default = "mail.bigelow.org:25"),
  verbose = FALSE){
    
  mailapp <- Sys.which("mail")
  if ( mailapp == "") stop("mail application not available")
  
  # https://tecadmin.net/ways-to-send-email-from-linux-command-line/ 
  # mail -a [attachment] -s [subject] <to> < [message]
  
  # store the message in a temporary file
  msgfile <- tempfile()
  cat(message, sep = "\n", file = msgfile)
  
  cmd <- sprintf("-s %s %s < %s", shQuote(subject), 
                 paste(to, collapse = ","), 
                 msgfile)
  if (!is.null(attachment)){
    cmd <- sprintf("-a %s %s", attachment, cmd)
  } 
  
  # relay through an SMTP server rather than the local MTA
  # s-nail (RHEL/Rocky 9+) calls the setting 'mta', heirloom mailx (RHEL/Rocky 8) calls it 'smtp'
  if (!is.null(smtp) && nzchar(smtp)){
    ver <- suppressWarnings(system2(mailapp, "-V", stdout = TRUE, stderr = TRUE))
    relay <- if (any(grepl("s-nail", ver, ignore.case = TRUE))) {
      paste0("mta=smtp://", smtp)
    } else {
      paste0("smtp=", smtp)
    }
    opts <- paste("-S", shQuote(relay))
    if (!is.null(from) && nzchar(from)) {
      opts <- paste(opts, "-S", shQuote(paste0("from=", from)))
    }
    cmd <- paste(opts, cmd)
  }
  
  if (verbose) message(paste('sendmail command:', mailapp, cmd))
  
  ok <- system2(mailapp, args = cmd)
  
  unlink(msgfile)  
  
  return(ok)  
  }