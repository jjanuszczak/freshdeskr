# freshdeskr: An R Package for the Freshdesk API
This R package acts as a wrapper for the [Freshdesk API](https://developers.freshdesk.com/api/). This is a work in progress. Check back for updates.

Currently this is bare bones and can be used to query the Freshdesk API and retreive an http response object, e.g.

```r
# create a client
fc <- freshdesk_client("your-domain", "your-api-key")

# query the api and get a list of tickets
resp <- freshdesk_api(fc, "/api/v2/tickets")
```

Check out the Freshdesk [API documentation](https://developers.freshdesk.com/api/) for more details.
