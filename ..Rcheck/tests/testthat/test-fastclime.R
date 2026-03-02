library(fastclime)

test_that("dantzig.generator works", {
  set.seed(42)
  L_dg = dantzig.generator(n = 50, d = 100, sparsity = 0.1)
  expect_equal(dim(L_dg$X0), c(50, 100))
  expect_equal(dim(L_dg$y), c(50, 1))
  expect_equal(sum(L_dg$BETA0), 0)
})

test_that("dantzig and dantzig.selector work", {
  # generate data
  set.seed(123)
  a = dantzig.generator(n = 200, d = 100, sparsity = 0.1)

  # regression coefficient estimation
  b = dantzig(a$X0, a$y, lambda = 0.1, nlambda = 100)

  expect_equal(sum(b$BETA0[, 1]), 0)

  expected_beta0_2 = rep(0, 100)
  expected_beta0_2[100] = 0.5845398
  expect_equal(b$BETA0[, 2], expected_beta0_2, tolerance = 1e-6)

  # estimated regression coefficient vector
  c = dantzig.selector(b$lambdalist, b$BETA0, 15)

  # should be -0.08010963
  expect_equal(sum(c), -0.08010963, tolerance = 1e-6)
})

test_that("fastclime.generator works for different graph types", {
  set.seed(42)

  # We test the different graph types, but set vis = FALSE to avoid
  # plotting side-effects in testing environments.
  L_fg1 = fastclime.generator(n = 100, d = 20)
  expect_equal(dim(L_fg1$data), c(100, 20))

  L_fg2 = fastclime.generator(graph = "band", g = 3)
  expect_equal(dim(L_fg2$data), c(200, 50))

  L_fg3 = fastclime.generator(vis = FALSE)
  expect_equal(dim(L_fg3$data), c(200, 50))

  L_fg4 = fastclime.generator(prob = 0.5, vis = FALSE)
  expect_equal(dim(L_fg4$data), c(200, 50))

  L_fg5 = fastclime.generator(graph = "hub", g = 6, vis = FALSE)
  expect_equal(dim(L_fg5$data), c(200, 50))

  L_fg6 = fastclime.generator(graph = "cluster", g = 8, vis = FALSE)
  expect_equal(dim(L_fg6$data), c(200, 50))
})

test_that("fastclime and fastclime.selector work", {
  set.seed(123)
  L = fastclime.generator(n = 100, d = 20)

  #graph path estimation
  out1 = fastclime(L$data,0.1)
  out2 = fastclime.selector(out1$lambdamtx, out1$icovlist,0.2)

  expect_equal(sum(out1$icovlist[[1]]), 0)

  expected_diag2 = c(0.7621407, 0.6337797, 0.9370682, 0.7667926, 0.7531294,
                     0.7805857, 0.9035125, 0.7033197, 1.0275991, 0.6264976,
                     0.6898066, 0.5739826, 0.8856609, 0.6319145, 0.7161172,
                     0.8805116, 0.8251614, 0.6665530, 0.5894222, 0.7895643)
  expect_equal(diag(out1$icovlist[[2]]), expected_diag2, tolerance = 1e-6)

  expected_diag3 = c(0.9140404, 0.6557950, 1.0102614, 0.8298148, 0.8146116,
                     0.8354372, 1.0899309, 0.8858942, 1.0711227, 0.6767176,
                     0.8276655, 0.6209249, 0.9027221, 0.6879543, 0.9254351,
                     0.9486373, 0.8426203, 0.7575949, 0.7198079, 0.8638316)
  expect_equal(diag(out1$icovlist[[3]]), expected_diag3, tolerance = 1e-6)
})

test_that("fastlp works", {
  A=matrix(c(-1,-1,0,1,-2,1),nrow=3)
  b_lp=c(-1,-2,1)
  c_lp=c(-2,3)
  res_fastlp = fastlp(c_lp,A,b_lp)

  expect_length(res_fastlp, 2)
  expect_equal(res_fastlp, c(2, 1), tolerance = 1e-6)
})

test_that("paralp works", {
  A=matrix(c(-1,-1,0,1,-2,1),nrow=3)
  b_lp=c(-1,-2,1)
  c_lp=c(-2,3)
  b_bar=c(1,1,1)
  c_bar=c(1,1)
  res_paralp = paralp(c_lp,A,b_lp,c_bar,b_bar)

  expect_length(res_paralp, 2)
  expect_equal(res_paralp, c(4/3, 1/3), tolerance = 1e-6)
})

test_that("stockdata works", {
  data(stockdata)
  expect_equal(dim(stockdata$data), c(1258, 452))
  expect_length(stockdata$info, 1356)
})
