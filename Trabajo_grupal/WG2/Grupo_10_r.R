#Base de datos

library("readxl")
Region_Junin <- read_excel("../data/Region_Junin.xlsx", col_names = T)

#Pregunta 1: Obtener el nombre de todas las variables

attach(Region_Junin) 
str(Region_Junin)
names(Region_Junin)

#Pregunta 2: Mostrar el tipo de variables (type) así como presentar los principales estadísticos.

lapply(Region_Junin, class) #list
sapply(Region_Junin, class) #vector, Datrame
summary(Region_Junin) # estadisticas desciptivas de las variables

#Pregunta 3: Verifique si las columnas presentan valores faltantes

any(is.na(Region_Junin))  # al menos una observación es Missing
sum(is.na(Region_Junin))  #hay 66 missing

#Pregunta 4: Cambie el nombre de las siguientes variables

install.packages("tidyverse")
library(tidyverse)

Region_Junin <- Region_Junin %>% 
select(Place, men_not_read, women_not_read, total_not_read) %>%
rename(comunidad = Place, homxlee = men_not_read, mujerxlee = women_not_read, totalxlee = total_not_read)
View(Region_Junin)

#Pregunta 5: Muestre los valores únicos de las siguientes variables ( comunidad , District)

attach(Region_Junin)
unique(comunidad) # De forma individual
unique(District) # De forma individual
unique(comunidad, District) # de manera conjunta

# Pregunta 6: Crear columnas con las siguiente información: el % de mujeres del que no escriben
#ni leen (mujerxlee/totalxlee) % de varones que no escriben ni leen (homxlee/totalxlee) y % de 
#nativos respecto al total de la población. Para el total de la población sumar (peruvian_men +
#peruvian_women + foreign_men + foreign_women)

# creación de la variable % de mujeres que no escriben ni leen
Region_Junin['% de mujeres del que no escriben ni leen'] = Region_Junin['mujerxlee']*100 / Region_Junin['totalxlee']

# creación de la variable % de varones que no escriben ni leen
Region_Junin['% de varones que no escriben ni leen'] = Region_Junin['homxlee']*100 / Region_Junin['totalxlee']

# Total de la población 
Region_Junin <- read_excel("../data/Region_Junin.xlsx", col_names = T)
attach(Region_Junin) 
Region_Junin['total de la población'] = Region_Junin['peruvian_men']+ Region_Junin['peruvian_women']+Region_Junin['foreign_men']+Region_Junin['foreign_women']  

# Pregunta 7: Crear una base de datos con la siguiente información:

# a. Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción

attach(Region_Junin) 
data_frame <-Region_Junin[District %in% c("CIUDAD DEL CERRO", "JAUJA", "ACOLLA", "SAN JERÓNIMO", "TARMA", "OROYA", "CONCEPCIÓN"),]

#b. Luego quedarse con las comunidades que cuentan con nativos y mestizos.

data_frame <- Region_Junin[Region_Junin$comunidad %in% c("nativos","mestizos"),]

#c. Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.

Region_Junin <- Region_Junin %>%
  select(comunidad, District,% de mujeres que no escriben ni leen, % de varones que no escriben ni leen, `total de la población`) %>%

#d. Guardar la base de datos en formato csv en la carpeta data. (Use el siguiente nombre Base_cleaned_WG(numero de grupo)





