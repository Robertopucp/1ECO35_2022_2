#Tarea 6
#Grupo 8


#----------------------------------------------------------------------------------------------#

#PREGUNTA 1

rm(list=ls())

install.packages("pacman")

pacman::p_load(haven,dplyr, stringr, fastDummies)

#MERGE DATASET

setwd(paste0("C:/Users/Alexander/Documents/2020/737-Modulo01/737-Modulo01") )

#Primero trabajamos con la bse de datos del año 2020

enaho01_2020 <- read_dta("../../../2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

enaho34_2020 <- read_dta("../../../2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")

enaho01_2020 <- enaho01_2020[ , c("conglome", "vivienda", "hogar")]

enaho34_2020 <- enaho34_2020[ , c("conglome", "vivienda", "hogar", "ld", "mieperho", "inghog1d", "gashog2d", "aÑo")]

enaho_merge_2020 <- merge(enaho01_2020, enaho34_2020,
                          by = c("conglome", "vivienda", "hogar"),
                          all.x = T)

#Primero trabajamos con la base de datos del año 2019

enaho01_2019 <- read_dta("../../../2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")

enaho34_2019 <- read_dta("../../../2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")

enaho01_2019 <- enaho01_2019[ , c("conglome", "vivienda", "hogar")]

enaho34_2019 <- enaho34_2019[ , c("conglome", "vivienda", "hogar", "ld", "mieperho", "inghog1d", "gashog2d", "aÑo")]

enaho_merge_2019 <- merge(enaho01_2019, enaho34_2019,
                          by = c("conglome", "vivienda", "hogar"),
                          all.x = T)

#Hacemos el append:

enaho_append <- bind_rows(enaho_merge_2019, enaho_merge_2020)
unique(enaho_append$aÑo)

#Base de deflactor temporal para el 2020
deflactores_2020 <- read_dta("../../../2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")

#Creamos ingreso y gasto mensual
enaho_append$ingreso_mensual <- enaho_append$inghog1d / (12*enaho_append$mieperho)

enaho_append$gasto_mensual <- enaho_append$gashog2d / (12*enaho_append$mieperho)

#Deflactando las variables (deflactor espacial y temporal):

#Deflactor espacial

enaho_append$ingreso_mensual_defl <- enaho_append$ingreso_mensual * enaho_append$ld
enaho_append$gasto_mensual_defl <- enaho_append$gasto_mensual * enaho_append$ld


#Creamos la variable "departamento" a partir del ubigeo para luego aplicar el merge con deflactores_2020

enaho_append['departamento'] = substr(enaho_append$ubigeo,1,2)

class(enaho_append$departamento)
class(deflactores_2020$dpto)

enaho_append$departamento <- as.numeric(enaho_append$departamento)
class(enaho_append$departamento)

#Merge entre la enaho_append y el deflactor temporal:

enaho_merge_def_temporal_2020 <- merge(enaho_append, deflactores_2020,
                                       by.x = c("departamento", "aÑo"),
                                       by.y = c("dpto", "aniorec"),
                                       all.x = TRUE)

unique(enaho_merge_def_temporal_2020$aÑo)
colnames(enaho_merge_def_temporal_2020)

#Ahora dividimos nuestras variables de ingreso y gasto por mieperho, 12, ld e i00

#Comenzamos con el ingreso
enaho_merge_def_temporal_2020['ingr_Per1'] = enaho_merge_def_temporal_2020$inghog1d / enaho_merge_def_temporal_2020$mieperho
enaho_merge_def_temporal_2020['ingr_Per2'] = enaho_merge_def_temporal_2020$inghog1d / enaho_merge_def_temporal_2020$ld
enaho_merge_def_temporal_2020['ingr_Per3'] = enaho_merge_def_temporal_2020$inghog1d / enaho_merge_def_temporal_2020$ 12
enaho_merge_def_temporal_2020['ingr_Per4'] = enaho_merge_def_temporal_2020$inghog1d / enaho_merge_def_temporal_2020$i00

#Seguimos con el gasto
enaho_merge_def_temporal_2020['gast_Per1'] = enaho_merge_def_temporal_2020$gashog2d / enaho_merge_def_temporal_2020$mieperho
enaho_merge_def_temporal_2020['gast_Per2'] = enaho_merge_def_temporal_2020$gashog2d / enaho_merge_def_temporal_2020$ld
enaho_merge_def_temporal_2020['gast_Per3'] = enaho_merge_def_temporal_2020$gashog2d / enaho_merge_def_temporal_2020$ 12
enaho_merge_def_temporal_2020['gast_Per4'] = enaho_merge_def_temporal_2020$gashog2d / enaho_merge_def_temporal_2020$i00


#----------------------------------------------------------------------------------------------#

#PREGUNTA2

#SALARIO POR HORA DEL TRABAJADOR DEPENDIENTE

setwd(paste0("C:/Users/Alexander/Documents/2020/737-Modulo05/737-Modulo05") )

enaho05_2020 <- read_dta("../../../2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta") %>%
  
  mutate(enaho05_2020_ingr_anual = i524e1 + i538e1, enaho05_2020_hrs_en_principal_y_2do_empleo = i513t + i518) %>%
  
  #Luego, hallamos salario por hora del trabajador independiente:
  
  enaho05_2020 <- read_dta("../../../2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta") %>%
  mutate(enaho_2020_salario_x_hora_trabajador_indep = enaho05_2020_ingr_anual / ((enaho05_2020_hrs_en_principal_y_2do_empleo) * 52)  ) %>%
  
  
  #----------------------------------------------------------------------------------------------#
  
  #PREGUNTA3
  #GROUP BY
  
  #Librerías
  library(haven)  # leer archivos spss, stata, dbf, etc
library(dplyr)  # limpieza de datos
library(stringr)   # grep for regular expression
library(fastDummies) # crear dummy
library(srvyr)  # libreria para declarar el diseño muestral de una encuesta
library(survey)


#Seteamos ubicación
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab7") ) # set directorio

#cargamos las bases de datos a utilizar

enaho02 <- read_dta("../../../enaho/2020/737-Modulo02/enaho01-2020-200.dta")


base1 <- enaho02%>% group_by(conglome, vivienda, hogar ) %>% summarise(edad_max = max(p208a))

enaho34 <- read_dta("../../../enaho/2020/737-Modulo34/sumaria-2020.dta")

#Hacemos el merge
num = list(enaho34)
merge1 = enaho02

for (i in num){
  
  merge1 <- merge(merge1, i,
                  by = c("conglome", "vivienda", "hogar"),
                  all.x = T, suffixes = c("",".y")
  )
}

names(merge1)

#Creamos la variable dummy
pension <- merge1 %>%mutate(g1 = ifelse(edad_max <=65,1,0))


#----------------------------------------------------------------------------------------------#
#PREGUNTA4

#INDICES

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab7") ) # set directorio

#EJERCICIO 1
#cargamos las bases de datos a utilizar
enaho37 <- read_dta("../../../enaho/2020/737-Modulo37/enaho01-2020-700.dta")

enaho37['ubigeo_dep'] = substr(enaho37$ubigeo, 1, 2)
enaho37 <- enaho37 %>%
  mutate(region = case_when(ubigeo_dep == "01" ~ "Amazonas",
                            ubigeo_dep == "02" ~ "Ancash",
                            ubigeo_dep == "03" ~ "Apurimac",
                            ubigeo_dep == "04" ~ "Arequipa",
                            ubigeo_dep == "05" ~ "Ayacucho",
                            ubigeo_dep == "06" ~ "Cajamarca",
                            ubigeo_dep == "07" ~ "Callao",
                            ubigeo_dep == "08" ~ "Cusco",
                            ubigeo_dep == "09" ~ "Huancavelica",
                            ubigeo_dep == "10" ~ "Huanuco",
                            ubigeo_dep == "11" ~ "Ica",
                            ubigeo_dep == "12" ~ "Junin",
                            ubigeo_dep == "13" ~ "La Libertad",
                            ubigeo_dep == "14" ~ "Lambayeque",
                            ubigeo_dep == "15" ~ "Lima",
                            ubigeo_dep == "16" ~ "Loreto",
                            ubigeo_dep == "17" ~ "Madre de Dios",
                            ubigeo_dep == "18" ~ "Moquegua",
                            ubigeo_dep == "19" ~ "Pasco",
                            ubigeo_dep == "20" ~ "Piura",
                            ubigeo_dep == "21"~ "Puno",
                            ubigeo_dep == "22" ~ "San Martin",
                            ubigeo_dep == "23" ~ "Tacna",
                            ubigeo_dep == "24" ~ "Tumber",
                            ubigeo_dep == "25" ~ "Ucayali") )

#Declaramos el diseño muestral
survey_enaho37 <- enaho37  %>% as_survey_design(dep = region, pension = p710_04)

#Obtenemos el promedio
survey_enaho37 <- survey_enaho37%>% group_by(vivienda)%>% group_by(region) %>% summarize(count = n(), pension1=sum(p710_04),promedio = pension1/count)

#EJERCICIO 2
#cargamos las bases de datos a utilizar

enaho34 <- read_dta("../../../enaho/2020/737-Modulo34/sumaria-2020.dta")

#A partir del ubigeo, creamos las regiones

enaho34['ubigeo_dep'] = substr(enaho34$ubigeo, 1, 2)
enaho34 <- enaho34 %>%
  mutate(region = case_when(ubigeo_dep == "01" ~ "Amazonas",
                            ubigeo_dep == "02" ~ "Ancash",
                            ubigeo_dep == "03" ~ "Apurimac",
                            ubigeo_dep == "04" ~ "Arequipa",
                            ubigeo_dep == "05" ~ "Ayacucho",
                            ubigeo_dep == "06" ~ "Cajamarca",
                            ubigeo_dep == "07" ~ "Callao",
                            ubigeo_dep == "08" ~ "Cusco",
                            ubigeo_dep == "09" ~ "Huancavelica",
                            ubigeo_dep == "10" ~ "Huanuco",
                            ubigeo_dep == "11" ~ "Ica",
                            ubigeo_dep == "12" ~ "Junin",
                            ubigeo_dep == "13" ~ "La Libertad",
                            ubigeo_dep == "14" ~ "Lambayeque",
                            ubigeo_dep == "15" ~ "Lima",
                            ubigeo_dep == "16" ~ "Loreto",
                            ubigeo_dep == "17" ~ "Madre de Dios",
                            ubigeo_dep == "18" ~ "Moquegua",
                            ubigeo_dep == "19" ~ "Pasco",
                            ubigeo_dep == "20" ~ "Piura",
                            ubigeo_dep == "21"~ "Puno",
                            ubigeo_dep == "22" ~ "San Martin",
                            ubigeo_dep == "23" ~ "Tacna",
                            ubigeo_dep == "24" ~ "Tumber",
                            ubigeo_dep == "25" ~ "Ucayali") )

#Declaramos el diseño muestral
survey_enaho34 <- enaho34  %>% as_survey_design(dep = region,
                                                salud = gru51hd,gasto = gashog2d)

#Obtenemos el porcentaje de gasto en salud
survey_enaho34 <- survey_enaho34 %>% dplyr::mutate(gasto_salud= gru51hd/gashog2d)

#Obtenemos el promedio por region
survey_enaho34 <- survey_enaho34 %>% group_by(region) %>% summarise(mean(gasto_salud)) 