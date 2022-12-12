######### TRABAJO FINAL R Y PYTHON ###########
              ## Grupo 3 ## 
    #### Laboratiorio de R y Python ####


# clear enviroment
rm(list=ls(all=TRUE))

# Cargamos las librerias que utilizaremos en este trabajo
# librarian::shelf : Se usa para cargas varias librerias a la vez.
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
  , xtable # exportar matriz o datafrma, table a latex
)

# abrimos base de datos a utilizar
user <- Sys.getenv("claud")
setwd( paste0("D:/PYTHON") )
trabajo <- read_dta("D:/PYTHON/mss_repdata.dta")

# EJERCICIO 1
## Ejercicio 1.1 ##
# TABLA 1
table1 <- trabajo %>% dplyr::select(NDVI_g, tot_100, trade_pGDP,
                                    pop_den_rur, land_crop, va_agr, va_ind_manf)%>% as.data.frame()

# nombramos las variables a evaluar
list_vars <- c("Tasa de variacion del
ındice de vegetacion","terminos de intercambio","porcentaje
de las exportaciones recpecto al PBI","Densidad poblacional rural","porcentaje de tierra cultivable en uso",
               "Valor agregado del sector
agrıcola respecto PBI","Valor agregado del sector manufacturero
respecto PBI")

# creamos la tabla descriptiva para que nos arroje los comandos que usaremos en overleaf
stargazer(table1, type="latex", title = "Descriptive Statistics", digits = 2,
          covariate.labels = list_vars, # nombre de las variables 
          summary.stat = c("mean", "sd", "n"), # estadísiticos a evaluar
          min.max = F, # quitamos el max y min que no nos piden
          notes = "Note.—The source of most characteristics is the World Bank’s World Development Indicators (WDI).",
          notes.append = F, notes.align = 'l') #se agregan algunos comandos LaTex para cuadrar la tabla entre otros aspectos

## Ejercicio 1.2 ##
#TABLA 2
#dummy por país para E.F que piden en el modelo
trabajo  <- dummy_cols(trabajo, select_columns = 'ccode')
index <- grep("ccode_", colnames(trabajo))
trabajo$time_year <- trabajo$year - 1978 # creando la variable temporal
list_vars <- names(trabajo)[index]
list_vars[1]
i = 1
while(i < 42){
  var <- paste0(list_vars[i],"_","time")
  trabajo[var]  <- trabajo[list_vars[i]]*trabajo["time_year"]
  i = i + 1
}

#modelo de primera variable dependiente "any_prio" modelo de efectos fijos
index_country_time <- grep("_time$", colnames(trabajo))
country_time_trend <-names(trabajo)[index_country_time]
index_country <- grep("^ccode_\\d+$", colnames(trabajo))
country_fe <-names(trabajo)[index_country]

model1_formula <- as.formula(
  paste("any_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", paste(country_time_trend, collapse = "+"),
              paste(country_fe, collapse = "+")
              , sep="+")
  )
)

ols_model1 <- lm_robust(model1_formula, data = trabajo,
                        clusters = ccode, se_type = "stata")

summary(ols_model1)
glance(ols_model1)
tidy(ols_model1)

rmse1 <- RMSE(ols_model1$fitted.values, trabajo$any_prio) # root mean squeare error

# Incluyendo ccode como argumento de efectos fijos

model1_formula <- as.formula(
  paste("any_prio",
        "~",
        paste("GPCP_g","GPCP_g_l",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)

ols_model1 <- lm_robust(model1_formula, data = trabajo,
                        clusters = ccode, se_type = "stata", fixed_effects = ~ ccode)

summary(ols_model1)
tidy(ols_model1)
glance(ols_model1)

rmse1 <- RMSE(ols_model1$fitted.values, trabajo$any_prio) # root mean squeare error

trabajo$ccode_factor <- as.factor(trabajo$ccode)
class(trabajo$ccode_factor)
class(trabajo$ccode)

model1_formula <- as.formula(
  paste("any_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", "ccode_factor",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)


ols_model1 <- lm_robust(model1_formula, data = trabajo,
                        clusters = ccode, se_type = "stata")

summary(ols_model1)
tidy(ols_model1)
glance(ols_model1)

"Usando LM y luego coestest para los error standar robusto"

m1 <- lm(model1_formula, data = trabajo)

lm_rmse1 <- round(RMSE(m1$fitted.values, trabajo$any_prio) ,2 )

robust_model1 <- coeftest(m1 ,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model1 <- robust_model1[,2]
#c.i : confidence interval 

coefci(m1, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")


#modelo de segunda variable dependiente "war_prio"
index_country_time <- grep("_time$", colnames(trabajo))
country_time_trend <-names(trabajo)[index_country_time]
index_country <- grep("^ccode_\\d+$", colnames(trabajo))
country_fe <-names(trabajo)[index_country]

model2_formula <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", paste(country_time_trend, collapse = "+"),
              paste(country_fe, collapse = "+")
              , sep="+")
  )
)

ols_model2 <- lm_robust(model2_formula, data = trabajo,
                        clusters = ccode, se_type = "stata")

summary(ols_model2)
glance(ols_model2)
tidy(ols_model2)

rmse2 <- RMSE(ols_model2$fitted.values, trabajo$war_prio) # root mean squeare error

# Incluyendo ccode como argumento de efectos fijos

model2_formula <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)

ols_model2 <- lm_robust(model2_formula, data = trabajo,
                        clusters = ccode, se_type = "stata", fixed_effects = ~ ccode)

summary(ols_model2)
tidy(ols_model2)
glance(ols_model2)

rmse2 <- RMSE(ols_model2$fitted.values, trabajo$war_prio) # root mean squeare error

trabajo$ccode_factor <- as.factor(trabajo$ccode)
class(trabajo$ccode_factor)
class(trabajo$ccode)

model2_formula <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l", "ccode_factor",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)


ols_model2 <- lm_robust(model2_formula, data = trabajo,
                        clusters = ccode, se_type = "stata")

summary(ols_model2)
tidy(ols_model2)
glance(ols_model2)

"Usando LM y luego coestest para los error standar robusto"

m2 <- lm(model2_formula, data = trabajo)

lm_rmse2 <- round(RMSE(m2$fitted.values, trabajo$war_prio) ,2 )

robust_model2 <- coeftest(m2 ,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model2 <- robust_model2[,2]

coefci(m2, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")


### exportamos a LaTex ###
stargazer(m1, m2, type="latex", 
          dep.var.caption = "Dependent Variable" ,
          dep.var.labels = c("Civil Conflict ≥25 Deaths (OLS)","Civil Conflict ≥1,000 Deaths (OLS)"),
          se=list(sd_robust_model1,sd_robust_model2),
          title = "Rainfall and Civil Conflict (Reduced-Form)",
          keep = c("GPCP_g","GPCP_g_l"),
          covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1"),
          align = T, no.space = T,
          add.lines=list(c("Country fixed effects", "yes","yes"),
                         c("Country-specific time trends","yes","yes"),
                         c("Root mean square error",lm_rmse1,lm_rmse2)),
          keep.stat = c("rsq","n"), 
          notes.append = FALSE, notes.align = "c", 
          notes ="Regression disturbance terms are clustered at the country
level.", style = "qje"
)


## Ejercicio 1.3 ##

## Graficar el Coeft plot del coeficiente estimado
## que corresponde a la variable GPCP g.

# Coef 2

# Ajustamos los errores estándares robustos. Esto a partir
# del coeftest y de la matriz de varianzas y covarianzas 
# HCI: Es la matriz de varianzas y covarianzas de Huber-white

md1.tab <- coeftest(m1, vcov=vcovHC(m1, type='HC1'))

md1_coef <- md1.tab[1,1]

md1_coef_se = md1.tab[1,2]


# Intervalo de confianza
# intervalo de cofianza ajsutado por heterocedasticidad
model1_lower = coefci(m1, df = Inf, vcov. = vcovHC, type = "HC1")[1,1]

model1_upper = coefci(m1, df = Inf, vcov. = vcovHC, type = "HC1")[1,2]



# Coef 2

md2.tab <- coeftest(m2, vcov=vcovHC(m2, type='HC1'))

md2_coef <- md2.tab[1,1]

md2_coef_se = md2.tab[1,2]


# Intervalo de confianza
# intervalo de cofianza ajsutado por heterocedasticidad
model2_lower = coefci(m2, df = Inf, vcov. = vcovHC, type = "HC1")[1,1]

model2_upper = coefci(m2, df = Inf, vcov. = vcovHC, type = "HC1")[1,2]

# Creamos una matris 2x4 con valores 0

table <- matrix (0, 2, 4)

# Ordenamos los rsultados obtenidos

table[1,1]<- md1_coef
table[1,2]<- md1_coef_se

table[2,1]<- md2_coef
table[2,2]<- md2_coef_se


table[1,3]<- model1_lower
table[1,4]<- model1_upper

table[2,3]<- model2_lower
table[2,4]<- model2_upper


#Asignamos los nombres correspondientes a las filas y columnas
colnames(table)<- c("Estimate","se","lower_bound","upper_bound")
rownames(table)<- c("OLS Civil conflict ≥ 25", "OLS Civil conflict ≥ 1000")

# Exportamos la tabla a latex 
xtable(table)

tab <- as.data.frame(table)

tab  %>% ggplot(aes(x=rownames(tab), y=Estimate)) +
  geom_point(size=2, color = 'black') +
  geom_errorbar(aes(ymin=lower_bound, ymax=upper_bound) , width = 0.07,color="blue", size = 0.9) +
  labs(x="", y="") + ggtitle("Coeficiente estimado de la variable GPCP_g")  +
  theme(text=element_text(size =15), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept= -0.11, linetype="dashed", color = "black", size=1) +
  geom_hline(yintercept= -0.245, linetype="dashed", color = "black", size=1) +
  theme(panel.grid.major = element_blank(), # borras las cuadrículas en el fondo
        panel.grid.minor = element_blank())


ggsave("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/Coef_plot.png"
       , height = 8  # alto
       , width = 12  # ancho
       , dpi = 320   # resolución (calidad de la imagen)
)

