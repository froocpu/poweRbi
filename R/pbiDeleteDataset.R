#' Delete a dataset.
#' @description Remove the dataset entirely, not just truncate the rows of a table.
#' @param guid A character string of a guid for a single dataset.
#' @return cat
#' @examples
#' pbiDeleteDataset(id = "as8sdfasdfjkhasdf776fdsjds")

pbiDeleteDataset <- function(guid){

  # Perform the call.
  l = pbiQueryBuilder(method = "DELETE", endpoint = "datasets", guid = guid, getContent = FALSE)

  # If guid doesn't exist, alert the user.
  if(l$status_code == 404) {
    warning(paste(guid, "does not exist."), call. = FALSE)
    return(NULL)
  }

  l = content(l)

  # Using content() produces an error when error handling is performed.
  # So less detailed error reporting is available for this function.
  if(length(l$error$code) > 0 & length(l) > 0) {
    warning(paste(guid, "produced the error code", l$status_code, "- please investigate further."), call. = FALSE)
    return(NULL)
  }

  # Print message to user.
  cat(paste("The dataset with the id of", guid, "has been deleted."))

}
