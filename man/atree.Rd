% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{atree}
\alias{atree}
\title{A simple, bifurcating tree for use in util examples}
\format{
phylo
}
\usage{
atree
}
\description{
A simple, bifurcating tree for use in util examples
}
\examples{
# Here is the code used to generate this tree
require(ape)
set.seed(42)
atree <- ape::rtree(10)
atree$tip.label <- paste0("t", 1:nleafs(atree))
atree$node.label <- paste0("n", 1:atree$Nnode + nleafs(atree))
}
\keyword{datasets}
