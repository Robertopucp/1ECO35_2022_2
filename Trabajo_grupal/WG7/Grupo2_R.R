################  WG7 ############################
## Curso: Laboratorio de R y Python ###########################


library(reshape)
library(haven)
library(readxl)
library(stringr)
library(tidyverse)
#------- Reshape -----------

"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab8") ) # set directorio


# load panel dataset

crime <- read_xlsx("../data/crime_data/data_administrativa.xlsx")


# 1. Convertimos el nombre de las variables a minúscula

colnames(crime) <- tolower(colnames(crime)) 


# Verificamos 
View(crime)

#2. Dado que el nombre de la persona tiene puntuaciones y números, nos encargamos
#de retirar todo aquello que no permita identificar el nombre correcto.


##Para realizarlo, substraemos las variables de LETRAS
crime$nombres_mod <- apply(crime['nombre'],
                    1 ,
                    function(x) str_replace(x,"[^a-zA-Z\\s]+",''))

##Ya tenemos nuestra variable nombres limpia en la nueva variable "nombres_mod"


#3.Limpiamos la fecha de nacimiento de aquellos elementos que la ensucien.


crime$born_date <- apply(crime['born_date'],
                        1 ,    # margin 1: aplicar la funcion por filas , por observaciones
                        function(x) str_replace(x,"(00:00)|(!)|(#%)", ''))

#3.1  Luego creamos otra variable con el formato de fecha. 


crime$born_date_format <-  as.Date(crime$born_date,format='%d/%m/%Y')


#4 Limpiamos la columna de edad, el cual tiene puntuaciones que no permiten identificar la edad correcta.


# extraemos entonces solo 2 digitos del rango 0-9

crime$edad <- apply(crime['age'],
                   1 ,
                   function(x) str_extract(x,"[0-9]{2}"))


###Nuestras variables limpias son las siguientes:

##nombres_mod
##born_date_format
##edad


#5 Crear dummies según el rango del sentenciado en la organización criminal
#dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
#dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor de 1 si el sentenciado fue sicario
#dum5: toma el valor de 1 si el sentenciado realizó extorsión
#dum6: toma el valor de 1 si el sentenciado fue miembro regular
#dum7: toma el valor de 1 si el sentenciado fue novato o principiante

#Creamos todas las dummies con con un condicional ifelse y detect para todo el valor de la variable o con la letra que empiece
#Para dum1 que detecte si la variable es "lider de la banda criminal" y si es asi toma 1 sino 0
#Para dum2 que detecte si la variable es "cabecilla local" y si es asi toma 1 sino 0
#Para dum3 que detecte si la variable es "cabecilla regional" y si es asi toma 1 sino 0
#Para dum4 que detecte si la variable empieza con las letras "sic" y si es asi toma 1 sino 0
#Para dum5 que detecte si la variable empieza con la letra "e", ya que hay observaciones con extorsion o extorsionador, y si es asi toma 1 sino 0
#Para dum6 que detecte si la variable empieza con las letra "m" y si es asi toma 1 sino 0
#Para dum7 que detecte si la variable empieza con las letras "n" o "p", ya que hay observaciones donde no esta bien escrito novato, y si es asi toma 1 sino 0

crime <- crime %>% mutate(
                        dum1 = ifelse(str_detect(rank,"lider de la banda criminal"), 1 , 0 ),
                        dum2 = ifelse(str_detect(rank,"cabecilla local"), 1 , 0 ), dum3 = ifelse(str_detect(rank,"cabecilla regional"), 1 , 0 ),
                        dum4 = ifelse(str_detect(rank,"^sic"), 1 , 0 ), dum5 = ifelse(str_detect(rank,"^e"), 1 , 0),
                        dum6 = ifelse(str_detect(rank, "^m"), 1 , 0), dum7 = ifelse(str_detect(rank,"(^n)|(^p)"), 1 , 0)
)

View(crime[ , c("rank","dum1","dum2","dum3","dum4","dum5","dum6","dum7")]) 



#6 Extraer el usuario del correo electrónico.

crime$usuario2 <- apply(crime['correo_abogado'],
                      1 ,  
                      function(x) str_extract(x,"[a-z]+"))

#7 Crear una columna que contenga solo la información del número de dni (por ejemplo: 01-75222677), en este caso se extraen los rangos de numeros como se indica en la estructura.

crime$num_dni <- apply(crime['dni'],
                      1 ,  
                      function(x) str_extract(x,"[0-9]+[-]+[0-9]+"))

#8 A partir de la columna observaciones, crear las siguiente variables:

#crimen: debe contener información del delito cometido, y para ello se indica la seccion de texto que debe extraer 

crime$crimen <- apply(crime['observaciones'],
                     1 ,  
                     function(x) str_match(x,"\\.*[P/p]or\\s([\\w*]*)")[2])

# n_hijos: cantidad de hijos del criminal 

crime$n_hijos <- apply(crime['observaciones'],
                      1 ,  
                      function(x) str_match(x,"\\.*[T/t]iene\\s([\\w*]*)")[2])

# edad_inicio : edad de inicio en actividades criminales

crime$edad_inicio <- apply(crime['observaciones'],
                          1 ,  
                          function(x) str_match(x,"\\.*[L/l]os\\s\\s([\\w*]*)")[2])


