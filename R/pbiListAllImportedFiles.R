#' List all imported files.
#' @description Return a data frame containing detailed information about all of the imported data on your Power BI web service. You will be able to join with other queries on the IDs. Requires authentication before it can be executed.
#' @param toDf When TRUE, a tabular format is returned. When FALSE, more detailed content is returned as JSON.
#' @return Data frame.
#' @examples
#' pbiListAllImportedFiles()

pbiListAllImportedFiles <- function(toDf = TRUE){

  # Call query builder to make the call.
  l = pbiQueryBuilder(endpoint = "imports")

  # Error handling.
  if(length(l$error$code) > 0) {
    warning(paste("GET request produced an error code: ", l$error$code), call. = FALSE)
    return(NULL)
  }

  # If the user wants the JSON from the successful API call, then return it.
  # Don't bother parsing to a data frame.
  if(toDf == FALSE) return(l)

  # Else, parse to a data frame.
  df = data.frame(
    Id = sapply(l$value, function(x){x$id}),
    Name = sapply(l$value, function(x){x$name}),
    ImportState = sapply(l$value, function(x){x$importState}),
    CreatedDateTime = sapply(l$value, function(x){x$createdDateTime}),
    UpdatedDateTime = sapply(l$value, function(x){x$createdDateTime}),
    ReportCount = sapply(l$value, function(x){length(x$reports)}),
    ReportIds = sapply(l$value, function(x){paste0(sapply(x$reports, function(y){y$id}), collapse = ", ")}),
    DatasetCount = sapply(l$value, function(x){length(x$datasets)}),
    DatasetIds = sapply(l$value, function(x){paste0(sapply(x$datasets, function(y){y$id}), collapse = ", ")})
  )

  return(df)

}
