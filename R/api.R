# Freshdesk API Utilities

#' Creates a Freshdesk API client
#'
#' \code{freshdesk_client} returns an object containing Freshdesk credentials.
#'
#' This function takes data regarding a Freshdesk account and creates a list object
#' continaing these credentials. This list contains data that will be used to
#' authenticate on Freshdesk when using the Freshdesk API.
#'
#' @param domain The Freshdesk domain, e.g. \code{https://<your-domain>.freshdesk.com}.
#' @param api_key Your Freshdesk api key. This can be found under \strong{Your API Key} on your
#'   Freshdesk \strong{Profile Settings} page. Otherwise set this to your user name to use basic
#'   authentication.
#' @param password Your password. Only required if you are using basic authentication.
#' @return A list of your credentials. This list is required by the \code{\link{freshdesk_api}}
#'   function to call methods through the API.
#' @examples
#' fc <- freshdesk_client("foo", "me@@foo.com", "myPassword")
freshdesk_client <- function(domain, api_key, password = "x") {
  # validate parameter values
  if (domain == "" || api_key == "") {
    stop("Freshdesk domain and api key must be specified", call. = FALSE)
  }

  config <- list(domain = domain, api_key = api_key, password = password)
  return(config)
}

freshdesk_api <- function(client, path) {
  url <- httr::modify_url(paste0("https://", client$domain, ".freshdesk.com"), path = path)
  resp <- httr::GET(url, authenticate(client$api_key, client$password))

  # send a worning if we don't get success
  if (httr::http_status(resp)$category != "Success"){
    warning(paste0(httr::http_status(resp)$reason," ",httr::http_status(resp)$message), call. = FALSE)
  }

  # send a warning if we don't get json back
  if (httr::http_type(resp) != "application/json") {
    warning("API did not return json", call. = FALSE)
  }

  return(resp)
}
