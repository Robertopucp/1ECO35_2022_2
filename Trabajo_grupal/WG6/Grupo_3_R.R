# TAREA 6


pacman::p_load(haven,dplyr,stringr, fastDummies,srvyr)

user <- Sys.getenv("fdcc0")

setwd( paste0("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho") )

# 

enaho01_2019 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")

enaho01_2020 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")


enaho34_2019 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")

enaho34_2020 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")


deflactor_temporal <- read_dta("D:/PYTHON/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")

# 1. MERGE DATASET 

enaho_merge2019 <- merge(enaho34_2019, enaho01_2019,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T
)


enaho_merge2020 <- merge(enaho34_2020, enaho01_2020,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T
)

# juntamos las bases 2019 y 2020
enaho_append <- append(enaho_merge2019, enaho_merge2020) 

# ingreso y gasto mensual
enaho_append$ingreso_mensual <- enaho_append$inghog1d / (12*enaho_append$mieperho)

enaho_append$gasto_mensual <- enaho_append$gashog2d / (12*enaho_append$mieperho)

# deflactando las variables (deflactor espacial y temporal)

# espacial
enaho_append$ingreso_mensual_defl <- enaho_append$ingreso_mensual * enaho_append$ld

enaho_append$gasto_mensual_defl <- enaho_append$gasto_mensual * enaho_append$ld

# temporal


##############################3#

# 2. Salario por hora del trabajador dependiente

enaho01_500 <- read_dta("D:/PYTHON/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")

# salario anual del primer y segundo empleo

enaho01_500$ingreso_anual <- enaho01_500$i524e1 + enaho01_500$i538e1

# cantidad de hrs trabajadas a la semana 

enaho01_500$horas_trab_sem <- enaho01_500$i513t + enaho01_500$i518

# salario por hora del trabajador dependiente

enaho01_500$salarioxhora <- enaho01_500$ingreso_anual / (enaho01_500$horas_trab_sem*52)

# reemplazamos los NA por valores cero 

enaho01_500$salarioxhora[is.na(enaho01_500$salarioxhora)] = 0


  # GROUPBY 

# personas con 65 o más años que puedan participar del programa Juntos
enaho01_200_2019 <- read_dta("D:/PYTHON/2019/687-Modulo02/687-Modulo02/enaho01-2019-200.dta")
enaho01_200_2020 <- read_dta("D:/PYTHON/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")

enaho_200_append <- append(enaho01_200_2019, enaho01_200_2020) 

enaho_200_append$mayor_65 <- enaho_200_append$p208a >= 65




# GROUPBY 

# personas con 65 o más años que puedan participar del programa pensión 65

enaho01_200_2019 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2019/687-Modulo02/687-Modulo02/enaho01-2019-200.dta")
enaho01_200_2020 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")



enaho01_200_2019 <- enaho01_200_2019[ , c("conglome", "vivienda", "hogar" , "codperso",
                                          "ubigeo", "dominio" ,"estrato" ,"p208a", "p209",
                                          "p207", "p203", "p201p" , "p204",  "facpob07")]


enaho_merge2019 <- merge(enaho34_2019, enaho01_200_2019,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T)


enaho_merge2019 <- enaho_merge2019[ , c("conglome", "vivienda", "hogar" , "codperso",
                                        "pobreza" ,"p208a")] %>% 
  mutate(dummy_pobreza = ifelse(enaho_merge2019$pobreza == 3,0,1)) %>% 
  filter(enaho_merge2019$p208a >= 65)

# INDICADORES

# halle el porcentaje que hogares a nivel departamental que se beneficia del programa.

enaho01_37_2020 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta")

# Creamos la variable departamental

enaho01_37_2020["cod_departamento"] = paste(str_sub(enaho01_37_2020$ubigeo,1,2))

survey_enaho37 <- enaho01_37_2020 %>% as_survey_design(ids = conglome,
                                                       strata = estrato,
                                                       weight = factor07)

indicador1 <- survey_enaho37 %>%
  group_by(cod_departamento) %>%
  summarise (beneficiario = survey_mean(p710_04))

# muestre el promedio del porcentaje de gasto en salud a nivel región


enaho34_2020 <- read_dta("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 6/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")

# Creamos la variable departamental

enaho34_2020["cod_departamento"] = paste(str_sub(enaho34_2020$ubigeo,1,2))

survey_enaho34 <- enaho34_2020 %>% as_survey_design(ids = conglome,
                                                    strata = estrato,
                                                    weight = factor07)


indicador2 <- survey_enaho34 %>% mutate(gastosalud = 
                                          enaho34_2020$gru51hd/
                                          enaho34_2020$gashog2d) %>% 
  group_by(cod_departamento) %>%
  summarise (beneficiario = survey_median(gastosalud))







