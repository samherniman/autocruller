ac_df <- ac_get_co2()

test_that("ac_get_co2 works", {
  expect_length(ac_df, 19)
  testthat::expect_type(ac_df$co2array[[1]], "double")
})
