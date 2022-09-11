

################################################################################
#                                                                              #
#                              TAREA 2 - GRUPO 4                               #
#                                                                              #
################################################################################

# Seidy Ascencios - 20191622
# Luana Morales - 20191240
# Flavia Oré - 20191215
# Marcela Quintero - 20191445


#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 1                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#En primer lugar, llamaremos a las librerías necesarias para empezar a tratar la base de datos

library(dplyr) 
library(tidyr)
library(readxl)


#Elegimos el directorio

getwd()
user <- Sys.getenv("USERNAME")

print(user)

setwd( paste0("C:/Users/", user, "/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG2") )

junin_data <- read_excel("../../data/Region_Junin.xlsx") 



#Obtenemos el nombre de las variables utilizando el comando str:

attach(junin_data)
str(junin_data)


#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 2                                    # 
#                                                                              #
#------------------------------------------------------------------------------#


#Obtenemos las variables y de qué tipo son utilizando lapply:

lapply(junin_data, class)


#Luego, para obtener los principales estadísticos descriptivos de las variables, usamos el comando summary:


summary(junin_data)



#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 3                                    # 
#                                                                              #
#------------------------------------------------------------------------------#


#Reemplazamos los missing values por "na":

na.strings=c("",NA)

#Verificamos la existencia de missing values:

any( is.na(junin_data) )  #El resultado es "TRUE", por lo que sí hay missing values


#Contamos el nÃºmero de missing values:

sum(is.na(junin_data)) #Vemos que existen 66 missing values en nuestra base de datos


#Obtenemos el nombre de las columnas con al menos 1 missing value: 

is.na(junin_data)

colSums(is.na(junin_data))

which(colSums(is.na(junin_data))>0)

names(which(colSums(is.na(junin_data))>0))

#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 4                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Ver los nombres de las columnas
names (junin_data )


#Instalar paquete "reshape" para activar rename

install.packages("reshape")


#Cambio de la variable place : comunidad

attach(junin_data) 

print(Place)

junin_data= rename(junin_data, c (Comunidad= "Place"))

table (junin_data$Comunidad)


#Cambio de la variable men_not_read: homxlee

attach(junin_data) 

print(men_not_read)

junin_data= rename(junin_data, c (homxlee= "men_not_read"))

table (junin_data$homxlee)


#Cambio de la variable women_not_read: mujerxlee

attach(junin_data) 

print(women_not_read)

junin_data = rename(junin_data, c (mujerxlee= "women_not_read"))

table (junin_data$mujerxlee)


#Cambio de la variable total_not_read: totalxlee

attach(junin_data) 

print(total_not_read)

junin_data = rename(junin_data, c (totalxlee= "total_not_read"))

table (junin_data$totalxlee)



#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 5                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Detección de valores duplicados en la columna comunidad y distrito

any(duplicated(Comunidad))
any(duplicated(District))
#En ambos casos, notamos que es cierto que existen valores duplicados.


#Podemos saber que la cantidad de missing values para Comunidad y Distrito:
sum(is.na(Comunidad))
sum(is.na(District))

# Valores únicos de Comunidad:
unique(Comunidad)

# Valores únicos de District:
unique(District)



#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 6                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Creamos la nuevas variables

junin_data['pmujxlee'] = junin_data['mujerxlee'] / junin_data['totalxlee'] * 100

junin_data['phomxlee'] = junin_data['homxlee'] / junin_data['totalxlee'] * 100

junin_data['total_pobla'] = junin_data['peruvian_men'] + junin_data['peruvian_women'] + junin_data['foreign_men'] + junin_data['foreign_women']

junin_data['pnativos'] = junin_data['natives'] / junin_data['total_pobla'] * 100


junin_data2 <- junin_data[,c('pmujxlee','phomxlee','total_pobla','pnativos')] 


#Columna del porcentaje de mujeres que no escriben ni leen

attach(junin_data2) 

View( junin_data2[1:197,c('pmujxlee')] )


#Columna del porcentaje de varones que no escriben ni leen

attach(junin_data2) 

View( junin_data2[1:197,c('phomxlee')] )

#Columna del porcentaje de nativos respectos al total de la poblaciÃ³n

attach(junin_data2) 

View( junin_data2[,c('nativos')] )

     
#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 7                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Subsetting columns
     
# Nos quedamos con los datos de los distritos de Ciudad del Cerro, Jauja, Acolla
#San GerÃ³nimo, Tarma, Oroya y Concepción     

junin_data3 <- junin_data[which(junin_data$District == 'CIUDAD DEL CERRO' | junin_data$District == 'JAUJA' | junin_data$District == 'ACOLLA' | junin_data$District == 'SAN GERÃ“NIMO' | junin_data$District == 'TARMA' | junin_data$District == 'OROYA' | junin_data$District == 'CONCEPCIÃ“N'), ]
View(junin_data3)

#comunidades que cuentan con nativos y mestizos

junin_data4 <- junin_data3[which(junin_data3$natives > 0 & junin_data3$mestizos > 0), ] 
View(junin_data4)

#crear una nueva base de datos 

junin_data5 <- junin_data4[,c('District','Comunidad')] 
View(junin_data5)

#Guardamos la base de datos en formato csv en la carpeta data

write.csv(base, '../data/Base_cleaned_4.xlsx')

     