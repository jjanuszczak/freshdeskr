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
#'   \code{\link{ticket_include_parameters}} which is defined in the package.
#' @param priorities_lookup Optional dataframe of ticket priorities and associated values.
#'   Defaults to \code{\link{ticket_priorities}} which is defined in the package.
#' @param sources_lookup Optional dataframe of ticket sources and associated values.
#'   Defaults to \code{\link{ticket_sources}} which is defined in the package.
#' @param status_lookup Optional dataframe of ticket status and associated values.
#'   Defaults to \code{\link{ticket_status}} which is defined in the package.
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
  ticket_data$priority <- priorities_lookup$Priority[priorities_lookup$Value == ticket_data$priority]
  ticket_data$source <- sources_lookup$Source[sources_lookup$Value == ticket_data$source]
  ticket_data$status <- status_lookup$Status[status_lookup$Value == ticket_data$status]

  return(ticket_data)
}

#' View a list of Tickets
#'
#' \code{tickets} queries the Freshdesk API and returns a data frame of ticke data.
#'
#' This function queries the Freshdesk API to view the details regarding multiple
#' tickets.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param tickets_path The path of the tickets API. Defaults to \code{/api/v2/tickets}.
#'   You should not need to change the default value.
#' @param remove_fields Fields returned by the Freshdesk API to remove from the data frame.
#'   Defaults to removing the \code{description} and \code{description_text} fields
#'   which could be quite verbose.
#' @param include_requester If \code{TRUE} returns additional attributes of the requester.
#' @param include_stats If \code{TRUE} returns additional attributes of the status.
#' @param include_custom_fields If \code{TRUE} customer fields will be included in the results.
#' @param priorities_lookup Optional dataframe of ticket priorities and associated values.
#'   Defaults to \code{\link{ticket_priorities}} which is defined in the package.
#' @param sources_lookup Optional dataframe of ticket sources and associated values.
#'   Defaults to \code{\link{ticket_sources}} which is defined in the package.
#' @param status_lookup Optional dataframe of ticket status and associated values.
#'   Defaults to \code{\link{ticket_status}} which is defined in the package.
#' @param date_fields Fields returned by the Freshdesk API that are date fields. Defaults
#'   to \code{\link{ticket_date_fields}} which is defined in the package.
#' @return A data frame of tickets.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view tickets
#' t <- tickets(fc)
#' }
#' @export
tickets <- function(client,
                    tickets_path = "/api/v2/tickets",
                    remove_fields = c("description", "description_text"),
                    include_requester = FALSE,
                    include_stats = FALSE,
                    include_custom_fields = FALSE,
                    priorities_lookup = ticket_priorities,
                    sources_lookup = ticket_sources,
                    status_lookup = ticket_status,
                    date_fields = ticket_date_fields) {
  # handle optional includes
  include <- vector()
  if (include_requester) {
    include <- c(include, "requester")
  }
  if (include_stats) {
    include <- c(include, "stats")
  }
  if (length(include) > 0) {
    include <- paste(include, collapse = ",")
  } else {
    include = NULL
  }

  query_args <- list(include = include)

  # retrieve the tickets data
  apidata <- freshdesk_api(client, tickets_path, query = query_args)
  ticket_data <- apidata$content

  # remove any fields specified in the call
  if (!is.null(remove_fields)) {
    ticket_data <- ticket_data[ , !(names(ticket_data) %in% remove_fields)]
  }

  # do some replacing of codes with labels
  ticket_data$priority <- priorities_lookup$Priority[match(ticket_data$priority, priorities_lookup$Value)]
  ticket_data$source <- sources_lookup$Source[match(ticket_data$source, sources_lookup$Value)]
  ticket_data$status <- status_lookup$Status[match(ticket_data$status, status_lookup$Value)]

  # change dates from character to date fields
  date_fields <- date_fields[(date_fields %in% names(ticket_data))]
  ticket_data[, date_fields] <- lapply(ticket_data[, date_fields], as.POSIXlt, format='%Y-%m-%dT%H:%M:%SZ')

  return(ticket_data)
}

#' Save a list of Tickets to a csv file
#'
#' \code{tickets} queries the Freshdesk API, saves a list of tickets to a file and
#'   returns a data frame of ticke data.
#'
#' This function queries the Freshdesk API to view and save the details regarding multiple
#' tickets to a csv file.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param file The csv file path to which the tickets data will be saved.
#' @param tickets_path The path of the tickets API. Defaults to \code{/api/v2/tickets}.
#'   You should not need to change the default value.
#' @param remove_fields Fields returned by the Freshdesk API to remove from the data frame.
#'   Defaults to removing the \code{description} and \code{description_text} fields
#'   which could be quite verbose.
#' @param include_requester If \code{TRUE} returns additional attributes of the requester.
#' @param include_stats If \code{TRUE} returns additional attributes of the status.
#' @param include_custom_fields If \code{TRUE} customer fields will be included in the results.
#' @return A data frame of tickets.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view tickets
#' t <- tickets_csv(fc)
#' }
#' @export
tickets_csv <- function(client,
                        file,
                        tickets_path = "/api/v2/tickets",
                        remove_fields = c("description", "description_text"),
                        include_requester = FALSE,
                        include_stats = FALSE,
                        include_custom_fields = FALSE) {
  # get ticket data
  ticket_data <- tickets(client,
                         tickets_path = tickets_path,
                         remove_fields = remove_fields,
                         include_requester = include_requester,
                         include_stats = include_stats,
                         include_custom_fields = include_custom_fields)

  # remove any non-atomic fields (but allow POSIXlt datetimes)
  ticket_data <- is_column_atomic(ticket_data)

  # save to file
  write.csv(ticket_data, file)

  #return the data frame
  return(ticket_data)
}


