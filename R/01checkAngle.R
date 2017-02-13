#' checkAngle
#' 
#' @description
#' Should not be called directly by users.
#' \code{checkAngle} identifies which segments are seperated by less than 70 degrees.
#'
#' @param x Data.frame with bearings and distances, as per \code{data(br319)} .
#'
#' @return Identifies which angles need to be excluded 
#' @export
#' @examples
#' \dontrun{
#' }
checkAngle <- function(x){
# em funcao das 2 azimutes....## 
brt <- x

brt <-  dplyr::mutate(brt, 
               lag_az = dplyr::lag(azimute , order_by = seg_id),
               ret_az = azimute - 180
)

df.ang <- plyr::ddply(brt,c("seg_id"), .fun = parcelareadev::correctAng)
brt <- merge(brt,df.ang)

# here identifies which angles are less than 70, based on differences in bearings
#http://stackoverflow.com/questions/12234574/calculating-if-an-angle-is-between-two-angles

brt$anglediff <- (brt$ret_az - brt$lag_az + 180) %% 360 - 180
brt$remove_angle <- ifelse(brt$anglediff <= 70 & brt$anglediff >= -70, 1, 0 )
brt$remove_all <- ifelse(is.na(brt$remove_angle) ==TRUE, brt$remove, brt$remove + brt$remove_angle)
brt$remove_all <- ifelse(brt$remove_all > 0,1,0)
brt
}