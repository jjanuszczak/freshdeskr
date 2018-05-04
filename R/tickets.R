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
#' @return A list with the attributes of the ticket.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view ticket with id = 3 and include addtional company and requester data
#' t <- ticket(fc, 3, include = "requester,company")
#' }
#' @export
ticket <- function(client, ticket_id, tickets_path = "/api/v2/tickets", include = NULL) {
  # validate arguments
  if (is.null(ticket_id)) {
    stop("Ticket ID not specified", call. = FALSE)
  }

  # add optional include query parameters
  if (!is.null(include)) {
    if (!all(include %in% ticket_include_parameters)) {
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
  ticket_data$priority = ticket_priorities$Priority[ticket_priorities$Value == ticket_data$priority]
  ticket_data$source = ticket_sources$Source[ticket_sources$Value == ticket_data$source]
  ticket_data$status = ticket_status$Status[ticket_status$Value == ticket_data$status]

  return(ticket_data)
}
