################  Trabajo 2 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Grupo
print(user)
library(readxl)
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab3") ) # set directorio
# ../ salir de la carpeta Lab3 para entrar a la carpeta data
Region_Junin <- read_excel("../data/Region_Junin.xlsx")

Region_Junin <- read_excel("../data/Region_Junin.xlsx", encoding = "UTF-8", na.strings=c("",NA)) 

# na.strings=c("",NA) reemplaza vacios por missing 

# Pregunta 1 y 2 
# Información de cada variable - # Obtener el nombre de todas las variables
View(Region_Junin)
str(Region_Junin)
names (Region_Junin)
head(Region_Junin)
# Mostrar el tipo de variables (type) así como presentar los principales estadísticos
class(Region_Junin)
# Las variables ordenadas
lapply(Region_Junin, class) # lapply(x, FUN)
str(lapply)
sapply(Region_Junin, class) # sapply(x, FUN):: vector, Datrame, 
summary(Region_Junin) # estadisticas desciptivas de las variables

# Pregunta 3
# Verifique si las columnas presentan missing values
# ´place    6_14_years_men  women_read women_write total_write men_not_write women_write total_not_write instruction_women instruction_total no_instruction_men finished_instr_wome finished_instr_men finished_instr_total not_finished_instr_men not_finished_instr_women not_finished_instr_total foreign_men natives mestizos
## revisando missing values

" En R, tenemos dos formas de missing, en general, NA y Null "
unique(Place)
any( is.na(Region_Junin["Place"]) ) # TRUE: al menos un missing value
any( is.na(Region_Junin["Region"]) )
any( is.na(Region_Junin["District"]) )
any( is.na(Region_Junin["4_6_years_men"]) )
any( is.na(Region_Junin["6_14_years_men"]) )
any( is.na(Region_Junin["6_14_years_women"]) )
any( is.na(Region_Junin["6_14_years_total"]) )
any( is.na(Region_Junin["man_read"]) )
any( is.na(Region_Junin["women_read"]) )
any( is.na(Region_Junin["total_read"]) )
any( is.na(Region_Junin["men_not_read"]) )
any( is.na(Region_Junin["women_not_read"]) )
any( is.na(Region_Junin["total_not_read"]) )
any( is.na(Region_Junin["man_write"]) )
any( is.na(Region_Junin["total_write"]) )
any( is.na(Region_Junin["women_write"]) )
any( is.na(Region_Junin["men_not_write"]) )
any( is.na(Region_Junin["women_write"]) )
any( is.na(Region_Junin["women_not_write"]) )
any( is.na(Region_Junin["women_write"]) )
any( is.na(Region_Junin["instruction_men"]) )
any( is.na(Region_Junin["instruction_total"]) )
any( is.na(Region_Junin["no_instruction_men"]) )
any( is.na(Region_Junin["no_instruction_women"]) )
any( is.na(Region_Junin["finished_instr_total"]) )
any( is.na(Region_Junin["foreign_women"]) )
any( is.na(Region_Junin["peruvian_women"]) )
any( is.na(Region_Junin["natives"]) )
any( is.na(Region_Junin["mestizos"]) )

## cantidad de missing 
sum(is.na(mestizos))
## Manipulando missing values

Region_Junin %>% drop_na() 

Region_Junin2 <- Region_Junin %>% drop_na()  # borras todas las filas con missig values


