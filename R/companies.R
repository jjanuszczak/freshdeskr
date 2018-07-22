# Companies

#' View an Company
#'
#' \code{agent} queries the Freshdesk API and returns data related to an comapny.
#'
#' This function queries the Freshdesk API based on company id to view the details
#' regarding this company.
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param company_id The ID of the company you would like to view.
#' @param companies_path The path of the companies API. Defaults to \code{/api/v2/companies}.
#'   You should not need to change the default value.
#' @return A list with the attributes of the company
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view compnay with id = 42001318958
#' co <- company(fc, 42001318958)
#' }
#' @export
company <- function(client,
                    company_id,
                    companies_path = "/api/v2/companies") {
  # get the record
  company_data <- get_freshdesk_record(client, company_id, companies_path)

  return(company_data)
}

#' View a list of Companies
#'
#' \code{companies} queries the Freshdesk API and returns a data frame of company data.
#'
#' This function queries the Freshdesk API to view the details regarding multiple
#' companies
#'
#' @param client The Freshdesk API client object (see \code{\link{freshdesk_client}}).
#' @param companies_path The path of the companies API. Defaults to \code{/api/v2/companies}.
#'   You should not need to change the default value.
#' @param max_records Specifies the maximum number of records to return.
#' @param date_fields Fields returned by the Freshdesk API that are date fields. Defaults
#'   to \code{\link{company_date_fields}} which is defined in the package.
#' @return A data frame of companies or \code{NULL} if there are no companies.
#' @examples
#' \dontrun{
#' fc <- freshdesk_client("your-domain", "your-api-key")
#'
#' # view companies
#' cos <- companies(fc)
#' }
#' @export
companies <- function(client,
                      companies_path = "/api/v2/companies",
                      max_records = Inf,
                      date_fields = company_date_fields) {

  # retrieve the agent data
  company_data <- get_freshdesk_records(client, companies_path, number_of_records = max_records)

  # it only makes sense to modify the results if results exist
  if(length(company_data) > 0) {

    # change dates from character to date fields
    company_data <- replace_with_POSIXlt(company_data, date_fields)
  } else {
    company_data <- NULL
  }

  return(company_data)
}
