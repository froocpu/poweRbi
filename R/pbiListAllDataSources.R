#' List all data sources (from all datasets)
#' @description Return all data sources from a single, multiple or from all datasets.
#' @param id A character string or vector containing guids. Hint: You can use pbiListAllDatasets to help you.
#' @param all When TRUE, it will override the value of id and proceed to find all datasets.
#' @return Data frame.
#' @examples
#' pbiListAllDataSources(id = "as876fdsjds")

pbiListAllDataSources <- function(id = NULL, allDatasets = FALSE){

  df = data.frame()

  # Parameter validation.
  if(is.null(id) | allDatasets == TRUE){
    warning("Overriding id variable...", call. = FALSE)
    id = as.character(pbiListAllDatasets()$Id)
  }

  if(typeof(id) == "list") {
    warning("id must be a character string or vector.", call. = FALSE)
    return(NULL)
  }

  # Begin looping through, producing as many results as required.
  for (each in id) {

    ## Make the call.
    l = pbiQueryBuilder(endpoint = "datasets", suffix = "dataSources", guid = each)

    ## Error handle.
    if(exists("error", where = l)) {
      warning(paste(each, "presented with an error message: ", l$error$message), call. = FALSE)
      next
    }

    ## Append the results to a variable.
    df = rbind(df, data.frame(
      Id = each,
      Name = sapply(l$value, function(x){x$name})
    ))

  }

  return(df)

}
