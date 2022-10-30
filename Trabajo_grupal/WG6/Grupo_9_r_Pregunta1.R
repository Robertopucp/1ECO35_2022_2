### Pregunta 1 #### Grupo 9 ####

pacman::p_load(haven,dplyr, stringr)


"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Grupo9") ) 


"2.0 Cargar dataset de ENAHO"

enaho01 <- read_dta("../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")
sumaria <- read_dta("../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")


"3.0 Juntar bases"

enaho_2020 <- merge(enaho01, sumaria,
                   by = c("conglome", "vivienda", "hogar"),
                   all.x = T, suffixes = c("",".y")
                   )
"4.0 Filtrar variables a usar"

enaho_2020 <- enaho_2020[ ,c("conglome", "vivienda", "hogar" ,"ubigeo", 
                   "aÑo" , "mieperho", "inghog1d", 
                   "gashog2d", "ld") ]


###### Repetir procedimiento con data 2019   ######
"2.0"
enaho01 <- read_dta("../../enaho/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")
sumaria <- read_dta("../../enaho/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")


"3.0"
enaho_2019 <- merge(enaho01, sumaria,
                    by = c("conglome", "vivienda", "hogar", 
                           "ubigeo", "dominio", "estrato"),
                    all.x = T, suffixes = c("",".y")
                    )

"4.0"
enaho_2019 <- enaho_2019[ ,c("conglome", "vivienda", "hogar" ,"ubigeo", 
                             "aÑo" , "mieperho", "inghog1d", 
                             "gashog2d", "ld") ]

###################################################

"5.0 Append de base 2019 y 2020"
enaho_append <-  bind_rows(enaho_2020, enaho_2019)

  #Año:
enaho_append <-  enaho_append %>% rename("aniorec"="aÑo")
  #Departamento:
enaho_append['dpto'] <- paste(as.numeric(substr(enaho_append$ubigeo, 1, 2)))  
      #Nota, se coloca as.numeric para convertirlo en numero y 
      #hacer merge con base de deflactor


"6.0 Deflactar las variables"
  #Deflactor espacial:
      # ld de base

  #Deflactor temporal:
deflactor <- read_dta("../../enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")
deflactor <- deflactor[ , c("dpto", "aniorec", "i00")]

  #Unir deflactor a la base principal:
enaho <- merge(enaho_append, deflactor,
               by = c( "dpto", "aniorec"),
               all.x=T)


"7.0 Dividir las variables de ingreso y gasto por mieperho, 12, ld e i00."

enaho <- enaho %>%
         mutate(
         ingreso_month_pc = enaho$inghog1d/(enaho$mieperho* enaho$ld * enaho$i00*12),
         gasto_month_pc = enaho$gashog2d/(enaho$mieperho* enaho$ld * enaho$i00*12)
         )

#Ingreso per cápita = ingreso_month_pc

#Gasto per cápita = gasto_month_pc

"8.0 Comprobación son los mismos valores que en Python"
enaho <- enaho[order(enaho$aniorec, enaho$conglome, enaho$vivienda, enaho$hogar),]
View(enaho)
