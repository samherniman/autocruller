ac_df_web <- ac_get_co2()
ac_df_dwn <- ac_get_co2("download")

test_that("ac_get_co2 works", {
  expect_length(ac_df_web, 18)
  testthat::expect_type(ac_df_web$co2readings[[1]], "double")

  expect_length(ac_df_dwn, 22)
  testthat::expect_type(ac_df_dwn$co2readings[[1]], "integer")
})
