###     TAREA 7  - GRUPO 6  ###
############################################
############################################
############################################

library(readxl)
library(stringr) # libreria para trabajar expresiones regulares
library(dplyr)
library(lubridate) # dmy
library(tidyverse) # dplyr, ggplot2, tdyr, stringi, stringr

#Primero, setearemos el directorio

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/data/crime_data") ) # set directorio


#utilizaremos la base de datos data_administrativa.xlsx que esta dentro de la carpeta crime_data
#seleccionamos la base de datos para que sea leida por el programa R studio

data_administrativa <- read_excel("C:/Users/User/Documents/GitHub/1ECO35_2022_2/data/crime_data/data_administrativa.xlsx")

#convertimos la misma basa de datos de excel en data frame
data2 <- data.frame(read_excel("C:/Users/User/Documents/GitHub/1ECO35_2022_2/data/crime_data/data_administrativa.xlsx"))

sapply(data_administrativa, typeof)

apply(data_administrativa , 2, function(x) sum(is.na(x)))

#------------------------------------------------------------------------
####### PREGUNTA 1  #######
###########################

#Convertir el nombre de las variables a minuscula

#utilizamos el comando tolower para convertir las variables de la base de datos "data" en min?sculas

colnames(data_administrativa) <- tolower(colnames(data_administrativa))

colnames(data2) <- tolower(colnames(data2))

#------------------------------------------------------------------------
####### PREGUNTA 2  #######
###########################

#Fijese que el nombre de la persona tiene puntuaciones y n?mero, retirar todo aquello que no permita identificar el nombre correcto.
#Entonces limpiamos la columna nombre mediante string replace 

data_administrativa$nombre<- apply(data_administrativa['nombre'],
                      1 ,    
                      function(x) str_replace(x,"[^a-zA-Z\\s]+",''))

#------------------------------------------------------------------------
####### PREGUNTA 3  #######
###########################

#DEBEMOS Limpiar la fecha de nacimiento de aquellos elementos que la ensucien. Luego crear otra variable con el formato de fecha.

###Primero, se limpiaran los datos de la variable born_date reemplazando los caracteres de m?s por espacios vacios o nada
#para ello, se empleara el comando str_replace
data_administrativa$born_date<- apply(data_administrativa['born_date'],
                                      1 ,  
                             function(x) str_replace(x,"(00:00)|(#%)|(!)", ''))


###Luego, se creara una nueva variable con el nombre "fecha" en que se extraera unicamente las fechas
#por lo que el formato debe tener dias, meses y año. 

data_administrativa$fecha <-as.Date(data_administrativa$born_date,format='%d/%m/%Y')

#------------------------------------------------------------------------
####### PREGUNTA 4  #######
###########################

#Limpiar la columna de edad, el cual tiene puntuaciones que no permiten identificar la edad correcta.
###Usamos el comando gsub porque eso nos ayudará a reemplazar datos que no se encuentren dentro del intervalo

data_administrativa$age <- apply(data_administrativa['age'],
                                 1 ,  
                                 function(x) gsub("[^0-9]", '', x))

###Empleamos el comando str_extract para extraer unicamente los n?meros de la columna age. Ademas, usamos "+" al final del rango de
#numeros para que selecciones todos los digitos.

data_administrativa$edad <- apply(data_administrativa['age'],
                   1 ,
                   function(x) str_extract(x,"[0-9]+", '', x))

#------------------------------------------------------------------------
####### PREGUNTA 5  #######
###########################

#Crear dummies segun el rango del sentenciado en la organizacion criminal

#dum1: toma el valor 1 si el sentenciado fue lider de la banda criminal
#dum2: toma el valor 1 si el sentenciado fue cabecilla local
#dum3: toma el valor 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor 1 si el sentenciado fue sicario
#dum5: toma el valor 1 si el sentenciado realizo extorsion
#dum6: toma el valor 1 si el sentenciado fue miembro regular
#dum7: toma el valor 1 si el sentenciado fue novato o principiante

#PRIMERO, Limpiaremos la variable de novato y la de extorsion, con el comando string replace 

data_administrativa$rank<- apply(data_administrativa['rank'],
                                 1 ,  
                                 function(x) str_replace(x,"(principiante)|(novto)|(noato)",'novato'))

data_administrativa$rank<- apply(data_administrativa['rank'],
                                 1 ,  
                                 function(x) str_replace(x,"(extorcionador)",'extorsion'))

#AHORA, corresponde crear las variables dummies

data_administrativa$dum1 <- ifelse(data_administrativa$rank == 'lider de la banda criminal', 1, 0)
data_administrativa$dum2 <- ifelse(data_administrativa$rank == 'cabecilla local', 1, 0)
data_administrativa$dum3 <- ifelse(data_administrativa$rank == 'cabecilla regional', 1, 0)
data_administrativa$dum4 <- ifelse(data_administrativa$rank == 'sicario', 1, 0)
data_administrativa$dum5 <- ifelse(data_administrativa$rank == 'extorsion', 1, 0)
data_administrativa$dum6 <- ifelse(data_administrativa$rank == 'miembro', 1, 0)
data_administrativa$dum7 <- ifelse(data_administrativa$rank == 'novato', 1, 0)

#------------------------------------------------------------------------
####### PREGUNTA 7  #######
###########################

#AQUI NOS corresponde Extraer el usuario del correo electronico
#ENTONCES, necesitamos extraer el usuario del listado de correos, no olvidando los espacios necesarios para arroba

data_admi$correo_abogado <- apply(data_administrativa['correo_abogado'],
                                  1 ,  
                                  function(x) str_extract(x,"[\\w+)\\@\\.*]"))

#------------------------------------------------------------------------
####### PREGUNTA 8  #######
###########################

#AHORA, Nos piden crear una columna que contenga solo la informaci?n del n?mero de dni (por ejemplo: 01-75222677)

#ENTONCES, necesitamos crear una columna que contenga la información del DNI

data_administrativa$dni <- apply(data_administrativa['dni'],
                                 1 ,  
                                 function(x) str_replace(x,"(dni es)", ''))

#------------------------------------------------------------------------
####### PREGUNTA 9  #######
###########################

#PARA ESTA PARTE, respecto a la columna observaciones, necesitamos crear las siguiente variables:

  #crimen: debe contener informacion del delito cometido
  #n_hijos: cantidad de hijos del criminal
  #edad_inicio : edad de inicio en actividades criminales

###PRIMERO, se creara la variable crimen
###CONFORME a lo mencionado en clase, aqui usamos la función look around, por lo que utilizamos
#los comandos string extract

data_administrativa$crimen <- data_administrativa$observaciones |> str_extract("(?<= por )[^\\d\\:]+")

data_administrativa$crimen <- apply(data_administrativa['crimen'],
                                    1 ,  
                                    function(x) str_replace(x,"(dice tener)|(inio de actividades ilegales)|(tiene) |(,)", ''))

###SEGUNDO, se creara la variable de cantidad de hijos del criminal
#utilizamos el string extract mediante el conteo continuo d+

data_administrativa$n_hijos <- data_administrativa$observaciones |> str_extract("(?<=tiene )[\\d+\\:]+")


###TERCERO, se creara la variable sobre edad de inicio en actividad criminal
#utilizamos el string extract mediante el conteo continuo d+ y resultante para cantidad de años

data_administrativa$edad_inicio <- data_administrativa$observaciones |> str_extract("[\\d+\\:]+(?= años)")





