#####################
###   SPSS file   ###
#####################


#############
####  1  ####

# Trabajar con la data_administrativa que está en la carpeta data.

pacman::p_load(tidyverse, haven, janitor, stringr )   # otra forma de cargar librerías

user <- Sys.getenv("USERNAME")  # username
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab6") ) # set directorio

# Put relative path
file_path = "../data/data_administrativa.sav"
df <- haven::read_sav(file_path , encoding = "UTF-8" )  # read dataset


#############
####  2  ####

# Mostrar las variables que presentan missing values
colSums(is.na(df))     # muestra el número de missing por columna


#############
####  3  ####

# Se le pide mostrar las etiquetas de dos variables (var labels) y las etiquetas 
# de los valores en dos variables (value's labels).

df$DOMINIO %>% attr('label')  # var labels
df$ESTRATO %>% attr('label')  # var labels

df$DOMINIO %>% attr('labels') # value labels      
df$ESTRATO %>% attr('labels') # value labels


#############
####  4  ####

# Se le pide detectar personas que fueran entrevistadas en ambos años. Para ello, se pide 
# detectar duplicados a partir del identificador por persona : conglome, vivienda, hogar y codperso.
attach(df) # para que cada columna sea un objeto independiente y prenscindamos del data$col

duplicated_data <- df %>% group_by(CONGLOME, VIVIENDA, HOGAR, CODPERSO) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) %>%
  select(CONGLOME, VIVIENDA, HOGAR, CODPERSO, duplicates ) 

View(duplicated_data)

# Borrando duplicados. Borra las copias, no las primeras apariciones.
df_noduplicates <- df %>% distinct(CONGLOME, VIVIENDA, HOGAR, CODPERSO, .keep_all = TRUE)


#############
####  5  ####

# Ordene la base de datos a partir de las variables que identifican cada miembro y la variable de año (year). 
# Así podrá observar a cada individuo en ambos años.

df_noduplicates <- df_noduplicates %>% arrange(year, CONGLOME, VIVIENDA, HOGAR, CODPERSO)  # libreria dplyr para ordenar


#############
####  6  ####
# Finalmente crear una base de datos para cada año y guardar en la carpeta data con los siguientes nombres 
# data_2019_(numero de grupo) y data_2020_(numero de grupo).

# creando base para cada año
df_2019 <- df_noduplicates %>% filter(year == "2019")
View(df_2019)

df_2020 <- df_noduplicates %>% filter(year == "2020")
View(df_2020)

# guardando las bases de datos
write.csv(df_2019,"../data/data_2019_Grupo7.csv", row.names = FALSE)
write.csv(df_2020,"../data/data_2020_Grupo7.csv", row.names = FALSE)


