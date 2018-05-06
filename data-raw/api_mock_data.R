# save data to be used for mocks when testing api calls (e.g. no internet)

library(httr)

get_output <- NULL
trace(
  GET,
  exit = function() { get_output <<- returnValue() }
)

api_path <- "/api/v2/tickets/3"
url <- httr::modify_url(paste0("https://", Sys.getenv("FRESHDESK_DOMAIN"), ".freshdesk.com"), path = api_path)
resp <- GET(url, authenticate(Sys.getenv("FRESHDESK_API_KEY"), "x"))

devtools::use_data(get_output, internal = TRUE, overwrite = TRUE)
