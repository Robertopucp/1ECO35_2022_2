## Grupo 4

# Flavia Oré - 20191215
# Seidy Ascencios - 20191622
# Luana Morales - 20191240
# Marcela Quintero - 20191445


# clear environment

rm(list=ls(all=TRUE))

# Load libraries 

install.packages("librarian")


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


# set directorio

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/data") ) 

# Pregunta 1.1

# subimos la base de datos

repdata <- read_dta("../data/dataverse_files/mss_repdata.dta")

str(repdata)

lapply(repdata, class)

names(repdata)

attributes(repdata)

summary(repdata)


# Observamos las etiquetas de variable de los valores de las variables

lapply(repdata, attr, 'label')

lapply(repdata, attr, 'labels')

repdata$ccode %>% attr('label') # var label

# dummy por país para efectos fijos


repdata  <- dummy_cols(repdata, select_columns = 'ccode')

#

index <- grep("ccode_", colnames(repdata))

# D*time_var 

repdata$time_year <- repdata$year - 1978 # creando la variable temporal

list_vars <- names(repdata)[index]

list_vars[1]

i = 1

while(i < 42){
  
  var <- paste0(list_vars[i],"_","time")
  repdata[var]  <- repdata[list_vars[i]]*repdata["time_year"]
  
  i = i + 1
}

# TABLE 1: DESCRIPTIVE STATISTICS ----


table1 <- repdata %>% dplyr::select(NDVI_g, tot_100_g, trade_pGDP,
                                    pop_den_rur, land_crop, va_agr, va_ind_manf) %>% as.data.frame()


stargazer(table1)


# summary.stat = c("n", "p75", "sd") ordenar las columnas de los estadisticos

list_vars <- c("Tasa de variación de índices de vegetación", "Términos de intercambio","Porcentaje de las exportaciones recpecto al PBI","Densidad poblacional rural",
               "Porcentaje de tierra cultivable en uso","Valor agregado del sector agrícola respecto PBI","Valor agregado del sector manufacturero respecto PBI")

stargazer(table1, title = "Descriptive Statistics", digits = 2, # decimales con 2 digitos
          covariate.labels = list_vars,  # Lista de etiquetas
          summary.stat = c("mean", "sd", "n"), # se especifica el orden de los estadísticos
          min.max = F, # borrar el estadístico de maximo y minimo
          notes = "Note.-The source of most characteristics is the World Bank's World Development Indicators (WDI)."
          , notes.append = FALSE, # TRUE append the significance levels
          notes.align = 'l')





# Pregunta 1.2

# Anteriormente creamos el country_time_trends, ahora crearemos los efectos fijos por país (country fixed effect):

index_country_time <- grep("_time$", colnames(repdata))
country_time_trend <-names(repdata)[index_country_time]


#Usando ccode como una variable tipo factor (variable categórica)

repdata$ccode_factor <- as.factor(repdata$ccode)

class(repdata$ccode_factor)

class(repdata$ccode)


#Planteamos el modelo 1 donde la variable "y" es Civil conflict > 25 deaths, Usando LM


formula_model1 <- as.formula(
  paste("any_prio",
        "~",
        paste("GPCP_g","GPCP_g_l","ccode_factor",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)

m1 <- lm(formula_model1, data = repdata)

lm_rmse1 <- round(RMSE(m1$fitted.values, repdata$any_prio ) ,2 )


robust_model1 <- coeftest(m1,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model1 <- robust_model1[,2]

coefci(m1, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")


#Planteamos el Modelo 2 donde la variable "y" es Civil conflict > 1000, usando LM

formula_model2 <- as.formula(
  paste("war_prio",
        "~",
        paste("GPCP_g","GPCP_g_l","ccode_factor",
              paste(country_time_trend, collapse = "+")
              , sep="+")
  )
)

m2 <- lm(formula_model2, data = repdata)

lm_rmse2 <- round(RMSE(m1$fitted.values, repdata$war_prio ) ,2 )


robust_model2 <- coeftest(m1,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model2 <- robust_model2[,2]

coefci(m1, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")


#latex
stargazer( m1, m2,
           se=list(sd_robust_model1, sd_robust_model2),
           dep.var.labels = c(""),
           title = "Rainfall and Civil Conflict (Reduced-Form)",
           keep = c("GPCP_g","GPCP_g_l"),
           covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1"),
           align = T, no.space = T,
           add.lines=list(c("Country fixed effects", "yes","yes"),
                          c("Country-specific time trends", "yes","yes"),
                          c("Root mean square error",lm_rmse1,lm_rmse2)),
           keep.stat = c("rsq","n"),
           notes.append = FALSE, notes.align = "l",
           notes ="Huber robust standard errors are in parentheses", style = "qje"
           )




# Pregunta 1.3

# Primer modelo para any_prio

model1 <- lm(any_prio~ GPCP_g +GPCP_g_l +ccode_factor, data = repdata)

model1.tab <- coeftest(model1, vcov=vcovHC(model1, type='HC1'))

model1_coef <- model1.tab[2,1]

model1_coef_se = model1.tab[2,2]

model1_lower = coefci(model1, df = Inf, vcov. = vcovHC, type = "HC1")[2,1]

model1_upper = coefci(model1, df = Inf, vcov. = vcovHC, type= "HC1")[2,2]

# Segundo modelo para war_prio

model2 <- lm(war_prio ~ GPCP_g +GPCP_g_l +ccode_factor, data = repdata)

model2.tab <- coeftest(model2, vcov=vcovHC(model2, type='HC1'))

model2_coef <- model2.tab[2,1]

model2_coef_se = model2.tab[2,2]

model2_lower = coefci(model2,df = Inf, vcov. = vcovHC, type = "HC1")[2,1]

model2_upper = coefci(model2,df = Inf, vcov. = vcovHC, type = "HC1")[2,2]

#Tabla de resultados

table<- matrix(0, 2, 4) # 3 filas y 4 columnas

table[1,1] = model1_coef
table[1,2] = model1_coef_se 
table[1,3] = model1_lower
table[1,4] = model1_upper 

table[2,1] = model2_coef
table[2,2] = model2_coef_se  
table[2,3] = model2_lower
table[2,4] = model2_upper 

colnames(table)<- c("Estimate","se","lower_bound","upper_bound")
rownames(table)<- c(" Civil Conflict >=25 Deaths", "Civil Conflict >=1000 Deaths")

# Exportación a Latex

tab <- as.data.frame(table)

# table de matriz a dataframe (tab)

# Coef-plot

options(repr.plot.width = 8, repr.plot.height =5) 

# aes: ejes

tab  %>% ggplot(aes(x=rownames(tab), y=Estimate)) +
  geom_point(size=2, color = 'red') +
  geom_errorbar(aes(ymin=lower_bound, ymax=upper_bound) , width = 0.05,color="blue", size = 0.8) +
  labs(x="", y="") + ggtitle("GPCP_g Coefficient (95% CI)")  +
  theme(text=element_text(size =15), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=0, linetype="dashed", color = "black", size=1) +
  scale_x_discrete(limits = c(" Civil Conflict >=25 Deaths", "Civil Conflict >=1000 Deaths")) + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

ggsave("../plots/Coef_plot.png"
       , height = 8  
       , width = 12  
       , dpi = 320  
)
