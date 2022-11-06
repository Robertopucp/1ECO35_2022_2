###########################################  GRUPO 1 ############################################

#####################################  Miembros del grupo  ######################################

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Egusquiza 
# 20163377, Jean Nino de Guzman

#Instalamos los paquetes que vamos a utilizar
install.packages("lubridate")
install.packages("tidyverse")

#Llamamos las librerías que vamos a utilizar 
library(readxl)
library(lubridate) 
library(tidyverse) 
search()

#Directorio
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal") ) # set directorio

data <- read_excel("../data/crime_data/data_administrativa.xlsx")
df <- data.frame(data)

# 1. Convertir el nombre de las variables a minuscula
colnames(df) <- tolower(colnames(df))

# 2. Fijese que el nombre de la persona tiene puntuaciones y nÃºmero, retirar todo aquello que no permita identificar el nombre correcto.

# Primero, voy a hacer una limpieza de los numeros que haya. Y pondr? las observaciones limpias en la variable "name".
# [0-9]* : identifica numeros entre 0 y 9, y encontrar? por lo menos desde 0 (ninguno o m?s).

df$name <- apply(df['nombre'],
                    1 ,    # margin 1: aplicar la funcion por filas , por observaciones
                    function(x) gsub("[0-9]*", '', x))

# Ahora, para eliminar los signos de puntuaci?n hay dos maneras:

# MANERA 1: creando variables adicionales sobre las que se vayan eliminando los signos de puntuacion.
df$name2 <- apply (df['name'], 1 ,  
                  function(x) gsub ("\\-", '', x) )

df$name3 <- apply (df['name2'], 1 ,   
                   function(x) gsub ("\\,", '', x) )

df$name4 <- apply (df['name3'], 1 ,    
                   function(x) gsub ("\\;", '', x) )

df$name5 <- apply (df['name4'], 1 ,   
                   function(x) gsub ("\\.", '', x) )

df$name6 <- apply (df['name5'], 1 ,   
                   function(x) gsub ("\\!", '', x) )

df$name7 <- apply (df['name6'], 1 ,    
                   function(x) gsub ("\\Â¡", '', x) )

df$name8 <- apply (df['name7'], 1 ,   
                   function(x) gsub ("\\Â¿", '', x) )

df$name9 <- apply (df['name8'], 1 ,   
                   function(x) gsub ("\\?", '', x) )

df$name10 <- apply (df['name9'], 1 ,   
                   function(x) gsub ("\\\\", '', x) )

df$name11 <- apply (df['name10'], 1 ,   
                    function(x) gsub ("\\/", '', x))

# Reemplazo la variable final 'name11' que estÃ¡ limpia de nÃºmeros y signos de puntuaciÃ³n sobre la variable 'nombre'.
df['nombre'] <- df['name11']

# Me quedo solo con las variables del principio.
df <- df[,1:7]

# MANERA 2:
# Hago que identifique y limpie los signos de puntuacion con: [[:punct:]]+
# [:punct:] : para identificar signos de puntuacion.
# + : lo hara por lo menos una vez
# 
df$name12 <- apply (df['nombre'], 1 ,   
                    function(x) gsub ("[[:punct:]]+", '', x))

# Al igual que antes, reemplazo esta variable 'name12' sobre la variable 'nombre'.
df['nombre'] <- df['name12']

# Me quedo solo con las variables del principio.
df <- df[,1:7]

# Nombre esta limpio.
df['nombre'] 

# Claramente, la manera 2 es mas rapida y ademas puede que con la manera 1 haya olvidado algunos signos de puntuacion.
# Entonces, esta manera 2 la aplicare en adelante, cuando sea necesario.

# 3. Limpiar la fecha de nacimiento de aquellos elementos que la ensucien. Luego crear otra variable con el formato de fecha.

# Algunas observaciones terminan en "00:00"
# Entonces, voy a limpiar esto de las observaciones. Para ello, uso "00:00$".
df$nacimiento <- apply (df['born_date'], 1 ,   
                        function(x) gsub ("00:00$", '', x))

# Ahora, para hacerlo mÃ¡s sencillo (pues hay estructuras complejas de signos de puntuaciÃ³n y las fechas tienen "/"), 
# voy a extraer directamente la fecha. Para ello, formarÃ© su estructura y, finalmente, usarÃ© str_extract.

df$fecha <- apply (df['nacimiento'], 1 ,   
                    function(x) str_extract(x, "[0-9]{2}/[0-9]{2}/[0-9]{4}"))

# [0-9]{n} : significa que tomara¡ numeros entre 0 y 9, y que, ademÃ¡s,se debe repetir como maximo n veces.
# El dia tiene 2 dos digitos como maximo. Por ello, va n = 2.
# Lo mismo serÃ¡ con el mes, cuyo valor de n es 2 tambiÃ©n. Y, para el aÃ±o, va n = 4.
# Luego, pongo como separador a "/".
# De manera que formo la estructura de la fecha como yo quiero que la extraiga.

# Ahora, me quedara solo con las variables relevantes.
df <- df[, c(1, 2, 9, 3, 4, 5, 6, 7)]

# Se tiene la variable "born_date" y "fecha" uno al lado de la otra.
# "Fecha" esta limpio.

df["fecha"]


#4. Limpiamos la edad

# extraer solo 3 digitos del rango 0-9 

df$edad <- apply(df['age'],
                   1 ,  
                   function(x) str_extract(x,"[0-9]{2}"))

#5. Creamos dummies para diferenciar los rangos de los sentenciados

df <- df %>% mutate(dum1 = ifelse(str_detect(rank,"(^l)"), 1 , 0 ),            #dum1: toma el valor de 1 si el sentenciado fue l?der de la banda criminal
                    dum2 = ifelse(str_detect(rank,"cabecilla\\s(l)"), 1 , 0),  #dum2: toma el valor de 1 si el sentenciado fue cabecilla local
                    dum3 = ifelse(str_detect(rank,"cabecilla\\s(r)"), 1 , 0),  #dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
                    dum4 = ifelse(str_detect(rank,"(^s)"), 1 , 0),             #dum4: toma el valor de 1 si el sentenciado fue sicario
                    dum5 = ifelse(str_detect(rank,"(^e)"), 1 , 0),             #dum5: toma el valor de 1 si el sentenciado realiz? extorsi?n
                    dum6 = ifelse(str_detect(rank,"(^m)"), 1 , 0),             #dum6: toma el valor de 1 si el sentenciado fue miembro regular
                    dum7 = ifelse(str_detect(rank,"(^n)|(^p)"), 1 , 0)         #dum7: toma el valor de 1 si el sentenciado fue novato o principiante
                    )

#7. Extraemos el usuario del correo electr?nico

df$correo <- apply(df['correo_abogado'],
                 1 ,  
                 function(x) str_extract(x,"(\\w+)"))

#8. Extraemos solo el numero del dni

df$dni_2 <- apply (df['dni'], 1 ,   
                   function(x) gsub ("dni es ", '', x) )

#9. Creamos las variables solicitadas

# Primero extraemos los hijos
hijos<- apply (df['observaciones'], 1 , function(x) str_extract(x, "...hij.s"))
hijos<-data.frame(hijos)

df$n_hijos <- apply(hijos,
                   1 ,
                   function(x) str_extract(x,"[0-9]"))

# Luego, la edad de inicio en actividades criminales

años<- apply (df['observaciones'], 1 , function(x) str_extract(x, "...años"))
años<-data.frame(años)

df$edad_inicio <- apply(años,
                         1 ,
                         function(x) str_extract(x,"[0-9]"))

# Información del delito cometido

crimen<- apply (df['observaciones'], 1 , function(x) str_extract(x, "sentenciado por [[:print:]]*[$|,]"))
crimen<-as.data.frame(crimen)
df$crimen <-crimen
