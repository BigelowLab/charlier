#' Send a mail message where \code{mail} binary is available
#' 
#' @export
#' @param to character, vector of one or more email addresses
#' @param subject character subject line
#' @param message character, vector of one or more lines of text
#' @param attachment NULL or charcater, file path to optional attachment
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
  attachment = NULL){
    
  mailapp <- Sys.which("mail")
  if ( mailapp == "") stop("mail application not available")
  
  # https://tecadmin.net/ways-to-send-email-from-linux-command-line/ 
  # mail -a [attachment] -s [subject] <to> < [message]
  
  # store the message in a temporary file
  msgfile <- tempfile()
  cat(message, sep = "\n", file = msgfile)
  
  cmd <- sprintf("-s %s %s < %s", subject, paste(to, collapse = ","), msgfile)
  if (!is.null(attachment)){
    cmd <- sprintf("-a %s %s", attachment, cmd)
  } 
  
  ok <- system2(mailapp, args = cmd)
  
  unlink(msgfile)  
  
  return(ok)  
  }