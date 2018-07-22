# Contacts

#' View a Contact
#'
#' \code{contact} queries the Freshdesk API and returns data related to a contact.
#'
#' This function queries the Freshdesk API based on contact id to view the details
#' regarding this contact.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param contact_id The ID of the contact you would like to view.
#' @param contacts_path The path of the contacts API. Defaults to \code{/api/v2/contacts}.
#'   You should not need to change the default value.
#' @return A list with the attributes of the contact.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view contact with id = 42001318958
#' ct <- contact(fc, 42001318958)
#' }
#' @export
contact <- function(client,
                  contact_id,
                  contacts_path = "/api/v2/contacts") {
  # get the record
  contact_data <- get_freshdesk_record(client, contact_id, contacts_path)

  return(contact_data)
}

#' View a list of Contacts
#'
#' \code{contacts} queries the Freshdesk API and returns a data frame of contact data.
#'
#' This function queries the Freshdesk API to view the details regarding multiple
#' contacts
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param contacts_path The path of the agents API. Defaults to \code{/api/v2/contacts}.
#'   You should not need to change the default value.
#' @param max_records Specifies the maximum number of records to return.
#' @param date_fields Fields returned by the Freshdesk API that are date fields. Defaults
#'   to \code{\link{contact_date_fields}} which is defined in the package.
#' @return A data frame of contacts or \code{NULL} if there are no contacts.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view contacts
#' cs <- contacts(fc)
#' }
#' @export
contacts <- function(client,
                    contacts_path = "/api/v2/contacts",
                    max_records = Inf,
                    date_fields = contact_date_fields) {

  # retrieve the agent data
  contact_data <- get_freshdesk_records(client, contacts_path, number_of_records = max_records)

  # it only makes sense to modify the results if results exist
  if(length(contact_data) > 0) {

    # change dates from character to date fields
    contact_data <- replace_with_POSIXlt(contact_data, date_fields)
  } else {
    contact_data <- NULL
  }

  return(contact_data)
}
