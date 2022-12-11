install.packages("rlang")
install.packages("Metrics")
install.packages("xtable")
install.packages("tidyverse")

library(ggplot2)
library(Metrics)
library(haven)
library(dplyr)
library(stargazer)
library(plm)
library(lmtest)
library(sandwich)
library(estimatr)
library(lfe)
library(caret)
library(texreg)
library(mfx)
library(fastDummies)
library(lubridate) 
library(tidyverse)

librarian::shelf(plm,lfe,caret,texreg,mfx,fastDummies,estimatr,dplyr,stargazer,tidyverse,sandwich,lmtest,xtable,haven)

#Seteamos el directorio
user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2") ) # set directorio


DATA <- read_dta("Trabajo_final/datos/mss_repdata.dta")
DATA <-as.data.frame(DATA)

#Me quedo con las variables necesarias para realizar la tabla de estadísticos
dat_2 <- DATA %>% dplyr::select(NDVI_g,tot_100,trade_pGDP,pop_den_rur,land_crop,va_agr,va_ind_manf) %>% as.data.frame()

#Tabla de estadísticas de variables seleccionadas
list_var <- c("Tasa de variación del índice de vegetación", "Términos de intercambio",
              "Porcentaje de las exportaciones recpecto al PBI", "Densidad poblacional rural",
              "Porcentaje de tierra cultivable en uso", "Valor agregado del sector agricultura respecto PBI",
              "Valor agregado del sector manufacturero respecto PBI")

stargazer(dat_2, title = "Descriptive Statistics", digits = 2, covariate.labels = list_var,  
          summary.stat = c("mean", "sd", "n"),min.max = F,
           notes.append = FALSE, notes.align = 'l')

#Se crean dummies para cada país

DATA  <- dummy_cols(DATA, select_columns = 'ccode')

index <- grep("ccode_", colnames(DATA))

# Se crea la variable año a partir de 1981 en adelante
DATA$time_year <- DATA$year - 1980

list_vars_mod <- names(DATA)[index]
list_vars_mod[1]

#Creamos la variable año x país.

i = 1

while(i < 42){
  
  var <- paste0(list_vars_mod[i],"_","time")
  DATA[var]  <- DATA[list_vars_mod[i]]*DATA["time_year"]
  
  i = i + 1
}


# Modelo (1)


index_country_time <- grep("_time$", colnames(DATA))
country_time_trend <-names(DATA)[index_country_time]
index_country <- grep("^ccode_\\d+$", colnames(DATA))

country_fe <-names(DATA)[index_country]


model1_formula <- as.formula(
  paste("any_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", paste(country_time_trend, collapse = "+"),
              paste(country_fe, collapse = "+")
              , sep="+")
  )
)


ols_model1 <- lm_robust(model1_formula, data = DATA,
                        clusters = ccode, se_type = "stata")

summary(ols_model1)
tidy(ols_model1)
glance(ols_model1)

#Usamos LM y luego coestest para hallar los errores standar robusto"


m1 <- lm(model1_formula, data = DATA)

lm_rmse1 <- round(rmse(m1$fitted.values, DATA$any_prio) ,2 )

robust_model1 <- coeftest(m1 ,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)



sd_robust_model1 <- robust_model1[,2]



# Modelo (2)

model2_formula <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", paste(country_time_trend, collapse = "+"),
              paste(country_fe, collapse = "+")
              , sep="+")
  )
)


ols_model2 <- lm_robust(model2_formula, data = DATA,
                        clusters = ccode, se_type = "stata")

summary(ols_model2)

#Usando LM y luego coestest para los error standar robusto"


m2 <- lm(model2_formula, data = DATA)

lm_rmse2 <- round(rmse(m2$fitted.values, DATA$war_prio ) ,2 )

robust_model2 <- coeftest(m2 ,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)



sd_robust_model2 <- robust_model2[,2]

#Exportando la tabla


stargazer( m1, m2,
           se=list(sd_robust_model1, sd_robust_model2),
           dep.var.labels = c(""),
           title = "Rainfall and Civil Conflict (Reduced-Form)",
           keep = c("GPCP_g","GPCP_g_l"),
           covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1"),
           align = T, no.space = T,
           add.lines=list(c("Country fixed effects","yes","yes"),
                          c("Country-specific time trends","yes","yes"),
                          c("Root mean square error",lm_rmse1,lm_rmse2)),
           keep.stat = c("rsq","n"),
           notes.append = FALSE, notes.align = "l",
           notes ="Huber robust standard errors are in parentheses. Regression disturbance terms are clustered at the country level.A country-specific year time trend is included in all specifications (coefficient estimates not reported). * Significantly different from zero at 90 percent confidence. ** Significantly different from zero at 95 percent confidence. *** Significantly different from zero at 99 percent confidence.", style = "qje"
)



##### Coef-plot

# Primero calculamos los intervalos de confianza para ambos modelos

#Modelos 1. c.i : confidence interval 

model1_lower = coefci(m1, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model1_upper = coefci(m1, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]

#Modelo 2. c.i : confidence interval 

model2_lower = coefci(m2, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model2_upper = coefci(m2, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]


#Extraemos los coeficientes de la variable gpcp_g de ambos modelos

model1_coef<- ols_model1$coefficients[2]

model2_coef<- ols_model2$coefficients[2]

# Creamos una tabla de resultados que recopile los coeficientes y los intervalos de confianza

table<- matrix(0, 2, 3)

table[1,1]<- model1_coef
table[1,2]<- model1_lower
table[1,3]<- model1_upper

table[2,1]<- model2_coef
table[2,2]<- model2_lower
table[2,3]<- model2_upper

#Le damos nombres a las filas y columnas
colnames(table)<- c("Estimate","lower_bound","upper_bound")
rownames(table)<- c("OLS 1", "OLS 2")


# Lo convertimos a dataframe para poder ploterarlo
tab <- as.data.frame(table)

#Ploteamos el gráfico

theme_set(theme_bw(20)) # tema con fondo blanco y cuadro con bordes en negro

options(repr.plot.width = 8, repr.plot.height =8)  # tamaño del gráfico


tab  %>% ggplot(aes(x=rownames(tab), y=Estimate)) +
  geom_point(size=2, color = 'red') +
  geom_errorbar(aes(ymin=lower_bound, ymax=upper_bound) , width = 0.1,color="blue", size = 0.9) +
  labs(x="", y="") + ggtitle("Stimated Coefficient of growth in rainfall (95% CI)")  +
  theme(text=element_text(size =8), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=0, linetype="dashed", color = "black", size=1) +
  scale_x_discrete(limits = c("OLS 1","OLS 2")) + # order x - axis
  theme(panel.grid.major = element_blank(), # borramos las cuadrículas en el fondo
        panel.grid.minor = element_blank())

# Guardamos la imagen del coefplot en la ruta especificada

ggsave("Trabajo_final/grupo1/plots/Coef_plot.png"
       , height = 8  # alto
       , width = 12  # ancho
       , dpi = 320   # resolución (calidad de la imagen)
)


