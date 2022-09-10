################  Trabajo 2 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Grupo 9


#-------------------------------------------------------------------------------
#*. Descargar librerias
library(dplyr)    # librería de limpieza de datos
library(tidyr)    # librería de limpieza de datos
library(readxl)   # librería para subir archivos excel, csv

#*. Cargar ruta
user <- Sys.getenv("USERNAME")  # username
print(user)

setwd(paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2"))  # set directorio

junin_data <- read_excel("data/Region_Junin.xlsx") 
na.strings=c("",NA)   # reemplaza vacios por missing 

View(junin_data)

#-------------------------------------------------------------------------------
# 1. Información de cada variable - # Obtener el nombre de todas las variables

str(junin_data)      #nombre de variables op.1
names (junin_data)   #nombre de variables  op.2
head(junin_data)     #nombre de variables op.3


#-------------------------------------------------------------------------------
# 2. Mostrar el tipo de variables (type) así como presentar los principales estadísticos
class(junin_data)    #tipo de archivo

lapply(junin_data, class) #tipos de variable en lista op.1
sapply(junin_data, class) #tipos de variable en vector op.2

summary(junin_data) # estadisticas descriptivas de cada variable

#-------------------------------------------------------------------------------
# 3. Verifique si las columnas presentan missing values

apply(X=is.na(junin_data),MARGIN = 2,FUN=sum)   
  #estos resultados se leen así, la variable 'Region' tiene 0 missings, la variable
  # 'Place' tiene 11 missings (así para todas las variables).

#-------------------------------------------------------------------------------
# 4.Renombrar las siguientes variables (se crea nueva data para ello):

  #place : comunidad
  #men_not_read: homxlee
  #women_not_read: mujerxlee
  #total_not_read: totalxlee

Junin2 <- junin_data %>% rename( comunidad = Place, homxlee = men_not_read,mujerxlee=women_not_read,totalxlee=total_not_read) 

#-------------------------------------------------------------------------------
#5.Muestre los valores únicos de las siguientes variables (comunidad , District)

#*Para variable "comunidad"
unique(Junin2$comunidad)
length(unique(Junin2$comunidad)) #183 valores únicos de comunidad

#Comprobación: 197 obs -14 obs duplicadas= 183 obs únicas
sum(duplicated(Junin2$comunidad) ) #14 valores duplicados 

#*Para variable "District"
unique(Junin2$District)
length(unique(Junin2$District)) #35 valores únicos de District

#Comprobación: 197 obs -162 obs duplicadas= 35 obs únicas
sum(duplicated(Junin2$District) ) #162 valores duplicados 


#-------------------------------------------------------------------------------
# 6. Crear columnas con las siguiente información: 
    # a. % de mujeres que no escriben ni leen
    # b. % de varones que no escriben ni leen 
    # c. % de nativos respecto al total de la población

#a.
Junin2['porct_mujer']=Junin2$mujerxlee/(Junin2$totalxlee)
#b. 
Junin2['porct_hombre']=Junin2$homxlee/(Junin2$totalxlee)

#c.
Junin2['total']=(Junin2$peruvian_men+Junin2$peruvian_women+Junin2$foreign_men+Junin2$foreign_women)  # primero se crea variable de poblacion total
Junin2['porct_natives']=Junin2$natives/(Junin2$total)


#-------------------------------------------------------------------------------
# 7. Crear una base de datos con la siguiente información

#a. Quedarse con la información de los distritos

Junin2 <- Junin2[junin_data$District %in% c("CIUDAD DEL CERRO","JAUJA","ACOLLA","SAN GERÓNIMO","TARMA","OROYA","CONCEPCIÓN"),]
dim(Junin2) #57=filas, 43=columnas
View(Junin2)

#b. Quedarse con las comunidades que cuentan con nativos y mestizos.

Junin2 <- Junin2 %>% filter( (natives > 0) & (mestizos > 0 ))
View(Junin2)


#c. Solo quedarse con las variables trabajadas en el punto 8)
Junin2 <- Junin2[,c('porct_mujer','porct_hombre','porct_natives','District','comunidad')]
View(Junin2)

#d. Guardar la base de datos en formato csv y excel en la carpeta data

write.csv(Junin2, 'data/Base_cleaned_WG9.csv')   #guardado en csv

install.packages("writexl")  # instalar paquete de ser necesario
library(writexl)

write_xlsx(Junin2, 'data/Base_cleaned_WG9.xlsx') #guardado en xlsx