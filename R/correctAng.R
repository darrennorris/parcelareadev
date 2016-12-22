#' correctAng
#' 
#' @description
#' Should not be called directly by users.
#' \code{correctAng} corrects bearings, prior to procesing by \code{checkAngle}.
#'
#' @param x Data.frame
#'
#' @return Angle corrected from azimuth calculation
#' @export
#' 
#' @examples
#' \dontrun{
#' }
correctAng <- function(x) {
  xa <- x$ret_az
  xa2 <- ifelse(is.na(xa)==TRUE, NA, xa)
  xa3 <- ifelse(xa2 > 360, 360 - xa2, xa2)
  xa4 <- ifelse(xa3 < 0, 360 + xa3, xa3)
  dft <- data.frame(ret_az_clean = xa4)
}