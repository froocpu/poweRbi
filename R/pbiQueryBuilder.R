#' Build simple REST API queries.
#' @description An internal function that acts as a skeleton for building API queries for other functions. This will only work when you have authenticated first.
#' @param method Default is GET.
#' @param version The API version.
#' @param endpoint Which endpoint of the API to query.
#' @param printCall Print the URL of the API call used for debugging.
#' @param getContent If TRUE, extract JSON from the response object.
#' @return HTTP response object.
#' @examples
#' pbiQueryBuilder(endpoint = "datasets")

pbiQueryBuilder <- function(
  endpoint,
  guid = NULL,
  object = NULL,
  suffix = NULL,
  method = "GET",
  version = "v1.0",
  printCall = FALSE,
  getContent = TRUE
  )

{

  # Update access token.
  if(as.numeric(Sys.time()) > .expires){
    # Refresh the access token with an internal method.
    .token <<- ._pbiRefresh()
  }

  # Begin testing.
  if(is.null(guid) & is.null(object) & is.null(suffix)) {
    query = paste0(
      "httr::", method, "(\"https://api.powerbi.com/", version, "/myorg/", endpoint, "\",
      httr::add_headers(
        Authorization = paste(\"Bearer\", \"", .token, "\")))"
    )}

  if(!is.null(guid) & is.null(object) & !is.null(suffix)) {
    query = paste0(
      "httr::", method, "(\"https://api.powerbi.com/", version, "/myorg/", endpoint, "/", guid, "/", suffix, "\",
      httr::add_headers(
      Authorization = paste(\"Bearer\", \"", .token, "\")))"
    )}

  if(!is.null(guid) & is.null(object) & is.null(suffix)) {
    query = paste0(
      "httr::", method, "(\"https://api.powerbi.com/", version, "/myorg/", endpoint, "/", guid, "\",
      httr::add_headers(
      Authorization = paste(\"Bearer\", \"", .token, "\")))"
    )}

  if(printCall) cat(query)

  # Perform the call.
  l = eval(parse(text = query))

  # Retrieve JSON?
  if(getContent) return(httr::content(l))

  # Else:
  return(l)


}
