#' Data from 9 PPBIO plots along the BR319 in Brazil.
#'
#' A dataset containing the azimuth and length of segments from 9 plots:
#' M01_TN_0500, M01_TN_3500, M02_TN_1500, M06_TS_0500, M02_TN_0500, M02_TN_2500,
#' M02_TS_0500, M03_TN_2500, M09_TN_1500 .
#'
#' @format A data frame with 264 rows and 6 variables:
#' \describe{
#'   \item{aid}{unique rowid, for data checking.}
#'   \item{plot_id}{ID code, unique for each plot.}
#'   \item{azimute}{bearing, used to calculate coordinates.}
#'   \item{segmento}{Distance (in meters) of each segment.}
#'   \item{remove}{Flag. Should segment be removed from analysis}
#'   \item{seg_id}{ID for segments. Unique within plot, for ordering.}
#' }
#' @source \url{https://ppbio.inpa.gov.br/sitios/br319/}
"br319"
#' Calculated areas from 9 PPBIO plots along the BR319 in Brazil.
#'
#' A dataset containing the calculated area (m2) from 9 nonlinear plots:
#' M01_TN_0500, M01_TN_3500, M02_TN_1500, M06_TS_0500, M02_TN_0500, M02_TN_2500,
#' M02_TS_0500, M03_TN_2500, M09_TN_1500 .
#'
#' @format A data frame with 864 rows and 8 variables:
#' \describe{
#'   \item{.id}{ID code, unique for each plot.}
#'   \item{variable}{Indicates which segments were used (4 types).}
#'   \item{lado}{Indicates which side was used for area calculations.}
#'   \item{faixa_id}{ID used in width calculation.}
#'   \item{area_m2}{Calculated area in m^2.}
#'   \item{seg_count}{How many segments were used in the area calculation.}
#'   \item{faixa_tipo}{ID for grouping calculation types.}
#'   \item{faixa_dist}{Indicates buffer width used in area calculations.}
#' }
#' 
"br319res"
#' Geographic coordiantes from 9 PPBIO plots along the BR319 in Brazil.
#'
#' A dataset containing geographic coordinates of the start point of 9 nonlinear plots:
#' M01_TN_0500, M01_TN_3500, M02_TN_1500, M06_TS_0500, M02_TN_0500, M02_TN_2500,
#' M02_TS_0500, M03_TN_2500, M09_TN_1500 .
#'
#' @format A data frame with 3 rows and 3 variables:
#' \describe{
#'   \item{PLOT_ID}{ID code, unique for each plot.}
#'   \item{LONG}{Longitude (x), decimal degrees, WGS84, epsg=4326.}
#'   \item{LAT}{Latitude (y), decimal degrees, WGS84, epsg=4326.}
#' }
#' @source \url{http://ppbio.inpa.gov.br/sites/default/files/SIG_oficial_BR319.zip} 
"br319coords"
