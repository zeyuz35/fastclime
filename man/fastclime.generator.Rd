\name{fastclime.generator}
\alias{fastclime.generator}

\title{
Data generator
}

\description{
Implements the data generation from multivariate normal distributions with different graph structures, including \code{"random"}, \code{"hub"}, \code{"cluster"} and \code{"band"}.
}

\usage{
fastclime.generator(n = 200, d = 50, graph = "random", v = NULL, u = NULL, 
g = NULL, prob = NULL, vis = FALSE, verbose = TRUE)
}

\arguments{
  \item{n}{
The number of observations (sample size). The default value is \code{200}.
}
  \item{d}{
The number of variables (dimension). The default value is \code{50}.
}
  \item{graph}{
The graph structure with 4 options: \code{"random"}, \code{"hub"}, \code{"cluster"} and \code{"band"}.
}
  \item{v}{
The off-diagonal elements of the precision matrix, controlling the magnitude of partial correlations with \code{u}. The default value is \code{0.3}.
}
  \item{u}{
A positive number being added to the diagonal elements of the precision matrix, to control the magnitude of partial correlations. The default value is \code{0.1}.
}
  \item{g}{
For \code{"cluster"} or \code{"hub"} graph, \code{g} is the number of hubs or clusters in the graph.
The default value is about \eqn{d/20} if \eqn{d \ge 40} and \eqn{2} if \eqn{d < 40}.
For \code{"band"} graph, \code{g} is the bandwidth and the default value is \code{1}.
NOT applicable to \code{"random"} graph.
}
  \item{prob}{
For \code{"random"} graph, it is the probability that a pair of nodes has an edge.
The default value is \eqn{3/d}.
For \code{"cluster"} graph, it is the probability that a pair of nodes has an edge in each cluster.
The default value is \eqn{6g/d} if \eqn{d/g \le 30} and \code{0.3} if \eqn{d/g > 30}.
NOT applicable to \code{"hub"} or \code{"band"} graphs.
}
  \item{vis}{
Visualize the adjacency matrix of the true graph structure, the graph pattern, the covariance matrix and the empirical covariance matrix. The default value is \code{FALSE}
}
  \item{verbose}{
If \code{verbose = FALSE}, tracing information printing is disabled. The default value is \code{TRUE}.
}
}

\details{
Given the adjacency matrix \code{theta}, the graph patterns are generated as below:

(I) \code{"random"}: Each pair of off-diagonal elements are randomly set
\eqn{\theta_{i,j}=\theta_{j,i}=1} for \eqn{i \neq j} with probability \code{prob},
and \code{0} otherwise.
It results in about \eqn{d(d-1)prob/2} edges in the graph.

(II) \code{"hub"}: The row/columns are evenly partitioned into \code{g} disjoint groups.
Each group is associated with a "center" row \eqn{i} in that group.
Each pair of off-diagonal elements are set \eqn{\theta_{i,j}=\theta_{j,i}=1}
for \eqn{i \neq j} if \eqn{j} also belongs to the same group as \eqn{i}
and \code{0} otherwise.
It results in \eqn{d - g} edges in the graph.

(III) \code{"cluster"}: The row/columns are evenly partitioned into \code{g} disjoint groups.
Each pair of off-diagonal elements are set \eqn{\theta_{i,j}=\theta_{j,i}=1}
for \eqn{i \neq j} with the probability \code{prob} if both \eqn{i} and \eqn{j}
belong to the same group, and \code{0} otherwise.
It results in about \eqn{g(d/g)(d/g-1)prob/2} edges in the graph.

(IV) \code{"band"}: The off-diagonal elements are set to be \eqn{\theta_{i,j}=1}
if \eqn{1 \le |i-j| \le g} and \code{0} otherwise.
It results in \eqn{(2d-1-g)g/2} edges in the graph.

The adjacency matrix \code{theta} has all diagonal elements equal to \code{0}.
To obtain a positive definite precision matrix,
the smallest eigenvalue of \eqn{\theta \times v} (denoted by \eqn{e}) is computed.
Then we set the precision matrix equal to \eqn{\theta \times v + (|e| + 0.1 + u)I}.
The covariance matrix is then computed to generate multivariate normal data.
}

\value{
An object with S3 class "sim" is returned:
\item{data}{
The \code{n} by \code{d} matrix for the generated data
}
\item{sigma}{
The covariance matrix for the generated data
}
  \item{omega}{
The precision matrix for the generated data
}
  \item{sigmahat}{
The empirical covariance matrix for the generated data
}
  \item{theta}{
The adjacency matrix of true graph structure (in sparse matrix representation) for the generated data
}
}

\author{
Haotian Pang, Han Liu and Robert Vanderbei \cr
Maintainer: Haotan Pang<hpang@princeton.edu>
}

\seealso{
\code{\link{fastclime}} and \code{\link{fastclime-package}}
}

\examples{
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

}
