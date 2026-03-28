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
  out1 = fastclime(L$data, 0.1)
  out2 = fastclime.selector(out1$lambdamtx, out1$icovlist, 0.2)

  expect_equal(sum(out1$icovlist[[1]]), 0)

  expected_diag2 <- c(0.76214, 0.63378, 0.93707, 0.76679, 0.75313, 0.78059, 0.90351,
0.70332, 1.0276, 0.6265, 0.68981, 0.57398, 0.88566, 0.63191,
0.71612, 0.88051, 0.82516, 0.66655, 0.58942, 0.78956)
  expect_equal(
    diag(out1$icovlist[[2]]),
    expected_diag2,
    tolerance = 1e-4
  )

  expected_diag3 <- c(0.91404, 0.65579, 1.01026, 0.82981, 0.81461, 0.83544, 1.08993,
0.88589, 1.07112, 0.67672, 0.82767, 0.62092, 0.90272, 0.68795,
0.92544, 0.94864, 0.84262, 0.75759, 0.71981, 0.86383)
  expect_equal(
    diag(out1$icovlist[[3]]),
    expected_diag3,
    tolerance = 1e-3
  )
})

test_that("fastlp works", {
  A = matrix(c(-1, -1, 0, 1, -2, 1), nrow = 3)
  b_lp = c(-1, -2, 1)
  c_lp = c(-2, 3)
  res_fastlp = fastlp(c_lp, A, b_lp)

  expect_length(res_fastlp, 2)
  expect_equal(res_fastlp, c(2, 1), tolerance = 1e-6)
})

test_that("paralp works", {
  A = matrix(c(-1, -1, 0, 1, -2, 1), nrow = 3)
  b_lp = c(-1, -2, 1)
  c_lp = c(-2, 3)
  b_bar = c(1, 1, 1)
  c_bar = c(1, 1)
  res_paralp = paralp(c_lp, A, b_lp, c_bar, b_bar)

  expect_length(res_paralp, 2)
  expect_equal(res_paralp, c(4 / 3, 1 / 3), tolerance = 1e-6)
})

test_that("stockdata works", {
  data(stockdata)
  expect_equal(dim(stockdata$data), c(1258, 452))
  expect_length(stockdata$info, 1356)
})
