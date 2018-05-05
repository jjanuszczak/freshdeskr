
<!-- README.md is generated from README.Rmd. Please edit that file -->
freshdeskr: An R Package for the Freshdesk API
==============================================

**Authors:** [John Januszczak](https://github.com/jjanuszczak)<br/> **License:** [MIT](https://opensource.org/licenses/MIT)

[![Travis-CI Build Status](https://travis-ci.org/jjanuszczak/freshdeskr.svg?branch=master)](https://travis-ci.org/jjanuszczak/freshdeskr)

This R package acts as a wrapper for the [Freshdesk API](https://developers.freshdesk.com/api/). This is a work in progress. Check back for updates.

Currently this is bare bones and can be used to query the Freshdesk API and retreive:

-   parsed json from the respose object
-   the httr response object
-   rate limit status

Installation
------------

You can install freshdeskr from github with:

``` r
# install.packages("devtools")
devtools::install_github("jjanuszczak/freshdeskr")
```

Example
-------

Usiung the `freshdesk_api` function you can call the Freshdesk API directly:

``` r
library(freshdeskr)

# create a client
fc <- freshdesk_client(my_domain, my_api_key)

# query the api and get a list of tickets
apidata <- freshdesk_api(fc, "/api/v2/tickets/3")
#> Warning in strptime(x, fmt, tz = "GMT"): unknown timezone 'zone/tz/2018c.
#> 1.0/zoneinfo/Asia/Manila'

# get useful data from the parsed response
apidata$content$subject
#> [1] "Chat with Norman Jones on Missing order."
```

``` r
# get current status of rate limit at time of api call
apidata$rate_limit_remaining
#> [1] "4999"
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
