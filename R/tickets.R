# Tickets

#' View a Ticket
#'
#' \code{ticket} queries the Freshdesk API and returns data related to a ticket.
#'
#' This function queries the Freshdesk API based on ticket id to view the details
#' regarding this ticket. You can optionally include conversation, requester, company
#' or extra stats data.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param ticket_id The ID of the ticket you would like to view.
#' @param tickets_path The path of the tickets API. Defaults to \code{/api/v2/tickets}.
#'   You should not need to change the default value.
#' @param include Optional include a vector of query string parameters.
#' @param valid_include_parameters Optional vector of valid include parameters. Defaults to
#'   \code{ticket_include_parameters} which is defined in the package.
#' @param priorities_lookup Optional dataframe of ticket priorities and associated values.
#'   Defaults to \code{ticket_priorities} which is defined in the package.
#' @param sources_lookup Optional dataframe of ticket sources and associated values.
#'   Defaults to \code{ticket_sources} which is defined in the package.
#' @param status_lookup Optional dataframe of ticket status and associated values.
#'   Defaults to \code{ticket_status} which is defined in the package.
#' @return A list with the attributes of the ticket.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view ticket with id = 3 and include addtional company and requester data
#' t <- ticket(fc, 3, include = "requester,company")
#' }
#' @export
ticket <- function(client,
                   ticket_id,
                   tickets_path = "/api/v2/tickets",
                   include = NULL,
                   valid_include_parameters = ticket_include_parameters,
                   priorities_lookup = ticket_priorities,
                   sources_lookup = ticket_sources,
                   status_lookup = ticket_status) {
  # validate arguments
  if (is.null(ticket_id)) {
    stop("Ticket ID not specified", call. = FALSE)
  }

  # add optional include query parameters
  if (!is.null(include)) {
    if (!all(include %in% valid_include_parameters)) {
      stop("Invalid parameters for include quesry string", call. = FALSE)
    } else {
      include <- paste(include, collapse = ",")
      include <- paste("include=", include, sep = "")
    }
  }

  # construct the API path for the ticket
  path = paste0(tickets_path, "/", ticket_id)

  # retrieve the ticket data
  apidata <- freshdesk_api(client, path, include)
  ticket_data <- apidata$content

  # do some cleaning
  ticket_data$priority = priorities_lookup$Priority[priorities_lookup$Value == ticket_data$priority]
  ticket_data$source = sources_lookup$Source[sources_lookup$Value == ticket_data$source]
  ticket_data$status = status_lookup$Status[status_lookup$Value == ticket_data$status]

  return(ticket_data)
}
