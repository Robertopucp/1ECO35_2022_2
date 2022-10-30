# TAREA 6

install.packages("fastDummies")

pacman::p_load(haven,dplyr, stringr, fastDummies)

user <- Sys.getenv("claud")

setwd( paste0("D:/PYTHON") )

# 


enaho01_2019 <- read_dta("D:/PYTHON/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")

enaho01_2020 <- read_dta("D:/PYTHON/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

enaho34_2019 <- read_dta("D:/PYTHON/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")

enaho34_2020 <- read_dta("D:/PYTHON/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")

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

# juntamos las bases 2019 y 2020, y creamos la variable "dpto" 
# a partir del ubigeo para luego aplicar el merge con deflactor_temporal

enaho_append <- bind_rows(enaho_merge2019, enaho_merge2020)
unique(enaho_append$aÑo)


enaho_append['dpto'] = substr(enaho_append$ubigeo.x, 1, 2)
class(enaho_append$dpto)
class(deflactor_temporal$dpto)

enaho_append$dpto <- as.numeric(enaho_append$dpto)
class(enaho_append$dpto)

# merge con deflactor temporal

enaho_defl <- merge(x = enaho_append, y = deflactor_temporal,
                  by.x = c("dpto", "aÑo.x"),
                  by.y = c("dpto", "aniorec"),
                  all.x = T)

unique(enaho_defl$aÑo)
colnames(enaho_defl)

# deflactamos las variables ingreso y gasto diviendolas por 
# mieperho, 12, ld, i00

  # INGRESO
enaho_defl['ingreso_perc1'] = enaho_defl$inghog1d / enaho_defl$mieperho
enaho_defl['ingreso_perc2'] = enaho_defl$inghog1d / enaho_defl$ld
enaho_defl['ingreso_perc3'] = enaho_defl$inghog1d / 12
enaho_defl['ingreso_perc4'] = enaho_defl$inghog1d / enaho_defl$i00
  
  # GASTO
enaho_defl['gasto_perc1'] = enaho_defl$gashog2d / enaho_defl$mieperho
enaho_defl['gasto_perc2'] = enaho_defl$gashog2d / enaho_defl$ld
enaho_defl['gasto_perc3'] = enaho_defl$gashog2d / 12
enaho_defl['gasto_perc4'] = enaho_defl$gashog2d / enaho_defl$i00


  # 2. SALARIO POR HORA DEL TRABAJADOR DEPENDIENTE

enaho01_500 <- read_dta("D:/PYTHON/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")

# salario anual del primer y segundo empleo

enaho01_500$ingreso_anual <- enaho01_500$i524e1 + enaho01_500$i538e1

# cantidad de hrs trabajadas a la semana 

enaho01_500$horas_trab_sem <- enaho01_500$i513t + enaho01_500$i518

# salario por hora del trabajador dependiente

enaho01_500$salarioxhora <- enaho01_500$ingreso_anual / (enaho01_500$horas_trab_sem*52)

# reemplazamos los NA por valores cero 

enaho01_500$salarioxhora[is.na(enaho01_500$salarioxhora)] = 0


  # 3. GROUPBY 

# personas con 65 o más años que puedan participar del programa Juntos
enaho01_200_2019 <- read_dta("D:/PYTHON/2019/687-Modulo02/687-Modulo02/enaho01-2019-200.dta")
enaho01_200_2020 <- read_dta("D:/PYTHON/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")

enaho_200_append <- append(enaho01_200_2019, enaho01_200_2020) 

enaho_200_append$mayor_65 <- enaho_200_append$p208a >= 65



