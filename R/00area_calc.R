#' area_calc
#' 
#' @description
#' \code{area_calc} Generates lines and polygons for area calculation of nonlinear plots.
#'
#' @param data_in Data.frame with bearings and distances. See \code{data(br319)}
#' for example of required format.
#' @param faixa_dist Distances to calculate area.
#' @param faixa_lado Distances to calculate area, 
#' seperately to the left and right of the central line
#' @param area_epsg EPSG for projection. This gives coordinate reference system used 
#' when calculating area.
#'
#' @return List of data and spatial (lines and polygons).
#' @export
#' @importFrom stats na.omit
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
#'                        make_shape = FALSE)
#' 
#' # Now shift central line to geographic coordinates 
#' # and export as shapefiles and KML for visualization and checking
#' data("br319coords")
#' pc <- br319coords
#' parcelareadev::exp_results(results_list = list_res, 
#'                            pcoords = pc, exp_KML = TRUE) 
#' }
area_calc <- function(data_in, faixa_dist = c(0.5, 10, 20, 22),
                      faixa_lado = c(1.5, 2, 10, 21.5, 22),
                      area_epsg = 3395){
  
  if(length(names(data_in)) < 6){
    stop("Input data format incorrect. Input data has too few columns.")
  }
  
  if(length(names(data_in)) > 6){
    stop("Input data format incorrect. Input data has too many columns.")
  }
  
  data_in <- na.omit(data_in)
  
  #2  Fazer
  ## 2.1 #### indentificar se angulo entre segementos eh <70 
  # resultado = data.frame com novas colunas: "remove_angulo" "remove_all"
  df.azi <- plyr::ddply(data_in,c("plot_id"),
                        .fun = parcelareadev::checkAngle)
  
  ## 2.2 #### coordenados linha central
  # resultado = data.frame com os coordenados da liha central nas parcelas
  df.CoordsCentral <- plyr::ddply(df.azi,c("plot_id"),
                                  .fun = parcelareadev::getCoords)
  
  ## 2.3 ##### fazer segmentos 
  # resultado = dataframe identificando segmentos antes e depois "remove" = 1  
  df.seg <- plyr::ddply(df.CoordsCentral, c("plot_id"),
                        .fun = parcelareadev::makeSeg)
  
  ## 2.4 ##### linha  central
  # resultado = uma lista de "spatial lines" 
  # com a linha central para as parcelas
  sp.LinhaCentral <- plyr::dlply(df.seg, c("plot_id"), 
                           .fun = parcelareadev::doLine)
  
  ## 2.5 ##### Amostragens simetricas
  # buffers (faixas) somando ambos os lados 
  # resultado = uma lista de "polygons" 
  # valores dos buffers "faixa_dist" pode ser ajustado
  sp.Buff <- lapply(sp.LinhaCentral, FUN = parcelareadev::doBuff, 
                    faixa_dist = faixa_dist)
  
  ## 2.6 ##### Amostragens asimetricas
  # buffers (faixas) separados referentes lado direta e esquerdo 
  # resultado = uma lista de "polygons" 
  # valores dos buffers "faixa_dist" pode ser ajustado 
  sp_buff_lado <- lapply(sp.LinhaCentral, FUN = parcelareadev::makelado, 
                         faixa_lado = faixa_lado)
  
  # 2.7 Tratamento:
  # gerando uma lista com os dados (dataframes), 
  # linhas (spatiallines) e faixas (polygons)
  #library(rlist)
  list_res <- rlist::list.merge(sp.LinhaCentral, 
                         sp.Buff,
                         sp_buff_lado,
                         plyr::dlply(data_in, 'plot_id',function(x){
                           l1<- list(data = list(input = x))
                         }),
                         plyr::dlply(df.CoordsCentral, 'plot_id',function(x){
                           l1<- list(data = list(coords = x))
                         }),
                         plyr::dlply(df.azi, 'plot_id',function(x){
                           l1<- list(data = list(azi = x))
                         }),
                         plyr::dlply(df.seg, 'plot_id',function(x){
                           l1<- list(data = list(lineseg = x))
                         })
  )
  return(list_res)
}