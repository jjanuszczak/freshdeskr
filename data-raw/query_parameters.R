# query parameters

# create ticket include parameters
ticket_include_parameters <- c("conversations", "requester", "company", "stats")

# persist the parameters for internal package use
devtools::use_data(ticket_include_parameters, internal = TRUE, overwrite = TRUE)
