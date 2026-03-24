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

  expected_diag2 <- c(
    0.746619266519813,
    0.589853797234145,
    0.888992299620688,
    0.830173663533387,
    0.989169761353677,
    0.751636804717494,
    0.89813682478262,
    0.762626359453803,
    0.866143879952295,
    0.633158928765776,
    0.733837616530804,
    0.57425477825274,
    0.852808675083864,
    0.623755861711885,
    0.604385440893092,
    0.924808197745182,
    0.811285947523237,
    0.662768244373909,
    0.70518947544622,
    0.742059292322992
  )
  expect_equal(
    diag(out1$icovlist[[2]]),
    expected_diag2,
    tolerance = 1e-6
  )

  expected_diag3 <- c(
    0.77318016090458,
    0.667282702915831,
    0.996683621448048,
    0.866802263992385,
    1.11190019134659,
    0.787232916454651,
    1.06862604869462,
    0.779480109351624,
    0.925968482462897,
    0.685620680684627,
    0.864793409470276,
    0.609758461972416,
    1.00114982668098,
    0.719883023556302,
    0.766734858771666,
    0.953603086518562,
    0.855354627427368,
    0.720545380642841,
    0.794254788109982,
    0.787286242755062
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

test_that("fastclime works with time-series and named matrix inputs", {
  library(zoo)
  # Test with asymmetric dimnames (colnames only)
  mat <- matrix(rnorm(100), 10, 10)
  sym_mat <- mat + t(mat)
  colnames(sym_mat) <- paste0("V", 1:10)

  res1 <- fastclime(sym_mat, lambda.min = 0.5, nlambda = 5)
  expect_equal(res1$cov.input, 1) # Should detect as covariance matrix

  # Test with zoo object (symmetric)
  z_sym <- zoo(sym_mat)
  res2 <- fastclime(z_sym, lambda.min = 0.5, nlambda = 5)
  expect_equal(res2$cov.input, 1) # Should detect as covariance matrix
  expect_s3_class(res2$data, "zoo") # Should preserve original class

  # Test with zoo object (asymmetric data matrix)
  z_data <- zoo(mat)
  res3 <- fastclime(z_data, lambda.min = 0.5, nlambda = 5)
  expect_equal(res3$cov.input, 0) # Should detect as data matrix
  expect_s3_class(res3$data, "zoo")
})
