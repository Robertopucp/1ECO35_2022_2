# install.packages("dplyr") # filter data
# install.packages("readxl") # excel, csv

'Solo es necesario cargar una vez los paquetes, luego simplemente debemos llamarlo:'

library(dplyr) # librería de limpieza de datos
library(tidyr)# librería de limpieza de datos
library(readxl) # lobreria para subir archivos excel, csv

user <- Sys.getenv("USERNAME")  # username
print(user)
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab3") ) # set directorio

netflix <- read.csv("../data/netflix_titles.csv", encoding = "UTF-8") # encoding : Leer caracteres especiales

netflix <- read.csv("../data/netflix_titles.csv", encoding = "UTF-8", na.strings=c("",NA)) 

# na.strings=c("",NA) reemplaza vacios por missing 

# Filas y columnas
dim(netflix) 

# Clase de estructura de objeto

class(netflix)

# Mostrar la variable release_year

print(release_year)

print(netflix$release_year) # será necesario llamar la variable desde la base de datos

# Permite convertir cada columna como objeto

attach(netflix) 

print(release_year)

# -------------------------------------------------------

# Información de cada variable

str(netflix)
lapply(netflix, class)
sapply(netflix, class)

summary(netflix) # estadisticas desciptivas de las variables

## Verificando ID

unique(show_id)

length(unique(show_id))

sum(duplicated(show_id) ) # cantidad de duplicados

### ***Exploring a DataFrame***:

class( netflix["director"] ) # Dataframe
class( netflix[director,] )

class( netflix$director ) # lista o vector

#-----------------------------------------------------------------------

## revisando missing values

" En R, tenemos dos formas de missing, en general, NA y Null "
unique(director) 
unique(director)[1]

any(is.na(netflix["director"]))

any(is.null(netflix["director"]))

any(is.na(netflix$director))

any(is.na(director))  # al menos una observación es Missing

## cantidad de missing 

sum(is.na(director))

## Manipulando missing values

netflix2 <- netflix %>% drop_na()  # borras todas las filas con missig values

netflix2 <- netflix %>% drop_na(director)

# borras observaciones con missing values de la columna director

netflix2 <- netflix %>% replace_na(list(director = "Sin director"))

"En R debe asignarse el objeto alterado a uno nuevo. En este caso a Netflix2"
#----------------------------------------------------------------------------

### ***Subsetting columns***

netflix2 <- netflix[,c('director','release_year','show_id')] # seleccionar columnas
View(netflix2)

View( netflix[1:100,c('director','release_year')] ) # filtrar columnas y filas 

View( netflix[c(1,10,100),c('director','release_year')] )

View( netflix[c(1,10,100),c(1,5)] ) # usando posiciones


View( netflix[1:100, c(1:5,10)] ) # usando posiciones

names(netflix)

names(netflix)[2]

#----------------------------------------------------------------------------

# Crear una nueva variable

netflix['number'] = runif(n = dim(netflix)[1], min = 1, max = 10)
netflix$number2 = runif(n = dim(netflix)[1], min = 1, max = 10)

### ***Sorting and Subsetting***

netflix['new'] = netflix['release_year'] + netflix['number'] 

netflix['new2'] = netflix$release_year + netflix$number

# ordering de manera ascendente por default

netflix <- netflix[order(release_year),]

netflix <- netflix[order(-release_year),] # descendente

#attach(netflix) 

netflix <- netflix[order(release_year, netflix$number2),]

netflix <- netflix[order(release_year, - netflix$number2),]
  
#----------------------------------------------------------------------------

### ***Subsetting rows***

netflix2 <- netflix[which(release_year < 2011 & netflix$number > 5), ]
View(netflix2)

netflix %>% filter( release_year < 2011 & netflix$number > 5  )  # using Tdyr library


### ***Subsetting based on text data***

netflix2 <- netflix[which(country == "Peru"), ]
View(netflix2)

netflix2 <- netflix[which(country == "Mexico"), ]
View(netflix2)


netflix2 <- netflix%>% filter( (country == "Brazil") | ( netflix$country == "Peru") ) 
View(netflix2)

# American movies

netflix2 <- netflix %>% filter( (type == "Movie") & ( country == "United States") 
                                & (release_year > 2019) ) 

# %in%

"
If you want to filter by multiple values of a categorical variable,
the easiest way is to use the %in% method "


data_frame <- netflix[country %in% c("Peru","Chile"),]

data_frame <- netflix[! country %in% c("Peru","Chile"),]  # ! negación en R

data_frame <- netflix %>% rename(Titulo = title,
                                 Duration_movie = duration) 


data_frame <- netflix[, ! names(netflix) %in% c('show_id', 'director')] # Drop variables

# Export dataset

write.csv(base, '../data/new_base.csv')

write.csv(base, '../data/new_base.xlsx')

