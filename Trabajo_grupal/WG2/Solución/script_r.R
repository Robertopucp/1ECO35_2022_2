
#######################################
" Homework 2 - solution  "
" @author: Roberto Mendoza "
" @date: 19/09/2020 "
" @code: This code clean dataset from native Census"
#######################################


library(dplyr) # librería de limpieza de datos
library(tidyr)# librería de limpieza de datos
library(readxl) # lobreria para subir archivos excel, csv

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG2/Solución") ) # set directorio

junin_data = read_excel("../../../data/Region_Junin.xlsx")


#1. ----------- Nombre de las variables ----------------------

names(junin_data)

#2. ---------- Type de variables y estadísticas ----------


str(junin_data)
sapply(junin_data, class)
summary(junin_data) # main statistics of numeric variables 

# 3. ------- Missing values --------------

sum(is.na(junin_data)) # total missing

sapply( junin_data, function(x) sum(is.na(x)) ) # total missing by variable


# 4. ------- Change variable's name --------------

# %>%  Ctrl + shift + m (shortcut)

junin_data <- junin_data %>% rename(
                                      comunidad = Place,
                                      homxlee = men_not_read,
                                      mujerxlee = women_not_read,
                                      totalxlee = total_not_read
                                     
                                     )


# 5. ------- unique values  --------------

unique(junin_data['comunidad'])

unique(junin_data['District'])


# 6. ------- Percentage variables  --------------

junin_data['total_pob'] = junin_data['peruvian_men'] + junin_data['peruvian_women']+
                            
                               junin_data['foreign_men'] + junin_data['foreign_women']


junin_data['var_women_read'] =  junin_data$mujerxlee/junin_data$totalxlee

junin_data['var_men_read'] =  junin_data$homxlee/junin_data$totalxlee


# 7. ------- Dataset  --------------

junin_data <- junin_data[junin_data$District %in% c("CIUDAD DEL CERRO",
"JAUJA", "ACOLLA", "SAN GERÓNIMO", "TARMA", 
"OROYA","CONCEPCIÓN"),] 


junin_data <- junin_data %>% filter( junin_data$natives > 0 &  junin_data$mestizos  > 0 )

junin_data <- junin_data[,c('District','comunidad','total_pob','var_women_read','var_men_read')]

write.csv(junin_data, '../../../data/Base_cleaned.csv')

write.csv(junin_data, '../../../data/Base_cleaned.xlsx')






































































































