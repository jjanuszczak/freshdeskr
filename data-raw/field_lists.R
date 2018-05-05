# field lists

# create ticket date fields list
ticket_date_fields <- c("due_by", "fr_due_by", "created_at", "updated_at")

# persist the lists for internal package use
devtools::use_data(ticket_date_fields, internal = TRUE, overwrite = TRUE)
