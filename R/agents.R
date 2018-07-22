# Agents

#' View an Agent
#'
#' \code{agent} queries the Freshdesk API and returns data related to an agent.
#'
#' This function queries the Freshdesk API based on agent id to view the details
#' regarding this agent.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param agent_id The ID of the agent you would like to view.
#' @param agents_path The path of the agents API. Defaults to \code{/api/v2/agents}.
#'   You should not need to change the default value.
#' @param ticket_scope_lookup Optional dataframe of ticket scope and associated values.
#'   Defaults to \code{\link{agent_ticket_scope}} which is defined in the package.
#' @return A list with the attributes of the agent.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view agent with id = 42001318958
#' a <- agent(fc, 42001318958)
#' }
#' @export
agent <- function(client,
                  agent_id,
                  agents_path = "/api/v2/agents",
                  ticket_scope_lookup = agent_ticket_scope) {
  # validate arguments
  if (is.null(agent_id)) {
    stop("Agent ID not specified", call. = FALSE)
  }

  # construct the API path for the ticket
  path = paste0(agents_path, "/", agent_id)

  # retrieve the ticket data
  apidata <- freshdesk_api(client, path)
  agent_data <- apidata$content

  # do some cleanup
  agent_data$ticket_scope <- ticket_scope_lookup$Scope[ticket_scope_lookup$Value == agent_data$ticket_scope]

  return(agent_data)
}

#' View a list of Agents
#'
#' \code{tickets} queries the Freshdesk API and returns a data frame of agent data.
#'
#' This function queries the Freshdesk API to view the details regarding multiple
#' agents
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param agents_path The path of the agents API. Defaults to \code{/api/v2/agents}.
#'   You should not need to change the default value.
#' @param max_records Specifies the maximum number of records to return.
#' @param ticket_scope_lookup Optional dataframe of ticket scope and associated values.
#'   Defaults to \code{\link{agent_ticket_scope}} which is defined in the package.
#' @param date_fields Fields returned by the Freshdesk API that are date fields. Defaults
#'   to \code{\link{agent_date_fields}} which is defined in the package.
#' @return A data frame of agents or \code{NULL} if there are no agents.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view agents
#' a <- agents(fc)
#' }
#' @export
agents <- function(client,
                   agents_path = "/api/v2/agents",
                   max_records = Inf,
                   ticket_scope_lookup = agent_ticket_scope,
                   date_fields = agent_date_fields) {

  # retrieve the agent data
  agent_data <- get_freshdesk_records(client, agents_path, number_of_records = max_records)

  # it only makes sense to modify the results if results exist
  if(length(agent_data) > 0) {

    # do some replacing of codes with labels
    agent_data$ticket_scope <- ticket_scope_lookup$Scope[match(agent_data$ticket_scope, ticket_scope_lookup$Value)]

    # change dates from character to date fields
    date_fields <- date_fields[(date_fields %in% names(agent_data))]
    agent_data[, date_fields] <- lapply(agent_data[, date_fields], as.POSIXlt, format='%Y-%m-%dT%H:%M:%SZ')
  } else {
    agent_data <- NULL
  }

  return(agent_data)
}
