#' Authenticate your Power BI API session.
#' @description Supply your application name, client ID and client secret. You will need to register an application here: https://powerbi.microsoft.com/en-us/documentation/powerbi-developer-register-a-web-app/
#' @param appName The name of the application.
#' @param clientId Application ID.
#' @param clientSecret Client secret.
#' @examples
#' # pbiAuthenticate(appName = "abc", clientId = "def", clientSecret = "ghi")
pbiAuthenticate <- function(
  appName,
  clientId,
  clientSecret
  )
{

  .pkgenv[["powerbi.urls"]] <- httr::oauth_endpoint(
        authorize = "https://login.windows.net/common/oauth2/authorize",
        access = "https://login.windows.net/common/oauth2/token")

  .pkgenv[["powerbi.app"]] <- httr::oauth_app(
          appName, key = clientId, secret = clientSecret)

  .pkgenv[["powerbi.token"]] <- httr::oauth2.0_token(
    .pkgenv[["powerbi.urls"]], .pkgenv[["powerbi.app"]],
        user_params = list(resource = "https://analysis.windows.net/powerbi/api"))

  expires = .pkgenv[["powerbi.token"]]

  .pkgenv[["expires"]] <- as.numeric(expires$credentials$expires_on)

  .pkgenv[["token"]] <- expires$credentials$access_token

}

.pkgenv <- new.env(parent=emptyenv())
