################################################################################
#                                                                              #
#                              TAREA 5 - GRUPO 4                               #
#                                                                              #
################################################################################

# Luana Morales - 20191240
# Flavia Oré - 20191215
# Marcela Quintero - 20191445
# Seidy Ascencios - 20191622

#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 2                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#En primer lugar, llamaremos a las librerías necesarias para empezar a tratar la base de datos

install.packages("pacman")
pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)

#Elegimos el directorio
user <- Sys.getenv("USERNAME")  

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG5") )

#Abrimos la base de datos

data_administrativa <- haven::read_sav("../../data/data_administrativa.sav") 

head (data_administrativa)

names(data_administrativa)

#variables que presentan missing values

any( is.na(data_administrativa) ) #El resultado es "TRUE", por lo que sí hay missing values

sum(is.na(data_administrativa)) #Vemos que existen 243075 missing values en nuestra base de datos

is.na(data_administrativa) #El resultado el "TRUE", donde existen missing values. Es decir, las varibles P203A, P203B, P204, P205, P206, P207,P208A, P208B, P209

#dos variables en var labels 

summary.data.frame (data_administrativa) #vemos el resumen estadístico

install.packages("Hmisc") #instalamos para tener la función label
library (Hmisc)
label (data_administrativa$P204)<- "miembro_hogar"
label (data_administrativa$P203)<- "parentesco_jefefamiliar"

#dos variables en value's labels 

table (data_administrativa$P207)
data_administrativa$p207<-factor(data_administrativa$p207,levels=c(1,2), labels  = c("hombre", "mujer"))
table (data_administrativa$P204)
data_administrativa$p204<-factor(data_administrativa$p204,levels=c(1,2), labels = c("si", "no"))

#detectar duplicados

data_adminitrativa_1 <- data_administrativa %>% distinct(CONGLOME,VIVIENDA,HOGAR,CODPERSO, .keep_all = TRUE)

#Ordenar base de datos

data_adminitrativa_2 <- data_adminitrativa_1[with(data_adminitrativa_1, order(data_adminitrativa_1$CODPERSO)), ] 

data_adminitrativa_3 <- data_adminitrativa_2[with(data_adminitrativa_2, order(data_adminitrativa_2$UBIGEO)), ] 

data_adminitrativa_4 <- data_adminitrativa_3[with(data_adminitrativa_3, order(data_adminitrativa_3$CONGLOME)), ] 

data_adminitrativa_5 <- data_adminitrativa_4[with(data_adminitrativa_4, order(data_adminitrativa_4$VIVIENDA)), ] 

data_adminitrativa_6 <- data_adminitrativa_5[with(data_adminitrativa_5, order(data_adminitrativa_5$HOGAR)), ] 

data_adminitrativa_7 <- data_adminitrativa_6[with(data_adminitrativa_6, order(data_adminitrativa_6$year)), ] 

#separar por año 

data_trabajada2019 <- data_adminitrativa_7[data_adminitrativa_7$year==2019,]

data_trabajada2020 <- data_adminitrativa_7[data_adminitrativa_7$year==2020,]

#se guarda las bases de datos creadas

install.packages("haven")      
library("haven")

write_sav(data_trabajada2019 , "../data/data_2019_grupo4.sav")
write_sav(data_trabajada2020 , "../data/data_2020_grupo4.sav")
