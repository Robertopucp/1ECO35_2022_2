#Instalamos el paquete "pacman"
install.packages("pacman")
pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)

#Colocamos el usuario para que pueda correr fácilmente
user <- Sys.getenv("USERNAME")  
#Seteamos el directorio
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/data")) 
#Colocamos la ruta 
file_path = "../data/data_administrativa.sav"

#Para que lea el archivo SPSS
df <- haven::read_sav(file_path , encoding = "UTF-8" )  

#Se muestran las variables del dataframe y abajo si tienen o no missing values
#Aparece True si tiene algún valor nulo y False si no tiene ningún valor nulo
apply(df, MARGIN = 2, function(x) any(is.na(x)))

#Se muestran las etiquetas de las dos variables P203 y P204:

#Etiqueta de P203
paste("Etiqueta de variable P203 =", df$P203 %>% attr('label') )# var label
#Etiqueta de P204
paste("Etiqueta de variable P204 =", df$P204 %>% attr('label') )# var label

#Se muestran las etiquetas de los valores de las dos variables P203 y P204:

#Etiquetas de los valores de variable P203
df$P203 %>% attr('labels')
#Etiquetas de los valores de la variable P204
df$P204 %>% attr('labels')

#Hallamos los duplicados con attach
attach(df)

#Se crea un dataframe con los valores duplicados
df_filtrada <- df %>% group_by(CONGLOME ,VIVIENDA , HOGAR ,CODPERSO) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) %>%

  #Se indica que se muestren las variables del Indicador por Persona y el año de cada registro
  select(year, CONGLOME ,VIVIENDA , HOGAR ,CODPERSO ,duplicates ) 

#Se ordena el nuevo dataframe para que se pueda identificar fácilmente los registros duplicados y en que año se registró cada uno
df_filtrada <- df_filtrada[order(df_filtrada$CONGLOME, df_filtrada$VIVIENDA, df_filtrada$year),]

#Mostramos el DataFrame
View(df_filtrada)


df_filtrada %>%  filter(year==2019)-> df_2019
df_filtrada %>%  filter(year==2020)-> df_2020

write.csv(df_2019, "../data/df_2019")
write.csv(df_2020, "../data/df_2020")












