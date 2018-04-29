# Freshdesk API Utilities

freshdesk_client <- function(domain, api_key, password = "x") {
  config <- list(domain = domain, api_key = api_key, password = password)
  return(config)
}

freshdesk_api <- function(client, path) {
  url <- httr::modify_url(paste0("https://", client$domain, ".freshdesk.com"), path = path)
  resp <- httr::GET(url, authenticate(client$api_key, client$password))

  # send a worning if we don't get success
  if (httr::http_status(resp)$category != "Success"){
    warning(paste0(httr::http_status(resp)$reason," ",httr::http_status(resp)$message))
  }

  # send a warning if we don't get json back
  if (httr::http_type(resp) != "application/json") {
    warning("API did not return json", call. = FALSE)
  }

  return(resp)
}
