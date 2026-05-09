#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclime.generator(): graph visualization                                    #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22nd 2016                                                           #
# Version: 1.4.1					                                            #
#-------------------------------------------------------------------------------#

#' @title Graph Visualization for Fastclime
#' @description Plots the estimated precision matrix as a graph
#' @export

fastclime.plot = function(
  G,
  epsflag = FALSE,
  graph.name = "default",
  cur.num = 1,
  location = NULL
) {
  gcinfo(FALSE)
  if (missing(location)) {
    location = getwd()
  }
  diag(G) = 0
  g = igraph::graph_from_adjacency_matrix(
    as.matrix(G != 0),
    mode = "undirected",
    diag = FALSE
  )
  layout.grid = igraph::layout_with_fr(g)

  if (epsflag == TRUE) {
    postscript(
      file.path(
        location,
        paste(paste(graph.name, cur.num, sep = ""), "eps", sep = ".")
      ),
      width = 8.0,
      height = 8.0
    )
  }
  graphics::par(mfrow = c(1, 1))
  graphics::plot(
    g,
    layout = layout.grid,
    edge.color = 'gray50',
    vertex.color = "red",
    vertex.size = 2,
    vertex.label = NA
  )
  rm(g, location)

  if (epsflag == TRUE) dev.off()
}
