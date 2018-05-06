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
