#### Grupo 9 #### Pregunta 4 ######


library(haven)  # leer archivos stata: dta
library(dplyr)  # limpieza de datos
library(stringr)   # grep for regular expression
library(srvyr)  # libreria para declarar el diseño muestral de una encuesta
library(survey)


"Set Directorio"
#---------------
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Grupo9") ) # set directorio


"Load dataset de ENAHO"
#----------------------

enaho34 = data.frame(
  read_dta("../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

enaho37 = data.frame(
  read_dta("../../enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta")
)


"Porcentaje de hogares a nivel departamental (o región) que se beneficia del programa 'juntos'"
#-----------------------------------------------------------------------------------------------

# Mantenemos variables de interés

enaho_merge_37 <- enaho37[ ,c("conglome", "vivienda", "hogar" ,"ubigeo", 
                               "estrato", "p710_04", "factor07")]

# Diseño muestral de su encuesta

  # Declarar el diseño de la encuesta
  # ids: conglomerado, strato: estrato y wieght : factor de expansión

survey_enaho_37 <- enaho_merge_37  %>% as_survey_design(ids = conglome, 
                                                        strata = estrato, 
                                                        weight = factor07)


# Creamos la variables 'ubigeo_dep', 'region'

enaho_merge_37['ubigeo_dep'] = substr(enaho_merge_37$ubigeo, 1, 2)

enaho_merge_37 <- enaho_merge_37 %>% 
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
                            ubigeo_dep == "22" ~ "San Martín",
                            ubigeo_dep == "23" ~ "Tacna",
                            ubigeo_dep == "24" ~ "Tumbes",
                            ubigeo_dep == "25" ~ "Ucayali",) 
                            )


survey_enaho_37 <- enaho_merge_37  %>% as_survey_design(ids = conglome, 
                                                        strata = estrato, 
                                                        weight = factor07)

# Creamos el índice 'juntos' que representa el porcentaje de hogares a 
# nivel departamental (región) que se beneficia del programa

enaho_37 <- survey_enaho_37 %>% group_by(region) %>%
  summarise(juntos= survey_mean(p710_04, na.rm = T)) 

#Respuesta:
View(enaho_37[, c('region', 'juntos')])

"************************ 2da parte del ejercicio *********************"


"El promedio del porcentaje de gasto en salud realizado por los hogares a nivel de región (o departamentos)"
#----------------------------------------------------------------------------------------------------------

# Mantenemos variables de interés

enaho_merge_34 <- enaho34[ ,c("conglome", "vivienda", "hogar" ,"ubigeo", 
                                     "estrato", "gru51hd", "gashog2d", "factor07")]


# Diseño muestral de su encuesta

# Declarar el diseño de la encuesta
# ids: conglomerado, strato: estrato y wieght : factor de expansión

survey_enaho_34 <- enaho_merge_34  %>% as_survey_design(ids = conglome, strata = estrato, 
                                                        weight = factor07)


# Creamos la variables 'ubigeo_dep', 'region' y la dummy 'p710_04'

enaho_merge_34['ubigeo_dep'] = substr(enaho_merge_34$ubigeo, 1, 2)
enaho_merge_34 <- enaho_merge_34 %>% 
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
                            ubigeo_dep == "22" ~ "San Martín",
                            ubigeo_dep == "23" ~ "Tacna",
                            ubigeo_dep == "24" ~ "Tumbes",
                            ubigeo_dep == "25" ~ "Ucayali",) )



survey_enaho_34 <- enaho_merge_34  %>% as_survey_design(ids = conglome, strata = estrato, 
                                                    weight = factor07)

# Creamos el índice 'promedio_gasto_salud' que representa el porcentaje de hogares a 
# nivel departamental (o región) que se beneficia del programa

ind2 <- survey_enaho_34 %>%  mutate(
    porcentaje_gasto_salud = gru51hd/gashog2d
  ) %>% group_by(region) %>% # indicador a nivel regional  %>% 
  
  summarise(promedio_gasto_salud= survey_mean(porcentaje_gasto_salud)) 

#Respuesta
View(ind2[, c('region', 'promedio_gasto_salud')])
