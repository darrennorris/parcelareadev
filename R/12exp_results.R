#' exp_results
#' 
#' @description
#' \code{exp_results} Exports central line shifted to geographic coordinates.
#'
#' @param results_list List of results from \code{area_calc}.
#' @param pcoords Data.frame, with geographic coordinates of plot start points.
#' @param exp_KML Logical. Export as KML.
#'
#' @return Exports shapefiles and kml of central line shifted to geographic coordinates.
#' @export
#'
#' @examples
#' \dontrun{
#' # Example with required data format
#' data(br319)
#' dados_in <- br319
#' 
#' # Generate lines and polygons for specified widths
#' list_res <- parcelareadev::area_calc(
#' data_in = dados_in, 
#' faixa_dist = c(0.5, 1, 3,12, 10, 20, 21, 22),
#' faixa_lado = c(0.5, 1, 3,12, 10, 20, 21, 22),
#' area_epsg = 3395)
#' 
#' # Calculate area and export results
#' df.resumo <- parcelareadev::area_results(results_list = list_res,
#'                                         make_shape = FALSE)
#'                                         
#' # Now shift central line to geographic coordinates 
#' # and export as shapefiles and KML for visualization and checking
#' data("br319coords")
#' pc <- br319coords
#' parcelareadev::exp_results(results_list = list_res, 
#'                            pcoords = pc, exp_KML = TRUE)                                         
#' }
exp_results <- function(results_list = list_res, pcoords = pcoords, exp_KML = TRUE){
   # check results valid
   if(class(results_list)=="logical" | 
     class(names(results_list))=="logical" |
     length(results_list)==0){
    stop("results do not contain valid elements")
   }
    
    wdorig <- getwd()
    fileend <- paste(format(Sys.time(),"%Y%m%d"), format(Sys.time(),"%H%M%S"), sep="_")
    dir.create(paste("shapes_plots_shift", fileend, sep="_"))
    newf <- paste(getwd(),paste("shapes_plots_shift", fileend, sep="_"), sep="/")
    setwd(newf)
    exps <- lapply(results_list, FUN = parcelareadev::expshiftSHP, pcoords = pcoords )
    setwd(wdorig)
    
    if(exp_KML!=FALSE){
      wdorig <- getwd()
      fileend <- paste(format(Sys.time(),"%Y%m%d"), format(Sys.time(),"%H%M%S"), sep="_")
      dir.create(paste("KML_plots_shift", fileend, sep="_"))
      newf <- paste(getwd(),paste("KML_plots_shift", fileend, sep="_"), sep="/")
      setwd(newf)
      expkml <- lapply(results_list, FUN = parcelareadev::expshiftKML, pcoords = pcoords  )
      setwd(wdorig)
    }

}
