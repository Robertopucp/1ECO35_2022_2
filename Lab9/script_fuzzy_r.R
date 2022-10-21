################  Clase 8 Fuzzy matching ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 


# Load libraries


library(readxl)



user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab8") ) # set directorio


# Master data

data <- read_excel("../data/Centro_salud/Centro_salud_mental.xls")




