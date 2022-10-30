####GRUPO 2
####CURSO: R Y PYTHON
####WG6


#############################EJERCICIO 1#########################
##################################################################


#Llamo paquetes necesarios
pacman::p_load(haven,dplyr, stringr, srvyr)

#Fijar directorio 

user <- Sys.getenv("USERNAME")  

setwd( paste0("C:/Users/",user,"/Documents/GitHub/My-scripts/Lab7") ) 

#Importar bases de datos

#2019
enaho01_2019 = data.frame(
  
  read_dta("../data_extra/enaho/2019/687-Modulo01/enaho01-2019-100.dta")
  
) #Modulo 1

enaho34_2019 = data.frame(
  read_dta("../data_extra/enaho/2019/687-Modulo34/sumaria-2019.dta")
) #Modulo 34

#2020
enaho01_2020 = data.frame(
  
  read_dta("../data_extra/enaho/2020/737-Modulo01/enaho01-2020-100.dta")
  
) #Modulo 1

enaho34_2020 = data.frame(
  read_dta("../data_extra/enaho/2020/737-Modulo34/sumaria-2020.dta")
) #Modulo 34

#Base de los deflactores

base_deflactor = data.frame(
  read_dta("../data_extra/enaho/2020/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")
) 

#Seleccionar variables que usaremos, principalmente los identificadores, miembros del hogar, ingreso, gasto y deflactores


enaho34_2019 <- enaho34_2019[ , c("aÑo", "conglome", "vivienda", "hogar",
                                  "ubigeo", "dominio" ,"estrato", "mieperho", "inghog1d", "gashog2d", "ld")]

enaho34_2020 <- enaho34_2020[ , c("aÑo", "conglome", "vivienda", "hogar",
                                  "ubigeo", "dominio" ,"estrato", "mieperho", "inghog1d", "gashog2d", "ld")]

base_deflactor <- base_deflactor[ , c("dpto", "i00", "aniorec")]

#---------- MERGE DE LAS BASES DE CADA AÑO-----------------------------------------

#2019
#Merge entre las bases enaho01_2019 y enaho34_2019, a travès de los identificadores conglome, vivienda y hogar. 
#Asimismo, la nueva base tendra todas las variables y observaciones asi no haya match y aquellas que tengan nombres repetidos y pertenezcan a la segunda base tendran el sufijo .y. 
enaho2019_merge <- merge(enaho01_2019, enaho34_2019,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T, all.y = T, suffixes = c("",".y")
)

colnames(enaho2019_merge)

#Elimino aquellas columnas que tengan el sufijo .y 
index <- grep(".y$", colnames(enaho2019_merge))

enaho_2019 <- enaho2019_merge[, - index]
colnames(enaho_2019)

#2020
#Realizo el merge con el mismo proceso de las bases del año 2019. 
enaho2020_merge <- merge(enaho01_2020, enaho34_2020,
                         by = c("conglome", "vivienda", "hogar"),
                         all.x = T, all.y = T, suffixes = c("",".y")
)

colnames(enaho2020_merge)

#Elimino aquellas variables con el sufijo .y
index1 <- grep(".y$", colnames(enaho2020_merge))

enaho_2020 <- enaho2020_merge[, - index1]
colnames(enaho_2020)

#Append de mis 2 bases, primero que aparesca la del año 2019 y luego la del año 2020

merge_append <-  bind_rows(enaho_2019, enaho_2020) 

unique(merge_append$aÑo)


#Se obtiene variable para  dpto ya que nos servirà para hacer el proximo merge
#Para ello, se extrae desde la posición 1, los 2 primeros digitos.

merge_append['departamento'] = substr(merge_append$ubigeo, 1, 2)

#Corroboramos las clases de cada variable de departamento en nuestras bases para hacer el merge
class(merge_append$departamento)
class(base_deflactor$dpto)
#Sin embargo, se obtiene que la primera es caracter y la segunda es numeric.

#Entonces, pasamos nuestra variable departamento de caracter a nùmero, así se podrá realizar mejor el merge.
merge_append$departamento <- as.numeric(merge_append$departamento)
class(merge_append$departamento) #ahora es numeric

#Merge con la base del deflactor
#Se indica que se realice el merge a travès de variables con distintos nombres, y que se quede con las observaciones de la primera base(merge_append).
base_enaho <- merge(merge_append, base_deflactor,
                    by.x = c("departamento", "aÑo"),
                    by.y = c("dpto", "aniorec"),
                    all.x = TRUE)

unique(base_enaho$aÑo)
colnames(base_enaho)

#Selecciono aquellas variables que usaré
base_enaho <- base_enaho[ , c( "departamento", "aÑo", "conglome", "vivienda", "hogar",
                               "ubigeo", "dominio" ,"estrato", "mieperho", "inghog1d", "gashog2d", "ld", "i00")]

#Por último hallo mis ingresos y gastos del ejercicio.
#Dividir las variables de ingreso y gasto por mieperho, 12, ld e i00

#Primero con el Ingreso
#ingreso bruto anual del hogar entre numero de miembros del hogar
base_enaho['ing_per1'] = base_enaho$inghog1d / base_enaho$mieperho
#ingreso bruto anual del hogar entre 12
base_enaho['ing_per2'] = base_enaho$inghog1d / base_enaho$ld
#ingreso bruto anual del hogar entre el deflactor espacial
base_enaho['ing_per3'] = base_enaho$inghog1d / 12
#ingreso bruto anual del hogar entre el deflactor temporal
base_enaho['ing_per4'] = base_enaho$inghog1d / base_enaho$i00

#Luego con el gasto
#gasto bruto anual del hogar entre miembros del hogar
base_enaho['gasto_per1'] = base_enaho$gashog2d / base_enaho$mieperho
#gasto bruto anual del hogar entre 12
base_enaho['gasto_per2'] = base_enaho$gashog2d / base_enaho$ld
#gasto bruto anual del hogar entre el deflactor espacial
base_enaho['gasto_per3'] = base_enaho$gashog2d / 12
#gasto bruto anual del hogar entre el delfactor temporal
base_enaho['gasto_per4'] = base_enaho$gashog2d / base_enaho$i00


#Extraer base de datos nueva
write_dta(base_enaho, "../data_extra/enaho/WG6_1_r.dta")


############################RESOLUCIÓN DEL EJERCICIO 2############################
#Importamos lo necesario para realizar el ejercicio

library(haven)  # leer archivos spss, stata, dbf, etc
library(dplyr)  # limpieza de datos
library(stringr)   # grep for regular expression
library(fastDummies) # crear dummy
library(srvyr)  # libreria para declarar el diseño muestral de una encuesta
library(survey)


#Realizamos los siguientes pasos para importar la data de ENAHO 2020, módulo 5 de empleo 

"Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/Quispe_Angie_Rep") ) # set directorio


"Creamos el dataset de ENAHO"

enaho01 <- read_dta("C:/Users/MSI/Documents/GitHub/Quispe_Angie_Rep/enaho01a-2020-500.dta")


# tibble dataset

enaho01$dominio

enaho01 <- data.frame(
  
  read_dta("../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-500.dta")
  
)

#data.frame dataset 

enaho01
enaho01$dominio

#Reviso los nombres de mi data para asegurarme que se encuentran las variable
#que necesito

enaho01$estrato  %>% attr('labels') # value labels


enaho01$factor07 %>% attr('label') # var label

names(enaho01)


# Selecciono las variables que utilizaré 

enaho01 <- enaho01[ , c("conglome", "vivienda", "hogar" , "codperso",
                        "ubigeo", "dominio" ,"estrato" , "i524e1" ,
                        "i538e1") ]

names(enaho01)

#Ahora, pasamos a los cálculos para poder hallar los ingresos por horas
#Primero, el ingreso anual del principal y segundo empleo del trabajador dependiente son 
#i524e1 i538e1 respectivamente

enaho01 <- enaho01 %>%
  mutate(ingreso_pc = enaho01$i524e1 + enaho01$i538e1) %>%
  
  #Para los ingresos por hora, el dato anterior hallado "ingresos_ suma" lo dividimos por 
  #la cantidad de horas trabajados en el principal y segundo empleo en la semana, i513t+ i518
  #respectivamente
  #Finalmente, se divide por 52, pues el año tiene 52 semanas.  
  
  enaho01 <- enaho01 %>%
  mutate(ingreso_hora=sum(i524e1+i538e1, na.rm = T)/sum((i513t+i518)/52, na.rm = T) %>%
           

############# EJERCICIO 4 ########################
         
########################### Problema Indicadores (Solo en R) ###########################

# Primero, especifique el diseño muestral de su encuesta.

# Use el modulo 37 (enaho01-2020-700) y a partir de la variable p710_04 (algún miembro del hogar es beneficiario del programa juntos en los últimos 3 años), halle el porcentaje que hogares a nivel departamental (o región) que se beneficia del programa.

# Se procede a instalar los packages
install.packages("srvyr")
install.packages("dplyr")
install.packages("grid")
install.packages("read_dta")

#Librerias de limpieza de datos 
install.packages("pacman")
pacman::p_load(haven,dplyr, stringr, fastDummies)

library(haven)  # leer archivos spss, stata, dbf, etc
library(dplyr)  # limpieza de datos
library(stringr)   # grep for regular expression
library(fastDummies) # crear dummy
library(srvyr)  # libreria para declarar el diseño muestral de una encuesta
library(survey)


# Setear directorio
"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data/") ) # set directorio

# Se procede a usar el modulo 37 (enaho01-2020-700)
enaho37 <- read_dta("/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data/enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta")
print(enaho37)


### Ubigeo de departamento

# sibstr permite sustraer digitos de un string, texto, caracter

enaho37['ubigeo_dep'] = substr(enaho37$ubigeo, 1, 2)

# a aprtir de  la posición inicial, extraer los dos primeros digitos

enaho37['ubigeo_dep_2'] = paste(substr(enaho37$ubigeo,1,2),
                                        "0000", sep = "")
print(enaho37['ubigeo_dep_2'])

### filtrado para algunos departamentos

enaho37  <- enaho37 %>% filter(
  enaho37$ubigeo_dep  %in% c("01","02","03","04","05","06","07","08","09","10","11","12",
                             "13","14","15","16","17","18","19","20","21","22","23","24","25","26") ) 

#library(dplyr)

enaho37  <- enaho37  %>% 
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
                            ubigeo_dep == "25" ~ "Ucayali") ) 


# Filtrar variable p710_04 
# (Algún miembro del hogar es beneficiario del programa juntos en los últimos 3 años), // Solo al jefe del hogar a nivel hogar
# Halle el porcentaje que hogares a nivel departamental (o región) que se beneficia del programa.
# Extraer primeros dígitos ()
enaho37 <- enaho37[enaho37$p710_04] #Considerar a beneficiarios y no beneficiarios

colnames(enaho37)

index = grep("(p710_04)|(aÑo)|(ubigeo_dep)",
             colnames(enaho37))

# group by a nivel departamental (con el nuevo código)/ la media a esaa variable.
  
print(colnames(enaho37)[index])

table(enaho37$p710_04)

enaho37 %>% dplyr::filter(!is.na(p710_04)) %>%  group_by(p710_04) %>% summarise(Freq.abs = n()) %>% 
  mutate(Freq.relative = (Freq.abs/sum(Freq.abs))*100) %>% arrange(desc(Freq.relative))  
# Esto nos arroja una tabla de frecuencias absolutas y relativas con los siguientes valores para los
# Beneficiarios del programa Juntos son cerca de 4946 beneficiarios.

# pj1 significa programa juntos
pj1 <- enaho37 %>% group_by(ubigeo_dep, aÑo) %>% 
  summarise(
    pj1_min = min(p710_04),
    pj1_sum = sum(p710_04), total_miembros = n(),
    pj1_max = max(p710_04), .groups = "keep"
  )

# sin considerar los missing 

pj1_no_missing <- enaho37 %>% group_by(ubigeo_dep, aÑo ) %>% 
  summarise(
    pj1_min = min(p710_04, na.rm = TRUE),
    pj1_sum = sum(p710_04, na.rm = T), total_miembros = n(),
    pj1_max = max(p710_04, na.rm = T), 
  )


# Explícitamente, la advertencia surge por que se están agrupando por varias variables. 
# Para evitar el mensaje, debemos incluir el argumento .groups = "keep"

pj2 <- enaho37 %>% group_by(ubigeo_dep, aÑo  ) %>% 
  summarise(
    pj2_min = min(p710_04, na.rm = TRUE),
    pj2_sum = sum(p710_04, na.rm = T), total_miembros = n(),
    pj2_max = max(p710_04, na.rm = T), .groups = "keep"
  )


pj3 <- enaho37 %>% group_by(ubigeo_dep) %>% 
  summarise(index_projuntos = mean(pj2 , na.rm = T), .groups = "keep" ) 

class(enaho37$p710_04)

# Para el 2020 según las tablas de la parte superior para la Región de
#Para la región de "01" ~ "Amazonas", el porcentaje es de 33% de beneficiarios
#Para la región de  "02" ~ "Ancash",el porcentaje es de 18% de beneficiarios
#Para la región de  "03" ~ "Apurimac",el porcentaje es de 34% de beneficiarios
#Para la región de "04" ~ "Arequipa",el porcentaje es de 2% de beneficiarios
#Para la región de "05" ~ "Ayacucho",el porcentaje es de 26% de beneficiarios
#Para la región de  "06" ~ "Cajamarca",el porcentaje es de 31% de beneficiarios
#Para la región de  "07" ~ "Callao",el porcentaje es de 1% de beneficiarios
#Para la región de "08" ~ "Cusco",el porcentaje es de 21% de beneficiarios
#Para la región de  "09" ~ "Huancavelica",el porcentaje es de 39% de beneficiarios
#Para la región de  "10" ~ "Huanuco",el porcentaje es de 31% de beneficiarios
#Para la región de "11" ~ "Ica",el porcentaje es de 1% de beneficiarios
#Para la región de "12" ~ "Junin",el porcentaje es de 11% de beneficiarios
#Para la región de "13" ~ "La Libertad",el porcentaje es de 15% de beneficiarios
#Para la región de  "14" ~ "Lambayeque",el porcentaje es de 2% de beneficiarios
#Para la región de "15" ~ "Lima",el porcentaje es de 1% de beneficiarios
#Para la región de  "16" ~ "Loreto",el porcentaje es de 30% de beneficiarios
#Para la región de  "17" ~ "Madre de Dios",el porcentaje es de 3% de beneficiarios
#Para la región de "18" ~ "Moquegua",el porcentaje es de 1% de beneficiarios
#Para la región de  "19" ~ "Pasco",el porcentaje es de 37% de beneficiarios
#Para la región de "20" ~ "Piura",el porcentaje es de 20% de beneficiarios
#Para la región de  "21" ~ "Puno",el porcentaje es de 19% de beneficiarios
#Para la región de  "22" ~ "San Martín",el porcentaje es de 16% de beneficiarios
#Para la región de "23" ~ "Tacna",el porcentaje es de 3% de beneficiarios
#Para la región de "24" ~ "Tumbes",el porcentaje es de 1% de beneficiarios
#Para la región de  "25" ~ "Ucayali" , el porcentaje es de 5% de beneficiarios

enaho37 %>% dplyr::filter(!is.na(p710_04)) %>%  group_by(p710_04) %>% summarise(total_miembros = n()) %>% 
  mutate(Porcentaje.projun = (total_miembros/sum(pj2))*100) %>% arrange(desc(Porcentaje.projun))  

survey_enaho37 <- svydesign(id=~ubigeo_dep, weights=~p710_04,strata=~estrato, data=enaho34)

# Ahora la segunda parte
# Del módulo 34 y la base de datos sumaria-2020, muestre el promedio del porcentaje de gasto en salud realizado por los hogares a nivel de región (o departamentos).
enaho34 <- read_dta("/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
print(enaho34)


### Luego, se procede a plantear la variable  Ubigeo de departamento

# sibstr permite sustraer digitos de un string, texto, caracter

enaho34['ubigeo_dep'] = substr(enaho34$ubigeo, 1, 2)

# a aprtir de  la posición inicial, extraer los dos primeros digitos

enaho34['ubigeo_dep_2'] = paste(substr(enaho37$ubigeo,1,2),
                                "0000", sep = "")
print(enaho34['ubigeo_dep_2'])

### filtrado para algunos departamentos

enaho34  <- enaho34 %>% filter(
  enaho34$ubigeo_dep  %in% c("01","02","03","04","05","06","07","08","09","10","11","12",
                             "13","14","15","16","17","18","19","20","21","22","23","24","25","26") ) 

#library(dplyr)

enaho34  <- enaho34  %>% 
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
                            ubigeo_dep == "25" ~ "Ucayali") ) 


# Para hallar el porcentaje del gasto anual del hogar destinado a la salud divida gru51hd por gashog2d.


# Se propone esta referenciaa gru51hd/gashoh2d

enaho34 <- enaho34 %>%
  dplyr::mutate(gasto_annual_salud = gru51hd/(100*gashoh2d)
               
print(enaho34['gasto_annual_salud'])
                
#creando dummies usando la variabe de nivel educativo alcanzado p301a

enaho34 <- dummy_cols(enaho34, select_columns = 'gru51hd')


View(enaho34[, c("gru51hd","gashoh2d")])
                
              
# Nota: debe aplicar las librerias dplyr y srvyr

# A continuación los 8 grupos de gasto clasificados por INEI. En la base de datos sumaria-2020-12g se muestra la agrupación en 12 grupos.

# gru11hd: gasto anual en alimentos
# gru21hd: gasto anual en vestido y calzado
# gru31hd: gasto anual en Alquiler de vivienda, Combustible, Electricidad y Conservación de la Vivienda
# gru41hd: gasto anual en Muebles, Enseres y Mantenimiento de la vivienda
# gru51hd: gasto anual en Cuidado, Conservación de la Salud y Servicios Médicos
# gru61hd: gasto anual en Transporte
# gru71hd: gasto anual en Esparcimiento
# gru81hd: gasto anual en Otros bienes y servicios





