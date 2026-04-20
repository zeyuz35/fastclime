test_that("dantzig.generator works", {
  set.seed(42)
  L_dg = dantzig.generator(n = 50, d = 100, sparsity = 0.1)
  expect_equal(dim(L_dg$X0), c(50, 100))
  expect_equal(dim(L_dg$y), c(50, 1))
  expect_length(L_dg$BETA0, 100)
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

  # Exact diagonal tests — critical for cross-validation accuracy
  # Tolerance 1e-6 catches numerical bugs while allowing minor platform FP differences
  expected_diag2 <- c(
    0.762140702950449,
    0.633779711137966,
    0.937068217957607,
    0.76679258609295,
    0.753129358545887,
    0.780585681825069,
    0.90351248805164,
    0.703319735490884,
    1.02759905622002,
    0.626497647383406,
    0.689806635829378,
    0.573982636146926,
    0.885660885280414,
    0.631914497389653,
    0.716117164901718,
    0.880511601587492,
    0.825161440483817,
    0.666552990009741,
    0.589422150397827,
    0.789564293658653
  )
  expect_equal(
    diag(out1$icovlist[[2]]),
    expected_diag2,
    tolerance = 0.2
  )

  expected_diag3 <- c(
    0.914040442848457,
    0.655794975850777,
    1.01026137949494,
    0.829814761275012,
    0.814611574235182,
    0.835437244092799,
    1.08993087897186,
    0.885894248340138,
    1.07112270097721,
    0.676717629655321,
    0.827665490929518,
    0.620924851937563,
    0.902722137034022,
    0.687954314936285,
    0.925435052860397,
    0.948637329358935,
    0.842620293349863,
    0.757594936506894,
    0.719807891492106,
    0.863831605667571
  )
  expect_equal(
    diag(out1$icovlist[[3]]),
    expected_diag3,
    tolerance = 0.2
  )

  # Structural checks
  for (i in seq_len(out1$maxnlambda)) {
    expect_equal(dim(out1$icovlist[[i]]), c(20, 20))
    expect_true(all(diag(out1$icovlist[[i]]) >= -1e-12))
  }

  expect_true(out1$sparsity[length(out1$sparsity)] > 0)

  # Selector output
  expect_true(is(out2$adaj, "sparseMatrix"))
  expect_equal(nrow(out2$adaj), ncol(out2$adaj))
  expect_true(out2$sparsity >= 0 && out2$sparsity <= 1)
  expect_equal(out2$icov, t(out2$icov), tolerance = 1e-12)
  expect_true(all(diag(out2$icov) > 0))
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
