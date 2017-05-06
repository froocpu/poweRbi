#' Create a new dataset.
#' @description Requires the correct metadata information to be passed to the function in the form of lists and named variables. Relationships, measures and columns can be handled.
#' @param name The name of the new dataset.
#' @param duplicate When TRUE, it will create a separate dataset with the same name as another dataset.
#' @param groupId Specify which group to create it to. Use pbiListAllUserGroups to find the ids.
#' @param tableSchema A list object containing relevant column metadata.
#' @param measureSchema A list object containing relevant information about measures.
#' @param relationshipSchema A list object containing relevant relationship metadata.
#' @param FIFO Default retention policy, or basic "first-in-first-out". Dataset will store between 200-210k rows and remove the oldest rows when the storage limit has been reached. Consider this option for streaming datasets. Options are 'none' or 'basicFIFO'.
#' @return HTTP response object.

pbiCreateDataset <- function(
  name = NULL,
  duplicate = FALSE,
  groupId = NULL,
  tableSchema = list(),
  measureSchema = list(),
  relationshipSchema = list(),
  FIFO = "none",
  verbose = FALSE
  )
{

    # Validate parameter.
    if(FIFO %in% c("none","basicFIFO")){

    # Check the access token.
    if(as.numeric(Sys.time()) > .expires){
    # Refresh the access token with an internal method.
    .token <<- ._pbiRefresh()
  }

  # Report extra information if verbose is selected.
  if(verbose){
    cat("More information about dataset properties: \r\nhttps://msdn.microsoft.com/en-us/library/mt742155.aspx\r\n\r\n")
    cat("groupId not yet implemented. Hold tight! :)")
  }

  # Begin.
  df = pbiListAllDatasets()

  if(is.null(name) | is.null(tableSchema)) {
    warning("A table name/column metadata is required.", call. = FALSE)
    return(NULL)
  }

  if(
      nrow(df[df$Name == name,]) > 0
      & duplicate == FALSE
    ) {
    warning("This dataset name already exists. Select duplicate = TRUE to create a dataset with the same name.", call. = FALSE)
    return(NULL)
  }

  ## Create a JSON structure to specify the
  l <- RJSONIO::toJSON(list(
    name = name,
    defaultMode = "Push",
    tables = list(
      list(
        name = "Triangle",
        columns = tableSchema,
        measures = measureSchema
      )
      ),
    relationships = relationshipSchema
    )
  )

  l = content(httr::POST(
    url = paste0("https://api.powerbi.com/v1.0/myorg/datasets?defaultRetentionPolicy=", FIFO),
    httr::add_headers(
      Authorization = paste("Bearer", .token)
    ),
    body = l
  ))

  # Error handling.
  if(length(l$error$code) > 0) {
    warning(paste("POST request produced an error code: ", l$error$code), call. = FALSE)
    return(NULL)
  }

    # Produce the error message for a bad input paramater.
    } else {
      warning("Invalid FIFO parameter.")
      return(NULL)
    }

  }
