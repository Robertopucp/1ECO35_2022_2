rm(list=ls())

#Instalamos los paquetes para realizar las actividades
#install.packages("reshape")
# install.packages("dplyr") 
# install.packages("readxl") 
# install.packages("tidyr")

#Cargamos nuestras librerías
library(reshape)
library(dplyr)
library(tidyr)
library(readxl) 

getwd()
user <- Sys.getenv("USERNAME")  # username
print(user)

#Primero corremos el directorio e importamos la base de datos
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/data"))
junin_data<- read_excel("Region_Junin.xlsx")

#1.-Obtenemos los nombres de mis variables
names(junin_data)

#2.1.-Detallamos nuestros tipos de variables
lapply(junin_data, class) #la mayoría de variables son "numeric", excepto region,district y Place

#2.2.-Mostramos los principales datos estadisticos: mediana, media, minimo, max, primer quintil,tercer quintil
summary(junin_data)

#3.-Verificamos que variables presentan missing values

#Al correr cada codigo, si resulta TRUE, significa que la variable entre corchetes presenta missing values.
#Si resulta FALSE, la variable no presenta missing values.
any(is.na(junin_data["Region"])) #No presenta missing values
any(is.na(junin_data["District"])) #No presenta Missings
any(is.na(junin_data["Place"])) #sí presenta missings
any(is.na(junin_data["4_6_years_men"])) #NO
any(is.na(junin_data["4_6_years_women"]))  #NO
any(is.na(junin_data["4_6_years_total"])) #NO
any(is.na(junin_data["6_14_years_men"])) #SÍ
any(is.na(junin_data["6_14_years_women"])) #NO
any(is.na(junin_data["6_14_years_total"])) #NO
any(is.na(junin_data["man_read"])) #NO
any(is.na(junin_data["women_read"])) #SI
any(is.na(junin_data["total_read"])) #NO
any(is.na(junin_data["men_not_read"])) #NO
any(is.na(junin_data["women_not_read"])) #NO
any(is.na(junin_data["total_not_read"])) #SI
any(is.na(junin_data["man_write"]))
any(is.na(junin_data["women_write"]))
any(is.na(junin_data["total_write"]))
any(is.na(junin_data["men_not_write"]))
any(is.na(junin_data["women_not_write"])) #NO
any(is.na(junin_data["total_not_write"]))
any(is.na(junin_data["instruction_men"])) #NO
any(is.na(junin_data["instruction_women"]))
any(is.na(junin_data["instruction_total"]))
any(is.na(junin_data["no_instruction_men"]))
any(is.na(junin_data["no_instruction_women"]))
any(is.na(junin_data["no_instruction_total"]))
any(is.na(junin_data["finished_instr_men"]))
any(is.na(junin_data["finished_instr_women"]))
any(is.na(junin_data["finished_instr_total"]))
any(is.na(junin_data["not_finished_instr_men"]))
any(is.na(junin_data["not_finished_instr_women"]))
any(is.na(junin_data["not_finished_instr_total"]))
any(is.na(junin_data["peruvian_men"]))
any(is.na(junin_data["peruvian_women"]))
any(is.na(junin_data["foreign_men"]))
any(is.na(junin_data["foreign_women"]))
any(is.na(junin_data["whites"]))
any(is.na(junin_data["natives"]))
any(is.na(junin_data["mestizos"]))
any(is.na(junin_data["blacks"]))

#4.-Cambiamos nombres a las siguientes variables:
#comunidad en lugar de place, homxlee en lugar de men_not_read, 
#mujerxlee en lugar de woman_not_read y totalxlee en lugar de total_not_read

junin_data= rename(junin_data, c(Place="Comunidad"))
junin_data= rename(junin_data, c(men_not_read="Homxlee"))
junin_data= rename(junin_data, c(women_not_read="Mujerxlee"))
junin_data= rename(junin_data, c(total_not_read="Totalxlee"))

#5.-Muestre los valores únicos de las siguientes variables ( comunidad , District)

unique(junin_data$Comunidad)

unique(junin_data$District)

#6.-Crear columnas con las siguiente información: 
#el % de mujeres del que no escriben ni leen (mujerxlee/totalxlee) 

#para hallar el % de las mujeres que no leen multiplicamos por 100 a la división (mujerxlee/totalxlee)
junin_data['%mujeresnoleen'] = 100 * junin_data['Mujerxlee'] / junin_data['Totalxlee'] 
#para hallar el % de las mujeres que no escriben multiplicamos por 100 a la división (mujerxlee/totalxlee)
junin_data['%mujeresnoescriben'] = 100 * junin_data['women_not_write'] / junin_data['total_not_write'] 

#% de varones que no escriben ni leen (homxlee/totalxlee)
#se realiza el mismo procedimiento que para mujeres
junin_data['%hombresnoleen'] = 100 * junin_data['Homxlee'] / junin_data['Totalxlee'] 
junin_data['%hombresnoescriben'] = 100 * junin_data['men_not_write'] / junin_data['total_not_write'] 

#% de nativos respecto al total de la población. 

#primero creamos una variable "población total" que suma mujeres y hombres peruanos y extranjeros
junin_data['poblacióntotal']= junin_data['peruvian_women'] + junin_data['peruvian_men'] + junin_data['foreign_women'] + junin_data['foreign_men']
#hallamos el % de nativos respecto al total de la población
junin_data['%nativos'] = 100 * junin_data['natives'] / junin_data['poblacióntotal'] 

#7.-Crear una base de datos con la siguiente información:

#a. Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción

clean <- junin_data[junin_data$District %in% c("CIUDAD DEL CERRO","JAUJA","ACOLLA","SAN GERÓNIMO","TARMA","OROYA", "CONCEPCIÓN"),]

# b. Luego quedarse con las comunidades que cuentan con nativos y mestizos.

clean1 <- clean[ ! clean$natives %in% c("0"),] #nos quedamos con solo nativos.Primero eliminamos todas las filas que tengan 0 en nativos. No asumimos que los NA son igual a 0.
clean2 <- clean1[ ! clean1$mestizos %in% c("0"),] #nos quedamos con solo mestizos. Primeros eliminamos todas las filas que tengan 0 en mestizos. No asumimos que los NA son igual a 0.

# c. Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.
Base_cleaned <- clean2[,c('District','Comunidad','%mujeresnoleen','%mujeresnoescriben','%hombresnoleen', '%hombresnoescriben', 'poblacióntotal','%nativos')] #seleccionar columnas solicitadas
View(Base_cleaned)

# d. Guardar la base de datos en formato csv en la carpeta data.

write.csv(Base_cleaned, '../data/Base_cleaned_WG(grupo8).csv')
