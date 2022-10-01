################  laboratorio 7 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 
## Clean dataset

#install.packages("pacman")
#install.packages("fastDummies")

#Librerias de limpieza de datos 

#pacman::p_load(haven,dplyr, stringr, fastDummies)

library(haven)
library(dplyr)
library(stringr)   # grep 
library(fastDummies)


# tydiverse: ggplot , dplyr other libraries


"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab7") ) # set directorio


"2.0 Load dataset de ENAHO"

enaho01 <- read_dta("../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

# tibble dataset

enaho01$dominio

enaho01 <- data.frame(
  
  read_dta("../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")
  
)

#data.frame dataset 

enaho01
enaho01$dominio

# Check labels

# %>% Ctrl + shift + m  

enaho01$p110 %>% attr('labels') # value labels


enaho01$p110 %>% attr('label') # var label


"Módulo02"

enaho02 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")
)

enaho03 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo03/737-Modulo03/enaho01a-2020-300.dta"))

enaho04 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo04/737-Modulo04/enaho01a-2020-400.dta")
)

enaho05 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")
)

enaho34 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")
)

enaho37 = data.frame(
  read_dta("../../../enaho/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta")
)




# Seleccionar variables 



enaho02 <- enaho02[ , c("conglome", "vivienda", "hogar" , "codperso",
                       "ubigeo", "dominio" ,"estrato" ,"p208a", "p209",
                       "p207", "p203", "p201p" , "p204",  "facpob07") ]


enaho03 <- enaho03[ , c("conglome", "vivienda", "hogar" , "codperso",
                        "p301a", "p301b", "p301c" , "p300a")]

enaho05 <- enaho05[ , c("conglome", "vivienda", "hogar" , "codperso",
                        "i524e1", "i538e1", "p558a5" , "i513t", "i518",
                        "p507", "p511a", "p512b", "p513a1", "p505" , "p506", "d544t", "d556t1",
                        "d556t2" , "d557t" , "d558t" , "ocu500" , "i530a" , "i541a")]

#----------------------------------------------------------
# 3.0 Merge section #

# Merge identifica automaticamente los casos de merge m:1, 1:1, 1:m



# _merge3 == 1

"Left merge"

#enaho02: master data
# enaho01: using data

enaho_merge <- merge(enaho02, enaho01,
                   by = c("conglome", "vivienda", "hogar"),
                   all.x = T
                   )

enaho_02_05 <- merge(enaho02, enaho05,
                     by = c("conglome", "vivienda", "hogar","codperso"),
                     all.x = T
)


# by: variable que permite identificar las observaciones en común en las bases de datos
# all.x : La base de datos preservará todas las observaciones de left data (enaho02)
# all.x tiene como valor predeterminado a False. 


# all.x = False, all.y = False

# _merge3 == 2


enaho_02_05 <- merge(enaho02, enaho05,
                     by = c("conglome", "vivienda", "hogar","codperso"),
                     all.y = TRUE
                      )


# _merge3 == 3 (match inner)

enaho_merge_inner <- merge(enaho02, enaho01,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = F, all.y = F
                       )



enaho_merge_inner <- merge(enaho02, enaho01,
                     by = c("conglome", "vivienda", "hogar")
                  )

enaho_merge_02_05 <- merge(enaho02, enaho05,
                           by = c("conglome", "vivienda", "hogar","codperso")
)


# Match outer 


enaho_merge_outer <- merge(enaho02, enaho05,
                           by = c("conglome", "vivienda", "hogar","codperso"),
                           all.x = T, all.y = T
)


enaho_merge_outer_2 <- merge(enaho02, enaho05,
                           by = c("conglome", "vivienda", "hogar","codperso"),
                           all=  T
)



# suffixes

enaho_merge <- merge(enaho02, enaho01,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T
)


names(enaho_merge)



enaho_merge <- merge(enaho02, enaho01,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T, suffixes = c("","")
                      )

enaho_merge <- merge(enaho02, enaho01,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T, suffixes = c("",".y")
)


names(enaho_merge)

#------------------------- Match with different keyword -------------------------


# rename variables que identifican de manera unica a cada hogar

enaho05 <- enaho05 %>% rename(Conglo = conglome, viv = vivienda,
                              hog = hogar, cod = codperso)

enaho_02_05 <- merge(enaho02, enaho05,
                     by.x = c("conglome", "vivienda", "hogar","codperso"),
                     by.y = c("Conglo", "viv", "hog","cod"),
                     all = TRUE
)

# reset los nombre correctos de la variables que identificar cada hogar

enaho05 <- enaho05 %>% rename(conglome = Conglo, vivienda = viv,
                              hogar = hog, codperso = cod)


#---------------------- Merge in Loop ------------------------------------

# <-  shortcut Alt + - 

num = list(enaho34 , enaho37) # lista de data.frames

merge_hog = enaho01 # Master Data

for (i in num){

  merge_hog <- merge(merge_hog, i,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T, suffixes = c("",".y")
                     )
}

names(merge_hog)



# Individual dataset

num = list(enaho03 , enaho04, enaho05 ) # lista de data.frames

merge_ind = enaho02 # Master Data

for (i in num){
  
  merge_ind <- merge(merge_ind, i,
                     by = c("conglome", "vivienda", "hogar","codperso"),
                     all.x = T, suffixes = c("",".y")
  )
}

names(merge_ind)


#----------------------------------------------------------

# merge merge_hog and merge_ind
# mwrge_ind : master data

merge_base <- merge(merge_ind, merge_hog,
                   by = c("conglome", "vivienda", "hogar"),
                   all.x = T, suffixes = c("",".y"))


colnames(merge_base)

index <- grep(".y$", colnames(merge_base))  # Regular regular 

index
class(index)

# $ el texto finaliza con .y


merge_base_2020 <- merge_base[, - index]

colnames(merge_base_2020)



#----------------------------------------------------------

"ENAHO 2019"

enaho01 <- data.frame(
  read_dta("../../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")
)

enaho02 = data.frame(
  read_dta("../../../datos/2019/687-Modulo02/687-Modulo02/enaho01-2019-200.dta")
)

enaho03 = data.frame(
  read_dta("../../../datos/2019/687-Modulo03/687-Modulo03/enaho01a-2019-300.dta"))

enaho04 = data.frame(
  read_dta("../../../datos/2019/687-Modulo04/687-Modulo04/enaho01a-2019-400.dta")
)

enaho05 = data.frame(
  read_dta("../../../datos/2019/687-Modulo05/687-Modulo05/enaho01a-2019-500.dta")
)

enaho34 = data.frame(
  read_dta("../../../datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")
)

enaho37 = data.frame(
  read_dta("../../../datos/2019/687-Modulo37/687-Modulo37/enaho01-2019-700.dta")
)


# Seleccionar variables 


enaho02 <- enaho02[ , c("conglome", "vivienda", "hogar" , "codperso",
                        "ubigeo", "dominio" ,"estrato" ,"p208a", "p209",
                        "p207", "p203", "p201p" , "p204",  "facpob07")]

enaho03 <- enaho03[ , c("conglome", "vivienda", "hogar" , "codperso",
                        "p301a", "p301b", "p301c" , "p300a")]

enaho05 <- enaho05[ , c("conglome", "vivienda", "hogar" , "codperso",
                        "i524e1", "i538e1", "p558a5" , "i513t", "i518",
                        "p507", "p511a", "p512b", "p513a1", "p505" , "p506", "d544t",
                        "d556t1",
                        "d556t2" , "d557t" , "d558t" , "ocu500" , "i530a" , "i541a")]

#-------------------------------------------------------


num = list(enaho34 , enaho37) # lista de data.frames

merge_hog = enaho01 # Master Data

for (i in num){
  
  merge_hog <- merge(merge_hog, i,
                     by = c("conglome", "vivienda", "hogar"),
                     all.x = T, suffixes = c("",".y")
  )
}

# Individual dataset

num = list(enaho03 , enaho04, enaho05 ) # lista de data.frames

merge_ind = enaho02 # Master Data

for (i in num){
  
  merge_ind <- merge(merge_ind, i,
                     by = c("conglome", "vivienda", "hogar","codperso"),
                     all.x = T, suffixes = c("",".y")
  )
}

#----------------------------------------------------------

merge_base <- merge(merge_ind, merge_hog,
                    by = c("conglome", "vivienda", "hogar"),
                    all.x = T, suffixes = c("",".y"))

index <- grep(".y$", colnames(merge_base))


merge_base_2019 <- merge_base[, - index]


### Ubigeo de departamento


merge_base_2020['ubigeo_dep'] = substr(merge_base_2020$ubigeo, 1, 2)

merge_base_2020['ubigeo_dep_2'] = paste(str_sub(merge_base_2020$ubigeo,1,2),
                                        "00", sep = "")

### filtrado para algunos departamentos

merge_base_2020 <- merge_base_2020 %>%  filter(
  merge_base_2020$ubigeo_dep  %in% c("15","03","04","12") )



#----------------------- Append -----------------------------------


merge_append <-  bind_rows(merge_base_2020, merge_base_2019)

# bind_rows from dplyr library 


write_dta(merge_append, "../data/append_enaho_r.dta")


#------------------------ Poverty and dummies -------------------------------

#dplyr

merge_base_2020 <- merge_base_2020 %>%
  mutate(ingreso_month = merge_base_2020$inghog1d/(12*merge_base_2020$mieperho),
         gasto_month = merge_base_2020$gashog2d/(12*merge_base_2020$mieperho)
         ) %>%
 mutate(dummy_pobre = ifelse( merge_base_2020$gasto_month < merge_base_2020$linea , 
                        1 , 
                        ifelse(!is.na(merge_base_2020$gashog2d),0, NA) ) )  %>%
  mutate(pobre = ifelse( merge_base_2020$gasto_month < merge_base_2020$linea , 
                               "pobre" , 
                  ifelse(!is.na(merge_base_2020$gashog2d),"No pobre", NA) ) )   %>%
 mutate(pc_pobre = case_when(merge_base_2020$pobreza == 1 ~ "Pobre extremo",
                             merge_base_2020$pobreza == 2 ~ "Pobre",
                             merge_base_2020$pobreza == 3 ~ "No pobre"))  



#creando dummies usando la variabe de nivel educativo alcanzado p301a

merge_base_2020 <- dummy_cols(merge_base_2020, select_columns = 'p301a')


merge_base_2020$p301a


View(merge_base_2020[, c("p301a","p301a_1","p301a_2","p301a_3","p301a_4","p301a_5")])



#----------------------------------------------------------------------
################ Colappse #############################################


# Tab in R from dplyr library

count(merge_base_2020, pobreza, sort = TRUE)

count(merge_base_2020, pobreza, sort = F)



df1 <- merge_base_2020 %>% group_by(conglome, vivienda, hogar ) %>% 
  summarise(
    edu_min = min(p301a, na.rm = TRUE),
    sup_educ = sum(p301a_10, na.rm = T), total_miembros = n(),
    edu_max = max(p301a, na.rm = T)
  )

# La advertencia surge por que se están agrupando por varias variables

df1_1 <- merge_base_2020 %>% group_by(conglome, vivienda, hogar ) %>% 
  summarise(
    edu_min = min(p301a, na.rm = TRUE),
    sup_educ = sum(p301a_10, na.rm = T), total_miembros = n(),
    edu_max = max(p301a, na.rm = T), .groups = "keep"
  )


# na.rm permite ignorar los missing en las operaciones mean, sum, max


df2 <- merge_base_2020 %>% group_by(ubigeo_dep) %>% 
  summarise(index_poverty = mean(dummy_pobre) )


#referecnes:#

"Haven documentation"


