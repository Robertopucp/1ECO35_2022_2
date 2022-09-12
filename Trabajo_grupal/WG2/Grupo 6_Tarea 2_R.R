' Se cargan los paquetes y luego ya los utilizaremos automaticamente'

library(dplyr) # librería de limpieza de datos
library(tidyr) # librería de limpieza de datos
library(readxl) # libreria para subir archivos excel, csv

library("readxl")

junin_data = read_excel("C:/Users/HP/Documents/GitHub/1ECO35_2022_2/data/Region_Junin.xlsx")
#-—----------------------------------------------------------------------------

### PREGUNTA 1 ###
# Hallando información sobre cada variable

# Mediante comando head se obtiene las categorias existentes de toda la data
head(junin_data)

#Mediante comando str podemos obtener los detalles característicos de cada variable existente
str(junin_data)
#-—------------------------------------------------------------------------

### PREGUNTA 2 ###
# Conociendo el tipo de variables y sus principales estadísticos

# Utilizando el comando lapply que va a iterar la información desde una lista, 
# y mostrando como resultado otra lista
lapply(junin_data, class)
str(lapply)

# Utilizando el comando sapply porque va aiterar la informacion de forma que
# nos muestre como resultado un vector. 
sapply(junin_data, class)

# Ahora, calculamos los estadísticos de las variables
summary(junin_data, class)

# Luego de ello, se puede evidenciar que existe para Region, Distrito, 
# Lugar, edad por intervalos para mujeres y varones, residencia, mestizaje, etc
#----------------------------------------------------------------------

### PREGUNTA 3 ###
# Verificando si las columnas tienen missing values
any(is.na(junin_data))

# Cuando se corre el codigo el resultado es TRUE, es decir existe al menos
# un valor perdido

# Por eso, ahora se pide al programa conocer cuántos valores perdidos hay en total
sum(is.na(junin_data))

# Cuando se corre el codigo, el resultado es 66 valores perdidos. 
#-----------------------------------------------------
### PREGUNTA 4 ###

# Primero observamos cuáles son los nombres de la tabla de datos Junin
names (junin_data)
View(junin_data)
# Se observa que en total hay 42 categorías de nombres en la tabla

# A continuacion nos piden renombrar 4 categorias
nuevo_junin = rename(junin_data, Comunidad = Place, homxlee = men_not_read, mujerxlee = women_not_read, totalxlee = total_not_read)
View(nuevo_junin)
# Asi finalmente se han renombrado cada una de las columnas de Place, men_not_read
# women_not_read y total_not_read --> por nombres como Comunidad, homxlee,
# mujerxlee y totalxlee

#-----------------------------------------------------------------------------------
### PREGUNTA 5 ###

# para poder abrir la base de datos a analizar
View(nuevo_junin)  

# filtrar columnas y filas específicas de las variables comunidad y distrito
View(nuevo_junin[c(1:144),c(3,4)])
#-------------------------------------------------------------------------------
### PREGUNTA 6 ###

#Tendremos que dividir las personas que no leen / total, esto para hallar el porcentaje de cada una.
#De esta manera, creamos los 3 requisitos. 
# DONDE:
#men_not_read -> homxlee
#women_not_read -> mujerxlee
#total_not_read -> totalxlee

#Esto corre en MacBook
nuevo_junin <- porcentaje_mujerxlee=nuevo_junin$$mujerxlee/nuevo_junin$$totalxlee

nuevo_junin <- porcentaje_homxlee=nuevo_junin$$homxlee/nuevo_junin$$totalxlee

nuevo_junin <- porcentaje_nativos=nuevo_junin$$natives/(nuevo_junin$$peruvian_men+nuevo_junin$$peruvian_women+nuevo_junin$foreign_men+nuevo_junin$foreign_women) 

#Con lo efectuado, podremos visualizar el porcentaje de cada uno.

View(nuevo_junin) # Con esto, notamos que hay elementos que superan el 100% (1.0). Identificamos un problema en la data, debido a que no deberían ser capaces de superar el total.

#### PREGUNTA 7 ###

dataframe2 <- data_frame[,c('mujeres que no escriben ni leen','varones que no escriben ni leen','Total de la poblacion','District','comunidad')] 
View(dataframe2)

#a.Quedarse con la informaci�n de los distritos de Ciudad del Cerro, Jauja, Acolla, San Ger�nimo, Tarma, Oroya y Concepci�n
junin_final = iris [Ciudad del Cerro, Jauja, Acolla, San Ger�nimo, Tarma, Oroya y Concepci�n]

#b.Luego quedarse con las comunidades que cuentan con nativos y mestizos.
junin_final = iris$Comunidad [nativos, mestizos]

#c.Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.
junin_final = iris[district, Comunidad]

#d.Guardar la base de datos en formato csv en la carpeta data. (Use el siguiente nombre Base_cleaned_WG(n�mero de grupo)
write.csv2(base '../data/Base_cleaned_WG(6).csv')


