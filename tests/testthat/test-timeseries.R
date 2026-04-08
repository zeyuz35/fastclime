test_that("fastclime preserves xts and zoo classes and attributes", {
  skip_if_not_installed("xts")
  skip_if_not_installed("zoo")

  x_mat <- matrix(rnorm(100), 10, 10)
  x_xts <- xts::xts(x_mat, order.by = as.Date("2020-01-01") + 0:9)

  out_xts <- fastclime(x_xts, lambda.min = 0.1)
  expect_equal(class(out_xts$data), class(x_xts))
  expect_equal(attributes(out_xts$data), attributes(x_xts))

  x_zoo <- zoo::zoo(x_mat, order.by = 1:10)
  out_zoo <- fastclime(x_zoo, lambda.min = 0.1)
  expect_equal(class(out_zoo$data), class(x_zoo))
  expect_equal(attributes(out_zoo$data), attributes(x_zoo))
})
