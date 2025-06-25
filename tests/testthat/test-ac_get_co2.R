icm_df <- ac_get_co2()

test_that("ac_get_co2 works", {
  expect_length(icm_df, 19)
})
