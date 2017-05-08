#' Supported dataset types.
#' @description Dataset types.
#' @return Character vector.
#' @examples
#' pbiDatasetTypes()

pbiDatasetTypes <- function(){
  DefaultModeProperties = c("Push", "Streaming", "PushStreaming")
  return(DefaultModeProperties)
}
