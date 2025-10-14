ac_df <- ac_get_co2_download()

test_that("ac_get_co2_download works", {
  expect_length(ac_df, 22)
  testthat::expect_type(ac_df$co2readings[[1]], "integer")
})
