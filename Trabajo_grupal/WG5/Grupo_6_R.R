################  TAREA 6 ############################
## Curso: Laboratorio de R y Python ###########################
## GRUPO 6



####Usted debe trabajar una base data_administrativa que está en la carpeta data. 
####Esta base de datos contiene es una encuesta realizado a miembros del hogar durante años años 2019 y 2020.
  
  # username
  user <- Sys.getenv("USERNAME")
  
  # set directorio
  setwd( paste0("C:\Users\User\Documents\GitHub\1ECO35_2022_2\data") ) 

  # Put relative path
  file_path = "../data/data_administrativa.sav"  

  # read dataset
  data_administrativa_1 <- haven::read_sav(file_path , encoding = "UTF-8" )  

####Mostrar las variables que presentan missing values

  #primero se mostraran todas las varaibles de la base de datos 
  names(data_administrativa_1
      
  #para ver el numero de missings values que tienen las variables      
  apply(data_administrativa_1, MARGIN = 2, function(x) sum(is.na(x)))   
  
  #Las varaibles con missings values son P203A, P203B, P204, P205, P206, P207, P208A, P208B y P209


####Se le pide mostrar las etiquetas de dos variables (var labels) y 
####las etiquetas de los valores en dos variables (value's labels).
  
  #Seleccionamos 2 varaibles para analizar y buscamos lo que significa cada una
  #para ello escogemos las variables P203 y P204
  data_administrativa_1$P203 %>% attr('label')
  data_administrativa_1$P204 %>% attr('label')
  
  #Luego, buscamos el significado de su valoracion de cada variable, es decir de P203 y P204
  data_administrativa_1$P203 %>% attr('labels')
  data_administrativa_1$P204 %>% attr('labels')
  #De lo anterior se puede determinar que P203 tiene hasta 11 posibles respuestas que se puede obtener
  #por el lado de P204 se puede observar que es una variable binaria, es decir con respuesta afirmativa y negativa
  
  
####Se le pide detectar personas que fueran entrevistadas en ambos años.
####Para ello, se pide detectar duplicados a partir del identificador por persona:
#### conglome, vivienda, hogar y codperso.
  
  #Primero, para que cada variable sea independiente establecemos el siguiente comanddo
  attach(data_administrativa_1)
  
  #Para detectar los duplicados de las variables CONGLOME, VIVIENDA, HOGAR, CODPERSO establecemos lo siguiente
  data_administrativa_1 %>% group_by(CONGLOME, VIVIENDA, HOGAR, CODPERSO) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) %>%
  select(CONGLOME ,VIVIENDA ,HOGAR ,CODPERSO, duplicates )
  
  
####Ordene la base de datos a partir de las variables que identifican cada miembro y la variable de año (year). 
####Así podrá observar a cada individuo en ambos años.
  
  library(dplyr)
  
  #para ver las variables en la base de datos de manera ordenada ascendentemente en años
  data_administrativa_1 <- arrange(data_administrativa_1, year)
  
  #reducimos a las variables que se estan usando y le asignamos su respectivo año
  #corremos lo siguiente para obtener las varaibles especificas
  select(data_administrativa_1, year, CONGLOME, VIVIENDA, HOGAR, CODPERSO)
  
####Finalmente crear una base de datos para cada año y guardar en la carpeta data con los siguientes nombres
#### data_2019_(numero de grupo) y data_2020_(numero de grupo).
  
  #Como ya la base de datos data_administrativa_1 esta ordenada ascendentemente en años
  #se procedera a crear otra base de datos con filas hasta del 42601, donde resulta el ultimo dato
  #del año 2019, y es a partir de la fila 42602 hasta el final en que se empieza a encontrar datos del 2020
  #por ello se crean 2 bases de datos nuevas para separar el 2019 y el 2020
  data_2019_6 <- data_administrativa_1[1:42601 , 1:6]
  data_2020_6 <- data_administrativa_1[42602:85035 , 1:6]
  