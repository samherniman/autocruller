ac_ls <- ac_make_linestring(
  lon = c(-0.614208, -0.613220, -0.598960, -0.584560, -0.575080, -0.560064),
  lat = c(51.31744, 51.31165, 51.31226, 51.31390, 51.31322, 51.32118),
  noise_distance = 100
)
ac_na <- ac_make_linestring(
  lon = c(-0.614208, NA, -0.598960, 0, -0.575080, -0.560064),
  lat = c(51.31744, NA, 51.31226, 0.000, 30.31322, 51.32118),
  noise_distance = 10
)
ac_empty <- ac_make_linestring(
  lon = c(),
  lat = c()
)

test_that("ac_make_linestring works", {
  expect_length(ac_ls, 12)
  expect_type(ac_ls, "double")
  expect_length(ac_na, 6)
  expect_s3_class(ac_ls, c("XY", "LINESTRING", "sfg"))
  expect_s3_class(ac_empty, c("XY", "POINT", "sfg"))
  expect_true(sf::st_is_empty(ac_empty))
  expect_error(ac_make_linestring())
})
