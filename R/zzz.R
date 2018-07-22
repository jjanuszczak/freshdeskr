#' @importFrom utils globalVariables
if(getRversion() >= "2.15.1")  {
  utils::globalVariables(c('ticket_priorities',
                           'ticket_sources',
                           'ticket_status',
                           'ticket_include_parameters',
                           'ticket_date_fields',
                           'agent_ticket_scope',
                           'agent_date_fields',
                           'company_date_fields',
                           'contact_date_fields'))
}
