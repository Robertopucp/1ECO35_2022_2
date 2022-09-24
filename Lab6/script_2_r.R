################  laboratorio 6 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 



pacman::p_load(tidyverse, haven, dplyr, janitor , stringr)

# haven: leer archivos spss (sav)
# string : trabajar con string



#janitor to detect duplicates

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab6") ) # set directorio

# Put relative path

file_path = "../data/enapres_2020_ch_100/736-Modulo1618/CAP_100_URBANO_RURAL_3.sav"

enapres2020_1 <- haven::read_sav(file_path , encoding = "UTF-8" )  # read dataset

head(enapres2020_1)

names(enapres2020_1) # nombre de las variables en una lista

# Observar labels 

# %>% Ctrl + shift + m

enapres2020_1$ESTRATO %>% attr('labels') # value labels


enapres2020_1$ESTRATO %>% attr('label') # var label



print(AREA)

enapres2020_1$AREA%>% attr('labels') # value labels

print(RESFIN)

enapres2020_1$RESFIN %>% attr('labels') # value labels

# 2. Check duplicates report

" %>%  Ctrol + shift + m, uso de dplyr library" 

attach(enapres2020_1)

# Filter hogares urbanos que responden toda la encuesta

enapres2020_1 <- enapres2020_1 %>% filter(RESFIN == 1 & AREA == 1)

data_filtrada <- enapres2020_1 %>% group_by(CCDD ,CCPP , CCDI ,CONGLOMERADO , NSELV, VIVIENDA, HOGAR) %>% 
  mutate(duplicates = n()) %>% filter(duplicates >1) %>%
  select(CCDD ,CCPP , CCDI ,CONGLOMERADO , NSELV, VIVIENDA, HOGAR, duplicates ) 

View(data_filtrada)



# First group by unique household identifier
# mutate() create variables
# filter duplicates 
# select unique household identifier

# Drop duplicates rows (observaciones). Se borra las copias, No las primeras apariciones

enapres2020_1_ndup <- enapres2020_1 %>% distinct(CCDD ,CCPP 
                                                 , CCDI ,CONGLOMERADO , NSELV,
                                                 VIVIENDA, HOGAR, .keep_all = TRUE)

# .keep_all = TRUE muestra todas las variables
                                                 
enapres2020_1_ndup <- enapres2020_1 %>% distinct(CCDD ,CCPP 
                                                 , CCDI ,CONGLOMERADO , NSELV,
                                                 VIVIENDA, HOGAR, .keep_all = F)

# .keep_all = FALSE Solo muestra las variables seleccionadas "CCDD ,CCPP,CCDI ,CONGLOMERADO , NSELV,VIVIENDA, HOGAR"

dim(enapres2020_1_ndup)


# Check unique values. We can se that there is missing values



enapres2020_1_ndup <- enapres2020_1_ndup %>%  mutate(Dummy_2 = ifelse(ESTRATO == 4 ,  1 , ifelse(!is.na(ESTRATO),0, NA) ) )


enapres2020_1_ndup <- enapres2020_1_ndup %>%  mutate(Dummy_3 = ifelse( ESTRATO %in% c(3,4,5) ,  1 , ifelse(!is.na(ESTRATO),0, NA) ) )


enapres2020_1_ndup 


write_sav(enapres2020_1_ndup , "../data/enapres_2020_ch_100/736-Modulo1618/df.sav")  # save in spss format 



































