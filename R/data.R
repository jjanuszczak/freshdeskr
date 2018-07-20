#' Ticket date fields returned by the Freshdesk API.
#'
#' A list containing all the potential date fields that
#' may be returned with tickt data from the Freshdesk API.
#'
#' @format A vector
#'
#' @source \url{https://developers.freshdesk.com/api/}
"ticket_date_fields"

#' Ticket embedding parameters by the Freshdesk API.
#'
#' A list containing all the valid parametes that can be
#' used by \code{include} query string when extracting
#' tickt data from the Freshdesk API.
#'
#' @format A vector
#'
#' @source \url{https://developers.freshdesk.com/api/}
"ticket_include_parameters"

#' Lookup table for ticket priorities.
#'
#' A dataset containing the priorty and value for valid
#' ticket priorities.
#'
#' @format A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{Priority}{the priority name}
#'   \item{Value}{the numeric value returned by the API}
#' }
#' @source \url{https://developers.freshdesk.com/api/}
"ticket_priorities"

#' Lookup table for ticket sources.
#'
#' A dataset containing the source and value for valid
#' ticket sources.
#'
#' @format A data frame with 7 rows and 2 variables:
#' \describe{
#'   \item{Source}{the source name}
#'   \item{Value}{the numeric value returned by the API}
#' }
#' @source \url{https://developers.freshdesk.com/api/}
"ticket_sources"

#' Lookup table for ticket status.
#'
#' A dataset containing the priorty and value for valid
#' ticket status.
#'
#' @format A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{Status}{the status name}
#'   \item{Value}{the numeric value returned by the API}
#' }
#' @source \url{https://developers.freshdesk.com/api/}
"ticket_status"

#' Agent date fields returned by the Freshdesk API.
#'
#' A list containing all the potential date fields that
#' may be returned with agent data from the Freshdesk API.
#'
#' @format A vector
#'
#' @source \url{https://developers.freshdesk.com/api/}
"agent_date_fields"

#' Lookup table for ticket scope
#'
#' A dataset containing the ticket scope and value for valid
#' ticket scope
#'
#' @format A data frame with 3 rows and 2 variables:
#' \describe{
#'   \item{Scope}{the ticket scope}
#'   \item{Value}{the numeric value returned by the API}
#' }
#' @source \url{https://developers.freshdesk.com/api/}
"agent_ticket_scope"
