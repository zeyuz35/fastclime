test_that("fastclime handles time-series objects correctly", {
  skip_if_not_installed("xts")
  skip_if_not_installed("zoo")

  set.seed(123)
  data <- matrix(rnorm(200), 100, 2)

  # Base R ts
  x_ts <- ts(data, start = c(2000, 1), frequency = 12)
  res_ts <- fastclime(x_ts, lambda.min = 0.5)
  expect_equal(class(res_ts$data), class(x_ts))
  expect_equal(dim(res_ts$data), dim(x_ts))

  # xts
  x_xts <- xts::xts(data, order.by = seq(as.Date("2000-01-01"), length.out = 100, by = "month"))
  res_xts <- fastclime(x_xts, lambda.min = 0.5)
  expect_equal(class(res_xts$data), class(x_xts))
  expect_equal(dim(res_xts$data), dim(x_xts))

  # zoo
  x_zoo <- zoo::zoo(data, order.by = seq(as.Date("2000-01-01"), length.out = 100, by = "month"))
  res_zoo <- fastclime(x_zoo, lambda.min = 0.5)
  expect_equal(class(res_zoo$data), class(x_zoo))
  expect_equal(dim(res_zoo$data), dim(x_zoo))
})
