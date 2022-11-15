################  Solución R ############################

### Regex ####

# clear environment

rm(list=ls(all=TRUE))

# load libraries

librarian::shelf(tidyverse,haven, readxl, lubridate, stringi)

# stringi para retirar tildes 

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG7/Solucion") ) # set directorio


data_crime <- read_excel("../../../data/crime_data/data_administrativa.xlsx")


# 1.0 nombre de las columnas en minuscula 


colnames(data_crime) <- tolower(colnames(data_crime))



# Retiramos las tildes (incluso el simbolo de la ñ) de las columnas nombre, rango criminal y observaciones

data_crime$nombre <- stri_trans_general(data_crime$nombre, id = "Latin-ASCII")

data_crime$rank <- stri_trans_general(data_crime$rank, id = "Latin-ASCII")

data_crime$observaciones <- stri_trans_general(data_crime$observaciones, id = "Latin-ASCII")

# Retiramos los espacios vacios al incio y al final

# Usaremos trim. Un ejemplo

str_trim(" Arriba Perú ")


# name, date_born and age clean 


data_crime <- data_crime %>% mutate(nombre = str_trim(nombre), rank = str_trim(rank),
                                    observaciones = str_trim(observaciones),
                                    nombre_clean =  str_replace(nombre,"[^a-zA-Z\\s]",''),
                                    date_clean =  str_replace(born_date,"(\"#%)|(!)|(00:00)",''),
                                    age_clean =  str_replace(age,"\\D+",''),
                                    new_date = dmy( date_clean )  # usamos lubridate
                                    )

# Dummies por rango criminal

data_crime <- data_crime |> mutate( 
  dum1 = ifelse(str_detect(rank,"criminal$"), 1 , 0 ),
  dum2 = ifelse(str_detect(rank,"local$"), 1 , 0 ),
  dum3 = ifelse(str_detect(rank,"regional$"), 1 , 0 ),
  dum4 = ifelse(str_detect(rank,"sicario"), 1 , 0 ),
  dum5 = ifelse(str_detect(rank,"^extor"), 1 , 0 ),
  dum6 = ifelse(str_detect(rank,"miembro"), 1 , 0 ),
  dum7 = ifelse(str_detect(rank,"(^princ)|(^nov)|(^noa)"), 1 , 0 ),
  user = str_match(correo_abogado, "(\\w+)\\@.*")[,2]
)
  
# Uso de Look around regex 

data_crime <- data_crime |> mutate( 
  dni_clean = str_extract(dni,"(?<=dni es )[\\d+\\-]+"), # Positive lpok behind
  crimen = str_extract(observaciones,"(?<=sentenciado por )[\\w+\\s]+"),
  cant_hijos = str_extract(observaciones,"(?<=tiene |tener )\\d+"),
  inicio_edad = str_extract(observaciones,"\\d+(?= anos)")  # Negative look behind
  
)


























