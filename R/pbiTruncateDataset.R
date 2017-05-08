#' Truncate a table.
#' @description Remove all rows from a table within a dataset. Hint: You can use pbiListAllTables to do this across multiple tables.
#' @param guid A single character string containing a guid.
#' @param tableName A single character string containing an pre-encoded friendly table name.
#' @return HTTP response.
#' @examples
#' \dontrun{pbiTruncateDataset(guid = "aasdafds", tableName = "June Sales")}

pbiTruncateDataset <- function(guid, tableName){

  # Update the access token.
  if(as.numeric(Sys.time()) > .pkgenv[["expires"]]){
    # Refresh the access token with an internal method.
    .pkgenv[["token"]] <- ._pbiRefresh()
  }

  # pbiQueryBuilder not used here.
  url = URLencode(
    paste0("https://api.powerbi.com/v1.0/myorg/datasets/", guid, "/tables/", tableName, "/rows")
  )

  # Make the call.
  l = content(httr::DELETE(
    url = url,
    httr::add_headers(
      Authorization = paste("Bearer", .pkgenv[["token"]])
    )))

  # Successful responses don't have content and have the type of environment.
  # This requires a two-tiered IF statement for error handling.
  if(!is.raw(l)) {

    if(exists("error", where = l)) {
      stop(paste(guid, "produced the error message:", l$error$message, "- please investigate further."))
      return(NULL)
    }}

  # Print a message.
  cat(paste(tableName, "successfully truncated."))

}
