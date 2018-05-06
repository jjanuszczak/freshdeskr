context("Freshdesk api")

test_that("data returned is valid", {
  api_data <- with_mock(
    `httr::GET` = function(...) {
      get_output
    },
    freshdesk_api(freshdesk_client("xxx", "xxx"), "/api/v2/tickets/3")
  )
  expect_equal(api_data$content$subject, "Chat with Norman Jones on Missing order.")
})

test_that("credentials are valid", {
  fc <- freshdesk_client("xxx", "xxx")
  expect_error(freshdesk_api(fc, "/api/v2/tickets/3"), "The API returned an error.")
})
