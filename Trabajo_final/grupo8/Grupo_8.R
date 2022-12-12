# Trabajo Final GRUPO 8

# Clear environment
rm(list=ls(all=TRUE))

# Cargamos librerías 
install.packages("librarian")
install.packages("read_dta")
library(haven)
install.packages("magrittr") 
library(magrittr)
library(dplyr)

librarian::shelf(
  tidyverse  # dplyr, tidyr, stringr, ggplot2, etc in unique library
  , haven   # to read datset: .dta (stata), .spss, .dbf
  , fastDummies  # for dummies
  , stargazer  # for summary and econometrics tables
  , sandwich  # for linear models
  , lmtest # for robust standar error
  , estimatr # for iv, cluster, robust standar error
  , lfe  # for fixed effects, cluster standar error
  , caret # for easy machine learning workflow (mse, rmse)
  , texreg # library for export table
  , xtable, mfx # probit , logit model marginal effects
)

# Modificamos la ruta donde se encuentra la data
user <- Sys.getenv("USERNAME")  # username
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_final/grupo8") ) # set directorio
data <- read_dta("../datos/mss_repdata.dta")

"
Datos que vamos a usar:
- NDVI g (Tasa de variación del índice de vegetación),
- tot 100 (t´erminos de intercambio), trade pGDP (porcentaje de las exportaciones recpecto al PBI),
- pop den rur (Densidad poblacional rural),
- land crop (porcentaje de tierra cultivable en uso),
- va agr (Valor agregado del sectoragr´ıculta respecto PBI) y va ind manf (Valor agregado del sector manufacturero respecto PBI).
"

# ----1 MODELOS LINEALES----
# ----Tabla de estadísticas----
# Definimos las variables que vamos a tomar en cuenta para la tabla
list_vars <- c("Tasa de variación del índice de vegetación","Términos de intercambio","Porcentaje de las exportaciones respecto al PBI","Densidad poblacional rural","Porcentaje de tierra cultivable en uso","Valor agregado del sector agricultura respecto PBI","Valor agregado del sector manufacturero respecto PBI")

table1 <- data %>% dplyr::select(NDVI_g, tot_100,trade_pGDP,
                                 pop_den_rur, land_crop, va_agr, va_ind_manf) %>% as.data.frame()

# Código para exportar a Latex
stargazer(table1, title = "Descriptive Statistics", digits = 2, # decimales con 2 dígitos
          covariate.labels = list_vars, # Lista de etiquetas
          summary.stat = c("mean", "sd", "n"), # se especifica el orden de los estadísticos
          min.max = F, # borrar el estadístico de maximo y mínimo
          notes.append = FALSE, # TRUE append the significance levels
          notes.align = 'l')

# ----Replicar tabla 3----
# Creamos dummies
data  <- dummy_cols(data, select_columns = 'ccode')
index <- grep("ccode_", colnames(data))
data$time_year <- data$year - 1978
list_vars <- names(data)[index]
list_vars[1]
i = 1
while(i < 42){
  var <- paste0(list_vars[i],"_","time")
  data[var]  <- data[list_vars[i]]*data["time_year"]
  i = i + 1
}

# Seteamos los efectos fijos y la tendencia en el tiempo 
data$ccode_factor <- as.factor(data$ccode)
class(data$ccode_factor)
class(data$ccode)
index_country_time <- grep("_time$", colnames(data))
country_time_trend <-names(data)[index_country_time]

# Especificamos la fórmula del MODELO 1 a regresionar
model1_formula <- as.formula(
  paste("any_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", "ccode_factor",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)

# Especificamos la fórmula del MODELO 2 a regresionar
model2_formula <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", "ccode_factor",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)

# Estimamos el MODELO 1 mediante el método OLS
ols_model1 <- lm(model1_formula, data = data)

# Estimamos el MODELO 2 mediante el método OLS
ols_model2 <- lm(model2_formula, data = data)

# Obtenemos los root mean square errors de cada modelo y los redondeamos al segundo (o tercer) decimal
rmse1 <- round(RMSE(ols_model1$fitted.values, data$any_prio ),2)
rmse2 <- round(RMSE(ols_model2$fitted.values, data$war_prio ),3)

# Obtenemos los errores estándares del MODELO 1 y los redondeamos al tercer decimal
robust_model1 <- coeftest(ols_model1,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)
sd_robust_model1 <- round(robust_model1[,2],3)

# Obtenemos los errores estándares del MODELO 2 y los redondeamos al tercer decimal
robust_model2 <- coeftest(ols_model2,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)
sd_robust_model2 <- round(robust_model2[,2],3)

# Redondeamos los R cuadrados al segundo decimal
r21<-round(summary(ols_model1)$ r.squared,2)
r22<-round(summary(ols_model2)$ r.squared,2)

# customizamos la tabla con los resultados de las regresiones para exportar a Latex
stargazer( ols_model1, ols_model2,
           se=list( sd_robust_model1, sd_robust_model2),
           dep.var.labels = c("Civil Conflict 25", "Civil Conflict 1,000"),
           column.labels=c("Deaths (OLS)","Deaths (OLS)"),
           title = "Rainfall and Civil Conflict (Reduced-Form)",
           keep = c("GPCP_g","GPCP_g_l"),
           covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1"),
           align = T, no.space = T,
           add.lines=list(c("Country fixed effects","yes","yes"),
                          c("Country-specific time trends","yes","yes"),
                          c("Root mean square error",rmse1,rmse2)),
           keep.stat = c("n", "rsq"),
           notes.append = FALSE, notes.align = "l",
           notes ="Huber robust standard errors are in parentheses.", style = "qje"
)

# ----Coeft plot----

# Establecemos las condiciones iniciales como los upper bounds y lower bounds
# para ambos modelos y los organizamos en una matriz
model1_lower = coefci(ols_model1, df = Inf, vcov. = vcovHC, type = "HC1")[2,1]
model1_upper = coefci(ols_model1, df = Inf, vcov. = vcovHC, type = "HC1")[2,2]

model2_lower = coefci(ols_model2, df = Inf, vcov. = vcovHC, type = "HC1")[2,1]
model2_upper = coefci(ols_model2, df = Inf, vcov. = vcovHC, type = "HC1")[2,2]

model1.tab <- coeftest(ols_model1, vcov=vcovHC(ols_model1, type='HC1'))
model2.tab <- coeftest(ols_model2, vcov=vcovHC(ols_model2, type='HC1'))

model1_coef <- model1.tab[2,1]
model2_coef <- model2.tab[2,1]

model1_coef_se = model1.tab[2,2]
model2_coef_se = model2.tab[2,2]

table<- matrix(0, 2, 4)

table[1,1]<- model1_coef
table[1,2]<- model1_coef_se

table[2,1]<- model2_coef
table[2,2]<- model2_coef_se

table[1,3]<- model1_lower
table[1,4]<- model1_upper

table[2,3]<- model2_lower
table[2,4]<- model2_upper

# Editamos los nombres de la matriz
colnames(table)<- c("Estimate","se","lower_bound","upper_bound")
rownames(table)<- c("≥25 Deaths (OLS)", "≥1000 Deaths (OLS)")

# Customizamos el plot
theme_set(theme_bw(20)) # tema con fondo blanco y cuadro con bordes en negro
options(repr.plot.width = 8, repr.plot.height =5)  # tamaño del gráfico
xtable(table)
tab <- as.data.frame(table)

# Coef Plot
tab  %>% ggplot(aes(x=rownames(tab), y=Estimate)) +
  geom_point(size=2, color = 'black') +
  geom_errorbar(aes(ymin=lower_bound, ymax=upper_bound) , width = 0.05,color="black", size = 0.8) +
  labs(x="", y="") + ggtitle("Coef plot GPCP_g")  +
  theme(text=element_text(size =15), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=0, linetype="dashed", color = "black", size=1) +
  scale_x_discrete(limits = c("≥25 Deaths (OLS)", "≥1000 Deaths (OLS)")) + # order x - axis
  theme(panel.grid.major = element_blank(), # borras las cuadrículas en el fondo
        panel.grid.minor = element_blank())

# Guardamos la imagen del plot
ggsave("coefplot.png")