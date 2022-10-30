
###########################################  GRUPO 1 ############################################
#####################################  Miembros del grupo  ######################################
# 20163197, Enrique Alfonso Pazos
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Eguzquiza
# 20163377, Jean Niño de Guzman

library(haven)  # leer archivos spss, stata, dbf, etc
library(dplyr)
library(haven)  # leer archivos spss, stata, dbf, etc
library(fastDummies) # crear dummy
library(srvyr)  # libreria para declarar el diseÃ±o muestral de una encuesta
library(survey)


##########################################  Pregunta 1 ##########################################
# Directorio
user <- Sys.getenv("USERNAME") 
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2") ) 

#2019
enaho_mod01_2019 <- read_dta("../../Enaho/2019/687-Modulo01/enaho01-2019-100.dta")
enaho_mod34_2019 <- read_dta("../../Enaho/2019/687-Modulo34/sumaria-2019.dta")
#2020
enaho_mod01_2020 <- read_dta("../../Enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")
enaho_mod34_2020 <- read_dta("../../Enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")

#Nos quedamos solo con variables relevantes
enaho_mod01_2019<-enaho_mod01_2019[,c("año", "conglome", "vivienda", "hogar", "ubigeo")]
enaho_mod01_2020<-enaho_mod01_2020[,c("año", "conglome", "vivienda", "hogar", "ubigeo")]

#Renombramos año como Year
enaho_mod01_2019<-enaho_mod01_2019 %>% rename(Year = año)
enaho_mod01_2020<-enaho_mod01_2020 %>% rename(Year = año)

#Merge ambas bases
Enaho_2019<-merge(enaho_mod01_2019,enaho_mod34_2019, by=c("vivienda", "hogar", "ubigeo"),all.x = TRUE)
Enaho_2020<-merge(enaho_mod01_2020,enaho_mod34_2020, by=c("vivienda", "hogar", "ubigeo"),all.x = TRUE)


Enaho_2019_2020<-bind_rows(Enaho_2019,Enaho_2020)
dep<-substr(Enaho_2019_2020$ubigeo,start = 1,stop=2)
dep<-as.numeric(dep)
dep <- data.frame(dep)
Enaho_2019_2020 <- cbind(Enaho_2019_2020, dep)

deflactor_temporal <- read_dta("../../Enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")

deflactor_temporal<-deflactor_temporal %>% rename(dep = dpto)
deflactor_temporal<-deflactor_temporal %>% rename(Year = aniorec)


merg_final<-merge(Enaho_2019_2020,deflactor_temporal, by =c("dep","Year"),all.x = TRUE)

# Deflacto entre la variable "mieperho", 12, "ld", "i00"

merg_final$inghog1d<- merg_final$inghog1d/merg_final$mieperho
merg_final$gashog2d<- merg_final$gashog2d/merg_final$mieperho

merg_final$inghog1d<- merg_final$inghog1d/12
merg_final$gashog2d<- merg_final$gashog2d/12

merg_final$inghog1d<- merg_final$inghog1d/merg_final$ld
merg_final$gashog2d<- merg_final$gashog2d/merg_final$ld

merg_final$inghog1d<- merg_final$inghog1d/merg_final$i00
merg_final$gashog2d<- merg_final$gashog2d/merg_final$i00

# Base de datos final:
merg_final

##########################################  Pregunta 2 ##########################################

##
## Salario por hora del trabajador dependiente
##

# Leemos la base de datos de la ENAHO
df <- read_dta("../../Enaho/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")

# Utilizamos fillna para reemplazar todos los missing values con 0 
# Solo lo hacemos en las variables que ser?n ?tiles para el c?lculo del salario por hora 
df <- mutate_at(df, c("i524e1","i538e1","i513t","i518"), ~replace(., is.na(.), 0))

# Creamos la variable salario_hora con la f?rmula de salario por hora especificado en la tarea
salario_hora <- ( (df$i524e1)+(df$i538e1) ) / ( ( (df$i513t) + (df$i518) ) * 52 )

# A?adimos la nueva variable a la base de datos
df <- cbind(df, salario_hora)

# Reemplazamos los 0 por Nan en la columna salario_hora
# Esto con la finalidad de indicar que no hay datos para esas filas
df$salario_hora[df$salario_hora == 0] <- NaN
df$salario_hora

##########################################  Pregunta 3 ##########################################

##
## Group By
##

#Se cargan las bases de datos del modulo02 y modulo34
#Modulo02:
enaho02 <- data.frame(
  read_dta("../../Enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")
)
#Modulo34
enaho34 <- data.frame(
  read_dta("../../Enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

#Se seleccionan las variables que necesarias para cada m?dulo (para identificar individuos en hogares y conocer la edad y pobreza del hogar)
enaho02 <- enaho02[ , c("conglome", "vivienda", "hogar","p208a") ]

enaho34 <- enaho34[ , c("conglome", "vivienda", "hogar","pobreza") ]


#Se aplica el groupby para el m?dulo02:

enaho02 <- enaho02%>%
  group_by(conglome, vivienda, hogar)%>%
  summarise(max(p208a)) #Se indica que se extraiga el mayor valor de edad de cada hogar

#Merge
#Se juntan las bases de datos en base a las variables de conglome, vivienda y hogar. Se tiene como base maestra el modulo02
enaho_merge <- merge(enaho02, enaho34,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T
)

#Se renombra a la variable p208a por "edad":
names (enaho_merge)[4] = "edad"

#Dummy
#Se crea una dummy con los criterios:
#Si el hogar tiene al menos un integrante mayor de 65 y est?n en pobreza, se le coloca 1
#Todos los dem?s casos se les coloca 0
#Adem?s, se indica que en caso se tengan datos na, estos no tengan un 0, sino que se les asigne un NA
enaho_merge <- enaho_merge %>%
  mutate(dummy_pobre = ifelse( (enaho_merge$p208a > 65 & enaho_merge$pobreza < 3) , 
                               1, 
                               ifelse(!is.na(enaho_merge$p208a |!is.na(enaho_merge$pobreza)),
                                      0, 
                                      NA) ) ) 


##########################################  Pregunta 4 ##########################################

##
## Indicadores
##

# Leemos la base de datos del modulo 37 y 34 de la ENAHO
enaho37 = data.frame(read_dta("../../Enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta"))

enaho34 = data.frame(read_dta("../../Enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta"))

#Nos quedamos solo con variables relevantes de ambos m?dulos

enaho37 <- enaho37[,c("p710_04", "factor07", "conglome", "vivienda", "hogar" ,"ubigeo", "estrato")]

enaho34 <- enaho34[ ,c("gru51hd", "gashog2d", "factor07", "conglome", "vivienda", "hogar" ,"ubigeo", "estrato")]


#Primero, especificamos el dise?o de las encuestas
# ids: conglomerado, strato: estrato y wieght : factor de expansi?n

encuesta_enaho37 <- enaho37  %>% as_survey_design(ids = conglome, 
                                                  strata = estrato, 
                                                  weight = factor07)

encuesta_enaho34 <- enaho34  %>% as_survey_design(ids = conglome, 
                                                  strata = estrato, 
                                                  weight = factor07)


#Obtenemos la variable de ubigeo de cada regi?n de ambos m?dulos

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
                            ubigeo_dep == "21" ~ "Puno",
                            ubigeo_dep == "22" ~ "San Mart?n",
                            ubigeo_dep == "23" ~ "Tacna",
                            ubigeo_dep == "24" ~ "Tumbes",
                            ubigeo_dep == "25" ~ "Ucayali",) 
  )


encuesta_enaho37 <- enaho37  %>% as_survey_design(ids = conglome, 
                                                  strata = estrato, 
                                                  weight = factor07)




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
                            ubigeo_dep == "21" ~ "Puno",
                            ubigeo_dep == "22" ~ "San Mart?n",
                            ubigeo_dep == "23" ~ "Tacna",
                            ubigeo_dep == "24" ~ "Tumbes",
                            ubigeo_dep == "25" ~ "Ucayali",) )



encuesta_enaho34 <- enaho34  %>% as_survey_design(ids = conglome, 
                                                  strata = estrato, 
                                                  weight = factor07)



#Calculamos el indicador de porcentaje que hogares a nivel de regi?n (departamentos) que se beneficia del programa

enaho37_final <- encuesta_enaho37 %>% group_by(region) %>%
  summarise(juntos= survey_mean(p710_04, na.rm = T))

View(enaho_37[, c('region', 'juntos')])


#Calculamos el indicador de promedio del porcentaje de gasto en salud realizado por los hogares a nivel de regi?n (departamentos)


enaho34_final <- encuesta_enaho34 %>% mutate(porcentaje_gasto_salud = gru51hd/gashog2d) %>% group_by(region) %>%
  summarise(promedio_gasto_salud= survey_mean(porcentaje_gasto_salud)) 

View(enaho34_final[, c('region', 'promedio_gasto_salud')])








