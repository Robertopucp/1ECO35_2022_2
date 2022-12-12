##########################################################
########Trabajo Final del curso de R y Python ############
##########################################################

################ EJERCICIO 1 (a)(b)(c)####################

################### Grupo 2###############################

#rm(list=ls(all=TRUE))

####Instalamos los paquetes y librerias que usaremos para este ejercicio ----

librarian::shelf(
    tidyverse  # dplyr, tidyr, stringr, ggplot2, etc in unique library
    , haven   # to read datset: .dta (stata), .spss, .dbf
    , fastDummies  # for dummies
    , stargazer  # for summary and econometrics tables
    , sandwich  # for linear models
    , lmtest # for robust standar error
    , estimatr # for iv, cluster, robust standar error (LM_robust)
    , lfe  # for fixed effects, cluster standar error
    , caret # for easy machine learning workflow (mse, rmse)
    , texreg # library for export table
    , mfx # probit , logit model marginal effects
)

##Instalamos metrics

install.packages("Metrics")
library(Metrics)


###Instalamos el paquete caret aparte###
install.packages('caret', dependencies = TRUE)
library(caret)
library(estimatr)
##Acedemos a la base de datos###
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab10") ) # set directorio

##Nombramos la data como "repdata"
repdata <- read_dta("../data/dataverse_files/mss_repdata.dta")

##Exploramos la data y vemos sus caracteristicas
str(repdata)

lapply(repdata, class)

names(repdata)

attributes(repdata)

summary(repdata)

# Observamos las etiquetas de variable de los valores de las variables

lapply(repdata, attr, 'label')

lapply(repdata, attr, 'labels')

repdata$ccode %>% attr('label') # var label

# dummy por país para efectos fijos que nos servira más adelante

repdata  <- dummy_cols(repdata, select_columns = 'ccode')

#
index <- grep("ccode_", colnames(repdata))

# Creamos la variable temporal

repdata$time_year <- repdata$year - 1981 # creando la variable temporal

list_vars <- names(repdata)[index]

list_vars[1]

i = 1

while(i < 42){

    var <- paste0(list_vars[i],"_","time")
    repdata[var]  <- repdata[list_vars[i]]*repdata["time_year"]

    i = i + 1
}

####Con todos estos elementos, ya tenemos la base lista
####para ser utilizada 

#######################
####EJERCICIO 1a#######
#######################

# Realizamos una tabla descriptiva de estadisticas de las siguientes variables

#NDVI g (Tasa de variacion del ındice de vegetacion),
#tot 100 (terminos de intercambio), 
#trade pGDP (porcentaje de las exportaciones respecto al PBI) 
#pop den rur (Densidad poblacional rural),
#land crop (porcentaje de tierra cultivable en uso), 
#va agr (Valor agregado del sector agrıcultura/ PBI) 
#va ind manf (Valor agregado del sector manufactura/ PBI)

# CREAMOS TABLE 1: 

table1 <- repdata %>% dplyr::select(NDVI_g, tot_100, trade_pGDP, 
                                    pop_den_rur, land_crop, va_agr, 
                                    va_ind_manf ) %>% as.data.frame()

##Ajustamos la tabla 1 con lo que me piden

stargazer(table1, title = "Estadísticas Descriptivas", digits = 2,
          covariate.labels = c("Tasa de variacion del ındice de vegetacion",
          "Terminos de intercambio","% Exportaciones respecto al PBI","Densidad poblacional rural",
          "% Tierra cultivable en uso","Valor agregado del sector agrıcultura/ PBI",
          "Valor agregado del sector manufactura/ PBI",
          "Doyle and Sambanis (2000)","Fearon and Laitin (2003)"),
          min.max = F)


#######################
####EJERCICIO 1b#######
#######################

##Replicar la tabla 3 (pag 737)

#Establecemos el modelo OLS simple

ols_model <- lm(gdp_g ~ GPCP_g + GPCP_g_l, data = repdata)

attributes(ols_model)

#Con este comando podemos ver los coeficientes del modelo
ols_model$coefficients  

#con este comando vemos los valores del vector Y estimado
ols_model$fitted.values 

# Para conocer bien el modelo hacemos un summary table

summary(ols_model)

summary(ols_model)$call

summary(ols_model)$coef

# Aplicamos el Test de significancia individual 
#usando Huber white robust standard errors 

coeftest(ols_model, vcov = vcovHC(ols_model, "HC1")) # Huber-White robust (STATA)


# Creamos el sd_robust y el cluster

robust_model <- coeftest(ols_model,
                          vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust <- robust_model[,2]


#### Primer Modelo ----

# OLS,con efectos fijos o country-time trend
# errores estandar robustas (Huber robust)
# Los residuos estan clusterizados (agrupados) a nivel país
# Using cluster and robust standar error

ols_model1 <- lm_robust(gdp_g ~ GPCP_g + GPCP_g_l, data = repdata,
              clusters = ccode, se_type = "stata")


summary(ols_model1)

attributes(ols_model1)

ols_model1$r.squared
ols_model1$fitted.values

#Estimamos los root mean squeare error

rmse1 <- rmse(ols_model1$fitted.values, repdata$gdp_g )

rmse(ols_model1$fitted.values, repdata$gdp_g )^2 # mean square error


# Aqui vemos los coeficientes y otras funciones de nuestro ols model1


glance(ols_model1)

tidy(ols_model1)

tidy(ols_model1)

htmlreg(ols_model1)

tidy(ols_model1)[2,2] # coeficiente
tidy(ols_model1)[2,6] # limite inferior
tidy(ols_model1)[2,7] # limite superior 

##Dado que stargazer no es compatible, utilizamos comando LM

m1 <- lm(gdp_g ~ GPCP_g + GPCP_g_l, data = repdata)

lm_rmse1 <- round(rmse(m1$fitted.values, repdata$gdp_g ) ,2 )
print(lm_rmse1)

robust_model1 <- coeftest(m1,
vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
type = "HC1",
cluster = ~ ccode)

##Para acceder a la columna de errores estandar -->sd_robust_model1
sd_robust_model1 <- robust_model1[,2]

# Hallamos el  intervalo de confianza --> model1_lower

model1_lower = coefci(m1, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model1_upper = coefci(m1, df = Inf,
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]

tidy(m1, conf.int = TRUE)

##Agrego el contrytime trends

#Primero deinimos las variables de control
control_vars <- c("y_0", "polity2l", "ethfrac", "relfrac", "Oil", "lmtnest","lpopl1")

#Vemos que las variables terminan en "_time"
names(repdata)

#Procedemos a crear el countrytrend
index_country_time <- grep("_time$", colnames(repdata))

country_time_trend <-names(repdata)[index_country_time]


model1_formula <- as.formula(
  
  paste("gdp_g",
        "~",
        paste("GPCP_g","GPCP_g_l", paste(country_time_trend, collapse = "+"),
              paste(control_vars, collapse = "+")
              ,sep="+")
  )
  
)

# Usamos nuevamente lm para correr el modelo 1 

m1 <- lm(model1_formula, data = repdata)

lm_rmse1 <- round(rmse(m1$fitted.values, repdata$gdp_g ) ,2 )

robust_model1 <- coeftest(m1,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model1 <- robust_model1[,2]

coefci(m1, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")

##Ahora añadimos efectos fijos
##############################

# Usando ccode como una variable tipo factor (variable categórica)

repdata$ccode_factor <- as.factor(repdata$ccode)

class(repdata$ccode_factor)

class(repdata$ccode)


model1_formula <- as.formula(
    paste("any_prio",
          "~",
          paste("GPCP_g","GPCP_g_l","ccode_factor",
                paste(country_time_trend, collapse = "+")
                , sep="+")
    )
)


ols_model1 <- lm_robust(model1_formula, data = repdata,
                        clusters = ccode, se_type = "stata")

summary(ols_model1)
tidy(ols_model1)
glance(ols_model1)

"Usando LM y luego coestest para los error standar robusto"

m1 <- lm(model1_formula, data = repdata)

lm_rmse1 <- round(rmse(m1$fitted.values, repdata$gdp_g ) ,2 )

robust_model1 <- coeftest(m1 ,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

##Saco la columna de errores standar
sd_robust_model1 <- robust_model1[,2]

#c.i : confidence interval 

coefci(m1, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")


#### Segundo Modelo CON WARPRIOR----

# OLS,con efectos fijos o country-time trend
# errores estandar robustas (Huber robust)
# Los residuos estan clusterizados (agrupados) a nivel país
# Using cluster and robust standar error

"Usando LM y luego coestest para los error standar robusto"

model2_formula <- as.formula(
    paste("war_prio",
          "~",
          paste("GPCP_g","GPCP_g_l","ccode_factor",
                paste(country_time_trend, collapse = "+")
                , sep="+")
    )
)

m2 <- lm(model2_formula, data = repdata)

lm_rmse2 <- round(rmse(m2$fitted.values, repdata$gdp_g ) ,2 )

robust_model2 <- coeftest(m2,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model2 <- robust_model2[,2]

coefci(m2, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")

##Intervalos de confianza


model2_lower = coefci(m2, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model2_upper = coefci(m2, df = Inf,
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]



# RMSE manual

sq_resid <- m2$residuals**2
lm_rmse5 <- round( mean(sq_resid)^0.5, 2)


#############################################
#CREAMOS TABLA para pasarla al overleaf######
#############################################

# Export using Stagezer

stargazer(m1, m2,type="latex",
          dep.var.caption = "Dependent variable" ,
          dep.var.labels = c("",""),
          se=list(sd_robust_model1, sd_robust_model2),
          title = "Rainfall and civil conflict(Reduce-form)",
          keep = c("GPCP_g","GPCP_g_l"),
          covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1"),
          align = T, no.space = T,
          add.lines=list(c("Country fixed effects", "yes","yes"),
                          c("Country-specific time trends","yes","yes"),
                          c("Root mean square error",lm_rmse1,lm_rmse2)),
          keep.stat = c("rsq","n"),
          notes.append = FALSE, notes.align = "c",
          notes ="Regressions disturbance terms are clustered at the country 
          trend", style = "qje")

##################################
####EJERCICIO 1b: COEFTPLOT#######
##################################

#Instalamos los paquetes
install.packages("librarian")

librarian::shelf(
  tidyverse
  , WDI
  , forcats
  , writexl
  
)


#Volvemos a estimar el robust_model1 

robust_model1 <- coeftest(m1,
                          vcov = vcovCL,  
                          type = "HC1",
                          cluster = ~ ccode)

# Hallamos el  intervalo de confianza --> model1_lower y model1_upper

model1_lower = coefci(m1, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model1_upper = coefci(m1, df = Inf,
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]

tidy(m1, conf.int = TRUE)

#Sacamos los coeficientes 

model1_coef <- robust_model1[2,1]
model1_coef_se = robust_model2[2,2]

#Volvemos a estimar el robust_model2 
robust_model2 <- coeftest(m2,
                          vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
                          type = "HC1",
                          cluster = ~ ccode)

# Hallamos el  intervalo de confianza --> model2_lower y model2_upper

model2_lower = coefci(m2, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model2_upper = coefci(m2, df = Inf,
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]

tidy(m2, conf.int = TRUE)

#Sacamos los coeficientes
model2_coef <- robust_model2[2,1]
model2_coef_se = robust_model2[2,2]

# Creamos la tabla con los componentes anteriores para usarla de base
#en nuestro coeftplot

table<- matrix(0, 2, 4) # 2 filas y 4 columnas


table[1,1]<- model1_coef
table[1,2]<- model1_coef_se

table[2,1]<- model2_coef
table[2,2]<- model2_coef_se

table[1,3]<- model1_lower
table[1,4]<- model1_upper

table[2,3]<- model2_lower
table[2,4]<- model2_upper

#En el coeftplot, nombramos nuestros modelos como model OLS1 y OLS2

colnames(table)<- c("Estimate","se","lower_bound","upper_bound")
rownames(table)<- c("OLS 1", "OLS 2")


# Para lograr la exportación a Latex utilizamos el comando "xtable"
install.packages("xtable")
library(xtable)
xtable(table)

# Pasamos la table creada a dataframe como (tab)
tab <- as.data.frame(table)


# Actualizamos unas caracteristicas que serviran para el Coeff-plot

theme_set(theme_bw(20)) # tema con fondo blanco y cuadro con bordes en negro

options(repr.plot.width = 8, repr.plot.height =5)  # tamaño del gráfico

# Finalmente creamos el coeftplot

tab  %>% ggplot(aes(x=rownames(tab), y=Estimate)) +
  geom_point(size=2, color = 'black') +
  geom_errorbar(aes(ymin=lower_bound, ymax=upper_bound) , width = 0.05,color="black", size = 0.8) +
  labs(x="", y="") + ggtitle("Coefplot (95% CI)")  +
  theme(text=element_text(size =15), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=0, linetype="dashed", color = "black", size=1) +
  scale_x_discrete(limits = c("OLS 1","OLS 2")) + # order x - axis
  theme(panel.grid.major = element_blank(), # borras las cuadrículas en el fondo
        panel.grid.minor = element_blank())
