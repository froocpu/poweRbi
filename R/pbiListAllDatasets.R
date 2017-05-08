#' List all datasets.
#' @description Return a data frame containing basic information about all of the datasets on your Power BI web service. Requires authentication before it can be executed.
#' @param toDf When TRUE, a tabular format is returned. When FALSE, more detailed content is returned as JSON.
#' @return Data frame.
#' @examples
#' pbiListAllDatasets()

pbiListAllDatasets <- function(toDf = TRUE){

  # Run query builder function to make the call.
  l = pbiQueryBuilder(endpoint = "datasets")

  # Error handling.
  if(exists("error", where = l)) {
    stop(paste("GET request produced an error message: ", l$error$message))
    return(NULL)
  }

  # If the user wants the JSON from the successful API call, then return it.
  # Don't bother parsing to a data frame.
  if(toDf == FALSE) return(l)

  # Else, parse to a data frame.
  df = data.frame(
    Id = sapply(l$value, function(x){x$id}),
    Name = sapply(l$value, function(x){x$name}),
    AddRowsAPIEnabled = sapply(l$value, function(x){x$addRowsAPIEnabled})
  )

  return(df)

}
