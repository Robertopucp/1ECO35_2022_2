
# ==================================
# Respuesta al Ejercicio Grupal No.2
# ==================================

#Primero alistaremos una seria de librerías que serán relevantes para el trabajo con la base de datos

library(dplyr) # librería de limpieza de datos (será esencial más adelante ;)
library(tidyr)# librería de limpieza de datos
library(readxl) # lobreria para subir archivos excel, csv
getwd() #es necesario identificar el working director para saber donde estaremos generando resultados y cual es el punto de origen desde el cual buscaremos información

file.choose()
ruta_excel <- "D:\\Users\\Usuario\\Documents\\GitHub\\1ECO35_2022_2\\data\\junin_region.xlsx"
excel_sheets(ruta_excel)

junin <- read_excel(ruta_excel)


# (1) Obtener el nombre de todas las variables


str(junin) #la función str da tanto un listado de las variables como información que las caracteriza
names(junin) #Si solo nos interesa desplegar el nombre de las columnas, posiblemente sea mejor recurrir a la función names


# (2) Mostrar el tipo de variables (type) así como presentar los principales estadísticos.

str(junin) #este comando nos permite conocer la estructura de nuestra data
#A partir de este notamos que nuestra base es de 197 observaciones x 42 variables
#Asímismo, la mayor parte de nuestras variables son de tipo numérico, sin embargo, variables como Region, Distrito y Comunidad son character (lo que en otros programas se cuenta como string)

summary(junin) #el comando precedente genera los estadísticos principales de nuestras variables numéricas (mínimo, quintiles 1 y 3,mediana, media y máximo) y character (moda y largo)

#Si quisieramos conocer la desviación estándar de las observaciones de una variable, por ejemplo, instruction_men, entonces:

sd(junin$instruction_men) 

#Adicionalmente, podemos requerir el cálculo de un subset de variables relevantes

attach(junin)
subset1 <- cbind(natives, whites, mestizos, blacks)
summary(subset1)

#También podemos recurrir a otras librerías para hacer el análisis descriptivo
install.packages("psych")
library(psych)
describe(subset1) #este comando en específico también nos da información sobre la simetría y la curtosis de la distribución de datos


# (3) Verifique si las columnas presentan missing values

any( is.na(junin) ) #esto quiere decir que en la base hay al menos un valor missing
any( is.null(junin) ) #mientras que no hay missings del tipo null


colSums(is.na(junin))# Notamos que son varias las columnas con valores missing

#Podemos identificar el número de columna y, por ende, el nombre de las columnas que contienen missings

names(which(colSums(is.na(junin))>0))


#Una forma alternativa de realizar esto, puede ser a través de la función apply

colnames(junin)[apply(junin, 2, anyNA)] #así requerimos los nombres de las columnas (por ello el segundo argumento es 2) que tienen missings


# (4) Cambie el nombre de las siguientes variables:
#place : comunidad
#men_not_read: homxlee
#women_not_read: mujerxlee
#total_not_read: totalxlee

#Podemos hacernos del paquete dplyr y renombrar las columnas directamente 

install.packages("dplyr")
library(dplyr)

head(junin) #hasta este punto las columnas tenían los nombres originales

junin <- rename(junin, comunidad="Place", homxlee="men_not_read", mujerxlee="women_not_read", totalxlee= "total_not_read")

head(junin) #ahora las columnas señaladas tienen nombres modficiados 


# (5) Muestre los valores únicos de las siguientes variables ( comunidad , District)

#Para hallar los valores únicos de una columna determinada la llamamos tras el signo $, y aplicamos el comando unique()
unique(junin$comunidad)

unique(junin$District)


# (6) Crear columnas con las siguiente información: el % de mujeres del que no escriben ni leen (mujerxlee/totalxlee) % de varones que no escriben ni leen (homxlee/totalxlee) y % de nativos respecto al total de la población. Para el total de la población sumar (peruvian_men + peruvian_women + foreign_men + foreign_women)

#Podemos abordar esto de múltiples formas
#Primero podríamos usar el operador $ (debemos usarlo tanto para indicar que la nueva columna formará parte de la base junin como para llamar a las columnas dentro de junin que serán operadas)

junin$per_women <- junin$mujerxlee/junin$totalxlee

head(junin$per_women)

#(7) Crear una base de datos con la siguiente información:

# a. Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción
#b. Luego quedarse con las comunidades que cuentan con nativos y mestizos.
#c. Solo quedarse con las variables nombre de distrito y comunidad.
#d. Guardar la base de datos en formato csv en la carpeta data. (Use el siguiente nombre Base_cleaned_WG(numero de grupo

#a. Debemos filtrar la base para quedarnos con un subset que cumpla una serie de características (tarea muy común en la ciencia de datos)

junin_f2 <- filter(junin, District=="CIUDAD DEL CERRO"
| District=="JAUJA"
|District=="ACOLLA"
|District=="SAN GERÓNIMO"
|District=="TARMA"
|District=="OROYA"
|District=="CONCEPCIÓN")

#b. ahora buscamos un subset con personas nativas o mestizas
#Por ello filtramos para quedarnos con observaciones cuyos números de nativos y mestizos sea mayor a cero

junin_f2 <- filter(junin, natives>0
                  & mestizos >0)
  
#c. Primero definimos las columnas de interés (sus nombres)

queda <- c("District","comunidad")
junin_f3 = junin_f2[queda]


write.csv(junin_f3,"D:\\Users\\Usuario\\Documents\\GitHub\\1ECO35_2022_2\\data\\Base_cleaned_WG2.csv", row.names = FALSE)