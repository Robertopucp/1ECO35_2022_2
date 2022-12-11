"TRABAJO FINAL"

"1. MODELOS LINEALES"

# clear environment
rm(list=ls(all=TRUE))

user <- Sys.getenv("USERNAME")  # username
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_final") ) # set directorio 

# Instalar y cargar librerías con shelf

librarian::shelf( 
  tidyverse  # dplyr, tidyr, stringr, ggplot2, etc in unique library
  , haven   # to read datset: .dta (stata), .spss, .dbf
  , fastDummies  # for dummies
  , stargazer  # for summary and econometrics tables
  , sandwich  # for linear models
  , lmtest # for robust standar error
  , estimatr # for iv, cluster, robust standar error (LM_robust)
  , lfe  # for fixed effects, cluster standar error
  , texreg # library for export table
  , caret
  , mfx # probit , logit model marginal effects
  , xtable
)

#Leer data
repdata <- read_dta("datos/mss_repdata.dta")

############## PARTE 1 ###################################
"Estadísticas descriptivas"

#Hacer tabla con las variables seleccionadas y convertirlas como data frame
table1 <- repdata %>% dplyr::select(NDVI_g, tot_100, trade_pGDP,
                                    pop_den_rur, land_crop, va_agr, va_ind_manf) %>% as.data.frame()



#Generar las etiquetas de las variables
list_vars <- c("Tasa de variación del índice de vegetación","términos de intercambio","porcentaje de las exportaciones respecto
al PBI","Densidad poblacional rural", "Porcentaje de tierra cultivable en uso", "Valor agregado del sector agricultura respecto PBI", "Valor agregado del sector manufacturero respecto PBI")

#Generar la tabla con opciones personalizadas en formato de latex
stargazer(table1, title = "Descriptive Statistics", digits = 2, # decimales con 2 digitos
          covariate.labels = list_vars,  # Lista de etiquetas
          notes = "Note.—The source of most characteristics is the World Bank’s World Development Indicators (WDI)."
          , notes.append = FALSE, # TRUE append the significance levels
          notes.align = 'r')


#Leer data
repdata <- read_dta("datos/mss_repdata.dta")

############## PARTE 2 ###################################

  #### 1. REGRESIÓN  #########################
"• Replicar la tabla 3 (pág 737): 
-Variable endógena 'Y' son:  
    ----- primer modelo 'any_prio': conflictos civiles con 25 a 1000 fallecidos.
    ----- segundo modelo 'war_prio'; conflictos civiles con más de 1000 fallecidos. 
-Variables explicativas 'x' son: 
    ----- GPCP g 1: Tasa de variación de las lluvias en el periodo t   
    ----- GPCP g l: Tasa de variación de las lluvias en el periodo t − 1 
    ----- Incluir country trend y efectos fijos a nivel país. "


"1.*************** Construir variables de efectos fijos ********************"

#A. dummy por país para efectos fijos
repdata  <- dummy_cols(repdata, select_columns = 'ccode')


#B. Country trend: Efectos fijos por el tiempo
    # B.1 creando la variable temporal
repdata$time_year <- repdata$year - 1978 

     #B.2. Construir variable country trend = dummies por país x variable temporal

index <- grep("ccode_", colnames(repdata)) #colnames(repdata): saca los nombres de la columnas
list_vars <- names(repdata)[index] #filtra nombres con los q' me interesan (q' inciian con ccode)
list_vars[1] #sería solo el 1ero (ccode 404) ; Serviran para iterar por país


i = 1

while(i < 42){ #hay 41 dummy's (mientras sea menor a 42)
  
  var <- paste0(list_vars[i],"_","time") #paste es concatenar
  repdata[var]  <- repdata[list_vars[i]]*repdata["time_year"]
  
  i = i + 1
}


"2.*************** Regresiones: estimaciones ********************"

index_country_time <- grep("_time$", colnames(repdata))
country_time_trend <-names(repdata)[index_country_time] #de 404, y 625_time
country_time_trend[]  #NOMBRE  de las variables de efectos country trend


index_country <- grep("^ccode_\\d+$", colnames(repdata)) #halla número de columans que terminan en _time
country_fe <-names(repdata)[index_country] #sale el nombre de las variables ya con el número de columnas halladas anteriormente
country_fe[]  #NOMBRE de las variables de efectos fijos temporales

repdata$ccode_factor <- as.factor(repdata$ccode)
class(repdata$ccode_factor)  #especificar dummy por país como efectos fijos
class(repdata$ccode)  #comparacion


"Regresion con y = any_prio************"

    #Formula
model1_formula <- as.formula(
  paste("any_prio", #variable y
        "~",
        paste("GPCP_g","GPCP_g_l","ccode_factor", 
              paste(country_time_trend, collapse = "+")
              , sep="+") #en formato de suma
  )
)
model1_formula #observar formula, notar que 'ccode_factor' sale como var. E.Fijo

  #Estimacion
m1 <- lm(model1_formula, data = repdata)
m1

  #RMSE
lm_rmse1 <- round(RMSE(m1$fitted.values, repdata$any_prio ) ,2 ) #redondear a 2 decimales
lm_rmse1   

  #Extraer errores estandar robustos
robust_model1 <- coeftest(m1,
                          vcov = vcovCL,
                          type = "HC1",   #Huber White robust
                          cluster = ~ ccode)  #errores estandar clusterizadas a nivel país
robust_model1


sd_robust_model1 <- robust_model1[,2] 
sd_robust_model1


"Regresion con y = war_prio************"

  #Formula
model2_formula <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l","ccode_factor", #este usa ccode_factor
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)
model2_formula #observar formula, notar que 'ccode_factor' sale como var. E.Fijo

  #Estimacion
m2 <- lm(model2_formula, data = repdata)
m2

  #RMSE
lm_rmse2 <- round(RMSE(m2$fitted.values, repdata$war_prio ) ,2 )
lm_rmse2

  #Sacar errores estandar robustos
robust_model2 <- coeftest(m2,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model2 <- robust_model2[,2] 
sd_robust_model2


#### 2. EXPORTAR EN LATEX  #########################
# Export tables ---- Export using Stagezer



stargazer( m1, m2,
           se=list(sd_robust_model1, sd_robust_model2),
           dep.var.labels = c(paste("Civil Conflict  25"), "Civil Conflict   1,000"), #nombres de columnas 2 y 3
           title = "Rainfall and Civil Conflict (Reduced-Form)", #título de la tabla
           column.labels = c("Death (OLS)", "Death (OLS)"), #para poner más información en referencia a dep.var.labels
           keep = c("GPCP_g","GPCP_g_l"),
           covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1"), #etiquetas de las filas
           align = T, no.space = F, #que este centrado y halla espacio entre las filas
           add.lines=list(c("Country fixed effects","yes","yes"),
                          c("Country-specific time trends","yes","yes"),
                          c("Root mean square error",lm_rmse1,lm_rmse2)),
           keep.stat = c("rsq","n"),  #mostrar el número de observaciones
           notes.append = FALSE, notes.align = "l", #notes.append: TRUE append the significance levels, alineación a  la izquierda
           notes ="Huber robust standard errors are in parentheses", style = "qje" 
)




############## PARTE 3 ###################################

#Model 1, extraer: coefficients
model1_coef <- robust_model1[2,1]
model1_coef

#                 : standard deviation
model1_coef_se = robust_model1[2,2]
model1_coef_se

#                 : lower and upper bound
model1_lower = coefci(m1, df = Inf, 
                      vcov. = vcovHC, type = "HC1")[2,1]
model1_lower
model1_upper = coefci(m1, df = Inf, vcov. = vcovHC, type = "HC1")[2,2]
model1_upper


#Model 2, extraer: coefficients
model2_coef <- robust_model2[2,1]
model2_coef

#                 : standard deviation 
model2_coef_se = robust_model2[2,2]
model2_coef_se

#                 : upper and lower bound
model2_lower = coefci(m2, df = Inf, 
                      vcov. = vcovHC, type = "HC1")[2,1]
model2_lower
model2_upper = coefci(m2, df = Inf, vcov. = vcovHC, type = "HC1")[2,2]
model2_upper

# Armar tabla de resultados

table<- matrix(0, 2, 4)
table[1,1]<- model1_coef
table[1,2]<- model1_coef_se
table[1,3]<- model1_lower
table[1,4]<- model1_upper

table[2,1]<- model2_coef
table[2,2]<- model2_coef_se
table[2,3]<- model2_lower
table[2,4]<- model2_upper

colnames(table)<- c("Estimate","Std. Error","Lower_bound","Upper_bound")
rownames(table)<- c("Civil Conflict > 25", "Civil Conflict > 1000")

table
tab<- xtable(table)

# Gráfica Coef-plot

theme_set(theme_bw(20))

options(repr.plot.width = 8, repr.plot.height =10)  # tamaño del gráfico

ggplot(tab, aes(x=rownames(tab), y=Estimate) ) +
  geom_point(size=4, color= rgb(0.8, 0.5, 0) ) +
  geom_errorbar(aes(ymin=Lower_bound, ymax=Upper_bound) , width = 0.1,color=rgb(0.4, 0.6, 0.8), size = 0.9) +
  labs(x="", y="") + ggtitle("Coeficiente de tasa de variación de lluvia (95% CI)")  +
  theme(text=element_text(size =15), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=0, linetype="dashed", color = rgb(0, 0, 0.6), size=1) +
  geom_text(aes(x=rownames(tab), y = Estimate, label = round(Estimate,2)), vjust = 1.5) 


#Guardar coef plot
ggsave("grupo9/Coef_plot.png"
       , height = 8  # alto
       , width = 12  # ancho
       , dpi = 320   # resolución (calidad de la imagen)
)