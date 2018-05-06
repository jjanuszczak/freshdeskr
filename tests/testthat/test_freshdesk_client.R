context("Freshdesk client")

test_that("client credentials are valid", {
  expect_error(freshdesk_client("xxx", "xxx", check_connection = TRUE), "The API returned an error.")
  expect_error(freshdesk_client())
  expect_error(freshdesk_client("xxx"))
})

test_that("freshdesk client output is valid", {
  credentials <- list(domain = "xxx", api_key = "xxx", password = "x")
  expect_identical(freshdesk_client("xxx", "xxx"), credentials)
  expect_identical(freshdesk_client("xxx", "xxx", check_connection = FALSE), credentials)
  expect_equal(freshdesk_client("xxx", "xxx", password = "test")$password, "test")
})
