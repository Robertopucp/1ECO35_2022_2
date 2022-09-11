library(dplyr)  # librería de limpieza de datos
library(tidyr)  # librería de limpieza de datos
library(readxl) # librería para subir archivos excel, csv

## Adaptamos el directorio
user <- Sys.getenv("USERNAME")  # username
print(user)
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab3") ) # set directorio
junin_data <- read_excel("../data/Region_Junin.xlsx")


###############################
### Exploring a DataFrame  ####
###############################


#-----------------------------------------------------------------------
# 1. Obtener el nombre de todas las variables. 

names(junin_data)

#-----------------------------------------------------------------------
# 2. Mostrar el tipo de variables (type) así como presentar los principales estadísticos.

str(junin_data)     # Se observa que todas las variables son numéricas a excepción de Region, Distric y Place que son character


#-----------------------------------------------------------------------
# 3. Verifique si las columnas presentan missing values.

unique(junin_data)     # muestra los valores únicos por cada columna

sum(is.na(junin_data)) # total de missing values en el dataframe

junin_data2 <- junin_data %>% drop_na()  # creando nueva base sin missing values


#-----------------------------------------------------------------------
# 4. Cambie el nombre de las siguientes variables:

junin_data2 <- junin_data2 %>% rename(comunidad = Place,
                                      homxlee = men_not_read,
                                      mujerxlee = women_not_read,
                                      totalxlee = total_not_read)  # nombre nuevo =  nombre antiguo


#----------------------------------------------------------------------------
# 5. Valores únicos de las siguientes variables ( comunidad , District)

# mostrar valores Ãºnicos de ambas variables

unique(junin_data2$comunidad)
unique(junin_data2$District)



#----------------------------------------------------------------------------

# 6. Crear columnas con la siguiente información

# Unimos las columnas de una vez al dataframe total

junin_data2$mujer_noescribenilee <- junin_data2$mujerxlee / junin_data2$totalxlee
junin_data2$hombre_noescribenilee <- junin_data2$homxlee  / junin_data2$totalxlee
junin_data2$nativos_total  <- junin_data2$natives / (junin_data2$peruvian_men + junin_data2$peruvian_women + junin_data2$foreign_men + junin_data2$foreign_women)



#-----------------------------------------------------------------------
# 7. Cambie el nombre de las siguientes variables:

# a. Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción

unique(junin_data2$District)   # para obtener los verdaderos nombres de los distritos

junin_data3 <- junin_data2 %>% filter( District %in% c("CIUDAD DEL CERRO", "JAUJA", "ACOLLA", "SAN GERÓNIMO", "TARMA", "OROYA", "CONCEPCIÓN"))

# b. Luego quedarse con las comunidades que cuentan con nativos y mestizos.

names(junin_data3)   # para ver el nombre de las variables
                     # vemos que los nombres son "whites" y "natives"

junin_data3 <- junin_data3 %>% filter( natives > 0  &  mestizos > 0 )

# c. Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.

junin_data3 <- junin_data3[ , c('mujer_noescribenilee', 'hombre_noescribenilee', 'nativos_total', 'District', 'comunidad')]

# d. Guardar la base de datos en formato csv en la carpeta data. (Use el siguiente nombre Base_cleaned_WG(numero de grupo)

write.csv(junin_data3, '../data/Base_cleaned_WG7.csv')


