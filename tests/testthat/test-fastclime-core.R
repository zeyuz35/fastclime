library(fastclime)
library(testthat)

test_that("fastclime print and plot methods work", {
  set.seed(42)
  L <- fastclime.generator(n = 50, d = 10)
  out <- fastclime(L$data, 0.1)
  
  # Test print output doesn't error and contains expected strings
  expect_message(print(out), "Path length: 10")
  expect_message(print(out), "Graph dimension: 10")
  expect_message(print(out), "Sparsity range:")
  
  # Test plot doesn't error
  # We use a temporary file to avoid cluttering the workspace
  tmp_plot <- tempfile(fileext = ".png")
  png(tmp_plot)
  expect_error(plot(out), NA) # expect no error
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

test_that("parametric solver works after refactor", {
  set.seed(123)
  # Simple case for parametric solver
  # Sigma is identity
  Sigma <- diag(5)
  out <- fastclime(Sigma, lambda.min = 0.1)
  
  expect_s3_class(out, "fastclime")
  expect_equal(ncol(out$data), 5)
  expect_true(length(out$icovlist) > 0)
})
