#Cargar librerías
pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)

#Colocamos el usuario 
user <- Sys.getenv("USERNAME")  # username

#Seteamos el directorio
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab6") )

# Put relative path
file_path = "../data/data_administrativa.sav"

#-------------------------------------------------------------------------------
#1.read dataset
datasav <- haven::read_sav(file_path , encoding = "UTF-8" )

#-------------------------------------------------------------------------------
#2.Mostrar las variables que presentan missing values
is.na(datasav)
apply(datasav, MARGIN = 2, function(x) any(is.na(x)))
#P203A, P203B, P204, P205, P206, P207, P208A, P208B, P209 Son las variables con missings

#comprobación que las sgtes variables no tienen missings: "year"     "MES"      "CONGLOME" "VIVIENDA" "HOGAR"    "CODPERSO" "UBIGEO" 
#DOMINIO" "ESTRATO"  "P201P"    "P203"  
sum(is.na(datasav$year))
sum(is.na(datasav$MES))
sum(is.na(datasav$CONGLOME))
sum(is.na(datasav$VIVIENDA))
sum(is.na(datasav$HOGAR))
sum(is.na(datasav$CODPERSO))
sum(is.na(datasav$UBIGEO))
sum(is.na(datasav$DOMINIO))
sum(is.na(datasav$ESTRATO))
sum(is.na(datasav$P201P))
sum(is.na(datasav$P203))

#todas salen con suma 0 de missings; por lo tanto, no habrían

#Nombre de las variables
names(datasav)

#-------------------------------------------------------------------------------
#3.Se le pide mostrar las etiquetas de dos variables (var labels) 
datasav$ESTRATO%>% attr('label')
datasav$P203%>% attr('label')

#3.las etiquetas de los valores de las dos variables (value's labels)
datasav$ESTRATO %>% attr('labels')
datasav$P203%>% attr('labels')

#-------------------------------------------------------------------------------
#4.Se le pide detectar personas que fueran entrevistadas en ambos años (duplicados). 
#Para ello, se pide detectar duplicados a partir del identificador por persona : conglome, vivienda, hogar y codperso.

data_filtrada <- datasav%>% group_by(CONGLOME, VIVIENDA, HOGAR, CODPERSO) %>% mutate(duplicates = n()) %>% filter(duplicates >1)
#en data_filtrada se ven todos los repetidos de ese grupo en columna 'duplicates'
#se incluye las demas variables también

data_filtrada2 <- datasav%>% group_by(CONGLOME, VIVIENDA, HOGAR, CODPERSO) %>% mutate(duplicates = n()) %>% filter(duplicates >1) %>% select(CONGLOME, VIVIENDA, HOGAR, CODPERSO,duplicates)
#en data_filtrada2 se observan solo las observaciones duplicadas con las variables de CONGLOME, VIVIENDA, HOGAR, CODPERSO,duplicates

#-------------------------------------------------------------------------------
#5.Ordene la base de datos a partir de las variables que identifican cada miembro
#y la variable de año (year). Así podrá observar a cada individuo en ambos años.

#regresar a data original pero con indicador de duplicados (1 y 2)
data_filtrada <- datasav%>% group_by(CONGLOME, VIVIENDA, HOGAR, CODPERSO) %>% mutate(duplicates = n())
colnames(data_filtrada)

#MOVER COLUMNAS para que estén al comienzo year, CONGLOME, VIVIENDA, HOGAR, CODPERSO y duplicates
data_ordenada <- data_filtrada[, c(1,3,4,5,6,21,2,7,8,9,10,11,12,13,14,15,16,17,18,19,20)]

#Ordenar values de CONGLOME, VIVIENDA, HOGAR, CODPERSO
#Donde duplicates=2, salen las 2 filas del individuo en los 2 años
data_ordenada <- data_ordenada[order(data_ordenada$CONGLOME,data_ordenada$VIVIENDA,data_ordenada$HOGAR,data_ordenada$CODPERSO),]

#-------------------------------------------------------------------------------
#6.Finalmente crear una base de datos para cada año 
#y guardar en la carpeta data con los siguientes nombres data_2019_(numero de grupo) y data_2020_(numero de grupo).
View(data_ordenada)


data_ordenada %>%  filter(year==2019)-> datasav_2019_9
data_ordenada %>%  filter(year==2020)-> datasav_2020_9

write.csv(datasav_2019, "../data/datasav_2019_9")
write.csv(datasav_2020, "../data/datasav_2020_9")
write_sav(datasav_2019, "../data/datasav_2019_9.sav")  # save in spss format 
write_sav(datasav_2020, "../data/datasav_2020_9.sav")

