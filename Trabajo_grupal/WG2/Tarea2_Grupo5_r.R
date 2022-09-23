#install.packages("dplyr") # filter data
#install.packages("readxl") # excel, csv
#install.packages("tidyr")
'Solo es necesario cargar una vez los paquetes, luego simplemente debemos llamarlo:'

library(dplyr) # librería de limpieza de datos
library(tidyr)# librería de limpieza de datos
library(readxl) # libreria para subir archivos excel, csv
getwd()
user <- Sys.getenv("USERNAME")  # username


print(user)
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/lab3") ) # set directorio

junin_data <- read_excel("../data/Region_Junin.xlsx")

View(junin_data)

#Pregunta 1
ls(junin_data) #para obtener el nombre de las variables
#Pregunta 2
str(junin_data) #para obtener información de cada variable
lapply(junin_data, class) #para obtener el tipo de variable que pertenece
summary(junin_data) #para obtener las principales estadísticas

#Pregunta 3
any(is.null(junin_data)) #verificar si existe algún missing null
any(is.na(junin_data)) #verificar si existe algún missing na
sum(is.na(junin_data)) #contar las cantidades de missing

#Pregunta 4: Aquí teníamos la opción de cambiar los nombres en la base original,
#pero decidimos hacerlo en un data frame para observar los cambios
data_frame <- junin_data %>% rename(comunidad = Place, 
                                    homxlee = men_not_read, 
                                    mujerxlee = women_not_read,
                                    totalxlee = total_not_read)
#Pregunta 5: Creamos dataframe1 para mostrar las columnas comunidad y District 
dataframe1 <- data_frame[,c('comunidad','District')] # seleccionar columnas
View(dataframe1)#Mostramos los valores del data frame

attach(dataframe1) #También podemos observar los valores únicos con attach y la base original
unique(District)#Valores unicos para District
unique(comunidad)#Valores unicos para comunidad

#Pregunta 6: Creamos 3 columnas en el data_frame para % de mujeres que no escriben ni leen, % de hombres que no escriben ni leen y % de nativos respecto al total de la población
data_frame['mujeres que no escriben ni leen'] = data_frame['mujerxlee'] / data_frame['totalxlee'] 
data_frame['varones que no escriben ni leen'] = data_frame['homxlee'] / data_frame['totalxlee'] 
data_frame['Nativos con respecto al total de la población'] = data_frame['natives']/(data_frame['peruvian_men'] + data_frame['peruvian_women'] + data_frame['foreign_men'] + data_frame['foreign_women'])
View(data_frame) #Ahora, al final del data_frame, deberiamos tener las nuevas variables en 3 columnas

#Pregunta 7:
#Finalmente, utilizamos filter para filtrar solo ciertos contenidos que deseamos en nuestros datos 
db_final = data_frame %>% filter(District %in% c("CIUDAD DEL CERRO", "JAUJA", "ACOLLA", "CONCEPCIÓN", "SAN GERÓNIMO", "TARMA", "OROYA"))
#Utilizamos el != "0" para obtener solo a comunidades con mestizos y natives
db_final1 = db_final %>% filter(mestizos != "0" & natives != "0")

db_final2 <- db_final1[, c("mujeres que no escriben ni leen","varones que no escriben ni leen","Nativos con respecto al total de la población","District","comunidad")] #Finalmente la nueva base de datos 
# Para exportar nuestra dataset a excel
write.csv2(db_final2, '../data/Base_cleaned_WG(5).csv')

#dataframe2 <- data_frame[,c('mujeres que no escriben ni leen','varones que no escriben ni leen','Total de la poblaci?n','District','comunidad')]
#View(dataframe2)