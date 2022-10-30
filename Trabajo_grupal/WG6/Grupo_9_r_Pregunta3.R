### Pregunta 3 #### Grupo 9 ####

#library(fastDummies) # crear dummy
#library(tidyverse) # dplyr, ggplot2, tdyr

pacman::p_load(haven,dplyr, stringr)


"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Grupo9") )


"2.0 Cargar dataset de ENAHO"

enaho02 <- read_dta("../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")
sumaria <- read_dta("../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")

"3.0 Mantener variables de interes"
enaho02 <-  enaho02[ ,c("conglome", "vivienda", "hogar" ,
                        "p208a") ]

sumaria <-  sumaria[ ,c("conglome", "vivienda", "hogar" ,
                        "pobreza", "linea") ]


"4.0 Group_by"

enaho02 <- enaho02 %>% group_by(conglome, vivienda, hogar) %>%
  summarise(
    p208a = max(p208a, na.rm=T), .groups = "keep"
    ) 

    #Mantener la observación del adulto de mayor edad por hogar.
    #La lógica es que, si el individuo no es mayor de 65, entonces, ningún 
    #otro individuo del hogar lo será. 
    #Luego, si este individuo es mayor 65, el hogar ya puede ser clasificado 
    #en este requisito como 'apto' (pudiendo haber otras personas del hogar 
    #que también son mayores a 65 o no).
  
"5.0 Juntar bases"
# _merge3 == 3 Mantener solo la intercepción entre bases

enaho_2020 <- merge(enaho02, sumaria,
                    by = c("conglome", "vivienda", "hogar")
                    )

"6.0 Crear dummy que cumpla ambos requisitos"
    # Requisito 1: ser un hogar con adulto mayor a 65
        # p208a >= 65

    # Requisito 2: ser hogar pobre (o extremo pobre)
        # pobreza < 3 ==> pues 1= extremo pobre y 2 = pobre


enaho_2020 <- enaho_2020 %>%
              mutate(accesitario = ifelse( p208a >= 65 &  pobreza < 3 , 
                     1 , # si cumple condiciones indica 1
                     ifelse(!is.na(enaho_2020$p208a )  | !is.na(enaho_2020$p208a ) ,
                     0 , # caso contrario es 0
                     NA) ) # a menos que exista missings en cuyo caso colocar na
                    )
"7.0 Respuestas"
table(enaho_2020$accesitario)
View(enaho_2020['accesitario'])
    #dummy accesitario = 1 ==> es candidato al programa
    
    #resulta en la misma cantidad de accesitarios que los 
    #hallados con Python


