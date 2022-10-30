library(haven)  # leer archivos spss, stata, dbf, etc
library(dplyr)  # limpieza de datos
library(stringr)   # grep for regular expression
library(fastDummies) # crear dummy
library(srvyr)  # libreria para declarar el diseño muestral de una encuesta
library(survey)

user <- Sys.getenv("fdcc0")

setwd( paste0("C:/Users/{user}/Documentos/GitHub/1ECO35_2022_2/lab7") )




#Pregunta 1
# Establecemos las bases que usaremos enaho01_19 y enaho34_19

enaho01_2019 <- read_dta("../../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")

enaho34_2019 <- read_dta("../../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

#Establecemos las bases que usaremos enaho01_20y enaho34_20

enaho01_2020 <- read_dta("../../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

enaho34_2020 <- read_dta("../../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")

# Establecemos la base de los deflactores

deflactor_temporal <- read_dta("../../../datos/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")

# Hacemos el merge entre ambas

enaho_merge2019 <- merge(enaho34_2019, enaho01_2019,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T
)


enaho_merge2020 <- merge(enaho34_2020, enaho01_2020,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T
)

# Ahora, vamos a realizar el append
enaho_append <- append(enaho_merge2019, enaho_merge2020) 

#Creamose el ingreso real mensual
#Creamose el gasto real menusal
enaho_append$ingreso_mensual <- enaho_append$inghog1d / (12*enaho_append$mieperho)

enaho_append$gasto_mensual <- enaho_append$gashog2d / (12*enaho_append$mieperho)

# deflactando las variables (deflactor espacial y temporal)

# espacial
enaho_append$ingreso_mensual_defl <- enaho_append$ingreso_mensual * enaho_append$ld

enaho_append$gasto_mensual_defl <- enaho_append$gasto_mensual * enaho_append$ld






#Pregunta 2
#el salario por hora del trabajador dependiente

enaho01_500 <- read_dta("../../../2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")

# Obtenemos el salario anual del primer y segundo empleo

enaho01_500$ingreso_anual <- enaho01_500$i524e1 + enaho01_500$i538e1

# Encontramos el número de hrs trabajadas en la semana 

enaho01_500$horas_trab_sem <- enaho01_500$i513t + enaho01_500$i518

# Encontramos el salario x hora del trabajador 

enaho01_500$salarioxhora <- enaho01_500$ingreso_anual / (enaho01_500$horas_trab_sem*52)

# reemplazamos los Na por valores 0 

enaho01_500$salarioxhora[is.na(enaho01_500$salarioxhora)] = 0


#Pregunta 3
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