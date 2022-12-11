################  Trabajo Final ############################
## Curso: Laboratorio de R y Python #################################
## Grupo 6

# clear environment

rm(list=ls(all=TRUE))

# Load libraries ----


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

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab10") ) # set directorio


repdata <- read_dta("../data/dataverse_files/mss_repdata.dta")


str(repdata)

lapply(repdata, class)

names(repdata)

attributes(repdata)

summary(repdata)

################# T A B L A 1: ESTADISTICOS DESCRIPTIVOS  ########################

#construyendo la tabla de las variables solicitadas

repdata <- read_dta("../data/dataverse_files/mss_repdata.dta")

table1 <- repdata %>% dplyr::select(NDVI_g, tot_100, trade_pGDP, pop_den_rur, land_crop, va_agr, va_ind_manf)


stargazer(table1)

# No obtenemos resultado pues la libreria exige que la base de datos sea DataFrame

table1 <- repdata %>% dplyr::select(NDVI_g, tot_100, trade_pGDP, pop_den_rur, land_crop, va_agr, va_ind_manf) %>% as.data.frame()


stargazer(table1)

#etiquetas

stargazer(table1, title = "Estadísticos Descriptivos", digits = 2,
          covariate.labels = c("Tasa de variación del índice de vegetación","Términos de intercambio","Porcentajes de las exportaciones respecto al PBI","Densidad poblacional rural",
                               "Porcentaje de tierra cultivable en uso","Valor agregado del sector agrícola respecto al PBI","Valor agregado del secctor manufacturero respecto al PBI"))
stargazer(table1, title = "Estadísticos Descriptivos", digits = 2,
          covariate.labels = c("Tasa de variación del índice de vegetación","Términos de intercambio","Porcentajes de las exportaciones respecto al PBI","Densidad poblacional rural",
                               "Porcentaje de tierra cultivable en uso","Valor agregado del sector agrícola respecto al PBI","Valor agregado del secctor manufacturero respecto al PBI"),
                              min.max = F)

#sum, ordenar las columnas de los estadisticos

list_vars <- c("Tasa de variación del índice de vegetación (NDVI_g)","Términos de intercambio (tot_100)","Porcentajes de las exportaciones respecto al PBI (trade_pGDP)","Densidad poblacional rural (pop
               _den_rur)",
               "Porcentaje de tierra cultivable en uso (land_crop)","Valor agregado del sector agrícola respecto al PBI (va_agr)","Valor agregado del secctor manufacturero respecto al PBI (va_ind_manf)")


stargazer(table1, title = "Estadísticos descriptivos", digits = 2, # decimales con 2 digitos
          covariate.labels = list_vars,  # Lista de etiquetas
          summary.stat = c("mean", "sd", "n"), # se especifica el orden de los estadÃ?sticos
          min.max = F, # borrar el estadÃ?stico de maximo y minimo
          notes = "Note.â€” Se tomó las variables indicadas."
          , notes.append = FALSE, # TRUE append the significance levels
          notes.align = 'l')

################# T A B L A 2: REGRESIÓN MCO SIMPLE  ########################

#modelo1

index_country_time <- grep("_time$", colnames(repdata))

country_time_trend <-names(repdata)[index_country_time]

index_country <- grep("^ccode_\\d+$", colnames(repdata))

country_fe <-names(repdata)[index_country]

ols_model <- lm( any_prio~ GPCP_g + GPCP_g_l,clusters = ccode, data = repdata, se_type = "stata", fixed_effects = ~ ccode)

attributes(ols_model)

ols_model$coefficients  # coeficientes

ols_model$fitted.values  # Y estimado

# summary table como en stata

summary(ols_model)

summary(ols_model)$call

summary(ols_model)$coef

# Test de significancia individual usando Huber robust standard errors

coeftest(ols_model, vcov = vcovHC(ols_model, "HC")) # Clasical white robust
coeftest(ols_model, vcov = vcovHC(ols_model, "HC0"))

coeftest(ols_model, vcov = vcovHC(ols_model, "HC1")) # Huber-White robust (STATA)
coeftest(ols_model, vcov = vcovHC(ols_model, "HC2")) # Eicker-Huber-White robust
coeftest(ols_model, vcov = vcovHC(ols_model, "HC3"))
coeftest(ols_model, vcov = vcovHC(ols_model, "HC4"))


# vcovHC Matrix varianza-covarianza robusta ante heterocedasticidad

# robust se and cluster

robust_model <- coeftest(ols_model,
                         vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
                         type = "HC1",
                         cluster = ~ ccode)

sd_robust <- robust_model[,2]

#rms

rmse1 <- RMSE(ols_model$fitted.values, repdata$any_prio ) # root mean squeare error

RMSE(ols_model$fitted.values, repdata$any_prio )^2 # mean square error

# using tdyr functions


glance(ols_model)

tidy(ols_model)

tidy(ols_model)

htmlreg(ols_model)

tidy(ols_model)[2,2] # coeficiente
tidy(ols_model)[2,6] # limite inferior
tidy(ols_model)[2,7] # limite superior 


"Usando LM y luego coestest para los error standar robusto"

m1 <- lm(any_prio ~ GPCP_g + GPCP_g_l, data = repdata)

lm_rmse1 <- round(RMSE(m1$fitted.values, repdata$any_prio ) ,2 )

robust_model <- coeftest(m1,
                          vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model <- robust_model[,2]

# intervalo de confianza 

model1_lower = coefci(m1, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model1_upper = coefci(m1, df = Inf,
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]

tidy(m1, conf.int = TRUE)


# segundo modelo 

index_country_time <- grep("_time$", colnames(repdata))

country_time_trend <-names(repdata)[index_country_time]

index_country <- grep("^ccode_\\d+$", colnames(repdata))

country_fe <-names(repdata)[index_country]

ols_model2 <- lm( war_prio~ GPCP_g + GPCP_g_l,clusters = ccode, data = repdata, se_type = "stata", fixed_effects = ~ ccode)

attributes(ols_model2)

ols_model2$coefficients  # coeficientes

ols_model2$fitted.values  # Y estimado

# summary table como en stata

summary(ols_model2)

summary(ols_model2)$call

summary(ols_model2)$coef

# Test de significancia individual usando Huber robust standard errors

coeftest(ols_model, vcov = vcovHC(ols_model2, "HC")) # Clasical white robust
coeftest(ols_model, vcov = vcovHC(ols_model2, "HC0"))

coeftest(ols_model, vcov = vcovHC(ols_model2, "HC1")) # Huber-White robust (STATA)
coeftest(ols_model, vcov = vcovHC(ols_model2, "HC2")) # Eicker-Huber-White robust
coeftest(ols_model, vcov = vcovHC(ols_model2, "HC3"))
coeftest(ols_model, vcov = vcovHC(ols_model2, "HC4"))


# vcovHC Matrix varianza-covarianza robusta ante heterocedasticidad

# robust se and cluster

robust_model2 <- coeftest(ols_model2,
                         vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
                         type = "HC1",
                         cluster = ~ ccode)

sd_robust2 <- robust_model2[,2]

#rms

rmse2 <- RMSE(ols_model2$fitted.values, repdata$war_prio ) # root mean squeare error

RMSE(ols_model2$fitted.values, repdata$war_prio )^2 # mean square error

# using tdyr functions


glance(ols_model2)

tidy(ols_model2)

tidy(ols_model2)

htmlreg(ols_model2)

tidy(ols_model2)[2,2] # coeficiente
tidy(ols_model2)[2,6] # limite inferior
tidy(ols_model2)[2,7] # limite superior 


"Usando LM y luego coestest para los error standar robusto"

m2 <- lm(war_prio ~ GPCP_g + GPCP_g_l, data = repdata)

lm_rmse2 <- round(RMSE(m2$fitted.values, repdata$war_prio ) ,2 )

robust_model2 <- coeftest(m2,
                         vcov = vcovCL,  # Matrix varianza-covarianza cluster (CL)
                         type = "HC1",
                         cluster = ~ ccode)

sd_robust_model2 <- robust_model2[,2]

# intervalo de confianza 

model2_lower = coefci(m2, df = Inf, 
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,1]

model2_upper = coefci(m2, df = Inf,
                      vcov. = vcovCL, cluster = ~ ccode, type = "HC1")[2,2]

tidy(m2, conf.int = TRUE)


# stargazer::stargazer(ols_model5, se = starprep(ols_model5))

texreg(list(ols_model, ols_model2),
       custom.coef.map = list("GPCP_g"="Growth in rainfall, t",
                              "GPCP_g_l"="Growth in rainfall, t-1"), digits = 3,
       stars = c(0.01, 0.05, 0.1),
       custom.gof.rows = list("Country fixed effects" = c("yes", "yes"),
                              "Country-specific time trends" = c("yes", "yes"),
                              "RMSE" = c(rmse1,rmse2)),
       caption = "Dependent Variable: Economic Growth Rate, t")


##################################################
#Gráfico de Coefplot del coeficiente para GPCP_g #                               
##################################################

#tabla de resultados

table<- matrix(0, 3, 4)

#


library(coefplot)
coefplot(ols_model, ols_model2)  + 
  theme_minimal() + 
  labs(title="Estimación de coeficientes con error estandar", 
       x="Estimación", 
       y="Variable", 
       caption="Elaboración propia con datos de mss_repdata")


ggsave("../plots/Coef_plot.png"
       , height = 8  # alto
       , width = 12  # ancho
       , dpi = 320   # resoluciÃ³n (calidad de la imagen)
)
