#' Internal method for refreshing the access token.
#' @description Uses a hidden function from the httr package to refresh the access token.
#' @param url Retrieves the URL object created by the authentication process.
#' @param app Retrieves the application object created by the authentication process.
#' @param cred Retrieves the credentials, containing the original access token and expiry dates.
#' @return A character string containing a valid access token.

._pbiRefresh <- function(
  urls = .powerbi.urls,
  app = .powerbi.app,
  cred = .powerbi.token$credentials
  )
{

  ## Run httr refresh function.
  token = try(
    httr:::refresh_oauth2.0(
      urls, app, cred,
      user_params = list(resource = "https://analysis.windows.net/powerbi/api")
      ))

  if(is(token, "try-error")) {
    stop("Could not refresh the access token. *shrugs*. Have you authenticated with pbiAuthenticate?")
    return(NULL)
  }

  .expires <<- as.numeric(token$expires_on)

  ## Reassign the hidden token value.
  return(token$access_token)

}
