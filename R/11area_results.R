#' area_results
#' 
#' @description
#' \code{area_results} Calculates area and exports results in user friendly formats.
#'
#' @param results_list List of results from \code{area_calc}.
#' @param make_shape Logical, should shapes be exported.
#'
#' @return Exports .csv of calulated area values and .pdfs with figures for checking.
#' @export
#'
#' @examples
#' \dontrun{
#' # Example with required data format
#' data(br319)
#' dados_in <- br319
#' 
#' # calculate area for specified widths
#' list_res <- parcelareadev::area_calc(
#' data_in = dados_in, 
#' faixa_dist = c(0.5, 1, 3,12, 10, 20, 21, 22),
#' faixa_lado = c(0.5, 1, 3,12, 10, 20, 21, 22),
#' area_epsg = 3395)
#' 
#' # produce results
#' df.resumo <- parcelareadev::area_results(results_list = list_res,
#'                                         make_shape = FALSE)
#' }
area_results <- function(results_list = list_res, make_shape = FALSE){
   # check results valid
   if(class(results_list)=="logical" | 
     class(names(results_list))=="logical" |
     length(results_list)==0){
    stop("results do not contain valid elements")
   }
  
  # check that buffers have been created
  require(rlist)
  if(length(rlist::list.find(list_res[1], 
                      class(buff_SpatialLinesAll$buf_22m)=="SpatialPolygons")) == 0 | 
     length(rlist::list.find(list_res[1], 
                      class(buff_SpatialLinesAll$buf_20m)=="SpatialPolygons")) == 0 |
     length(rlist::list.find(list_res[1], 
                      class(buff_SpatialLinesAll$buf_10m)=="SpatialPolygons")) == 0) 
    stop("Buffer not created. Check option faixa_dist.
         Results must include 10m, 20m and 22m buffers")
  
  if( length(rlist::list.find(list_res[1],
                       class(ladobuff_SpatialLinesAll$'ladobuf_22m') =="SpatialPolygonsDataFrame"))==0) 
    stop("Buffer not created. Check option faixa_lado. Results must include 22m buffer")
  
  # 3 Resultados
  ## 3.1 resumo das parcelas: 
  # resultado = uma data.frame "df.resumo" com area em m2
  df.resumo <- ldply(results_list,.fun = parcelareadev::out_resumo)
  
    # com parallel, need to update
  #library(doMC)
  #registerDoMC(cores=4)
  #df.resumo <- ldply(list_res,.fun = out_resumo,.parallel = TRUE)
  
  # 3.2 figuras 
  # resultado = arquivos .pdf mostrando a linha central e area
  
  # linhas
  pdf(file="check_linha_test.pdf", onefile=TRUE) 
  figlinha <- lapply(results_list, FUN = parcelareadev::check_linha )
  dev.off()
  # area simetrica
  # Funcione somente quando especificar pelo menos 22m, 20m e 10m em faixa_lado.
  pdf(file="check_area_test.pdf", onefile=TRUE) 
  figarea <- lapply(results_list, FUN = parcelareadev::check_area )
  dev.off()
  
  # area asimetrica
  # Funcione somente quando especificar pelo menos 22m em faixa_lado.
  pdf(file="check_lado_test.pdf", onefile=TRUE) 
  figlado <- lapply(results_list, FUN = parcelareadev::check_lado )
  dev.off()
  
  write.csv2(df.resumo,"resumo_parcelas.csv")
  
  if(make_shape!=FALSE){
    fileend <- paste(format(Sys.time(),"%Y%m%d"), format(Sys.time(),"%H%M%S"), sep="_")
    dir.create(paste("shapes_plots", fileend, sep="_"))
    newf <- paste(getwd(),paste("shapes_plots", fileend, sep="_"), sep="/")
    setwd(newf)
    exps <- lapply(results_list, FUN = parcelareadev::expshape )
  }
  
  return(df.resumo)

}