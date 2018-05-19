# checks for internet connection
check_internet <- function() {
  if (!curl::has_internet()) {
    stop("Please check your internet connection", call. = FALSE)
  }
}

# checks status of http request
check_status <- function(resp) {
  if (httr::http_error(resp)){
    stop(paste0("The API returned an error. ", httr::http_status(resp)$reason," ",
                httr::http_status(resp)$message), call. = FALSE)
  }
}

# wrapper for freshdesk GET requests
freshdesk_GET <- function(domain, path, api_key, password, query = NULL, freshdesk_address = "freshdesk.com") {
  url <- httr::modify_url(paste0("https://", domain, ".", freshdesk_address), path = path)
  resp <- httr::GET(url, query = query, httr::authenticate(api_key, password))

  # check response
  check_status(resp)
  return(resp)
}

# checks if class is POSIXlt
is_POSIXlt <- function(x) {
  inherits(x, "POSIXlt")
}

# removes columns from a data frame that are not atomic
is_column_atomic <- function(dataset, allow_POSIXlt = TRUE) {
  if (!allow_POSIXlt) {
    dataset <- dataset[, sapply(dataset, function(x) all(is.atomic(x)))]
  } else {
    dataset <- dataset[, sapply(dataset, function(x) all(is.atomic(x) | is_POSIXlt(x)))]
  }

  return(dataset)
}
