# Extracted from test-fastclime-core.R:10

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "fastclime", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
library(fastclime)
library(testthat)

# test -------------------------------------------------------------------------
set.seed(42)
L <- fastclime.generator(n = 50, d = 10)
out <- fastclime(L$data, 0.1)
expect_output(print(out), "Path length: 10")
