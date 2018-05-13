# field lists

# create ticket date fields list
ticket_date_fields <- c("due_by", "fr_due_by", "created_at", "updated_at", "agent_responded_at", "requester_responded_at",
                        "first_responded_at", "status_updated_at", "reopened_at", "resolved_at", "closed_at", "pending_since")

# persist the lists for internal package use
devtools::use_data(ticket_date_fields, internal = FALSE, overwrite = TRUE)
