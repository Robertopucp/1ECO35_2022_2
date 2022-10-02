#Pregunta número 2
pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)
user <- Sys.getenv("USERNAME")
library("magrittr")
library(haven)

#Importamos la base de datos
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab6") )
file_path = "../data/data_administrativa.sav"
data_administrativa <- haven::read_sav(file_path , encoding = "UTF-8" ) 
View(data_administrativa)
#Encontramos los missing en la data frame
is.na(data_administrativa)
#Aquí mostramos el value labels de Estrato y Dominio
data_administrativa$ESTRATO %>% attr('labels') # value labels
data_administrativa$DOMINIO %>% attr('labels') # value labels
#Aquí mostramos el label de Estrato y Domio
data_administrativa$ESTRATO %>% attr('label') # var label
data_administrativa$DOMINIO %>% attr('label') # var label
#Cada variable separada sola
attach(data_administrativa)
#Vamos a filtrar la data, si contiene duplicados
data_filtrada <- data_administrativa %>% group_by(CONGLOME, VIVIENDA, HOGAR , CODPERSO) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) %>%
#Vamos a elegir solo algunas variables
select(year, CONGLOME, VIVIENDA, HOGAR , CODPERSO, duplicates)
#Ahora vamos a eliminar los duplicados porque crearemos una nueva base de datos
data_administrativa_ndup <- data_administrativa %>% distinct(year, CONGLOME, VIVIENDA, HOGAR , CODPERSO, .keep_all = FALSE)
#Creamos una data frame para cada año 
data_años <- split(data_administrativa_ndup,data_administrativa_ndup$year)
#Ahora guardamos los archivos
data_2019_5 <- data_años$`2019`
data_2020_5 <- data_años$`2020`
write_sav(data_2019_5,file_path )
write_sav(data_2020_5,file_path)
