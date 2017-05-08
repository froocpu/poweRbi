#' Create a new dataset from a data frame.
#' @description Requires the correct metadata information to be passed to the function in the form of lists and named variables. Relationships, measures and columns can be handled.
#' @param name The name of the new dataset.
#' @param tableName An character vector for a table name (max 1 table created per call)
#' @param df A data frame to determine the table schema. Uses pbiGenerateTableSchema to infer the data types and creates a JSON object.
#' @param duplicate When TRUE, it will create a separate dataset with the same name as another dataset.
#' @param addRows When TRUE, it will create the schema and data. When FALSE, just the schema will be created.
#' @param datasetType What kind of dataset do you want to use? Use pbiDatasetTypes to see the available options.
#' @param FIFO Default retention policy, or basic "first-in-first-out". Dataset will store between 200-210k rows and remove the oldest rows when the storage limit has been reached. Consider this option for streaming datasets. Options are 'none' or 'basicFIFO'.
#' @param verbose If TRUE, return extra information about the endpoint.
#' @return HTTP response object.
#' @examples pbiCreateDatasetFromDataFrame(name = "New Dataset", df = data.frame(cars), tableName = "Cars Table")

pbiCreateDatasetFromDataFrame <- function(
  name,
  df,
  tableName,
  duplicate = FALSE,
  addRows = TRUE,
  datasetType = "Push",
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
    cat("groupId, measure and relationships not yet implemented. Hold tight! :)")
  }

  if(is.null(name) | is.null(df)) {
    stop("A table name/column metadata is required.")
    return(NULL)
  }

  # Begin.
  datasets = pbiListAllDatasets()

  if(
      nrow(datasets[datasets$Name == name,]) > 0
      & duplicate == FALSE
    ) {
    stop("This dataset name already exists. Select duplicate = TRUE to create a dataset with the same name.")
    return(NULL)
  }

  ## Create a JSON structure to specify the table to be created.
  l <- paste0(
    "{ \"name\":\"", name,
    "\",\"defaultMode\":\"", datasetType,
    "\",\"tables\":[", pbiGenerateTableSchema(df, tableName = tableName, debug = FALSE), "]}"
    )

  l = content(httr::POST(
    url = URLencode(paste0("https://api.powerbi.com/v1.0/myorg/datasets?defaultRetentionPolicy=", FIFO)),
    httr::add_headers(
      Authorization = paste("Bearer", .token)
    ),
    body = l
  ))

  # Error handling.
  if(exists("error", where = l)) {
    stop(paste("POST request produced an error message: ", l$error$message))
    return(NULL)
  }

  # If addRows is selected, then call pbiAddRowsToTable to insert into the new table.
  if(addRows){
    ## Get the new dataset id.
    newDatasets <- pbiListAllDatasets()
    newDataset <- as.character(newDatasets$Id[!(newDatasets$Name %in% datasets$Name)])

    ## Add rows.
    pbiAddRowsToTable(df = df, guid = newDataset, tableName = tableName)

  }

    # Produce the error message for a bad input paramater.
    } else {
      stop("Invalid FIFO parameter.")
      return(NULL)
    }

  }
