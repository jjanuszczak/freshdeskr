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
    url <- httr::modify_url(paste0("https://", domain, ".freshdesk.com"), path = check_api_path)
    resp <- httr::GET(url, httr::authenticate(api_key, password))
    check_status(resp)
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
#' \code{freshdesk_api} queries the Freshdesk API and returns a result.
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
freshdesk_api <- function(client, path, query = NULL) {
  url <- httr::modify_url(paste0("https://", client$domain, ".freshdesk.com"), path = path)
  resp <- httr::GET(url, query = query, httr::authenticate(client$api_key, client$password))

  # check for internet connection
  check_internet()

  # send an error if we don't get success
  check_status(resp)

  # send an error if we don't get json back
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  # parse the content of the response
  parsed <- jsonlite::fromJSON(httr::content(resp, "text"))

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
