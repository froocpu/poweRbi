#' Truncate a table.
#' @description Remove all rows from a table within a dataset. Hint: You can use pbiListAllTables to do this across multiple tables.
#' @param guid A single character string containing a guid.
#' @param tableName A single character string containing an pre-encoded friendly table name.
#' @return HTTP response.
#' @examples
#' pbiTruncateDataset(guid = "aasdafs876fdsjds", tableName = "June Sales")

pbiTruncateDataset <- function(guid, tableName){

  # Update the access token.
  if(as.numeric(Sys.time()) > .expires){
    # Refresh the access token with an internal method.
    .token <<- ._pbiRefresh()
  }

  # pbiQueryBuilder not used here.
  url = URLencode(
    paste0("https://api.powerbi.com/v1.0/myorg/datasets/", guid, "/tables/", tableName, "/rows")
  )

  # Make the call.
  l = httr::DELETE(
    url = url,
    httr::add_headers(
      Authorization = paste("Bearer", .token)
    ))

  # Using content() produces an error when error handling is performed.
  # So less detailed error reporting is available for this function.
  if(length(l$error$code) > 0 & length(l) > 0) {
    warning(paste(guid, "and", tableName, "produced the error code", l$status_code, "- please investigate further."), call. = FALSE)
    return(NULL)
  }

  cat(paste(tableName, "successfully truncated."))

}
