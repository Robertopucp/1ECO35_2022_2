################  Solución R ############################


# clear environment

rm(list=ls(all=TRUE))

# load libraries

librarian::shelf(tidyverse,haven,srvyr)


# 1.0 merge Datasets ----------------------------------------------

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2") ) # set directorio


enaho_19_01 <- read_dta("../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta")


enaho_19_34 <- read_dta("../../datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta")


deflactor <- read_dta(
"../../datos/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta")


sapply(deflactor, class)

class(enaho_19_01$aÑo)

## Año 2019 ##

# Sumaria

enaho_19_34  <- enaho_19_34 |> dplyr::select(conglome,vivienda,hogar,mieperho,inghog1d,gashog2d,ld)


# Modelo 1 (caracteristica de la vivienda y del hogar)

enaho_merge_19 <- enaho_19_01 |> dplyr::rename(year = aÑo) |>
    select(year,conglome,vivienda,hogar,ubigeo) |>
    left_join(enaho_19_34,
                        by = c("conglome","vivienda","hogar"))


# Año 2020 ##


enaho_20_01 <- read_dta("../../datos/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")


enaho_20_34 <- read_dta("../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")


enaho_20_34  <- enaho_20_34 |> dplyr::select(conglome,vivienda,hogar,mieperho,inghog1d,gashog2d,ld)



enaho_append <- enaho_20_01 |> dplyr::rename(year = aÑo) |>
    select(year,conglome,vivienda,hogar,ubigeo) |>  # seleccion de variables
left_join(enaho_20_34, by = c("conglome","vivienda","hogar")) |> # left merge
    bind_rows(enaho_merge_19) |>  # append
    mutate(dep =  as.numeric(substr(ubigeo, 1, 2)),  # creamos codigo solo departamento y convertimos a numeric
                  year = as.numeric(year)  # year de string a numeric
                  ) |>
    left_join(deflactor, by = c("year"="aniorec","dep"="dpto")) |> # merge deflactor
    mutate(ing_pc_real = inghog1d/(12*ld*i00*mieperho),
            gas_pc_real = gashog2d/(12*ld*i00*mieperho)) # creacion de variables deflactadas



# Salario por hora ---------------------------------------------


enaho_20_05 <- read_dta("../../datos/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta")


enaho_20_05 <- enaho_20_05 |> select(conglome,vivienda,hogar,i524e1, i538e1,i513t, i518) |>
  rowwise() |> # permite aplicar luego suma fila por fila 
  mutate(suma_ingreso = sum(i524e1, i538e1, na.rm = TRUE), # na.rm ignores NA
         total_horas = sum(i513t, i518, na.rm = TRUE),
         hour_wage = suma_ingreso/(52*total_horas),
         hour_wage = replace(hour_wage, which(hour_wage %in% c(0,NaN)) , NA))
  
# which permite reemplazar con rapidez 


# Groupby -------------------------------------------------------------


enaho_20_02 <- read_dta("../../datos/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta")

enaho_20_34 <- read_dta("../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta")


df <- enaho_20_02 |> select(conglome, vivienda, hogar, p208a ) |> 
  group_by(conglome, vivienda, hogar) |>
  summarise(edad_max = max(p208a, na.rm = T), .groups = "keep") 

# Si quiero observar la mayor edad como dato en cada fila

df2 <- enaho_20_02 |> select(conglome, vivienda, hogar, p208a ) |> 
  group_by(conglome, vivienda, hogar) |>
  summarise(edad_max = max(p208a, na.rm = T), .groups = "keep") |> ungroup()

# Si quiero observar el dato de mayor edad en cada fila y con todas las demás variables de la base

df3 <- enaho_20_02 |> select(conglome, vivienda, hogar, p208a ) |> 
  group_by(conglome, vivienda, hogar) |>
  mutate(edad_max = max(p208a, na.rm = T))



# Merge Sumaria (modulo 34)

enaho_pension <- df |> left_join(enaho_20_34, by = c("conglome", "vivienda", "hogar")) |>
  mutate(hogar_benf_pen = ifelse(edad_max >= 65 & (pobreza %in% c(1,2)), 1, 0))

# Ifelse coloca missing si edad_max o pobreza es missing


table(enaho_pension$hogar_benf_pen)


# Se verifica que coincide con Python 

# Indicadores ----

# Programas sociales 

enaho_20_37 <- read_dta("../../datos/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta")

  
enaho_20_37 <- enaho_20_37 |> dplyr::select(conglome, vivienda, hogar, p710_04)

enaho_20 <- enaho_20_34 |> dplyr::select(conglome, vivienda, hogar, estrato, ubigeo, gru51hd,
                                            gashog2d,factor07) |>
                              left_join(enaho_20_37, by = c("conglome", "vivienda", "hogar")) |>
                              mutate(dep =  substr(ubigeo, 1, 2), health_spend = (gru51hd/gashog2d)*100,
                                     region = case_when(dep == "01" ~ "Amazonas",
                                                        dep == "02" ~ "Ancash",
                                                        dep == "03" ~ "Apurimac",
                                                        dep == "04" ~ "Arequipa",
                                                        dep == "05" ~ "Ayacucho",
                                                        dep == "06" ~ "Cajamarca",
                                                        dep == "07" ~ "Callao",
                                                        dep == "08" ~ "Cusco",
                                                        dep == "09" ~ "Huancavelica",
                                                        dep == "10" ~ "Huanuco",
                                                        dep == "11" ~ "Ica",
                                                        dep == "12" ~ "Junin",
                                                        dep == "13" ~ "La Libertad",
                                                        dep == "14" ~ "Lambayeque",
                                                        dep == "15" ~ "Lima",
                                                        dep == "16" ~ "Loreto",
                                                        dep == "17" ~ "Madre de Dios",
                                                        dep == "18" ~ "Moquegua",
                                                        dep == "19" ~ "Pasco",
                                                        dep == "20" ~ "Piura",
                                                        dep == "21" ~ "Puno",
                                                        dep == "22" ~ "San Martin",
                                                        dep == "23" ~ "Tacna",
                                                        dep == "24" ~ "Tumbes",
                                                        dep == "25" ~ "Ucayali"
                                                        )
                                     
                                     )

survey_enaho <- enaho_20 %>% as_survey_design(ids = conglome, strata = estrato,
                                                     weight = factor07)

# En este caso el factor de expansión es a nivel de hogares factor07

attributes(survey_enaho)

survey_enaho %>%  group_by(region) %>%  
  summarise(
    percent_juntos = survey_mean(p710_04, na.rm = T)*100, percent_health = survey_mean(health_spend, na.rm = T)
  ) -> table_ind






































