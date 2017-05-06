#' List all tiles (from all dashboards)
#' @description Return all tiles from a single, multiple or from all dashboards.
#' @param id A character string or vector containing guids. Hint: You can use pbiListAllDashboards to help you.
#' @param all When TRUE, it will override the value of id and proceed to find all dashboards.
#' @return Data frame.
#' @examples
#' pbiListAllTiles(all = TRUE)

pbiListAllTiles <- function(id = NULL, allDashboards = FALSE){

  df = data.frame()

  # Input validation.
  if(is.null(id) | allDashboards == TRUE){
    warning("Overriding id variable...", call. = FALSE)
    id = as.character(pbiListAllDashboards()$Id)
  }

  if(typeof(id) == "list") {
    warning("id must be a character string or vector.", call. = FALSE)
    return(NULL)
  }

  # Begin looping through to collect the results as required.
  for (each in id) {

    ## Make the call.
    l = pbiQueryBuilder(endpoint = "dashboards", suffix = "tiles", guid = each)

    ## Error handling.
    if(length(l$error$code) > 0) {
      warning(paste(each, "produced an error code: ", l$error$code), call. = FALSE)
      next
    }

    ## Append the results to a data frame.
    df = rbind(df, data.frame(
      DashboardId = each,
      TileId = sapply(l$value, function(x){x$id}),
      Title = sapply(l$value, function(x){ifelse(is.null(x$title), "", x$title)}),
      Subtitle = sapply(l$value, function(x){ifelse(is.null(x$subTitle), "", x$subTitle)}),
      RowSpan = sapply(l$value, function(x){x$rowSpan}),
      ColumnSpan = sapply(l$value, function(x){x$colSpan}),
      EmbeddedUrl = sapply(l$value, function(x){x$embedUrl})
    ))

  }

  return(df)

}
