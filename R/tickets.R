# Tickets

ticket <- function(client, ticket_id, tickets_path = "/api/v2/tickets") {
  # construct the API path for the ticket
  path = paste0(tickets_path, "/", ticket_id)

  # retrieve the ticket data
  apidata <- freshdesk_api(client, path)
  ticket_data <- apidata$content

  # do some cleaning
  ticket_data$priority = ticket_priorities$Priority[ticket_priorities$Value == ticket_data$priority]
  ticket_data$source = ticket_sources$Source[ticket_sources$Value == ticket_data$source]
  ticket_data$status = ticket_status$Status[ticket_status$Value == ticket_data$status]

  return(ticket_data)
}
