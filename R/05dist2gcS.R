#' dist2gcs
#' 
#' @description
#' Should not be called directly by users.
#' Copied and adapted from function "dist2gc" in geosphere package by Robert Hijmans.
#' \code{dist2gcs} calculates signed distance between point and a line.
#'
#' @param p1 Start of great circle path. longitude/latitude of point(s).
#' @param p2 End of great circle path. As above.
#' @param p3 Point away from the great cricle path. As for p2.
#' @param r radius of the earth; default = 6378137.
#'
#' @details Just took out "abs" from original code in \code{geosphere::dist2gc}. 
#' So returns signed values to indicate left or right, as used by \code{makelado}.
#' 
#' @return Signed distance between point and line i.e. cross track distance.
#' @export
#'
#' @examples
#' \dontrun{
#' dist2gcs(c(0,0),c(90,90),c(80,80)
#' dist2gcs(c(0,0),c(90,90),c(-80,80))
#' }
dist2gcS <- function (p1, p2, p3, r = 6378137) 
{ # 
  # based on code by Ed Williams
  # Licence: GPL
  # http://williams.best.vwh.net/avform.htm#XTE
  # Port to R by Robert Hijmans
  # October 2009
  # version 0.1
  # license GPL3
  require(geosphere)
  toRad <- pi/180
  p1 <- matrix(p1, ncol = 2) #geosphere:::.pointsToMatrix(p1)
  p2 <- matrix(p2, ncol = 2) #geosphere:::.pointsToMatrix(p2)
  p3 <- matrix(p3, ncol = 2) #geosphere:::.pointsToMatrix
  r <- as.vector(r)
  p <- cbind(p1[, 1], p1[, 2], p2[, 1], p2[, 2], p3[, 1], p3[, 2], r)
  p1 <- p[, 1:2]
  p2 <- p[, 3:4]
  p3 <- p[, 5:6]
  r <- p[, 7]
  tc <- geosphere::bearing(p1, p2) * toRad
  tcp <- geosphere::bearing(p1, p3) * toRad
  dp <- geosphere::distCosine(p1, p3, r = 1)
  xtr <- asin(sin(tcp - tc) * sin(dp)) * r
  as.vector(xtr)
}