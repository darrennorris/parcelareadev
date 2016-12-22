#' getCoords
#'
#' @description
#' Should not be called directly by users.
#' \code{getCoords} generates coordinates from bearing and distance.
#'
#' @param data Data.frame with bearings and distances, as per \code{data(br319)} .
#'
#' @return Coordinates from bearings and distance between points
#' @export
#'
#' @examples
#' \dontrun{
#' }
getCoords <- function(data) {
  #http://stackoverflow.com/questions/1638437/given-an-angle-and-length-how-do-i-calculate-the-coordinates
  # need to add row to data so that "for (i in 2:" works in parallel with xys
  data$coord_x <- 0
  data$coord_y <- 0
  
  df1 <- data[1,]
  df1$aid <- 0
  df1[,c(3,4,5,6,7,8)] <- NA
  data <- rbind(df1,data)
  xys <- data.frame(x=0, y=0)

  for (i in 2:nrow(data)) {
    xys[i,] <-  geosphere::destPoint(c(xys[i-1, 1],xys[i-1, 2]), 
                          data$azimute[i], data$segmento[i], r = 6378137)
  }
   

  dft <- data.frame(plot_id = data[2:nrow(data),'plot_id'],
            seg_id = data[2:nrow(data),'seg_id'],
            segmento = data[2:nrow(data),'segmento'],
            coord_x = xys[1:nrow(data) - 1,'x'], 
            coord_y = xys[1:nrow(data) - 1,'y'],
            azimute = data[2:nrow(data),'azimute'],                     
            remove_trilha = data[2:nrow(data),'remove'],
            remove_angle = data[2:nrow(data),'remove_angle'],
            remove_all = data[2:nrow(data),'remove_all']
            ) 
  df1 <- dft[1,]
  df1[,c(2,3,4,5,6,7,8,9)] <- NA
  df1$coord_x <- xys[nrow(xys) ,'x'] 
  df1$coord_y <- xys[nrow(xys),'y']
  dft <- rbind(dft,df1)
  dft$remove_trilha <- ifelse(is.na(dft$remove_trilha) == TRUE , 0, dft$remove_trilha)
  dft$remove_angle <- ifelse(is.na(dft$remove_angle) == TRUE , 0, dft$remove_angle)
  dft$remove_all <- ifelse(is.na(dft$remove_all) == TRUE , 0, dft$remove_all)
  dft$removeF <- ifelse(dft$remove_angle==1,2, dft$remove_trilha)
  dft$seg_id <- ifelse(is.na(dft$seg_id) == TRUE , row(dft),dft$seg_id)
  dft

}