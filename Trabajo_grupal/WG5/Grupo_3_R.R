
# Instalar paquete  

#"pacman": permite abrir varias librerias de R al mismo tiempo

pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)

# haven: leer archivos spss (sav). Se usará este para el trabajo

# 1. Trabajar base data_administrativa 
  # Definimos usuario
  user <- Sys.getenv("fdcc0")

  # Definimos directorio
  setwd( paste0("C:/Users/fdcc0/Documents/GitHub/1ECO35_2022_2/data") )

  #Definimos archivo
  base = "data_administrativa.sav"

  # Definimos la base a trabajar con el nombre "enc_hogar"
  enc_hogar <- haven::read_sav(base , encoding = "UTF-8")

# 2. Mostrar variables con missing values
  sapply( enc_hogar, function(x) sum(is.na(x)) )

  # Las variables con mmissing values son: P203A, P203B, P204, P205, P206,
  # P207, P208A, P208B, P209

# 3. Mostrar las etiquetas de dos variables:

  enc_hogar$DOMINIO %>% attr('label')
  enc_hogar$ESTRATO %>% attr('label')

  # Mostrar las etiquetas de los valores de dos variables
  enc_hogar$DOMINIO %>% attr('labels')
  enc_hogar$ESTRATO %>% attr('labels')
  enc_hogar$P203 %>% attr('labels')
  enc_hogar$P203B %>% attr('labels')
  enc_hogar$P204 %>% attr('labels')
  enc_hogar$P205 %>% attr('labels')
  enc_hogar$P206 %>% attr('labels')
  enc_hogar$P207 %>% attr('labels')
  enc_hogar$P209 %>% attr('labels')

# 4. Detectar personas evaluadas en ambos año 2019 y 2020

  # Usamos "attach" para generar cada variable como objeto independiente
  attach(enc_hogar)

  # Mutate crear variables 

  # Ver duplicados (incluye las copias)
  enc_hogar %>% group_by( CONGLOME, VIVIENDA, HOGAR, CODPERSO) %>% 
    mutate(duplicates = n()) %>% filter(duplicates >1) %>% 
    select(CONGLOME, VIVIENDA, HOGAR, CODPERSO, duplicates)

  # Borrar duplicados y solo quedarnos con la evaluación de una persona}
  
  enc_hogardup <- enc_hogar %>% distinct(CONGLOME, 
                                         VIVIENDA, HOGAR, 
                                         CODPERSO, .keep_all = TRUE)
  
  # "Dim": para saber el # de filas y columnas
  dim(enc_hogar)
  dim(enc_hogardup)
  
  # base original(enc_hogar) #obs = 85035
  # base sin duplicados (enc_hogardup) #obs = 80900
  # Hay un total de 4135 personas duplicadas (encuestadas en 2019 y 2020)
  
  
  
# 5. Ordenar la base de datos a partir de variables que identifican cada
  #miembro y la variable del año "year". Así poder ver al individuo en ambos años
  
    attach(enc_hogar)
  
  # Usando el codigo anterior añadimos el filtro que diferencia el año y podemos ver cada al miembro en cada año 
  
  enc_hogar2019 <- enc_hogar %>% filter( year == 2019) %>% distinct(CONGLOME, 
                                         VIVIENDA, HOGAR, 
                                         CODPERSO, .keep_all = TRUE)
  
  enc_hogar2020 <- enc_hogar %>% filter( year == 2020) %>% distinct(CONGLOME, 
                                                                    VIVIENDA, HOGAR, 
                                                                    CODPERSO, .keep_all = TRUE)
    
  
# 6. Crear base de datos para cada año 

 # En el problema anterior ya se definieron las bases por año, entonces se cambia al nombre solicitado
  
  
  data2019 <- enc_hogar2019
  data2020 <- enc_hogar2020
  
  # Guardamos base en la ruta de data en formato spss
  
  write_sav(data2019 , "data_2019_Grupo3.sav")
  write_sav(data2020 , "data_2020_Grupo3.sav")

