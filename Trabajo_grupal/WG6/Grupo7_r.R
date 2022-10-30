##########################################
#------------- Workgroup 6 ---------------
##########################################


#---------------- 1. Merge Dataset (Python y R) --------------------

# 1.  Ingreso y gasto real per cápita mensual del hogar para los años 2019 y 2020.

library(haven)      # read datasets
library(tidyverse)
library(srvyr)      # para declarar bases de datos como encuestas



#---- 2019 ----

# Cargando bases de datos
enaho01 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta"))
enaho34 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta"))

# Merge 
merge_base_2019 <- merge(enaho01, enaho34,
                    by = c("conglome", "vivienda", "hogar"),
                    all.x = T, suffixes = c("",".y"))

# eliminando columnas con terminacion .y 
index <- grep(".y$", colnames(merge_base_2019))
merge_base_2019 <- merge_base_2019[, - index]



#---- 2020 ----

# Cargando bases de datos
enaho01 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta") )
enaho34 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta") )

# Merge 
merge_base_2020 <- merge( enaho01, enaho34,
                          by = c("conglome", "vivienda", "hogar"),
                          all.x = T, suffixes = c("",".y"))

# eliminando columnas con terminacion .y 
index <- grep(".y$", colnames(merge_base_2020))
merge_base_2020 <- merge_base_2020[, - index]



#------- Juntando bases del 2019 y 2020 --------

base_2019_2020 <- bind_rows(merge_base_2019, merge_base_2020)     # une correctamente bases con columnas diferentes

base_2019_2020$ubigeo_dep <- substr(base_2019_2020$ubigeo, 1, 2)  # 1 : a partir del la posicion 1
                                                                  # 2 : substraer 2 digitos
base_2019_2020$ubigeo_dep <- strtoi(base_2019_2020$ubigeo_dep)    # convirtiendo a int para futuro merge

### Deflactor espacial
#despacial_ldnew <- data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/despacial_ldnew.dta") )

#base_final <- merge( base_final, despacial_ldnew,
#                     by.x = c("dominio"),
#                     by.y = c("dominioA"),
#                     all = TRUE
#                     )


### Deflactor temporal
deflactores_base2020_new <- data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta") )
deflactores_base2020_new <- deflactores_base2020_new[ , c("dpto", "aniorec", "i00") ]

# inner merge con base deflactores
base_2019_2020 <- merge( base_2019_2020, deflactores_base2020_new,
                         by.x = c("ubigeo_dep", "aÑo"),
                         by.y = c("dpto", "aniorec"),
                         all.x = T
                         )

# dividiento variables de ingreso y gasto por mieperho, 12, ld e i00
base_2019_2020$ingreso_deflact <- base_2019_2020$inghog1d / (12 * base_2019_2020$mieperho * base_2019_2020$ld * base_2019_2020$i00)
base_2019_2020$gasto_deflact   <- base_2019_2020$gashog2d / (12 * base_2019_2020$mieperho * base_2019_2020$ld * base_2019_2020$i00)

base_2019_2020 <- base_2019_2020[order (base_2019_2020$conglome, base_2019_2020$vivienda, base_2019_2020$hogar), ]






#---------------- 2. Salario por hora del trabajador dependiente (Python y R) --------------------------------

# Cargando modulo 05
enaho05 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta") )
enaho05 <- enaho05[ , c("i524e1", "i538e1", "i513t", "i518") ]

# reemplazando NA por ceros
enaho05[is.na(enaho05)] <- 0

# generando variables necesarias
enaho05$ingreso <- enaho05$i524e1 + enaho05$i538e1
enaho05$horas   <- enaho05$i513t + enaho05$i518

# reemplazando NA por 0
enaho05$ingreso <- replace_na(enaho05$ingreso, 0)
enaho05$horas   <- replace_na(enaho05$horas, 0)

# salario por hora
enaho05$sal_hora_depend <- enaho05$ingreso / (enaho05$horas * 52)

# Si un salario por hora resulta 0, convertir a missing.
enaho05$sal_hora_depend <- replace(enaho05$sal_hora_depend, enaho05$sal_hora_depend == 0, NaN)






#------------------ 3. Groupby (Python y R) --------------------------------

enaho02 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta") )
enaho34 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta") )

# identificando hogares con algun miembro mayor a 65 años
enaho02_1 <- enaho02 %>% group_by(conglome, vivienda, hogar ) %>% 
  summarise( edad_max = max(p208a), .groups = "keep" )

# inner merge
base_final_2 <- merge( enaho02_1, enaho34,
                       by = c("conglome", "vivienda", "hogar"),
                       all = FALSE
                       )

## Creando dummy pobreza y mayor a 65 años
# La estrategia es generara dummies tanto para pobreza y mayor a 65 años
# Luego se sumaran las dummies y aquellas que resulten 2 es porque cumple la condicion.
# Finalmente, se convertira el 2 en 1 para tener una dummy que cumpla con las condiciones.

base_final_2 <- base_final_2 %>%
  mutate(gasto_month_pc   = base_final_2$gashog2d / (12*base_final_2$mieperho)) %>%
  mutate(dummy_pobre = ifelse( gasto_month_pc < base_final_2$linea , 
                               1, 
                               ifelse(!is.na(base_final_2$gashog2d), 0, NA) ) )

base_final_2 <- base_final_2 %>%
  mutate(dummy_mayor65 = ifelse( edad_max > 65, 
                               1,
                               0))
# sumando dummies
base_final_2$dummy_suma = base_final_2$dummy_pobre + base_final_2$dummy_mayor65 
 
# reemplazando 2 por 1
base_final_2 <- base_final_2 %>%
  mutate(dummy_pobre_mayor65 = ifelse( dummy_suma == 2,
                                       1,
                                       0 ))





#------------------ 4. Indicadores (Solo en R) --------------------------------

# 1. 
# porcentaje que hogares a nivel departamental (o región) que se beneficia del programa Juntos

# cargando modulo 37
enaho37 = data.frame( read_dta("C:/Users/Jose Pastor/Documents/datos_documents/enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta") )

# generando ubigeo_dep
enaho37['ubigeo_dep']  <- substr(enaho37$ubigeo, 1, 2) 


# modulo37 y module02 
mod_37_02 <- merge( enaho02, enaho37,
                        by = c("conglome", "vivienda", "hogar"),
                        all = FALSE, suffixes = c("",".y"))

# eliminando columnas con terminacion .y 
index <- grep(".y$", colnames(sumaria_mod02))
sumaria_mod02 <- sumaria_mod02[, - index]

# indicando el diseño muestral de la encuesta
mod_37_02 <- mod_37_02  %>% as_survey_design(ids    = conglome,
                                             strata = estrato,
                                             weight = facpob07
                                             )

# porcentaje de hogares a nivel departamental (o región) que se beneficia del programa
df_hogares_juntos <- mod_37_02 %>% group_by(ubigeo_dep) %>% 
  summarise( prom_horaes_juntos = survey_mean(p710_04 , na.rm = T), .groups = "keep" )    



# 2. 

# De Sumaria (modulo 34) y module02 
sumaria_mod02 <- merge( enaho02, enaho34,
                        by = c("conglome", "vivienda", "hogar"),
                        all = FALSE, suffixes = c("",".y"))

# eliminando columnas con terminacion .y 
index <- grep(".y$", colnames(sumaria_mod02))
sumaria_mod02 <- sumaria_mod02[, - index]

# generando varialbe departamento y porcentaje de gasto en salud anual
sumaria_mod02['ubigeo_dep']  <- substr(sumaria_mod02$ubigeo, 1, 2) 
sumaria_mod02['gasto_salud_anual_porcentaje'] <- sumaria_mod02$gru51hd / sumaria_mod02$gashog2d

# indicando el diseño muestral de la encuesta
sumaria_mod02_srvy <- sumaria_mod02  %>% as_survey_design(ids    = conglome,
                                                          strata = estrato,
                                                          weight = facpob07
                                                          )

# promedio del gasto anual en salud
prom_gast_anual_salud <- sumaria_mod02_srvy %>% group_by(ubigeo_dep) %>% 
  summarise( prom_gast_anual_salud = survey_mean(gasto_salud_anual_porcentaje, na.rm = T), .groups = "keep" )    






