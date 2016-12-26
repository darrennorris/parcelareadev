# parcelareadev
R functions. Development of nonlinear RAPELD plot area calculations and processing.

RAPELD and environmental monitroing: https://ppbio.inpa.gov.br/en/Biodiversity_and_Integrated

Brief intro to RAPELD, Chapter 3, Download:
http://ppbio.inpa.gov.br/sites/default/files/Biodiversidade%20e%20monitoramento%20ambiental%20integrado.pdf

Takes compass bearings and distances recorded during plot installation
and then: 
1) derives coordinates and calculates the survey area of nonlinear plots.
2) exports .pdf files showing plots
3) exports calculated areas as .csv
4) Exports plot lines as shapefiles and .kml


## Installation to R
Install development version from github.

1. install current devtools package from CRAN: `install.packages("devtools")` .

2. Use devtools to install the parcelareadev package from github: `devtools::install_github("darrennorris/parcelareadev")` .

3. load: `library("parcelareadev")`
