ac_df <- ac_get_co2_transit()

test_that("ac_get_co2_download works", {
  expect_length(ac_df, 16)
  testthat::expect_type(ac_df$co2Array[[1]], "character")
})
