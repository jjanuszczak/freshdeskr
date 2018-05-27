# field lists

# create ticket date fields list
ticket_date_fields <- c("due_by", "fr_due_by", "created_at", "updated_at", "stats.agent_responded_at", "stats.requester_responded_at",
                        "stats.first_responded_at", "stats.status_updated_at", "stats.reopened_at", "stats.resolved_at", "stats.closed_at", "stats.pending_since")

# persist the lists for internal package use
devtools::use_data(ticket_date_fields, internal = FALSE, overwrite = TRUE)
