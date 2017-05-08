#' Internal method for inferring Power BI data types from a data frame.
#' @description Uses class() and typeof() to predict what the correct Power BI data type should be for a data frame column.
#' @param x A data frame column.
#' @return Character string.

._pbiGetDataType = function(x){

  cl = class(x)
  t = typeof(x)

  # Test.
  if(cl == "factor") return("String")
  if(cl == "logical") return("Boolean")
  if(cl %in% c("POSIXct","POSIXt","Date")) return("DateTime")
  if(cl == "integer" | (cl == "double" & t == "integer")) return("Int64")
  if(cl == "numeric" & t == "double") return("Double")

  # Else
  return("String")
}
