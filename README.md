
<!-- README.md is generated from README.Rmd. Please edit that file -->
freshdeskr: An R Package for the Freshdesk API
==============================================

**Authors:** [John Januszczak](https://github.com/jjanuszczak)<br/> **License:** [MIT](https://opensource.org/licenses/MIT)

[![Travis-CI Build Status](https://travis-ci.org/jjanuszczak/freshdeskr.svg?branch=master)](https://travis-ci.org/jjanuszczak/freshdeskr)

This R package acts as a wrapper for the [Freshdesk API](https://developers.freshdesk.com/api/). Currently, the package contains functionality for retrieving ticket, agent, company and contact data from Freshdesk. This data can be used in subsequent analysis.

Installation
------------

You can install freshdeskr from github with:

``` r
# install.packages("devtools")
devtools::install_github("jjanuszczak/freshdeskr")
```

Examples
--------

The following examples demonstrate how to retrieve ticket, agent, company and contact data from Freshdesk.

### Tickets

Using the `tickets` method, retrieve a data frame of tickets and get the status, priority and subject of all tickets updated since May 1, 2018:

``` r
library(freshdeskr)

# create a client
fc <- freshdesk_client(my_domain, my_api_key)

# gets tickets undated since May 1, 2018
ticket_data <- tickets(fc, updated_since = "2018-05-01")

# subset by columns of interest
ticket_data[, c("subject", "status", "priority")]
#>                              subject status priority
#> 1                 Where is my flour?   Open      Low
#> 2                       I need flour   Open      Low
#> 3 Vintage table lamp - Out of stock?   Open      Low
#> 4   Mary Jane shoes - Shipping rates   Open     High
```

### Companies

Using the `companies` method, get a list of companies:

``` r
# retrieve all companies
comps <- companies(fc, max_records = 2)

head(comps)
#>            id      name description note domains          created_at
#> 1 42000100795  ACME Inc          NA   NA    NULL 2018-05-13 06:29:55
#> 2 42000100791 Freshdesk          NA   NA    NULL 2018-05-13 02:33:13
#>            updated_at
#> 1 2018-05-13 06:29:55
#> 2 2018-05-13 02:33:13
```

### Agents

Using the `agent` method, get data on an agent based on the agent ID:

``` r
# get agent based on agent id
ag <- agent(fc, 42001318960)

# get the agent's name and email
cat(ag$contact$name, ",", ag$contact$email)
#> Customer Service , custserv@freshdesk.com
```

### Contacts

Use the `contacts` method to add contact name and email to a list of tickets

``` r
# get tickets updated since January 1, 2018
ticket_date <- tickets(fc, updated_since = "2018-01-01")

# get data on all contacts
contact_data <- contacts(fc)

# join data frames
tickets_with_contact_info <- merge(x = ticket_data, y = contact_data, by.x = "requester_id", by.y = "id")

# show contact name and email with ticket number and subject
tickets_with_contact_info[, c("id", "subject", "name", "email")]
#>   id                            subject            name
#> 1  1   Mary Jane shoes - Shipping rates      Emily Dean
#> 2  2 Vintage table lamp - Out of stock?     Matt Rogers
#> 3  5                 Where is my flour? Maria Christina
#> 4  4                       I need flour Maria Christina
#>                       email
#> 1  emily.dean@freshdesk.com
#> 2 matt.rogers@freshdesk.com
#> 3            maria@acme.com
#> 4            maria@acme.com
```

Interacting Directly with the API
---------------------------------

For lower level control and flexibility, use the `freshdesk_api` function to call the Freshdesk API directly to retrieve the following:

-   parsed and consolidated content from the API's http respose objects
-   the http response objects<sup>[1](#footnote1)</sup>
-   rate limit status

In the following example, we retrieve the ticket subject from the parsed response object:

``` r
library(freshdeskr)

# create a client
fc <- freshdesk_client(my_domain, my_api_key)

# query the api and view the details of ticket #3
apidata <- freshdesk_api(fc, "/api/v2/tickets/3")

# get useful data from the parsed response
apidata$content$subject
#> [1] "Chat with Norman Jones on Missing order."
```

One can also inspect the http response directly, for example:

``` r
apidata$response$status_code
#> [1] 200
```

Rate limit information is also returned by calls to the `freshdesk_api` function:

``` r
# get current status of rate limit at time of api call
apidata$rate_limit_remaining
#> [1] "976"
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

Endnotes
--------

<a name="footnote1"><sup>1</sup></a>The `freshdesk_api` method automatically handles pagination. If more than one api call was made to fetch data, a list of http response objects will be returned.
