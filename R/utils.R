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

# replaces specified fields with POSIXlt fields based on the format provided
replace_with_POSIXlt <- function(data, date_fields, date_format = '%Y-%m-%dT%H:%M:%SZ') {
  date_fields <- date_fields[(date_fields %in% names(data))]
  data[, date_fields] <- lapply(data[, date_fields], as.POSIXlt, format=date_format)
  return(data)
}
