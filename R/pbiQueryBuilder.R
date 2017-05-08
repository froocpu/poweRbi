#' Build simple REST API queries.
#' @description An internal function that acts as a skeleton for building API queries for other functions. This will only work when you have authenticated first.
#' @param method Default is GET.
#' @param guid When required, supply a guid. This will often be provided by a loop.
#' @param object Usually reserved for table names, but will be the child of an endpoint (like datasets) or a guid.
#' @param version The API version.
#' @param suffix Usually "rows", goes at the end of the URL.
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
  if(as.numeric(Sys.time()) > .pkgenv[["expires"]]){
    # Refresh the access token with an internal method.
    .pkgenv[["token"]] <- ._pbiRefresh()
  }

  # Begin testing.
  if(is.null(guid) & is.null(object) & is.null(suffix)) {
    query = paste0(
      "httr::", method, "(\"https://api.powerbi.com/", version, "/myorg/", endpoint, "\",
      httr::add_headers(
        Authorization = paste(\"Bearer\", \"", .pkgenv[["token"]], "\")))"
    )}

  if(!is.null(guid) & is.null(object) & !is.null(suffix)) {
    query = paste0(
      "httr::", method, "(\"https://api.powerbi.com/", version, "/myorg/", endpoint, "/", guid, "/", suffix, "\",
      httr::add_headers(
      Authorization = paste(\"Bearer\", \"", .pkgenv[["token"]], "\")))"
    )}

  if(!is.null(guid) & is.null(object) & is.null(suffix)) {
    query = paste0(
      "httr::", method, "(\"https://api.powerbi.com/", version, "/myorg/", endpoint, "/", guid, "\",
      httr::add_headers(
      Authorization = paste(\"Bearer\", \"", .pkgenv[["token"]], "\")))"
    )}

  if(printCall) cat(query)

  # Perform the call.
  l = eval(parse(text = query))

  # Retrieve JSON?
  if(getContent) return(httr::content(l))

  # Else:
  return(l)


}
