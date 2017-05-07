#' Add rows to a table.
#' @description Assumes that the schema of the data frame matches the table, it will try and insert the rows.
#' @param df The data frame you want to insert.
#' @param guid Dataset Id.
#' @param tableName The friendly name of the table. The URL will be encoded.
#' @param truncate When TRUE, calls pbiTruncateDataset to clean the table before loading.
#' @examples
#' pbiAddRowsToTable(df = iris, guid = "dasdf8768adsf87ef", tableName = "Iris Data", truncate = TRUE)

pbiAddRowsToTable <- function(df, guid, tableName, truncate = FALSE){

  # Check access token.
  if(as.numeric(Sys.time()) > .expires){
    # Refresh the access token with an internal method.
    .token <<- ._pbiRefresh()
  }

  # Construct URL for the POST request.
  url = URLencode(paste0("https://api.powerbi.com/v1.0/myorg/datasets/", guid, "/tables/", tableName, "/rows"))

  # Truncate the dataset before inserting if that's what the user wants.
  if(truncate) {
    warning("Truncating rows...", call. = FALSE)
    pbiTruncateDataset(guid, tableName)
  }

  # Convert all rows from the data frame into JSON.
  rows = paste0(apply(df, 1, RJSONIO::toJSON), collapse = ",")
  rows = paste0("{\"rows\":[", rows, "]}")

  # Make the request.
  l = content(httr::POST(
    url = url,
    httr::add_headers(
      Authorization = paste("Bearer", .token),
      `Content-Type` = "application/json"
    ),
    body = rows))

  # Two-tiered IF statement for this particular statement.

  if(!is.raw(l)){

  # Error handling.
  if(exists("error", where = l)) {
    warning(paste(guid, "and", tableName, "produced an error message:", l$error$message, "."), call. = FALSE)
    return(NULL)
  }}

  cat(paste(nrow(df), "rows inserted into", tableName, "successfully!"))

}
