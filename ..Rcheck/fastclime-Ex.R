pkgname <- "fastclime"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('fastclime')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("dantzig")
### * dantzig

flush(stderr()); flush(stdout())

### Name: dantzig
### Title: A solver for the Dantzig selector estimator
### Aliases: dantzig

### ** Examples


#generate data
a = dantzig.generator(n = 200, d = 100, sparsity = 0.1)

#regression coefficient estimation
b = dantzig(a$X0, a$y, lambda = 0.1, nlambda = 100)




cleanEx()
nameEx("dantzig.generator")
### * dantzig.generator

flush(stderr()); flush(stdout())

### Name: dantzig.generator
### Title: Dantzig data generator
### Aliases: dantzig.generator

### ** Examples


##
L = dantzig.generator(n = 50, d = 100, sparsity = 0.1)




cleanEx()
nameEx("dantzig.selector")
### * dantzig.selector

flush(stderr()); flush(stdout())

### Name: dantzig.selector
### Title: Dantzig selector
### Aliases: dantzig.selector

### ** Examples


# generate data
a = dantzig.generator(n = 200, d = 100, sparsity = 0.1)

# regression coefficient estimation
b = dantzig(a$X0, a$y, lambda = 0.1, nlambda = 100)

# estimated regression coefficient vector
c = dantzig.selector(b$lambdalist, b$BETA0, 15)




cleanEx()
nameEx("fastclime")
### * fastclime

flush(stderr()); flush(stdout())

### Name: fastclime
### Title: The main solver for fastclime package
### Aliases: fastclime

### ** Examples

#generate data
L = fastclime.generator(n = 100, d = 20)

#graph path estimation
out1 = fastclime(L$data,0.1)
out2 = fastclime.selector(out1$lambdamtx, out1$icovlist,0.2)
fastclime.plot(out2$adaj)

#graph path estimation using the sample covariance matrix as the input.
out1 = fastclime(cor(L$data),0.1)
out2 = fastclime.selector(out1$lambdamtx, out1$icovlist,0.2)
fastclime.plot(out2$adaj)



cleanEx()
nameEx("fastclime.generator")
### * fastclime.generator

flush(stderr()); flush(stdout())

### Name: fastclime.generator
### Title: Data generator
### Aliases: fastclime.generator

### ** Examples

## band graph with bandwidth 3
L = fastclime.generator(graph = "band", g = 3)
plot(L)

## random sparse graph
L = fastclime.generator(vis = TRUE)

## random dense graph
L = fastclime.generator(prob = 0.5, vis = TRUE)

## hub graph with 6 hubs
L = fastclime.generator(graph = "hub", g = 6, vis = TRUE)

## hub graph with 8 clusters
L = fastclime.generator(graph = "cluster", g = 8, vis = TRUE)




cleanEx()
nameEx("fastclime.plot")
### * fastclime.plot

flush(stderr()); flush(stdout())

### Name: fastclime.plot
### Title: Graph visualization
### Aliases: fastclime.plot

### ** Examples

## visualize the hub graph
L = fastclime.generator(graph = "hub")
fastclime.plot(L$theta)

## visualize the band graph
L = fastclime.generator(graph = "band",g=5)
fastclime.plot(L$theta)

## visualize the cluster graph
L = fastclime.generator(graph = "cluster")
fastclime.plot(L$theta)

#show working directory
getwd()
#plot 5 graphs and save the plots as eps files in the working directory
fastclime.plot(L$theta, epsflag = TRUE, cur.num = 5)



cleanEx()
nameEx("fastclime.selector")
### * fastclime.selector

flush(stderr()); flush(stdout())

### Name: fastclime.selector
### Title: A precision matrix and path selector function for fastclime
### Aliases: fastclime.selector

### ** Examples

#generate data
L = fastclime.generator(n = 100, d = 20)

#graph path estimation
out1 = fastclime(L$data,0.1)
out2 = fastclime.selector(out1$lambdamtx, out1$icovlist,0.2)
fastclime.plot(out2$adaj)



cleanEx()
nameEx("fastlp")
### * fastlp

flush(stderr()); flush(stdout())

### Name: fastlp
### Title: A generic LP solver
### Aliases: fastlp

### ** Examples

#generate an LP problem and solve it
A=matrix(c(-1,-1,0,1,-2,1),nrow=3)
b=c(-1,-2,1)
c=c(-2,3)
fastlp(c,A,b)



cleanEx()
nameEx("paralp")
### * paralp

flush(stderr()); flush(stdout())

### Name: paralp
### Title: A solver for parameterized LP problems
### Aliases: paralp

### ** Examples

#generate an LP problem and solve it
A=matrix(c(-1,-1,0,1,-2,1),nrow=3)
b=c(-1,-2,1)
c=c(-2,3)
b_bar=c(1,1,1)
c_bar=c(1,1)
paralp(c,A,b,c_bar,b_bar)



cleanEx()
nameEx("stockdata")
### * stockdata

flush(stderr()); flush(stdout())

### Name: stockdata
### Title: Stock price of S&P 500 companies from 2003 to 2008
### Aliases: stockdata
### Keywords: datasets

### ** Examples

data(stockdata)
image(stockdata$data)
stockdata$info



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
