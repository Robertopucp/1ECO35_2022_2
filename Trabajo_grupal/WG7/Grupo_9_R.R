########################### Workgroup7 - ############################

library(readxl)
library(lubridate) 
library(tidyverse)
library(stringr) 
library(dplyr)


"Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab8") ) # set directorio

data <- read_excel("../data/crime_data/data_administrativa.xlsx")



#-------------------------------------------------------------------------------
"Ej.1 "
#Convertir el nombre de las variables a minúscula

colnames(data) <- tolower(colnames(data)) 
colnames(data)

#-------------------------------------------------------------------------------
"Ej.2"
#Fíjese que el nombre de la persona tiene puntuaciones y número,
#retirar todo aquello que no permita identificar el nombre correcto

data$nombre<- apply(data['nombre'],
                     1 ,  
                     function(x) str_replace(x,"[^a-zA-Z\\s]+",''))


data$nombre


#Reemplaza lo que sea diferente de letras (minúsculas y mayúsculas) y espacios (con 1 o más ocurrencias)
#con espacio en blanco

#-------------------------------------------------------------------------------
"Ej.3"
#Limpiar la fecha de nacimiento de aquellos elementos que la ensucien.
#Luego crear otra variable con el formato de fecha.

data['born_date'] <- apply (data['born_date'],
                       1 ,  
                       function(x) str_match(x,"[0-9]*/[0-9]*/[0-9]*"))
data$born_date

#extrae lo que tenga la estructura de numeros con "/" 
#se usa "*" para no especificar la cantidad de cifras, ya sea en el día, mes o año

#Cambio de formato a "Date" de born_date en otra variable:
data$nacim <- as.Date(data$born_date, format =  '%d/%m/%Y')

#Comprobar formato de las variables
sapply(data, class)

#-------------------------------------------------------------------------------
"Ej.4"
#Limpiar la columna de edad, el cual tiene puntuaciones que no permiten identificar la edad correcta.

data$age<- apply(data['age'],
                  1 ,  
                  function(x) str_replace(x,"[^\\d]+",''))
data$age
#reemplaza todo lo que sea diferente de dígitos con 1 o más ocurrencias con espacios en blanco


#-------------------------------------------------------------------------------
"Ej.5"
## 5.0  dummies según el rango del sentenciado en la organización criminal
'dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
 dum2: toma el valor de 1 si el sentenciado fue cabecilla local
 dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
 dum4: toma el valor de 1 si el sentenciado fue sicario
 dum5: toma el valor de 1 si el sentenciado realizó extorsión
 dum6: toma el valor de 1 si el sentenciado fue miembro regular
 dum7: toma el valor de 1 si el sentenciado fue novato o principiante
 '
data <- data %>% mutate(dum1 = ifelse(str_detect(rank,"(lider de la banda criminal)"), 1 , 0 ),
                        dum2 = ifelse(str_detect(rank,"(cabecilla local)"), 1 , 0 ),
                        dum3 = ifelse(str_detect(rank,"(cabecilla regional)"), 1 , 0 ),
                        dum4 = ifelse(str_detect(rank,"(sicario)"), 1 , 0 ),
                        dum5 = ifelse(str_detect(rank,"(ext)"), 1 , 0 ),
                        dum6 = ifelse(str_detect(rank,"^miembro"), 1 , 0 ),
                        dum7 = ifelse(str_detect(rank,"no([\\w*]*)to") | str_detect(rank,"prin"), 1 , 0 ),
                        )

data$dum1
data$dum2
data$dum3
data$dum4
data$dum5
data$dum6
data$dum7


#-------------------------------------------------------------------------------
"Ej.7"

##Extraer el usuario del correo electrónico
data$usuario <- sapply(data$correo_abogado,
                       function(x) str_extract(x,"[\\w+]+(?=@)"))

data["usuario"]

#-------------------------------------------------------------------------------
"Ej.8"
##Crear una columna que contenga solo la información del número de dni (por ejemplo: 01-75222677)"

data$DNI <- apply(data['dni'],
                  1 ,  
                  function(x) gsub("[a-z]+", '', x) )

data$DNI

#-------------------------------------------------------------------------------
"Ej.9"

## A partir de la columna observaciones, crear las siguiente variables:

# crimen: debe contener información del delito cometido"
data$observaciones

data$crimen <- sapply(data$observaciones,
                     
                      function(x) {
                        match1= str_extract(x,"((?<=por)[\\w*\\s]+)")
                        match = str_extract(x, "(robo)")
                        
                        if (! is.na(match) ) {
                          return(match)
                        }
                        
                        
                        if ( is.na(match) & !is.na(match1) ){
                          return(match1)
                        }
                        
                        else {
                          return(NA)
                        }
                         }  )
data["crimen"]

#Nota, se tuvo que usar match1 y match porque existía conflictos para extraer la
#observación 15 (que no tenía coma) y 20 en el que el delito estaba al inicio
#con primer if se busca que la prioridad sea la palabra robo, entonces, 
#si ello ocurre aparecerá en la columna 'crimen'
#luego, la segunda opcion es que aparece otra delito (no robo), aparece en
#match1 y eso retorna en la columna crimen


# n_hijos: cantidad de hijos del criminal"
                                              
data$n_hijos <- sapply(data$observaciones,
                       function(x) str_extract(x,"\\d{1,2}(?= hij)"))
data['n_hijos']
                                              
# edad_inicio : edad de inicio en actividades criminales"
                                              
data$edad_inicio <- sapply(data$observaciones,
                    function(x) str_extract(x,"\\d{1,2}(?= años)"))

data['edad_inicio']


                                              