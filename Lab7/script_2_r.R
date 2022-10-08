################  laboratorio 7 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 
## Clean dataset


library(reshape)
library(haven)
library(dplyr)

#------- Reshape -----------

"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab7") ) # set directorio


# load panel dataset

panel <- read_dta("../data/panel_2016_2018.dta", encoding = "latin1")

# rename variables

panel <- panel  %>% rename("year_16" = "aÑo_16", "year_17" = "aÑo_17", "year_18" = "aÑo_18", "year_19" = "aÑo_19",
                           "year_20" = "aÑo_20", "cong"= "conglome", "viv" ="vivienda" ) %>% 
  mutate(hog = hogar_16)


panel <- panel  %>%
  select(cong, viv, hog, everything())


drop <- c("tipocuestionario_20","tipoentrevista_20","sub_conglome_20","lineav_rpl_20","lineav_20","pobrezav_20")

panel <- panel[,! names(panel) %in% drop]

# Usando la libreria reshape

index_1 =  grep(c("pobreza"), colnames(panel))
index_2 =  grep(c("ubigeo"), colnames(panel))
index_3 =  grep(c("linea"), colnames(panel))
index_4 =  grep(c("estrsocial"), colnames(panel))
index_5 =  grep(c("factor07"), colnames(panel))

index <- c(1,2,3,index_1, index_2, index_3, index_4, index_5)

new_data <- panel[,index]

new_panel <- reshape(data = new_data, idvar = c("cong", "viv", "hog"), varying = 4:28, sep="_", timevar = "time_var", 
                     times = c(16,17,18,19,20), direction = "long")



rownames(new_panel) <- NULL  # borrar nombres 

new_panel[order(cong,viv,hog,time_var),]

new_panel <- new_panel %>% mutate(time_var = case_when(time_var == 16 ~ 2016,
                                                       time_var == 17 ~ 2017, time_var == 18 ~ 2018,
                                                       time_var == 19 ~ 2019, time_var == 20 ~ 2020))



df <- new_panel[order(new_panel$cong,new_panel$viv,new_panel$hog,new_panel$time_var),]
