library(haven)

#subimos la base de datos
#--------------------------
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documentos/Git_Hub/1ECO35_2022_2/Lab6") ) # set directorio

file_path = "../data/data_administrativa.sav"

data_administrativa <- haven::read_sav(file_path , encoding = "UTF-8" )  # read dataset

head(data_administrativa)

names(data_administrativa) # nombre de las variables en una lista

#Las etiquetas de las variables de la base de datos
#--------------------------------------------------

#La etiqueta de la variable 'DOMINIO' de la base de datos
data_administrativa$DOMINIO %>% attr('label')

#La etiqueta de la variable 'P203' de la base de datos
data_administrativa$P203 %>% attr('label')

#las etiquetas de los valores de las variables en la base de datos
#-----------------------------------------------------------------

#La etiqueta de la variable 'DOMINIO' de la base de datos
data_administrativa$DOMINIO %>% attr('labels')

#La etiqueta de la variable 'P203' de la base de datos
data_administrativa$P203 %>% attr('labels')


#Duplicados a partir del identificador por persona : conglome, vivienda, hogar y codperso  
#--------------------------------------------------------------------------------------------
attach(data_administrativa)

data_administrativa_filtrada <- data_administrativa %>% group_by(CODPERSO ,CONGLOME , VIVIENDA, HOGAR) %>% 
mutate(duplicates = n()) %>% filter(duplicates >1) %>%
select(CODPERSO, CONGLOME, VIVIENDA, HOGAR, duplicates ) 

View(data_administrativa_filtrada)


# me quedo con las primeras apariciones y elimino los duplicados
data_administrativa_ndup <- data_administrativa %>% distinct(CODPERSO ,CONGLOME , VIVIENDA, HOGAR, .keep_all = TRUE)


# Variables que presentan valores faltantes
#--------------------------------------------

any( is.na(data_administrativa)) # TRUE: al menos un missing value

is.na(data_administrativa) #Variables con missing value

data_administrativa_ndup <- data_administrativa_ndup %>%  mutate(Dummy_2 = ifelse(DOMINIO == 4 ,  1 , ifelse(!is.na(DOMINIO),0, NA) ) )

#podemos ver que sí hay variables con missing values


# Base de datos ordenada a partir de las variables que identifican cada miembro y la variable de año (year)
#----------------------------------------------------------------------------------------------------------

data_administrativa_new <- data_administrativa[order(data_administrativa$CODPERSO, data_administrativa$year),]
View(data_administrativa_new)


#Cree una base de datos para cada año
#----------------------------------

#Creamos la base de datos para el año 2019
data_administrativa_2019_Grupo10 <- data_administrativa %>% filter( (year == "2019") ) #con la base data_administrativa
data_administrativa_2019_Grupo10_1 <- data_administrativa_ndup %>% filter( (year == "2019") ) #data_administrativa_ndup

#Guardamos la base de datos 2019
write_sav(data_administrativa,"../data/data_administrativa_2019_Grupo10.sav")
write_sav(data_administrativa,"../data/data_administrativa_2019_Grupo10_1.sav")


#Creamos la base de datos para el año 2020
data_administrativa_2020_Grupo10 <- data_administrativa %>% filter( (year == "2020") ) #con la base data_administrativa
data_administrativa_2020_Grupo10_1 <- data_administrativa_ndup %>% filter( (year == "2020") ) #data_administrativa_ndup

#Guardamos la base de datos 2020
write_sav(data_administrativa,"../data/data_administrativa_2020_Grupo10.sav")
write_sav(data_administrativa,"../data/data_administrativa_2020_Grupo10_1.sav")