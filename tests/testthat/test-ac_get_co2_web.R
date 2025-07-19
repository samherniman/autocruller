ac_df <- ac_get_co2_web()

test_that("ac_get_co2_web works", {
  expect_length(ac_df, 18)
  testthat::expect_type(ac_df$co2readings[[1]], "double")
})
