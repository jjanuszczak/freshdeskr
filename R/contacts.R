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
