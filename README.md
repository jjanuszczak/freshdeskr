# freshdeskr: An R Package for the Freshdesk API
This R package acts as a wrapper for the [Freshdesk API](https://developers.freshdesk.com/api/). This is a work in progress. Check back for updates.

Currently this is bare bones and can be used to query the Freshdesk API and retreive:

* parsed json from the respose object
* the httr response object
* rate limit status

```r
library(freshdeskr)

# create a client
fc <- freshdesk_client("your-domain", "your-api-key")

# query the api and get a list of tickets
apidata <- freshdesk_api(fc, "/api/v2/tickets/3")

# get useful data from the parsed response
apidata$content$subject

## [1] "Chat with Norman Jones on Missing order."

# get current status of rate limit at time of api call
apidata$rate_limit_remaining

## [1] "4999"
```

Check out the Freshdesk [API documentation](https://developers.freshdesk.com/api/) for more details.
