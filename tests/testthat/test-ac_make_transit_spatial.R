ac_df <- ac_get_co2_transit() |>
  ac_make_transit_spatial()

test_that("ac_get_co2_transit works", {
  expect_equal(length(ac_df), 40)
  expect_gt(nrow(ac_df), 7000)
  expect_type(ac_df$co2readings, "list")
})
