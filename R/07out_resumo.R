#' out_resumo
#'
#' @description
#' Should not be called directly by users.
#' \code{out_resumo} calculates area and formats results for .csv export.
#' 
#' @param list.poly List of results from \code{area_calc}
#'
#' @return Data.frame with calculated areas. 
#' @export
#'
#' @examples
#' \dontrun{
#' }
out_resumo <- function(list.poly) {
  require(sp)
 # area simetrica
  l1 <- list(buff_SpatialLinesAll = list.poly$buff_SpatialLinesAll,
             buff_SpatialLinesRemoveTrilha = list.poly$buff_SpatialLinesRemoveTrilha,
             buff_SpatialLinesRemoveAngle = list.poly$buff_SpatialLinesRemoveAngle,
             buff_SpatialLinesRemoveAll = list.poly$buff_SpatialLinesRemoveAll)

  getarea <- function(x){
    
    areacalc <- function(x1){
      require(sp)
      require(rgeos)
      myarea <- sum(gArea(x1, byid=TRUE))
      mydata <- data.frame(area_m2 = myarea)
    }
    
    oudata <- plyr::ldply(x,.fun = areacalc)
    
  }

 area_parcela <- plyr::llply(l1,.fun = getarea)
 od <- data.frame(area_parcela)
 
 #area asimetrica
# "ladobuff_SpatialLinesAll"          "ladobuff_SpatialLinesRemoveTrilha"
# "ladobuff_SpatialLinesRemoveAngle"  "ladobuff_SpatialLinesRemoveAll"
 l2 <- list( 
   ladobuff_SpatialLinesAll = list.poly$ladobuff_SpatialLinesAll,
   ladobuff_SpatialLinesRemoveTrilha = list.poly$ladobuff_SpatialLinesRemoveTrilha,
   ladobuff_SpatialLinesRemoveAngle = list.poly$ladobuff_SpatialLinesRemoveAngle,
   ladobuff_SpatialLinesRemoveAll = list.poly$ladobuff_SpatialLinesRemoveAll)

getlado <- function(x){
  
  areacalc <- function(x1){
    if (class(x1)=="logical"){
      dfout <- data.frame(id_lado = c("1", "2"), lado = c("left", "right"),
                          area_m2 = NA)
    }else{
      require(sp)
      require(rgeos)
      df1 <- data.frame(
        id_lado = c("1", "2"),
        lado =  names(gArea(x1, byid = TRUE)),
        area_m2 = gArea(x1, byid = TRUE)
      )
      #dfout <- merge(data.frame(x1), df1)
      dfout <- df1
    }

  }
  
  oudata <- plyr::ldply(x, .fun = areacalc)  
}

# run function
area_lado <- plyr::llply(l2, .fun = getlado)

df1 <- data.frame(area_lado)

 # contagem de segmentos
 seg_count_all <- length(data.frame( 
                        list.poly$SpatialLines_proj$SpatialLinesAll)[,1]
                        )
 seg_count_tr <- length(SpatialLinesLengths( 
   list.poly$SpatialLines_proj$SpatialLinesRemoveTrilha[,1])
 )
 seg_count_ra <- length(SpatialLinesLengths( 
   list.poly$SpatialLines_proj$SpatialLinesRemoveAngle[,1])
 )
 seg_count_rall <- length(SpatialLinesLengths( 
   list.poly$SpatialLines_proj$SpatialLinesRemoveAll[,1])
 )
 
 # dataframe com area
  outbuff <- rbind(data.frame(variable = "All", lado = "ambos",
                              faixa_id = od$buff_SpatialLinesAll.bufnames,
                              area_m2 = od$buff_SpatialLinesAll.area_m2,
                              seg_count = seg_count_all
                              ),
                   data.frame(variable = "Remove_Trilha", lado = "ambos",
                              faixa_id = od$buff_SpatialLinesRemoveTrilha.bufnames,
                              area_m2 = od$buff_SpatialLinesRemoveTrilha.area_m2,
                              seg_count = seg_count_tr
                              ),
                   data.frame(variable = "Remove_Angle", lado = "ambos",
                              faixa_id = od$buff_SpatialLinesRemoveAngle.bufnames,
                              area_m2 = od$buff_SpatialLinesRemoveAngle.area_m2,
                              seg_count = seg_count_ra
                              ),
                   data.frame(variable = "Remove_All", lado = "ambos",
                             faixa_id = od$buff_SpatialLinesRemoveAll.bufnames,
                             area_m2 = od$buff_SpatialLinesRemoveAll.area_m2,
                             seg_count = seg_count_rall
                             ),
                   data.frame(variable = "All", 
                              lado = df1$ladobuff_SpatialLinesAll.lado,
                              faixa_id = df1$ladobuff_SpatialLinesAll.bufnames,
                              area_m2 = df1$ladobuff_SpatialLinesAll.area_m2,
                              seg_count = seg_count_all), 
                   data.frame(variable = "Remove_Trilha", 
                              lado = df1$ladobuff_SpatialLinesRemoveTrilha.lado,
                              faixa_id = df1$ladobuff_SpatialLinesRemoveTrilha.bufnames,
                              area_m2 = df1$ladobuff_SpatialLinesRemoveTrilha.area_m2,
                              seg_count = seg_count_tr),
                   data.frame(variable = "Remove_Angle", 
                              lado = df1$ladobuff_SpatialLinesRemoveAngle.lado,
                              faixa_id = df1$ladobuff_SpatialLinesRemoveAngle.bufnames,
                              area_m2 = df1$ladobuff_SpatialLinesRemoveAngle.area_m2,
                              seg_count = seg_count_ra),
                   data.frame(variable = "Remove_All", 
                              lado = df1$ladobuff_SpatialLinesRemoveAll.lado,
                              faixa_id = df1$ladobuff_SpatialLinesRemoveAll.bufnames,
                              area_m2 = df1$ladobuff_SpatialLinesRemoveAll.area_m2,
                              seg_count = seg_count_rall) 
  )
  
  outbuff$faixa_tipo <- stringr::str_split_fixed(outbuff$faixa_id, "_", 2)[,1]  
  outbuff$faixa_dist <- stringr::str_split_fixed(outbuff$faixa_id, "_", 2)[,2]
  outbuff
}