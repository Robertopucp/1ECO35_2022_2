################  Tarea 5 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 


library(haven)
library(stringr)
library(dplyr)

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG5/Solucion") ) # set directorio

# Cargamos la base de datos 

file_path = "../../../data/data_administrativa.sav"

data <- haven::read_sav(file_path , encoding = "UTF-8" )  # read dataset


# Obervamos las etiquetas de variable y valores 


data$P209 %>% attr('labels') # value labels
data$P209 %>% attr('label') # var label

data$P206 %>% attr('labels') # value labels
data$P206 %>% attr('label') # var label


# detección de duplicados

data_filtrada <- data %>% group_by(CONGLOME ,VIVIENDA , HOGAR, CODPERSO) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) 

# ordenamos segun identificados de prsona y año

attach(data_filtrada) # cada variables se convierte en objeto independiente

data1 <- data_filtrada[order(CONGLOME ,VIVIENDA , HOGAR, CODPERSO, year),] # ordenamos 


data_2019 <- data1 %>%filter( year == "2019") 
data_2020 <- data1 %>%filter( year == "2020") 

# guardamos la base de datos 

write_sav(data_2019 , "../../../data/data2019.sav") 
write_sav(data_2020 , "../../../data/data2020.sav") 


