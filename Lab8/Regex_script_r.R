  ################  Clase 8 Expresiones regulares ############################
  ## Curso: Laboratorio de R y Python ###########################
  ## @author: Roberto Mendoza 
  
  
  # Load libraries
  
  
library(readxl)
library(stringr) # libreria para trabajar expresiones regulares 
library(dplyr)
library(tidyverse) # dplyr, ggplot2, tdyr
  
  
search()
  
"1.0 Set Directorio"

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab8") ) # set directorio


data <- read_excel("../data/Centro_salud/Centro_salud_mental.xls")
data2 <- data.frame(read_excel("../data/Centro_salud/Centro_salud_mental.xls"))


sapply(data, typeof)

apply(data , 2, function(x) sum(is.na(x)))

# Nombre de las variables a minuscula

colnames(data) <- tolower(colnames(data)) # capital letters to lower letters 


#------- Regex -----------


# Patrones básicos 

# 1. [] : permitir indicar tipo de caracteres, definir el rango de las caracteres
# 2. (): permite agrupar caracteres
# 3. \\-,  \\#,  \\?
# 4. " " : dentro de comillar se debe espeficiar el patron del texto 

# \\\ , un \;  \\\\, para 2\

# 2: patrones de texto 

# \\d : identifica digitos
# \\w : identifica caracteres alfanumericos (letras y numeros)
# \\s : identificas espacios 
# [a-z], [A-Z], [a-zA-Z] : rango de letras mayusculas o minusculas
# [0-9]: rango de numeros 

# \\D : NO identifica digitos
# \\W : NO identifica caracteres alfanumericos (letras y numeros)
# \\S : NO identificas espacios 
# [^0-9] : No caputara numero del rango 0 al 9
#  [^a-zA-Z]: No captura o identifica letras (mayuscula o minuscula)

"Patrones de inicio y fin"

# ^\\d, ^M, ^2, ^\\-  : captura inicio de un texto 
# \\d$, _M$, -2$, \\-$: captura los textos que terminan en digitis, M, 2 o -
# \\. : identificar todo (espacios, numeros, letras, #!%$)

"jdhdh 77575"

# [0-9]*: astericos permite capterar ninungo, uno o más de uno 
# [0-9]+: el signo más permite capturar uno o más uno 
# [0-9][a-z]? : ?, permite capturar a lo más una ocurrencia. 


# 1) Extraer solo texto de una celda que contiene numero y texto 


data$inst1 <- apply(data['institución_ruc'],
                    1 ,    # margin 1: aplicar la función por filas , por observaciones
                    function(x) gsub("[0-9]+", '', x))

data$inst1 <- apply(data['institución_ruc'],
                    1 ,    # margin 1: aplicar la función por filas , por observaciones
                    function(x) gsub("[0-9]*", '', x))

# gsub permitir reemplazar, gusb( se espeficica el patron de texto, '', string)

"[0-9]*: ninguno, uno o más digitos"

data$inst2 <- apply(data['institución_ruc'],
                    1 ,  
                    function(x) gsub("\\d+", '', x))


"\\d+: uno o más digitos"

# usando la función extraer

data$inst4 <- apply(data['institución_ruc'],
                    1 ,  
                    function(x) str_extract(x,"[a-zA-Z]*"))



data$inst5 <- apply(data['institución_ruc'],
                    1 ,  
                    function(x) gsub("[^a-zA-Z\\s]", '', x))


# Extraer numero


data$ruc1 <- apply(data['institución_ruc'],
                    1 ,  
                    function(x) gsub("[a-zA-Z]*", '', x))


# se extrae digitos de uno o más ocurrencia 

data$ruc2 <- apply(data['institución_ruc'],
                   1 ,  
                   function(x) str_extract(x,"[0-9]+"))

# extraer solo 3 digitos del rango 0-9 

data$ruc3 <- apply(data['institución_ruc'],
                   1 ,  
                   function(x) str_extract(x,"[0-9]{3}"))

# {3} me permtie extraer 3 digitos

data$ruc4 <- apply(data['institución_ruc'],
                    1 ,  
                    function(x) str_extract(x,"[0-9]{1,}"))


# usando [^0-9], lo que sea diferente de numero en el rango 0 a 9, 
# me reemplazas por nada. 

data$ruc5 <- apply(data['institución_ruc'],
                    1 ,  
                   function(x) gsub("[^0-9]", '', x))


# usando \\D*, lo que sea diferentes de digitos, me reemplazas por nada

data$ruc6 <- apply(data['institución_ruc'],
                    1 ,  
                    function(x) gsub("\\D*", '', x))




# Retirar :00:00 , !%& y 00/00/00

# usando str_replace para reemplazar caracteres
# () permite agrupar, | (permite espeficar diferentes textos)

data$fecha_apertura <- apply(data['fecha_apertura'],
                   1 ,  
                   function(x) str_replace(x,"(:00:00)|(!%&)|(00/00/00)", ''))


# Extraer las coordenadas de la variables GPS


data$coordinates <- apply(data['gps'],
                             1 ,  
              function(x) str_extract(x,"-([0-9]{1,2}).([0-9]{1,3}),-([0-9]{2}).([0-9]{1,4})"))

# [0-9]{1,2} uno o digitos

# @-1.15,-74.155$%&//5


#------ str_match ---------

# Extraer una sección del texto sin especificar la forma completa del texto


x <- "dada--dss kks. 12434 distrito san juan miraflores Region juan lurigancho sds fdds"

str_match(x,"\\.*[D/d]istrito\\s([\\w*\\s]*)\\s[R/r]egion\\s([\\w*\\s]*)")


#\\.* : captura inunga, una, o más de un caracter (cualquie: espcaios, letras, numeros, #!%&/())
# () permite capturar lo que me interesa

str_match(x,"\\.*+[D/d]istrito\\s([\\w*\\s]*)\\s[R/r]egion\\s([\\w*\\s]*)")[2] # distrito

str_match(x,"\\.*+[D/d]istrito\\s([\\w*\\s]*)\\s[R/r]egion\\s([\\w*\\s]*)")[3]  # region



data$distrito <- apply(data['dirección'],
                          1 ,  
              function(x) str_match(x,"\\.*[D/d]istrito\\s([\\w*\\s]*)\\s[R/r]egion\\s([\\w*\\s]*)")[2])

data$region <- apply(data['dirección'],
                          1 ,  
              function(x) str_match(x,"\\.*+[D/d]istrito\\s([\\w*\\s]*)\\s[R/r]egion\\s([\\w*\\s]*)")[3])


#extracción del numero telefonico

data$telefono_fijo <- apply(data['telefono'],
                     1 ,  
                     function(x) str_match(x,"\\.*+(\\d+\\-\\d+)$")[2])


data$telefono_fijo_2 <- apply(data['telefono'],
                            1 ,  
                            function(x) str_match(x,"\\.*+(...\\-\\d+)$")[2])


data$telefono_fijo_3 <- apply(data['telefono'],
                              1 ,  
                              function(x) str_match(x,"\\.*+(\\d+.\\d+)$")[2])

# Extraer seccción de un texto cuando se tiene que especificar toda la estrucutra del texto


match_output <- stringr::str_match(data$resolucion, 
                   'DS-([0-9]+)-([0-9]+)\\s([A-Z]+)')

"[0-9]+: existe uno o más digitos"                  

data <- data %>% mutate(code_res = match_output[,2], year_res = match_output[,3],
                         entidad_res = match_output[,4])


# Regex que detecte un patron y crear dummies

# str_detect es un bool variable (True , False). Coloca True si el texto contiene el patron. 

data <- data %>% mutate(code_res = match_output[,2], year_res = match_output[,3],
                        entidad_res = match_output[,4],
                        Gob_regional_jur = ifelse(str_detect(institución_ruc,"\\^G"), 1 , 0 ),
                        Minsa_jur = ifelse(str_detect(institución_ruc,"\\^M"), 1 , 0 )
)
  
# Nos quedamos con los centros de salud mental que tienen GPS (georeferenciación)

data_filter <- data %>%  filter(str_detect(gps,"[\\d?]"))

"\\d?: A los más identifica un digito"


# ---------------- Fechas en R -----------------

data$fecha_apertura_format <-  as.Date(data$fecha_apertura,format='%d/%m/%Y')


#date un different columns 

data$year = as.numeric (format(data$fecha_apertura_format ,"%Y"))
data$month = as.numeric (format(data$fecha_apertura_format ,"%m"))
data$day = as.numeric (format(data$fecha_apertura_format ,"%d"))


#----- Segunda aplicación ------------------


junin_data = read_excel("../data/Region_Junin.xlsx")


newbase <- dplyr::filter(junin_data, grepl('AC', District))

newbase <- dplyr::filter(junin_data, grepl('pacha', Place))

# ignore.case=TRUE: ignora mayuscula o minuscula (upper or lower case)

newbase <- junin_data %>% filter(grepl('pacha', Place, ignore.case=TRUE))


newbase <- junin_data %>% filter(grepl('CIUDAD', District, ignore.case=TRUE))

# Beginning word with hu

newbase <- junin_data %>% filter(grepl('^hu', District, ignore.case=TRUE))


# Ending word

newbase <- junin_data %>% filter(grepl('ro$', Place, ignore.case=TRUE))


newbase <-  junin_data %>% filter(grepl('^a\\.*', Place, ignore.case=TRUE))

# match con a, . , a.

newbase <-  junin_data %>% filter(grepl('^a\\.+', Place, ignore.case=TRUE))

# match con a.

newbase  <- junin_data %>% filter(grepl('^a\\.?', Place, ignore.case=TRUE))


# match con a, a.









