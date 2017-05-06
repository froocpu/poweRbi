#' Supported dataset types.
#' @description Dataset types.
#' @return List
#' @examples
#' pbiDatasetTypes()

pbiDatasetTypes <- function(simple = TRUE, verbose = FALSE){
  DefaultModeProperties = c("Push", "Streaming", "PushStreaming")
  return(DefaultModeProperties)
}
