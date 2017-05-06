#' Supported data types.
#' @description A data frame contain supported data types and restrictions, sourced from the REST API reference.
#' @param simple If TRUE, simply return a character vector of the names. Else, return a detailed data frame with restrictions.
#' @param verbose If TRUE, it will report information about Power BI data types to the user.
#' @return Data frame.
#' @examples
#' pbiDataTypes()

pbiDataTypes <- function(){

  if(verbose){
  cat("Information correct as of 06 May 2017:
      https://msdn.microsoft.com/en-us/library/mt203569.aspx")
}

  # Data table converted from text.
  dataTypes = read.table(
    text = "DataType	Restrictions
Int64	Int64.MaxValue and Int64.MinValue not allowed.
Double	Double.MaxValue and Double.MinValue values not allowed. NaN not supported.+Infinity and -Infinity not supported in some functions (e.g. Min, Max).
Boolean	None
Datetime	During data loading we quantize values with day fractions to whole multiples of 1/300 seconds (3.33ms).
String	Currently allows up to 128K characters.",
    sep = "\t",
    header = TRUE
    )

  # Return either a character string or a data frame.
  if(simple) {
    return(as.character(unlist(dataTypes[1])))
  } else {
    return(dataTypes)
  }

}
