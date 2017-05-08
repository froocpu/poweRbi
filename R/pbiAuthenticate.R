#' Authenticate your Power BI API session.
#' @description Supply your application name, client ID and client secret. You will need to register an application here: https://powerbi.microsoft.com/en-us/documentation/powerbi-developer-register-a-web-app/
#' @param appName The name of the application.
#' @param clientId Application ID.
#' @param clientSecret Client secret.
#' @examples
#' pbiAuthenticate(appName = "abc", clientId = "def", clientSecret = "ghi")

pbiAuthenticate <- function(
  appName,
  clientId,
  clientSecret
  )
{

  .powerbi.urls <<- httr::oauth_endpoint(
        authorize = "https://login.windows.net/common/oauth2/authorize",
        access = "https://login.windows.net/common/oauth2/token")

  .powerbi.app <<- httr::oauth_app(
          appName, key = clientId, secret = clientSecret)

  .powerbi.token <<- httr::oauth2.0_token(
        .powerbi.urls, .powerbi.app,
        user_params = list(resource = "https://analysis.windows.net/powerbi/api"))

  .expires <<- as.numeric(.powerbi.token$credentials$expires_on)

  .token <<- .powerbi.token$credentials$access_token

}
