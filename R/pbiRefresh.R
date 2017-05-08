#' Internal method for refreshing the access token.
#' @description Uses a hidden function from the httr package to refresh the access token.
#' @return A character string containing a valid access token.

._pbiRefresh <- function()
{

  urls = .pkgenv[["powerbi.urls"]]
  app = .pkgenv[["powerbi.app"]]
  token = .pkgenv[["powerbi.token"]]

  cred = token$credentials

    ### Taken from httr:::known_oauth2.0_error to avoid R CMD check errors. TO BE REMOVED. ###
    ufnKnown = function(response)
    {
      if (httr::status_code(response) %in% c(400, 401)) {
        content <- httr::content(response)
        if (content$error %in% c("invalid_request", "invalid_client", "invalid_grant", "unauthorized_client",
                                 "unsupported_grant_type", "invalid_scope")) {
          return(TRUE)
        }
      }
      FALSE
    }

  ### Taken from httr:::refresh_oauth2.0 to avoid R CMD check errors. ###
  ufnRefresh = function (endpoint, app, credentials, user_params = NULL, use_basic_auth = FALSE)
  {
    if (is.null(credentials$refresh_token)) {
      stop("Refresh token not available", call. = FALSE)
    }
    refresh_url <- endpoint$access
    req_params <- list(refresh_token = credentials$refresh_token,
                       client_id = app$key, grant_type = "refresh_token")
    if (!is.null(user_params)) {
      req_params <- utils::modifyList(user_params, req_params)
    }
    if (isTRUE(use_basic_auth)) {
      response <- httr::POST(refresh_url, body = req_params, encode = "form",
                             httr::authenticate(app$key, app$secret, type = "basic"))
    }
    else {
      req_params$client_secret <- app$secret
      response <- httr::POST(refresh_url, body = req_params, encode = "form")
    }
    if (ufnKnown(response)) {
      warning("Unable to refresh token", call. = FALSE)
      return(NULL)
    }
    httr::stop_for_status(response)
    refresh_data <- httr::content(response)
    utils::modifyList(credentials, refresh_data)
  }


  ## Run httr refresh function.
  token = try(
    ufnRefresh(
      urls, app, cred,
      user_params = list(resource = "https://analysis.windows.net/powerbi/api")
    ))

  if(is(token, "try-error")) {
    stop("Could not refresh the access token. *shrugs*. Have you authenticated with pbiAuthenticate?")
    return(NULL)
  }

  .pkgenv[["expires"]] = as.numeric(token$expires_on)

  ## Reassign the hidden token value.
  return(token$access_token)

}
