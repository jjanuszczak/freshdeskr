% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tickets.R
\name{tickets_csv}
\alias{tickets_csv}
\title{Save a list of Tickets to a csv file}
\usage{
tickets_csv(client, file, tickets_path = "/api/v2/tickets",
  remove_fields = c("description", "description_text"),
  include_requester = FALSE, include_stats = FALSE,
  include_custom_fields = FALSE, updated_since = NULL, max_records = Inf)
}
\arguments{
\item{client}{The Freshdesk API client object (see \code{\link{freshdesk_client}}).}

\item{file}{The csv file path to which the tickets data will be saved.}

\item{tickets_path}{The path of the tickets API. Defaults to \code{/api/v2/tickets}.
You should not need to change the default value.}

\item{remove_fields}{Fields returned by the Freshdesk API to remove from the data frame.
Defaults to removing the \code{description} and \code{description_text} fields
which could be quite verbose.}

\item{include_requester}{If \code{TRUE} returns additional attributes of the requester.}

\item{include_stats}{If \code{TRUE} returns additional attributes of the status.}

\item{include_custom_fields}{If \code{TRUE} customer fields will be included in the results.}

\item{updated_since}{Specifies tickets to include in results based on last time they were
updated. If set to \code{NULL}, only tickets updated in the last 30 days are returned.
The value can be a Date object or a character string in the format \code{YYYY-MM-DD}.}

\item{max_records}{Specifies the maximum number of records to return. If the number of records
specified is less then 30, up to 30 records will be returned by default if they exist.}
}
\value{
A data frame of tickets.
}
\description{
\code{tickets} queries the Freshdesk API, saves a list of tickets to a file and
  returns a data frame of ticke data.
}
\details{
This function queries the Freshdesk API to view and save the details regarding multiple
tickets to a csv file.
}
\examples{
\dontrun{
fc <- freshdesk_client("your-domain", "your-api-key")

# view tickets
t <- tickets_csv(fc)
}
}
