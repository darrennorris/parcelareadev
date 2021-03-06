% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/05doBuff.R
\name{doBuff}
\alias{doBuff}
\title{dobuff}
\usage{
doBuff(list.lines, faixa_dist = c(0.5, 1, 1.5, 2, 10, 20), buff_epsg = 3395)
}
\arguments{
\item{list.lines}{List with central lines (class SpatialLines) generated by \code{doline}.}

\item{faixa_dist}{Vector of plot survey widths.}

\item{buff_epsg}{EPSG code to use.}
}
\value{
List of buffers (SpatialPolygons) of the survey area for a plot.
}
\description{
Should not be called directly by users.
\code{dobuff} creates buffers around the central line.
}
\examples{
 \dontrun{
}
}
