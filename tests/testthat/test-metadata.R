test_that("fastclime preserves metadata and handles time-series types safely", {
  testthat::local_edition(3)

  data <- matrix(rnorm(100), 10, 10)
  data <- t(data) %*% data
  colnames(data) <- paste0("V", 1:10)
  rownames(data) <- paste0("V", 1:10)
  data_xts <- zoo::zoo(data, order.by=Sys.Date() + 1:10)

  res <- fastclime(data_xts)
  expect_true(!is.null(colnames(res$lambdamtx)))
  expect_equal(colnames(res$lambdamtx), colnames(data))
  expect_true(!is.null(colnames(res$icovlist[[1]])))
  expect_equal(colnames(res$icovlist[[1]]), colnames(data))

  sel <- fastclime.selector(res$lambdamtx, res$icovlist, 0.2)
  expect_equal(colnames(sel$icov), colnames(data))
  expect_equal(colnames(sel$adaj), colnames(data))
})
