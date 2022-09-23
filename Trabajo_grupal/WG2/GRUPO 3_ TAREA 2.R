# instalar paquete readxl para importar la base de datos
install.packages("readxl")

#cargar paquete readxl
library(readxl)

#importamos los datos
junin_data <- read_excel("C:\\Users\\claud\\Downloads\\Region_Junin.xlsx", 
                         range = 'B1:AP198')
fil
## 1) obtener el nombre de todas las variables (son 41 variables)
names(junin_data)

## 2) mostrar el tipo de variable y los principales estadísticos

## los tipos
str(junin_data) ## se observa que las 3 primeras variables son del tipo 'character' (texto) mientras que las 38 restantes son del tipo 'num' (numéricas) 

## los principales estadísticos (mediana, media, # de missings) dependiendo del tipo de variable 
summary(junin_data) ## para las variables "character" la información es distinta, se muestra el numero de veces que cada valor aparece en los datos

## 3) verificar si las columnas presentan missing values
sum(is.na(junin_data)) ## tenemos el número total de missings en el dataframe (66)
apply(X=is.na(junin_data), MARGIN = 2, FUN = sum) ## así tenemos la cantidad de missings por columnas (por variable)

## 4) cambiar el nombre de las siguientes variables:

## place : comunidad
colnames(junin_data)[3] <- "comunidad" #cambiamos el nombre de la columna

## men_not_read : homxlee
colnames(junin_data)[13] <- "homxlee"

## women_not_read : mujerxlee
colnames(junin_data)[14] <- "mujerxlee"

## total_not_read : totalxlee
colnames(junin_data)[15] <- "totalxlee"

# 5. Mostrar valores unicos de comunidad y distrito
# Se observan los valores unicos de la variable comunidad
unique(junin_data$comunidad)

# 6. Crear columnas 

# Pregunta 6: Crear columnas con las siguiente información
# Para esta pregunta, es relevante conocer los siguientes datos: 
# men_not_read: homxlee
# women_not_read: mujerxlee
# total_not_read: totalxlee
# Entonces, en primera instancia hallamos el % de mujeres que no escriben ni leen (mujerxlee/totalxlee)
# El código a utilizar para identificar ello es: 

Region_Junin$porcentajemujeres_noescriben_noleen=Region_Junin$women_not_read/Region_Junin$total_not_read


# En segunda instancia, hallamos el % de varones que no escriben ni leen, razón por la cual, el código a utilizar es: 

Region_Junin$porcentajehombres_noescriben_noleen=Region_Junin$men_not_read/Region_Junin$total_not_read

# En tercera instancia, hallamos el % de nativos respecto al total de la población. Para el total de la población sumar (peruvian_men + peruvian_women + foreign_men + foreign_women). En este sentido, el código a utilizar es: 

Region_Junin$porcentajenativos_respecto_totalpoblación=Region_Junin$natives/(Region_Junin$peruvian_men+Region_Junin$peruvian_women+Region_Junin$foreign_men+Region_Junin$foreign_women)


# 7. Crear base de datos
 ## Quedarse con los valores de los ditritos: CIUDAD DEL CERRO, JAUJA, ACOLLA, SAN GERÓNIMO, TARMA, OROYA, CONCEPCIÓN

install.packages("tidyverse")
library(tidyverse)

## Quedarse con las variables Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción
junin_data2 <- junin_data %>% filter( District != "JAUJA", "CIUDAD DEL CERRO", "ACOLLA", "SAN GERÓNIMO", "TARMA", "OROYA", "CONCEPCIÓN")

# Quedarse con los que cuentan con nativos y mestizos

junin_data3 <- junin_data2 %>% filter( natives > 0 )

junin_data4 <- junin_data3 %>% filter( mestizos > 0)

# Generar base en formato excel

write.table(junin_data4, file = "Base_cleaned_WG3.csv" , sep = ";", row.names = F)

# Se descarga y adjunta base
