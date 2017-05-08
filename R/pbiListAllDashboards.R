#' List all dashboards.
#' @description Return a data frame containing basic information about all of the dashboards on your Power BI web service. Requires authentication before it can be executed.
#' @param toDf When TRUE, a tabular format is returned. When FALSE, more detailed content is returned as JSON.
#' @return Data frame or JSON.
#' @examples
#' \dontrun{pbiListAllDashboards(toDf = FALSE)}

pbiListAllDashboards <- function(toDf = TRUE){

  # Run the query builder function.
  l = pbiQueryBuilder(endpoint = "dashboards")

  # Error handling.
  if(exists("error", where = l)) {
    stop(paste("GET request produced an error message: ", l$error$message))
    return(NULL)
  }

  # If the user wants the JSON from the successful API call, then return it.
  # Don't bother parsing to a data frame.
  if(toDf == FALSE) return(l)

  # Parse to a data frame.
  df = data.frame(
    Id = sapply(l$value, function(x){x$id}),
    Name = sapply(l$value, function(x){x$displayName}),
    IsReadOnly = sapply(l$value, function(x){x$isReadOnly}),
    EmbeddedUrl = sapply(l$value, function(x){x$embedUrl})
  )

  return(df)

}
