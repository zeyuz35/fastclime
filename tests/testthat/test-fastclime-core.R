test_that("fastclime print and plot methods work", {
  set.seed(42)
  L <- fastclime.generator(n = 50, d = 10)
  out <- fastclime(L$data, 0.1)

  expect_output(print(out), "Path length:")
  expect_output(print(out), "Graph dimension: 10")
  expect_output(print(out), "Sparsity range:")

  tmp_plot <- tempfile(fileext = ".png")
  png(tmp_plot)
  expect_error(plot(out), NA)
  dev.off()
  if (file.exists(tmp_plot)) unlink(tmp_plot)
})

test_that("fastclime.selector works with sparsity", {
  set.seed(42)
  L <- fastclime.generator(n = 50, d = 10)
  out <- fastclime(L$data, 0.1)

  sel <- fastclime.selector(out$lambdamtx, out$icovlist, 0.1)
  expect_s3_class(sel, "fastclime.selector")
  expect_true(!is.null(sel$sparsity))
  expect_true(sel$sparsity >= 0 && sel$sparsity <= 1)
})

test_that("parametric solver works with identity covariance", {
  set.seed(123)
  Sigma <- diag(5)
  out <- fastclime(Sigma, lambda.min = 0.1)

  expect_s3_class(out, "fastclime")
  expect_equal(ncol(out$data), 5)
  expect_true(length(out$icovlist) > 0)
})

test_that("fastclime preserves time-series properties safely", {
  skip_if_not_installed("xts")

  set.seed(42)
  mat <- matrix(rnorm(100), 20, 5)
  colnames(mat) <- paste0("V", 1:5)

  # Create an xts time series object
  x <- xts::xts(mat, Sys.Date() + 1:20)
  attr(x, "scale") <- TRUE

  # This used to fail on isSymmetric(x) S3 dispatch
  out <- fastclime(x, lambda.min = 0.5, nlambda = 5)

  expect_s3_class(out, "fastclime")
  # Original input class should be preserved in out$data
  expect_true(inherits(out$data, "xts"))
  expect_true(attr(out$data, "scale"))
  # Colnames should be preserved correctly on sigmahat
  expect_equal(colnames(out$sigmahat), colnames(mat))
})
