library(testthat)

test_that("fastclime preserves time-series classes", {
  library(zoo)
  library(xts)

  m <- matrix(rnorm(100), 10, 10)

  # zoo
  z <- zoo(m, order.by = 1:10)
  out_z <- fastclime::fastclime(z, 0.1)
  expect_equal(class(out_z$data), class(z))
  expect_equal(attributes(out_z$data), attributes(z))

  # xts
  x <- xts(m, order.by = as.Date("2020-01-01") + 1:10)
  out_x <- fastclime::fastclime(x, 0.1)
  expect_equal(class(out_x$data), class(x))
  expect_equal(attributes(out_x$data), attributes(x))

  # ts
  t <- ts(m, start = 1, frequency = 4)
  out_t <- fastclime::fastclime(t, 0.1)
  expect_equal(class(out_t$data), class(t))
  expect_equal(attributes(out_t$data), attributes(t))

  # mts
  expect_true(inherits(t, "mts"))
})
