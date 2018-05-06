# lookup tables useful for interacting with the Freshdesk API

# create priorities lookup table
values <- c(1, 2, 3, 4)
priority <- c("Low", "Medium", "High", "Urgent")
ticket_priorities <- data.frame("Priority" = priority, "Value" = values)

# creates the sources lookup table
values <- c(1, 2, 3, 7, 8, 9, 10)
source <- c("Email", "Portal", "Phone", "Chat", "Mobihelp", "Feedback Widget", "Outbound Email")
ticket_sources <- data.frame("Source" = source, "Value" = values)

# create ticket status lookup table
values <- c(2, 3, 4, 5)
status <- c("Open", "Pending", "Resolved", "Closed")
ticket_status <- data.frame("Status" = status, "Value" = values)

# persist the lookup tables for internal package use
devtools::use_data(ticket_priorities, internal = FALSE, overwrite = TRUE)
devtools::use_data(ticket_sources, internal = FALSE, overwrite = TRUE)
devtools::use_data(ticket_status, internal = FALSE, overwrite = TRUE)
