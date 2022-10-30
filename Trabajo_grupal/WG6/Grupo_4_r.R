
###############################  WG # 6 ######################################

# Grupo 4

# Seidy Ascencios - 20191622
# Luana Morales - 20191240
# Marcela Quintero - 20191445
# Flavia OrÈ - 20191215

##############################################################################
#                                                                            #
#                                 PREGUNTA 1                                 #
#                                                                            #
##############################################################################


#install.packages("stringr")


library(haven)  # leer archivos spss, stata, dbf, etc
library(dplyr)  # limpieza de datos
library(stringr)   # grep for regular expression
library(fastDummies) # crear dummy
library(srvyr)  # libreria para declarar el dise√±o muestral de una encuesta
library(survey)

"1) Set Directorio"

user <- Sys.getenv("USERNAME")  

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG6") ) # set directorio


"ENAHO 2020"

"2) Load dataset de ENAHO"

enaho01 <- read_dta("../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")


enaho34 <- read_dta("../../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")


enaho01<- data.frame(
  
  read_dta("../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")
  
)

enaho34 = data.frame(
  read_dta("../../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)


"4) Merge section"

"Left merge"

#enaho34: master data
#enaho01: using data

enaho_merge <- merge(enaho34, enaho01,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T
)


index <- grep(".y$", colnames(enaho_merge))  # Regular regular 

# $ el texto finaliza con .y

merge_base_2020 <- enaho_merge[, - index]


"ENAHO 2019"


enaho01_1 <- read_dta("../../../../enaho/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")


enaho34_1 <- read_dta("../../../../enaho/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")


"4) Merge section"

"Left merge"

#enaho34_1: master data
#enaho01_1: using data

enaho_merge_1 <- merge(enaho34_1, enaho01_1,
                       by = c("conglome", "vivienda", "hogar"),
                       all.x = T
)


index_1 <- grep(".y$", colnames(enaho_merge_1))  # Regular regular 

# $ el texto finaliza con .y

merge_base_2019 <- enaho_merge_1[, - index_1]


colnames(merge_base_2020)

#----------------------- Append -----------------------------------

merge_append <-  bind_rows(merge_base_2019, merge_base_2020) # bind_rows from dyplr 

unique(merge_append$a√ëo)


#rename 

merge_append <- merge_append %>% dplyr::rename(a√ëo = a√ëo.x,ubigeo = ubigeo.x)


# sibstr permite sustraer digitos de un string, texto, caracter

merge_append['ubigeo_dep'] = substr(merge_append$ubigeo, 1, 2)

#----------------------- Deflactar -----------------------------------

deflactores_base2020_new <- read_dta("../../../../enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")


deflactores_base2020_new <- deflactores_base2020_new %>% dplyr::rename(a√ëo = aniorec)


names(deflactores_base2020_new)

"4) Merge section deflactores"


# merge usando como llaves a las variables dpto y aniorec. 
#merge_append: master data
#deflactores_base2020_new: using data


enaho_merge_defla <- merge(merge_append, deflactores_base2020_new,
                           by = c("dpto", "a√ëo"),
                           all.x = T, suffixes = c("","")
)

colnames(enaho_merge_defla)

enaho_merge_defla <- enaho_merge_defla %>%
  mutate(ingreso_month_pc = enaho_merge_defla$inghog1d/(12*enaho_merge_defla$mieperho*enaho_merge_defla$ld*enaho_merge_defla$i00),
         gasto_month_pc = enaho_merge_defla$gashog2d/(12*enaho_merge_defla$mieperho*enaho_merge_defla$ld*enaho_merge_defla$i00)
  )





#------------------------------------------------------------------------------#
#                                                                              #
#                           PREGUNTA 2 - GROUP BY                              # 
#                                                                              #
#------------------------------------------------------------------------------#

#Importamos los programas necesarios 


library(haven)  
library(dplyr)  
library(stringr)   
library(fastDummies) 
library(srvyr)  
library(survey)

# Seteamos el directorio

user <- Sys.getenv("USERNAME")  

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG6") ) # set directorio

#Leemos la base de datos

enaho_2 <-  read_dta(r"../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")

#Vemos la base de datos

enaho_2$dominio

enaho_2 <- data.frame(
  
  read_dta("../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")
  
)


#Vemos los labels antes de realizar el groupby

names(enaho_2)


#Seleccionamos las variables que usaremos

hogares <- enaho_2[ , c("conglome", "vivienda", "hogar", "p208a") ]


#Hacemos un merge con el modulo 34 para obtener los datos que nos faltan (pobreza)

#Para ello primero cargamos la base de datos (modulo 34) y obtenemos sus labels


enaho34 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

names(enaho34)

#Ahora filtramos la base con groupby para quedarnos solo con lo que necesitamos (el estado de pobreza)

hogares34 <- enaho34[ , c("conglome", "vivienda", "hogar", "pobreza") ]


#Ahora, procedemos a realizar el merge entre hogares y hogares 34

enaho_merge <- merge(hogares, hogares34,
                           by = c("conglome", "vivienda", "hogar")
)

print (enaho_merge)



#Procedemos a crear la dummy que verifica si el hogar es pobre y cuenta con algun miembro del hogar mayor a 65 aÒos.

enaho_merge['dummypension'] <- (enaho_merge['p208a'] >= 65) & (enaho_merge['pobreza'] < 3)*1
## Se puede obtener la dummy mediante la funciÛn if_else(), as.numeric() o multiplicando por 1 lo que deseamos evaluar, 
## en este caso, pobreza del hogar y el requisito de la edad.


#Visualizamos la dummy, la cual ser· true (1) si se cumplen ambas condiciones y false (0) si no se cumplen

print(enaho_merge['dummypension'])







#------------------------------------------------------------------------------#
#                                                                              #
#                        PREGUNTA 4 - indicadores                              # 
#                                                                              #
#------------------------------------------------------------------------------#

#Insatalamos los paquetes necesarios 

pacman::p_load(haven,dplyr, stringr, fastDummies,srvyr )

library(reshape)
library(haven)
library(dplyr)
library (srvyr)
library(survey)

#insertamos las bases de datos
user <- Sys.getenv("USERNAME") 

setwd( paste0("C:/Users/",user,"/Documents/data_enaho") )

enaho.700 <- read_dta("C:/Users/seibe/OneDrive/Documents/DATA_STATA/enaho01-2020-700.dta")
View(enaho.700)

enaho.sumaria <- read_dta("C:/Users/seibe/OneDrive/Documents/DATA_STATA/sumaria-2020-12g.dta")
View(enaho.sumaria)

#Especificamos el dise√±o muestral 
survey_enaho <- enaho.700%>% as_survey_design(ids = conglome, strata = estrato, 
                                              weight = factor07)

View (survey_enaho)

survey_enaho_2 <- enaho.sumaria%>% as_survey_design(ids = conglome, strata = estrato, 
                                                    weight = factor07)

View (survey_enaho_2)

#Creamos la variable region para ambas muestras

enaho.700['ubigeo'] = substr(enaho.700$ubigeo, 1, 2)

enaho.700 <- enaho.700 %>% 
  mutate(region = case_when(ubigeo == "01" ~ "Amazonas",
                            ubigeo == "02" ~ "Ancash",
                            ubigeo == "03" ~ "Apurimac",
                            ubigeo == "04" ~ "Arequipa", 
                            ubigeo == "05" ~ "Ayacucho",
                            ubigeo == "06" ~ "Cajamarca",
                            ubigeo == "07" ~ "Callao",
                            ubigeo == "08" ~ "CUsco",
                            ubigeo == "09" ~ "Huancavelica",
                            ubigeo == "10" ~ "Huanuco",
                            ubigeo == "11" ~ "Ica",
                            ubigeo == "12" ~ "Junin", 
                            ubigeo == "13" ~ "La Libertad",
                            ubigeo == "14" ~ "Lambayeque",
                            ubigeo == "15" ~ "Lima",
                            ubigeo == "16" ~ "Loreto",
                            ubigeo == "17" ~ "Madre de Dios",
                            ubigeo == "18" ~ "Moquegua",
                            ubigeo == "19" ~ "Pasco", 
                            ubigeo == "20" ~ "Piura",
                            ubigeo == "21" ~ "Puno",
                            ubigeo == "22" ~ "San Martin",
                            ubigeo == "23" ~ "Tacna",
                            ubigeo == "24" ~ "Tumbes",
                            ubigeo == "25" ~ "Ucayali", ))

View(enaho.700[, c("region")]) 


enaho.sumaria['ubigeo'] = substr(enaho.sumaria$ubigeo, 1, 2)

enaho.sumaria <- enaho.sumaria %>% 
  mutate(region = case_when(ubigeo == "01" ~ "Amazonas",
                            ubigeo == "02" ~ "Ancash",
                            ubigeo == "03" ~ "Apurimac",
                            ubigeo == "04" ~ "Arequipa", 
                            ubigeo == "05" ~ "Ayacucho",
                            ubigeo == "06" ~ "Cajamarca",
                            ubigeo == "07" ~ "Callao",
                            ubigeo == "08" ~ "CUsco",
                            ubigeo == "09" ~ "Huancavelica",
                            ubigeo == "10" ~ "Huanuco",
                            ubigeo == "11" ~ "Ica",
                            ubigeo == "12" ~ "Junin", 
                            ubigeo == "13" ~ "La Libertad",
                            ubigeo == "14" ~ "Lambayeque",
                            ubigeo == "15" ~ "Lima",
                            ubigeo == "16" ~ "Loreto",
                            ubigeo == "17" ~ "Madre de Dios",
                            ubigeo == "18" ~ "Moquegua",
                            ubigeo == "19" ~ "Pasco", 
                            ubigeo == "20" ~ "Piura",
                            ubigeo == "21" ~ "Puno",
                            ubigeo == "22" ~ "San Martin",
                            ubigeo == "23" ~ "Tacna",
                            ubigeo == "24" ~ "Tumbes",
                            ubigeo == "25" ~ "Ucayali", ))

View(enaho.sumaria[, c("region")]) 

# Se halla el porcentaje que hogares a nivel departamental (o region) que se beneficia del programa.

bene_prog <- enaho.700 %>% group_by(ubigeo, region) %>% 
  summarise(porc_bene_pro = mean(p710_04, na.rm = T), .groups = "keep" ) 


View(bene_prog)

# Se muestra el promedio del porcentaje de gasto en salud realizado por los hogares a nivel de region

enaho.sumaria<-mutate(enaho.sumaria, gasto_anual_hogar=gru51hd/gashog2d)

View(enaho.sumaria[, c("gasto_anual_hogar", "region")]) 

gasto_salud <- enaho.sumaria %>% group_by(ubigeo, region) %>% 
  summarise(porc_gasto_salud = mean(gasto_anual_hogar, na.rm = T), .groups = "keep" )

View(gasto_salud)
