% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phylostratr.R
\name{species_tree_to_data_tree}
\alias{species_tree_to_data_tree}
\title{Acquire the protein sequence of each species}
\usage{
species_tree_to_data_tree(x, FUN, ...)
}
\arguments{
\item{x}{A species tree}

\item{FUN}{A function of the species tree and ... that retrieves the raw
data (usually protein sequences) needed for the phylostratigraphy analysis}

\item{...}{Additional arguments passed to FUN}
}
\value{
A tree of raw data
}
\description{
Acquire the protein sequence of each species
}
