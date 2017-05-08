#' List all tables (from all datasets)
#' @description Return all tables from a single, multiple or from all datasets.
#' @param id A character string or vector containing guids. Hint: You can use pbiListAllDatasets to help you.
#' @param all When TRUE, it will override the value of id and proceed to find all datasets.
#' @return Data frame.
#' @examples
#' pbiListAllTables(id = "as876fdsjds")

pbiListAllTables <- function(id = NULL, allDatasets = FALSE){

  df = data.frame()

  # Parameter validation.
  if(is.null(id) | allDatasets == TRUE){
    stop("Overriding id variable, retrieving all datasets...")
    id = as.character(pbiListAllDatasets()$Id)
  }

  if(typeof(id) == "list") {
    stop("The variable 'id' must be a character string or vector.")
    return(NULL)
  }

  # Begin looping to collect asmany results as required.
  for (each in id) {

    ## Make the call.
    l = pbiQueryBuilder(endpoint = "datasets", suffix = "tables", guid = each)

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

    ## Append the results.
    df = rbind(df, data.frame(
      Id = each,
      Name = sapply(l$value, function(x){x$name})
    ))

  }

  return(df)

}
