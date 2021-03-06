#' expshiftkML
#' 
#' @description
#' Should not be called directly by users.
#' \code{expshiftKML} Moves central line to geographic coordinates.
#'
#' @param res_list List with data, spatial lines and polygons generated by \code{area_calc}.
#' @param pcoords Data.frame with geographic coordinates of plot start point.
#' @param c_epsg EPSG code for projected buffers.
#'
#' @return Exports cental line shifted to geographic coordinates 
#' as kml for visualization.
#' @export
#'
#' @examples
#' \dontrun{
#' }
expshiftKML <- function(res_list = res_list, pcoords = pcoords, c_epsg = 3395){
  require(sp)
  require(rgdal)
  mycrs <- paste("+init=epsg:", c_epsg,sep="")
  mypn <- as.character(res_list$SpatialLines_wgs84$SpatialLinesAll$plot_id[1]) 
  linename <- paste(mypn, "_linha_geo.kml", sep="")
# shift
  require(raster)
  s1 <- res_list$SpatialLines_wgs84$SpatialLinesAll # shift "SpatialLinesAll"
  selC <- which(pcoords$PLOT_ID %in% s1$plot_id[1])
  s2 <- raster::shift(s1, x = pcoords[selC, 'LONG'], y = pcoords[selC, 'LAT'])
# write kml 
  s2$distm <- s2$seg_id * 10
  s2$lab <- paste(s2$plot_id, paste(s2$distm,"m"))

  p1 <- plotKML::plotKML(s2, folder.name = mypn,
                         file.name = linename, 
                         labels = lab, colour = remove_all, 
                         open.kml = FALSE)
return(p1)
}