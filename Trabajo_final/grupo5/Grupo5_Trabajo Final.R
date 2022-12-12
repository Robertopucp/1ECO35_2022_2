rm(list=ls())
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_final/datos") ) # set directorio

#---------------------------- Pregunta 1 ----------------------------------
# Cargamos la base de datos
#install.packages("haven")
library(haven)
data<-read_dta("../datos/mss_repdata.dta")

# Resumen estadístico

## Variables de interés
variables <- c("NDVI_g", "tot_100",
               "trade_pGDP", "pop_den_rur",
               "land_crop", "va_agr", "va_ind_manf")
## Nombres de las variables
var_lab <- list("Tasa de var. del indice de vegetacion",
                "Terminos de intercambio",
                "Exportaciones respecto al PBI",
                "Densidad poblacional rural",
                "Porcentaje de tierra cultivable en uso",
                "V. A. del sector agriculta respecto PBI",
                "V. A. del sector manufacturero respecto PBI")

# Cargamos paquete
#install.packages("vtable")
library(vtable)
# Creamos tabla de resumen
sumtable(
  # Base filtrada con var de interés
  data[ , names(data) %in% variables],
  # Inputamos los nombres de variables
  labels = var_lab,
  # Número de dígitos
  digits = 2,
  # Estadísticos de interés
  summ=c('notNA(x)', 'mean(x)', 'sd(x)'),
  # Nombres de estadísticos
  summ.names = c("Observaciones", "Promedio", "Desv. estandar"),
  # Título
  title = "Resumen estadístico",
  # Nota
  note = "Fuente: Estimaciones propias en base a datos mss_repdata.dta",
  # Exportamos
  file='resumen_descriptivo.tex', out = 'latex')
#---------------------------- 1.2. Regresiones ------------------------------------

#install.packages("lfe")
library(lfe)
## Primera dependiente
twfe_1 <- felm(any_prio ~ GPCP_g + GPCP_g_l -1 |
               # Efectos fijos
               year + ccode |
               # No incluimos variable instrumental
               0 |
               # Cluster
               ccode, data)
## Segunda dependiente
twfe_2 <- felm(war_prio ~ GPCP_g + GPCP_g_l -1 |
               # Efectos fijos
               year + ccode |
               # No incluimos variable instrumental
               0 |
               # Cluster
               ccode, data)

#install.packages("texreg")
library("texreg")

# Resumimos los resultados según la tabla 3 y exportamos 

texreg(
  # Lista con regresiones calculadas
  list(twfe_1,twfe_2),
  # Exportamos en formato
  file = "rainfall_table.tex",
  doctype = TRUE,
  # Formato de reporte
  digits = 3,
  stars = c(0.01, 0.05, 0.10),
  # Nombre de explicativas
  custom.coef.names = c("Growth in rainfall, $t$",
                        "Growth in rainfall, $t-1$"),
  # Nombre de dependientes
  custom.model.names = c("Civil Conflict $geq$ 25 Deaths",
                         "Civil Conflict $geq$ 1,000 Deaths"),
  # Añadimos notas de uso de efectos fijos y el RMS
  custom.gof.rows=list(
    "Country fixed effects" = c("yes", "yes"),
    "Country-specific time trends" = c("yes", "yes"),
    "Root Mean Square" = c(sqrt(mean(twfe_1$residuals^2)),
                           sqrt(mean(twfe_2$residuals^2)))),
  # Seleccionamos los estadísticos de reporte a usar     
  include.adjrs = F,
  include.proj.stats = F,
  include.groups = F,
  include.nobs = T,
  # Nota personalizada
  custom.note = paste("\\item[$\\bullet$] Note. — Huber robust standard errors are in parentheses. Regression disturbance terms are clustered at the country level. A country-specific year time trend is included in all specifications (coefficient estimates not reported).",
                      "$*$ Significantly different from zero at 90 percent.",
                      "$**$ Significantly different from zero at 95 percent.",
                      "$***$ Significantly different from zero at 99 percent."),
  # Título personalizado
  custom.title = "Rainfall and Civil Conflict (Reduced-Form)",
  single.row = TRUE,
  threeparttable = TRUE)
#---------------------------- 1.3. Plot de coeficientes ------------------------------------
# Realizamos el gráfico con la información correspondiente del beta de interés
plotreg(
  # Lista de regresiones
  list(twfe_1,twfe_2),
  # Nombre de la variable a omitir
        omit.coef=c('Growth in rainfall, t-1'),
  # Ponemos los nombres
        custom.coef.names = c("Growth in rainfall, t",
                              "Growth in rainfall, t-1"),
  # Título de los modelos
  custom.model.names = c("Moldel 1",
                               "Model 2"),
  # Opción para recibir todo en una sola viñeta
  type="forest",
  # Personalización del label
  custom.title="Impacto de GPCP_g por modelo",
  custom.note = "Coeficiente en color azul, intervarlo de confianza en celeste")
# Exportamos
ggsave("plot_coef.png",
               width = 18, height = 10, units = "cm")

#--------------------- Pregunta georeferencia ------------------------------
#install.packages("rgdal")
#install.packages("rgeos")
#install.packages("ggmap")
#install.packages("ggplot2")
library(ggplot2) # Gráficos
library(rgdal) # Leer shapefiles
library(ggmap) # Shapefiles y ggplot
library(rgeos) # Manipulación de shapefiles

# Cargamos los shape file de norte, sur y centro y los convertimos base de datos
HL <- readOGR("1_Data/huan_line.shp")    
HL <- fortify(HL)
PT <- readOGR("1_Data/pot_line.shp")    
PT <- fortify(PT)
MITA <- readOGR("1_Data/MitaBoundary.shp")    
MITA <- fortify(MITA)

# Representamos en el gráfico la información
ggplot() + 
  # Base norte
  geom_polygon(data = HL, aes(x=long, lat))+
  # Base sur
  geom_polygon(data = PT, aes(x=long, lat))+
  #geom_polygon(data = MITA, aes(x=long, lat))+
  # Personalización
  theme_void()+ ggtitle("Mita Boundary")
# Exportamos
ggsave("3_Plots/plot_MITA.png",
       width = 18, height = 10, units = "cm")
