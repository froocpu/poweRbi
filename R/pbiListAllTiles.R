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
    stop("Overriding id variable...")
    id = as.character(pbiListAllDashboards()$Id)
  }

  if(typeof(id) == "list") {
    stop("id must be a character string or vector.")
    return(NULL)
  }

  # Begin looping through to collect the results as required.
  for (each in id) {

    ## Make the call.
    l = pbiQueryBuilder(endpoint = "dashboards", suffix = "tiles", guid = each)

    ## Error handling.
    if(exists("error", where = l)) {
      stop(paste(each, "produced an error message: ", l$error$message))
      next
    }

    if(!exists("value", where = l)){
      next
    }

    if(
      length(grepl("xml", class(l))) > 0
    ){
      stop(paste(each, "produced an XML output, which usually means a bad request."))
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
