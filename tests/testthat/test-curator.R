test_that("fastclime preserves time-series class, index, attributes, and column names", {
  library(xts)
  set.seed(123)
  mat <- matrix(rnorm(100), 10, 10)
  colnames(mat) <- paste0("V", 1:10)
  x_xts <- xts(mat, order.by=Sys.Date()+1:10)

  res_xts <- fastclime(x_xts)
  expect_equal(class(res_xts$data), class(x_xts))
  expect_equal(dimnames(res_xts$data), dimnames(x_xts))
  expect_equal(attributes(res_xts$data)$index, attributes(x_xts)$index)

  x_ts <- ts(mat)
  res_ts <- fastclime(x_ts)
  expect_equal(class(res_ts$data), class(x_ts))
  expect_equal(dimnames(res_ts$data), dimnames(x_ts))
})
