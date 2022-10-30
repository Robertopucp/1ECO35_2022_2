### Pregunta 2 #### Grupo 9 ####
#library(tidyverse) # dplyr, ggplot2, tdyr

pacman::p_load(haven,dplyr, stringr)

"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Grupo9") )

"2.0 Cargar dataset de ENAHO"

enaho_2020 <- read_dta("../../enaho/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")

"3.0 Extraer variables"

enaho_20 <-  enaho_2020[ ,c('i524e1', 'i538e1', 'i513t' ,
                        'i518') ]

"4.0 Reemplazar na a ceros"
any(is.na(enaho_2020))  # al menos una observación es Missing
sum(is.na(enaho_2020))  # hay missing

enaho_2020[is.na(enaho_2020)] <- 0
ifelse(is.na(enaho_2020),0,enaho_2020)     # reemplazar a O en caso haya na
enaho_2020 <- mutate_all(enaho_2020, ~replace(., is.na(.), 0)) 
modified_enaho_2020 <- replace(enaho_2020,is.na(enaho_2020),0) # using replace method change the na value to 0

print("modified_enaho_2020")

"5.0 Suma de variables"
enaho_2020['salrioxhora'] = enaho_2020['i524e1']+ enaho_2020['i538e1']
enaho_2020['salrioxhora01'] = enaho_2020['i513t']+ enaho_2020['i518']


wxhr = enaho_2020['salrioxhora'] / (enaho_2020['salrioxhora01']*52)             #salario por hora del trabajador dependiente
wxhr 

"6.0 Convertir variables"
# using replace method change the na value to 0
wxhr01 <- replace(wxhr,0, 'NA')
wxhr01 #observar el salario por hora del trabajador dependiente, ya con los valores cambiados a NaN