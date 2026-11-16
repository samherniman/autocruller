ac_df <- ac_get_co2_transit()
ac_df_long <- ac_df |>
  ac_unnest_longer()

test_that("ac_get_co2_transit works", {
  expect_length(ac_df, 39)
  expect_length(ac_df_long, 41)
  expect_gt(nrow(ac_df), 7000)
  expect_gt(nrow(ac_df_long), 160000)
  expect_type(ac_df$co2readings, "list")
  expect_type(ac_df_long$co2readings, "integer")
})
