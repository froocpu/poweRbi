#' Return time in minutes before token expiry.
#' @description An internal utility for determining when the current access token will expire. Refreshing of access tokens is handled automatically.
#' @param verbose When FALSE, messages are turned off. This should improve the accuracy of the value returned.
#' @return numeric

._pbiTokenExpiresIn <- function(verbose = FALSE){

  # When verbose == FALSE, this will be accurate to an average of 21-25 milliseconds (microbenchmark over repeated 100-1m evaluations.)
  if(verbose == FALSE) return((.expires - as.numeric(Sys.time())) / 60)

  # Else, be chatty and human readable.
  mins = (.expires - as.numeric(Sys.time())) / 60

  if(mins < 0){
    cat("Expired.\r\n")
    return(NULL)
  } else {
    cat(
      paste(round(mins, 4),"minutes until token expiry.\r\n")
    )
    return(mins)
  }

}



