#TAREA 7
#Grupo 8

# clear environment
rm(list=ls(all=TRUE))
install.packages("readxl")
install.packages("lubridate")
install.packages("tidyverse")
library(reshape)
library(haven)
library(dplyr)
library("readxl")
library(stringr)


#------- Reshape -----------

"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab8") ) # set directorio


# load dataset

data <- read_excel("../data/crime_data/data_administrativa.xlsx")

# nombres de variables en minúsculas
colnames(data) <- tolower(colnames(data))

# limpiar nombres
data$inst1 <- apply(data['nombre'],
                    1 ,
                    function(x) gsub("[0-9]", '', x))
data$inst2 <- apply(data['inst1'],
                    1 ,
                    function(x) gsub("\\-", '', x))
data$inst3 <- apply(data['inst2'],
                    1 ,
                    function(x) gsub("\\.", '', x))
data$inst4 <- apply(data['inst3'],
                    1 ,
                    function(x) gsub("\\/", '', x))

# limpiar born_date

data$date1 <- apply(data['born_date'],
                             1 ,
                             function(x) str_replace(x,'00:00',''))

data$date2 <- apply(data['date1'],
                    1 ,
                    function(x) str_replace(x,'"#%',''))

data$date3 <- apply(data['date2'],
                    1 ,
                    function(x) str_replace(x,'!',''))

# date como variable en formato fecha
data <- data |> dplyr::mutate(
  date = dmy( date3  )
)

# limpiar born_date

data$age1 <- apply(data['age'],
                    1 ,
                    function(x) str_extract(x,'[0-9]+'))

# limpiar rank
data$rank1 <- apply(data['rank'],
                    1 ,
                    function(x) str_replace(x,'extorsionador','extorsion'))

data$rank2 <- apply(data['rank1'],
                    1 ,
                    function(x) str_replace(x,'novto','novato'))

data$rank3 <- apply(data['rank2'],
                    1 ,
                    function(x) str_replace(x,'noato','novato'))

data$rank4 <- apply(data['rank3'],
                    1 ,
                    function(x) str_replace(x,'principiante','novato'))
# crear dummies

data1<- data %>% dplyr::mutate(dum1 = ifelse( rank == 'lider de la banda criminal',
                                                     1 ,
                                                     0 ) )%>%
  dplyr::mutate(dum2 = ifelse( rank == 'cabecilla local',
                               1 ,
                               0 ) )%>%                                     
dplyr::mutate(dum3 = ifelse( rank == 'cabecilla regional',
                             1 ,
                             0 ) )%>%   
  dplyr::mutate(dum4 = ifelse( rank == 'sicario',
                               1 ,
                               0 ) )%>%
  dplyr::mutate(dum5 = ifelse( rank == 'extorsion',
                               1 ,
                               0 ) )%>%
  dplyr::mutate(dum6 = ifelse( rank == 'miembro',
                               1 ,
                               0 ) )%>%
  dplyr::mutate(dum7 = ifelse( rank == 'novato',
                               1 ,
                               0 ) )

# extraer usuario de correo electronico
                   
data1$user<- apply(data1['correo_abogado'],
                    1 ,
                    function(x) str_match(x, "(\\w+)\\@.*")[2])

# extraer dni

data1$dni1 <- apply(data1['dni'],
                            1 ,
                            function(x) str_match(x,"\\.*(\\d+\\-\\d+)$")[2])
# crear variable crimen
data1$crimen <-apply(data1['observaciones'],
                      1 ,
                      function(x) str_match(x,"\\.*+[P/p]or\\s([\\w*\\s]*)")[2])           
# crear variable n_hijos
data1$n_hijos <-apply(data1['observaciones'],
                     1 ,
                     function(x) str_match(x,"\\d*[Tt]iene\\s([0-9]*)")[2])

# crear variable edad_inicio
data1$edad_inicio1 <-apply(data1['observaciones'],
                      1 ,
                      function(x) str_match(x,"\\.*+([\\w*\\s]*)\\s[A/a]ños")[2])

data1$edad_inicio <- apply(data1['edad_inicio1'],
                           1 ,
                           function(x) str_extract(x,"[0-9]+"))