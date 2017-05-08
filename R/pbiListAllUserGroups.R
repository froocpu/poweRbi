#' List all imported files.
#' @description Return a data frame containing information about the groups associated with the user.
#' @param toDf When TRUE, a tabular format is returned. When FALSE, more detailed content is returned as JSON.
#' @return Data frame.
#' @examples
#' pbiListAllUserGroups()

pbiListAllUserGroups <- function(toDf = TRUE){

  # Call the query builder to make the call.
  l = pbiQueryBuilder(endpoint = "groups", getContent = FALSE)

  # Error handling.
  if(exists("error", where = l)) {
    stop(paste("GET request produced an error message: ", l$error$message))
    return(NULL)
  }

  if(length(l$content) == 0) {
    stop("Check your app permissions - there was no content attached to the response.")
    return(NULL)
  }

  # If the user wants the JSON from the successful API call, then return it.
  # Don't bother parsing to a data frame.
  if(toDf == FALSE) return(l)

  # Else, parse to a data frame.
  df = data.frame(
    Id = sapply(l$value, function(x){x$id}),
    Name = sapply(l$value, function(x){x$name})
  )

  return(df)

}
