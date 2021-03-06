#' doLine
#' 
#' @description
#' Should not be called directly by users.
#' \code{doline} creates central line from coordinates generated by \code{makeSeg}.
#'
#' @param dfseg Data.frame of coordinates from segments generated by \code{makeSeg}.
#' @param line_epsg EPSG code to use. 
#'
#' @return Produces list with two SpatialLinesDataFrames, one with geographic (epsg = 4326)
#' and the other projected (epsg:3395) coordinate reference systems.
#' @export
#'
#' @examples
#' \dontrun{
#' }
doLine <- function(dfseg, line_epsg = 3395){
dfl <- dfseg
require(sp)
require(rgdal)

mycrs <- paste("+init=epsg:", line_epsg,sep="")
# 01. make spatial lines .............................................
###### spatial lines , todos os segementos ############

# make data.frame in format for lines
dfline <- function(x) {
  dft <- rbind(data.frame(plot_id = x$plot_id, seg_id = x$seg_id, 
                          sec_id = x$sec_id, row_id= x$row_id,
                          ponto = "start", coord_x = x$coord_x, 
                          coord_y = x$coord_y),
               data.frame(plot_id = x$plot_id, seg_id = x$seg_id,
                          sec_id = x$sec_id, row_id= x$row_id, 
                          ponto = "end", coord_x = x$lead_x, 
                          coord_y = x$lead_y)
              )
}

dfla <- plyr::ddply(dfl,c("plot_id"),.fun = dfline)

# make SpatialLinesDataFrame
 myline <- function(x){
   require(sp)
   coordinates(x) <- ~coord_x+coord_y
   Lines(list(Line(x)), x$row_id[1L])
 }

lsp <- plyr::dlply(dfla, c("plot_id", "row_id"), myline)

lines <- SpatialLines(lsp)
data <- data.frame(id = unique(dfla$row_id))
data <- merge(data,dfl,by.x="id", by.y="row_id")
rownames(data) <- data$id
spl <- SpatialLinesDataFrame(lines, data)
proj4string(spl)<-CRS("+init=epsg:4326")

lrt <- subset(spl, remove_trilha==0)
lra <- subset(spl, remove_angle==0)
lrall <- subset(spl, remove_all==0)

SpatialLines_wgs84 <- list(SpatialLinesAll = spl, 
                           SpatialLinesRemoveTrilha = lrt,
                           SpatialLinesRemoveAngle = lra, 
                           SpatialLinesRemoveAll = lrall)
SpatialLines_proj <- lapply(SpatialLines_wgs84, 
                             FUN = spTransform, CRS(mycrs))
listout <- list(SpatialLines_wgs84 = SpatialLines_wgs84,
                SpatialLines_proj = SpatialLines_proj)
}