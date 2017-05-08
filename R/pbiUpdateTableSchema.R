#' Update an existing table schema.
#' @description Requires dataset id and table name and a data.frame. Passes a table schema to the body of the request - uses pbiGenerateTableSchema to dynamically create a table schema off of a data frame, which you can use to give you an idea about what the R object should look like if you want to create a data frame yourself.
#' @param df A data frame off of which to build the table schema. It can be empty or contain rows, so long as the types are correct.
#' @param guid Dataset id. Use pbiListAllDatasets.
#' @param tableName Friendly table name - see pbiListAllTables for help.
#' @return HTTP response object.
#' @examples
#' pbiUpdateTableSchema(iris, guid = "sdjfalsdkfj2", tableName = "Friendly Name")
#' pbiGenerateTableSchema(iris)

pbiUpdateTableSchema <- function(df, guid, tableName) {

    # Check the access token.
    if(as.numeric(Sys.time()) > .expires){
      # Refresh the access token with an internal method.
      .token <<- ._pbiRefresh()
    }

    # Make the call.
    l = content(httr::PUT(
      url = URLencode(paste0("https://api.powerbi.com/v1.0/myorg/datasets/", guid, "/tables/", tableName)),
      httr::add_headers(
        Authorization = paste("Bearer", .token),
        `Content-Type` = "application/json"
      ),
      body = pbiGenerateTableSchema(df, tableName = tableName)
    ))

    # Error handling.
    if(exists("error", where = l)) {
      stop(paste("PUT request produced an error message: ", l$error$message))
      return(NULL)
    }

    # Return a snapshot of the new table schema object.
    cat("The following table schema has been applied:")
    return(pbiGenerateTableSchema(df, debug = TRUE))

}
