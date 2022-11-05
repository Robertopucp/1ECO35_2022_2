################  Clase 10 gráficos (World Bank) ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza

# clear environment

rm(list=ls(all=TRUE))

librarian::shelf(
    tidyverse
    , haven

)

# Set directorio ----

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab10") ) # set directorio

