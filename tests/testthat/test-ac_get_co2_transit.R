ac_df <- ac_get_co2_transit()

test_that("ac_get_co2_transit works", {
  expect_equal(length(ac_df), 16)
  expect_gt(nrow(ac_df), 1000)
  expect_type(ac_df$co2Array, "double")
})
