#####################################
#######      Grupo 6 - R      #######
#####################################

#----------------------------------------------------------------------------------------------------
##########     Pregunta 1     ##########      
########################################

#install.packages("stringr")


library(haven)  # Libreria que lee archivos como stata o spss
library(dplyr)  # para limpieza de datos
library(stringr)   # grep for regular expression
library(fastDummies) # para crear una dummy
library(srvyr)  # Libreria para declarar diseño muestral de una encuesta
library(survey) 

################################################################################
##### PRIMERO, HACIENDO MERGE: Para fijar la dirección de la base de datos

"1 - Set Directorio" 

user <- Sys.getenv("USERNAME")  

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG6") )

##### Cargamos la base de datos de ENAHO, indicando el nro de salidas para reconocer la base
"2 - Load dataset de ENAHO" 
  
enaho01 <- read_dta("../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")
  
  
enaho34 <- read_dta("../../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
  
  
enaho01<- data.frame(
    
  read_dta("../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")
 
)
  
enaho34 = data.frame(
  read_dta("../../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

##### Usando conglome para juntar las bases
"3 - conglome section" 
"Left merge"

#enaho34: master data
#enaho01: using data

##### Para $ cuando el texto finaliza con .y
enaho_merge <- merge(enaho34, enaho01,
                     by = c("conglome", "vivienda", "hogar", 
                            "ubigeo", "dominio", "estrato"),
                     all.x = T, suffixes = c("",".y") 
)

index <- grep(".y$", colnames(enaho_merge))  # Regular regular 

merge_base_2020 <- enaho_merge[, - index]

"ENAHO 2019"
enaho01_1 <- read_dta("../../../../enaho/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")

enaho34_1 <- read_dta("../../../../enaho/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")

##### Usando merge para la base
"4 - merge section"

enaho_merge <- enaho_merge[ ,c("conglome", "vivienda", "hogar" ,"ubigeo", 
                             "aÑo" , "mieperho", "inghog1d", 
                             "gashog2d", "ld") ]

################################################################################
##### SEGUNDO HACIENDO APPEND 
merge_append <-  bind_rows(merge_base_2019, merge_base_2020) # bind_rows from dyplr 

unique(merge_append$aÑo)

#rename 

merge_append <- merge_append %>% dplyr::rename(aÑo = aÑo.x,ubigeo = ubigeo.x)

# sibstr permite sustraer digitos de un string, texto, caracter

merge_append['ubigeo_dep'] = substr(merge_append$ubigeo, 1, 2)

################################################################################
##### TERCERO HACIENDO LA DEFLACTACIÓN

deflactores_base2020_new <- read_dta("../../../../enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")

deflactores_base2020_new <- deflactores_base2020_new %>% dplyr::rename(aÑo = aniorec)

"4 - Merge section deflactores"

# Se aplica el merge, utilizando las llaves para variables dpto y aniorec. 
#merge_append: master data
#deflactores_base2020_new: using data

enaho_merge_defla <- merge(merge_append, deflactores_base2020_new,
                           by = c("dpto", "aÑo"),
                           all.x = T, suffixes = c("","")
)

colnames(enaho_merge_defla)

enaho_merge_defla <- enaho_merge_defla %>%
  mutate(ingreso_month_pc = enaho_merge_defla$inghog1d/(12*enaho_merge_defla$mieperho*enaho_merge_defla$ld*enaho_merge_defla$i00),
         gasto_month_pc = enaho_merge_defla$gashog2d/(12*enaho_merge_defla$mieperho*enaho_merge_defla$ld*enaho_merge_defla$i00)
  )

names(deflactores_base2020_new)

#----------------------------------------------------------------------------------------------------
##########     Pregunta 2     ##########      
########################################

################################################################################
##### PRIMERO, HACIENDO EL GROUP BY

##### Se importan las librearias necesarias 

library(haven)  
library(dplyr)  
library(stringr)   
library(fastDummies) 
library(srvyr)  
library(survey)

##### Se hace el set para el directorio

user <- Sys.getenv("USERNAME")  

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG6") ) # set directorio

##### Indicamos para que lea la base de datos

enaho_2 <-  read_dta(r"../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")

##### Hacemos un avistamiento a la base de datos

enaho_2$dominio

enaho_2 <- data.frame(
  
  read_dta("../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")
  
)

##### Antes del groupby analizamos cuáles son los labels de la base

names(enaho_2)

##### Hacemos la seleccion de las variables a utilizar

hogares <- enaho_2[ , c("conglome", "vivienda", "hogar", "p208a") ]

##### Hacemos el merge con modulo 34 para hallar datos que no tenemos como pobreza

##### ENTONCES, primero se carga la base de datos el modulo 34 y obtenemos los labels

enaho34 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

names(enaho34)

##### LUEGO, filtramos la base mediante groupby para solo quedarse con lo necesario, es decir pobreza

hogares34 <- enaho34[ , c("conglome", "vivienda", "hogar", "pobreza") ]

##### LUEGO, efectuamos merge entre hogares 34 y hogares

enaho_merge <- merge(hogares, hogares34,
                     by = c("conglome", "vivienda", "hogar")
)

print (enaho_merge)

##### PARA IR FINALIZANDO, se crea la dummy para verificar si hogar es: pobre y con algun miembro de hogar mayor a 65 años

enaho_merge['dummypension'] <- (enaho_merge['p208a'] >= 65) & (enaho_merge['pobreza'] < 3)*1
## Se puede obtener la dummy mediante la funci?n if_else(), as.numeric() o multiplicando por 1 lo que deseamos evaluar, 
## en este caso, pobreza del hogar y el requisito de la edad.


##### FINALMENTE, vemos la dummy, donde ser true (=1) refiere que si se cumplen ambas condiciones 
# y false (=0) si no se cumplen ambas condiciones

print(enaho_merge['dummypension'])

#----------------------------------------------------------------------------------------------------
##########     Pregunta 3     ##########      
########################################

################################################################################
##### HACIENDO Indicadores ######

##### Primero importamos las librerias
library(haven)
library(dplyr)
library(stringr)
library(fastDummies)
library(srvyr)  # q nos permite declarar como una encuesta
library(survey)

#especificamos el tamaño muestral de la encuesta
#seteamos el directorio

user <- Sys.getenv("USERNAME")

setwd( paste0("C:/Users/",user,"/Documents/data_enaho") ) 

#cargamos la base de datos de la ENAHO a utilizar

enaho37 = data.frame(
  read_dta("C:/Users/User/Documents/enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta")
)

#para facilidad del ejercicio, creamos la variable ubigeo_dep y les asignamos nombre sengun su numero de ubigeo

enaho37['ubigeo_dep'] = substr(enaho37$ubigeo, 1, 2)

#sesustrae los primero ceros de la varaible ubigeo ya que se repite en cada categoria
enaho37['ubigeo_dep_2'] = paste(substr(enaho37$ubigeo,1,2),
                                "0000", sep = "")

#luego se filtran los ultimos numeros, lo cual nos permitiran indicar cuales son los nombres de las regiones dentro del analisis muestral
enaho37 <- enaho37 %>%  filter(
  enaho37$ubigeo_dep  %in% c("15","03","04","12") ) 

enaho37 <- enaho37 %>% 
  mutate(region = case_when(ubigeo_dep == "04" ~ "Arequipa",
                            ubigeo_dep == "03" ~ "Apurimac",
                            ubigeo_dep == "12" ~ "Junin",
                            ubigeo_dep == "15" ~ "Lima") ) 

#Ahora delimitaremos a las variables que nos resultan importante en este ejercicio

enaho37 <- enaho37[, c("conglome", "vivienda", "hogar", "ubigeo", "dominio", "estrato", "ubigeo_dep", "p710_04")]

#hallamos el porcentaje de horgares a nivel departamental que se benefica del programa en base a la variable hallada anteriormente

survey_enaho <- enaho37  %>% as_survey_design(ids = conglome, strata = estrato, 
                                              ubication = ubigeo_dep)

ind1 <- survey_enaho %>%  dplyr::filter(p710_04=1) %>%
  
  mutate( 
    g1 = ifelse(p710_04=1), 
    
  )  %>%  group_by(ubigeo_dep) %>%   
  
  sumarise(
    gp1 = sum(g1), hogar = n(),
    g_percent = gp1/hogar
  )

##### Para la segunda parte del ejercicio cargamos las bases de datos del modulo 37, es decir sumaria-2020.dta y sumaria-2020-12g.dta

enaho34 = data.frame(
  read_dta("C:/Users/User/Documents/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

enaho34_12g = data.frame(
  read_dta("C:/Users/User/Documents/enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020-12g.dta")
)

#####Realizamos un merge completo para crear una base de datos que contenga las varaibles tanto de la base de sumaria-2020 y sumaria-2020-12g
#### Por lo que lo haremos en funcion de ls variables que se repiten en ambas base de datos: "conglome", "vivienda" y "hogar"

enaho_merge_outer <- merge(enaho34, enaho34_12g,
                           by = c("conglome", "vivienda", "hogar"),
                           all.x = T, all.y = T)


  