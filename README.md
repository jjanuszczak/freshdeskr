
<!-- README.md is generated from README.Rmd. Please edit that file -->
freshdeskr: An R Package for the Freshdesk API
==============================================

**Authors:** [John Januszczak](https://github.com/jjanuszczak)<br/> **License:** [MIT](https://opensource.org/licenses/MIT)

[![Travis-CI Build Status](https://travis-ci.org/jjanuszczak/freshdeskr.svg?branch=master)](https://travis-ci.org/jjanuszczak/freshdeskr)

This R package acts as a wrapper for the [Freshdesk API](https://developers.freshdesk.com/api/). This is a work in progress. Check back for updates.

Installation
------------

You can install freshdeskr from github with:

``` r
# install.packages("devtools")
devtools::install_github("jjanuszczak/freshdeskr")
```

Example
-------

Using the `tickets` method, retrieve a data frame of tickets and get the status, priority and subject of all tickets updated in May 2018:

``` r
library(freshdeskr)

# create a client
fc <- freshdesk_client(my_domain, my_api_key)

# gets tickets 
ticket_data <- tickets(fc)

# filter by date
# dates in the dataframe are of type POSIXlt so they can be easily filtered by date or time part 
# (e..g month, year, etc.) remembering that months index from 0-11 and year is years since 1900
ticket_data <- ticket_data[ticket_data$updated_at$mon + 1 == 5 & ticket_data$updated_at$year + 1900 == 2018, ]

# subset by columns of interest
ticket_data[, c("subject", "status", "priority")]
#>                              subject status priority
#> 2 Vintage table lamp - Out of stock?   Open      Low
#> 3   Mary Jane shoes - Shipping rates   Open     High
```

Using the `freshdesk_api` function you can call the Freshdesk API directly to retrieve the following:

-   parsed json from the respose object
-   the httr response object
-   rate limit status

``` r
library(freshdeskr)

# create a client
fc <- freshdesk_client(my_domain, my_api_key)

# query the api and get a list of tickets
apidata <- freshdesk_api(fc, "/api/v2/tickets/3")

# get useful data from the parsed response
apidata$content$subject
#> [1] "Chat with Norman Jones on Missing order."
```

``` r
# get current status of rate limit at time of api call
apidata$rate_limit_remaining
#> [1] "4990"
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
