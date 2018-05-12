# save data to be used for mocks when testing api calls (e.g. no internet)

library(httr)

get_output <- NULL
trace(
  freshdeskr:::freshdesk_GET,
  exit = function() { get_output <<- returnValue() }
)

api_path <- "/api/v2/tickets/3"

resp <- freshdeskr:::freshdesk_GET(Sys.getenv("FRESHDESK_DOMAIN"), api_path, Sys.getenv("FRESHDESK_API_KEY"), "x")

devtools::use_data(get_output, internal = TRUE, overwrite = TRUE)
