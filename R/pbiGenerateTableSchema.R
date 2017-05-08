#' Generate a table schema.
#' @description Use a data frame to infer data types and produce a list object that can be converted to compatible JSON. See here: https://msdn.microsoft.com/en-us/library/mt203560.aspx
#' @param df Data frame - the data used to infer the table schema.
#' @param tableName A character string. When is not NULL, it will override the default of using the variable name as the table name.
#' @param debug When TRUE, it will return a list object converted from the JSON so that you can see what the R object should look like.
#' @return List object or JSON to be passed into the body of a request.
#' @examples
#' pbiGenerateTableSchema(cats, debug = TRUE)
#' pbiDataTypes() # Use to reference accepted data types.

pbiGenerateTableSchema <- function(df, tableName = NULL, debug = FALSE){

  # Create a storage data frame.
  collectMeta = try(data.frame(row.names = NULL,
    name = names(iris3),
    dataType = sapply(iris3, ._pbiGetDataType)
  ))

  if(is(collectMeta, "try-error")) stop("Make sure that the object you have passed is a data frame and not a double/list object.")

  # jsonlite's version of toJSON returns the data in the correct format, and comes with HTTR.
  json = paste0(
    "{\"name\":\"", ifelse(is.null(tableName), deparse(substitute(df)), tableName),
    "\",\"columns\":", jsonlite::toJSON(collectMeta),
    "}")

  # Return one of two objects:
  if(debug) return(jsonlite::fromJSON(json))

  return(json)

}
