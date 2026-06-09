QLASSO.Hessian.Omega.BK17.CLIME <- function(X, Sigma = NULL, lambda_1, lambda_2, solver = "SCS") { return(list(Omega = diag(ncol(X)), lambda = data.frame(lambda_1 = lambda_1, lambda_2 = lambda_2))) }
