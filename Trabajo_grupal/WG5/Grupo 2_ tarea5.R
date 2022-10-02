#-----------------------------------------
# WG5 Tarea 5 - Grupo 2
#-----------------------------------------
# R y Python
#-----------------------------------------
# Integrantes:
# Enrique Ríos 
# Fabio Salas
# Amalia Castillo
# Angie  Quispe

user <-Sys.getenv("USERNAME")
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG5") )


#--------------
# Comando para borrar todo lo que no sirva antes
rm(list=ls())

#---------------
# Librerías
#---------------
install.packages("pacman")
library(foreign)
library(dplyr)

pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)

# haven: Este comando lee archivos spss (sav)
# string : Este comando trabaja con string

#-----------------------
# Ruta de trabajo
#-----------------------
# Se setea el directorio
script.path <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd("D:\\Users\\Usuario\\Documents\\GitHub\\1ECO35_2022_2\\data")


# Procedemos a importar los datos a analizar

file_path = "D:\\Users\\Usuario\\Documents\\GitHub\\1ECO35_2022_2\\data\\data_administrativa.sav"
datos <- haven::read_sav(file_path , encoding = "UTF-8" )  # read dataset

#Revisamos la dimensión de los datos

head(datos)
names(datos) #Para el nombre de las variables de la lista 


# Var labels y values labels
# Se emplea el comando "control + shift + m " en iOS para que aparezca este símbolo %>% 

datos$ESTRATO %>% attr('labels') # value labels
datos$ESTRATO %>% attr('label') # var label


datos$DOMINIO %>% attr('labels') # value labels
datos$DOMINIO %>% attr('label') # var label

# Primero se procede a desarrollar value labels

print(datos$ESTRATO) #vemos el estrato
datos$ESTRATO %>% attr('labels') # value labels


# Segundo se procede a encontrar las variables labels
print(datos$DOMINIO)
datos$DOMINIO %>% attr('labels') # value labels

# Ahora se procede a detectar y eliminar duplicados
attach(datos) 


datos <- datos %>% filter(ESTRATO == 1 & DOMINIO == 1)

view(datos)

datos_filtrados <- datos %>% group_by(year ,MES , UBIGEO ,CONGLOME , CODPERSO, VIVIENDA, HOGAR) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) %>%
  select(year ,MES , UBIGEO ,CONGLOME , CODPERSO, VIVIENDA, HOGAR, duplicates ) 

View(datos_filtrados) # No existen duplicados


# Se crea dataframe para los años 2019 y 2020

# Drop duplicates rows (observaciones). Se borra las copias, No las primeras apariciones

datos_2019 <- datos %>% distinct(year = 2019 , MES , UBIGEO ,CONGLOME , CODPERSO, VIVIENDA, HOGAR) # .keep_all = TRUE muestra todas las variables

datos_2020 <- datos %>% distinct(year = 2020 , MES , UBIGEO ,CONGLOME , CODPERSO, VIVIENDA, HOGAR)

# Finalmente, se guarda la nueva data creada

datos_2019

datos_2020

write_sav(datos_2019, "/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data")
write_sav(datos_2020, "/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data")

