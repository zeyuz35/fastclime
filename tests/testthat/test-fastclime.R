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

  expected_diag2 = c(
    0.7287888,
    0.6710710,
    0.7936875,
    0.8100290,
    0.8157571,
    0.7726834,
    0.9514006,
    0.7512723,
    0.9083669,
    0.6206226,
    0.6842458,
    0.6715744,
    0.8599619,
    0.8021299,
    0.7284883,
    0.8089637,
    0.6896824,
    0.6827572,
    0.6790104,
    0.6922301
  )
  expect_equal(
    diag(out1$icovlist[[2]]),
    expected_diag2,
    tolerance = 1e-6
  )

  expected_diag3 = c(
    0.9168410,
    0.7205304,
    0.8554107,
    0.8526005,
    0.9009442,
    0.7731859,
    1.0033823,
    0.7804546,
    1.2113871,
    0.7210265,
    0.7081836,
    0.7613153,
    0.9781418,
    0.8030060,
    0.7496296,
    0.8488565,
    0.8077362,
    0.6875899,
    0.7102704,
    0.7673958
  )
  expect_equal(
    diag(out1$icovlist[[3]]),
    expected_diag3,
    tolerance = 1e-6
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
