library(fastclime)
library(microbenchmark)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
    stop("Please give an output file name for the benchmark RDS.")
}
out_file <- args[1]

# Generate some data
set.seed(42)
data <- fastclime.generator(n = 200, d = 50, graph = "random", prob = 0.1)

# Run benchmark
mb <- microbenchmark(
    fastclime_run = fastclime(data$data, lambda.min = 0.1, nlambda = 20),
    times = 20
)

saveRDS(mb, out_file)
cat("Saved benchmark to", out_file, "\n")
