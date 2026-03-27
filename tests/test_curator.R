library(fastclime)
library(xts)
library(zoo)

# Test input xts object
data <- matrix(rnorm(100), 10, 10)
colnames(data) <- paste0("V", 1:10)
dates <- seq(as.Date("2020-01-01"), length.out = 10, by = "days")
xts_data <- xts(data, order.by = dates)
attr(xts_data, "my_custom_scale") <- c(1, 2, 3)

out1 = fastclime(xts_data, 0.1)

stopifnot(inherits(out1$data, "xts"))
stopifnot(identical(attr(out1$data, "my_custom_scale"), c(1, 2, 3)))
stopifnot(identical(colnames(out1$data), paste0("V", 1:10)))

print("Curator tests passed!")
