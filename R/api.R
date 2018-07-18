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
#' @param check_connection If \code{TRUE}, checks internet connection and connection to the API
#'   by querying \code{check_api_path}. \strong{Note: Checking the connection consumes API call credits}.
#' @param check_api_path The API path used to test the connection if \code{check_connection} is set
#'   to \code{TRUE}.
#' @return A list of your credentials. This list is required by the \code{\link{freshdesk_api}}
#'   function to call methods through the API.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("foo", "me@@foo.com", "myPassword")
#' fc <- freshdesk_client("foo", "MyAPIKey")
#' }
#' @export
freshdesk_client <- function(domain, api_key,
                             password = "x",
                             check_connection = FALSE,
                             check_api_path = "/api/v2/settings/helpdesk") {
  # validate parameter values
  if (domain == "" || api_key == "") {
    stop("Freshdesk domain and api key must be specified", call. = FALSE)
  }

  # initialize the data to return
  config <- list(domain = domain,
                 api_key = api_key,
                 password = password,
                 rate_limit_remaining = NULL,
                 rate_limit_total = NULL)

  if (check_connection) {
    # first check that there is an internet connection
    check_internet()

    # check connecting to API
    resp <- freshdesk_GET(domain, check_api_path, api_key, password)

    # if we get this far, provide current rate limit status
    config$rate_limit_remaining = httr::headers(resp)$`x-ratelimit-remaining`
    config$rate_limit_total = httr::headers(resp)$`x-ratelimit-total`
    message(paste0("Valid API client. ", httr::headers(resp)$`x-ratelimit-remaining`, " API calls of ",
                   httr::headers(resp)$`x-ratelimit-total`, " remaining."))
  }

  return(config)
}

#' Calls Freshdesk API
#'
#' \code{freshdesk_api_call} makes a single query the Freshdesk API and returns a result.
#'
#' This function queries the Freshdesk API based on a path and returns a \code{freshdesk_api}
#' object containing the http response, the parsed content, and the API rate limit status.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param path The API query path.
#' @param  query API query string.
#' @return An S3 object contaitning the following attributes:
#'   \itemize{
#'     \item{\code{content}}: {the parsed content of the response.}
#'     \item{\code{path}}: {the API query path.}
#'     \item{\code{response}}: {the complete httr reponse object.}
#'     \item{\code{rate_limit_remaining}}: {the API calls remaining in the current period.}
#'     \item{\code{rate_limit_total}}: {the total API calls for the current period.}
#'   }
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("foo", "MyAPIKey")
#' apidata <- freshdesk_api(fc, "/api/v2/tickets/3")
#' apidata$rate_limit_remaining
#' }
#' @export
freshdesk_api_call <- function(client, path, query = NULL) {

  # check for internet connection
  check_internet()

  # get and chek response from API
  resp <- freshdesk_GET(client$domain, path, client$api_key, client$password, query = query)

  # send an error if we don't get json back
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  # parse the content of the response
  parsed <- jsonlite::fromJSON(httr::content(resp, "text"), flatten = TRUE)

  # return a simple S3 object containing the parsed content, the raw response object,
  # and API rate limit status
  return(
    structure(
      list(
        content = parsed,
        path = path,
        response = resp,
        rate_limit_remaining = httr::headers(resp)$`x-ratelimit-remaining`,
        rate_limit_total = httr::headers(resp)$`x-ratelimit-total`
      ),
      class = "freshdesk_api"
    )
  )
}

#' Calls Freshdesk API
#'
#' \code{freshdesk_api} queries the Freshdesk API and returns a result.
#'
#' This function queries the Freshdesk API based on a path and returns a \code{freshdesk_api}
#' object containing the http responses, the parsed content, and the API rate limit status. If the
#' results are paginated, all of the results will be returned up to the number of pages specified
#' (all pages by default). If the results span multiple pages, a list of http responses and the
#' rate limit information from the final call is returned in the \code{freshdesk_api} object along
#' with \strong{all} the data combined.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param path The API query path.
#' @param query API query string.
#' @param per_page The number of results per page. The default is 30. Values over 100 will
#'   result in an error being raised as it wis not allowed by the Freshdesk API.
#' @param pages By default, all pages will be returned. Specify this value along with the
#'   \code{per_page} parameter to limit the number of results returned.
#' @return An S3 object contaitning the following attributes:
#'   \itemize{
#'     \item{\code{content}}: {the parsed content of the response.}
#'     \item{\code{path}}: {the API query path.}
#'     \item{\code{response}}: {the complete httr reponse objects.}
#'     \item{\code{rate_limit_remaining}}: {the API calls remaining in the current period.}
#'     \item{\code{rate_limit_total}}: {the total API calls for the current period.}
#'   }
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("foo", "MyAPIKey")
#' apidata <- freshdesk_api(fc, "/api/v2/tickets/3")
#' apidata$rate_limit_remaining
#' }
#' @export
freshdesk_api <- function(client, path, query = NULL, per_page = NULL, pages = Inf) {

  page_count <- 1

  if(!is.null(per_page)) {
    # the maximum number of objects that can be retrieved per page is 100
    # invalid values and values greater than 100 will result in an error
    # if the value specified is too large, just set to 100
    if(per_page > 100) {
      per_page <- 100
    }

    # add the query parameter for per_page
    query$per_page <- per_page

    # get first set up results
    api_data <- freshdesk_api_call(client, path, query = query)
    api_pages <- list(api_data$content)
    api_responses <- list(api_data$response)

    # if there is no data, it is pointless to continue
    if(length(api_data$content) > 0) {

      # as long as there is a link to the next page and within pages specified
      # add to list of pages
      while("link" %in% names(api_data$response$headers) & (page_count <= pages)) {
        page_count <- page_count + 1
        query$page <- page_count
        api_data <- freshdesk_api_call(client, path, query = query)
        api_pages[[length(api_pages) + 1L]] <- api_data$content
        api_responses[[length(api_responses) + 1L]] <- api_data$response
      }

      # bind all of the records returned together
      api_data$content <- jsonlite::rbind_pages(api_pages)

      # provide the list of response objects
      api_data$response <- api_responses
    }
  } else {
    api_data <- freshdesk_api_call(client, path, query)
  }

  return(api_data)
}

#' Generic print for \code{freshdesk_api} class
#'
#' Prints the class name, parsed json and current rate limit information
#'
#' @param x freshdesk api object
#' @param ... other arguments
#' @export
print.freshdesk_api <- function(x, ...) {
  cat("<Freshdesk ", x$path, ">\n", sep = "")
  str(x$content)
  cat(x$rate_limit_remaining, " calls of ", x$rate_limit_total, " remaining.\n", sep="")
  invisible(x)
}

# wrapper for freshdesk GET requests
freshdesk_GET <- function(domain, path, api_key, password, query = NULL, freshdesk_address = "freshdesk.com") {
  url <- httr::modify_url(paste0("https://", domain, ".", freshdesk_address), path = path)
  resp <- httr::GET(url, query = query, httr::authenticate(api_key, password))

  # check response
  check_status(resp)
  return(resp)
}

# calculate pagination parameters
get_pagination_params <- function(records_requested, per_page = 100) {
  if(is.infinite(records_requested)) {
    num_pages <- Inf
  } else {
    if(records_requested <= 100) {
      per_page <- records_requested
      num_pages <- 1
    } else {
      num_pages <- ceiling(records_requested / 100)
    }
  }

  return(list(records_per_page = per_page, number_of_pages = num_pages))
}

# get specific number fo records via freshdesk api
get_freshdesk_records <- function(client, path, query = NULL, number_of_records = Inf) {
  pagination_params <- get_pagination_params(number_of_records)
  apidata <- freshdesk_api(client, path,
                           query = query,
                           per_page = pagination_params$records_per_page,
                           pages = pagination_params$number_of_pages)
  records <- apidata$content
  if(nrow(records) > number_of_records) {
    records <- records[1:number_of_records,]
  }
  return(records)
}
