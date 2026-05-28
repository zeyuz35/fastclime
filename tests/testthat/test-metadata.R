test_that("fastclime preserves dimension names", {
  mat <- matrix(c(1, 0.5, 0.5, 1), nrow = 2)
  colnames(mat) <- c("A", "B")
  rownames(mat) <- c("A", "B")

  res <- fastclime(mat)

  expect_equal(colnames(res$lambdamtx), c("A", "B"))
  expect_equal(colnames(res$icovlist[[1]]), c("A", "B"))
  expect_equal(rownames(res$icovlist[[1]]), c("A", "B"))
})

test_that("dantzig preserves rownames and prevents drop=FALSE issues", {
  X <- matrix(rnorm(12), nrow = 3)
  colnames(X) <- c("X1", "X2", "X3", "X4")
  y <- rnorm(3)

  res <- dantzig(X, y)

  expect_equal(rownames(res$BETA0), c("X1", "X2", "X3", "X4"))
  expect_true(is.matrix(res$BETA0))
})
