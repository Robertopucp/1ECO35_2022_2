rm(list=ls(all=TRUE))


# cargando librerías ----

librarian::shelf(
  tidyverse      # dplyr, tidyr, stringr, ggplot2, etc in unique library
  , haven        # to read datset: .dta (stata), .spss, .dbf
  , fastDummies  # for dummies
  , stargazer    # for summary and econometrics tables
  , sandwich     # for linear models
  , lmtest       # for robust standar error
  , estimatr     # for iv, cluster, robust standar error (LM_robust)
  , lfe          # for fixed effects, cluster standar error
  , caret        # for easy machine learning workflow (mse, rmse)
  , texreg       # library for export table
  , mfx          # probit , logit model marginal effects
  , xtable
)


# directorio y base de datos ----
user <- Sys.getenv("USERNAME")  # username
setwd( paste0("C:/Users/",user,"/Documents/GitHub/Jose_Pastor_r_py_jl/Python & R & Julia/Trabajo Final") ) # set directorio
repdata <- read_dta("mss_repdata.dta")


#############################################
# exportar en latex una tabla de estadísticas (media, desviación estándar y total de observaciones) ----
table1 <- repdata %>% dplyr::select(NDVI_g, tot_100, trade_pGDP, 
                                    pop_den_rur, land_crop, va_agr, 
                                    va_ind_manf) %>% as.data.frame()

list_vars <- c("NDVI_g", "tot_100", "trade_pGDP", "pop_den_rur", "land_crop", "va_agr", "va_ind_manf")

stargazer(table1, title = "Descriptive Statistics", digits = 2, # decimales con 2 digitos
          covariate.labels = list_vars,                         # Lista de etiquetas
          summary.stat = c("mean", "sd", "n"),                  # se especifica el orden de los estadÃ­sticos
          min.max = F,                                          # borrar el estadístico de maximo y minimo
          notes = "Source: World Bank's World Development Indicators (WDI)."
          ,notes.append = FALSE,                                # TRUE append the significance levels
          notes.align = 'l')                                    # notes.align = 'l' : notas a la izquierda


#####################################
# Replicar la tabla 3 (pag 737). ---- 


# creando dummy por país para efectos fijos
repdata  <- dummy_cols(repdata, select_columns = 'ccode')


# creando variable temporal para que vaya de 1, 2, así...
repdata$time_year <- repdata$year - 1978  


# creando variable trend effect
index <- grep("ccode_", colnames(repdata))
list_vars <- names(repdata)[index]
list_vars[1]

i = 1
while(i < 42){
  var <- paste0(list_vars[i],"_","time")
  repdata[var]  <- repdata[list_vars[i]]*repdata["time_year"]
  i = i + 1
}

repdata$ccode_factor <- as.factor(repdata$ccode)         # variable categórica

index_country_time <- grep("_time$", colnames(repdata))  # grep() devuelve las posiciones
country_time_trend <-names(repdata)[index_country_time]



#####################
####  Modelo 1  #####

# Usando as.formula pues la fórmula del modelo se hace extensa, luego de paste lo convertiré en fórmula
model1 <- as.formula(
  paste("any_prio", "~", paste("GPCP_g", "GPCP_g_l", "ccode_factor", paste(country_time_trend, collapse = "+"), 
                               sep="+")
  )
)


# Usando LM y luego coestest para error standar robusto
m1 <- lm(model1, data = repdata)
lm_rmse1 <- round(RMSE(m1$fitted.values, repdata$gdp_g ), 2 )
robust_model1 <- coeftest(m1,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model1 <- robust_model1[,2]

coefci(m1, df = Inf, vcov. = vcovCL, cluster = ~ ccode, type = "HC1")





#####################
####  Modelo 2  #####

# Usando as.formula pues la fórmula del modelo se hace extensa, luego con paste se convertirá en fórmula
model2 <- as.formula(
  paste("war_prio", "~", paste("GPCP_g", "GPCP_g_l", "ccode_factor", paste(country_time_trend, collapse = "+"), 
                               sep="+")
  )
)

# Usando LM y luego coestest para error standar robusto
m2 <- lm(model2, data = repdata)
lm_rmse2 <- round(RMSE(m2$fitted.values, repdata$gdp_g ), 2 )
robust_model2 <- coeftest(m2,
                          vcov = vcovCL,
                          type = "HC1",
                          cluster = ~ ccode)

sd_robust_model2 <- robust_model2[,2]

coefci(m2, df = Inf, 
       vcov. = vcovCL, cluster = ~ ccode, type = "HC1")




# Exportando tabla a latex

stargazer( m1, m2,                           # los 5 modelos anterioremente calculados
           se=list(sd_robust_model1, sd_robust_model2),
           dep.var.labels = c(""),
           title = "Rainfall and Civil Conflict (Reduced-Form)",
           keep = c("GPCP_g","GPCP_g_l"),   # las variables que mostrará en la tabla
           covariate.labels=c("Growth in rainfall, t","Growth in rainfall, t-1",
                              "Growth in rainfall, t+1"),   # label de las variables que mostrará en la tabla
           align = T, no.space = T,
           add.lines=list(c("Country fixed effects", "yes","yes"),
                          c("Country-specific time trends","yes","yes"),
                          c("Root mean square error",lm_rmse1,lm_rmse2)),
           keep.stat = c("rsq","n"),
           notes.append = FALSE, notes.align = "l",
           notes ="Huber robust standard errors are in parentheses", 
           style = "qje"         # estilo de tabla como los journals of economics
)




###################################################################################################
# Graficar el Coeft plot del coeficiente estimado que corresponde a la variable GPCP g.
# El gráfico debe incluir el coeficiente e intervalo de confianza respectivo de cada modelo.


######### Coefplot Modelo 1 ####################
model1 <- lm(model1, data = repdata) 

model1.tab <- coeftest(model1, vcov=vcovHC(model1, type='HC1')) # vcovHC : heterocedasticidad
# type='HC1': matriz var y cov de Huber-White
model1.tab

model1_coef <- model1.tab[2,1]
model1_coef_se = model1.tab[2,2]

model1_lower = coefci(model1, df = Inf, vcov. = vcovHC, type = "HC1")[2,1]   # fila 2, columna 1
model1_upper = coefci(model1, df = Inf, vcov. = vcovHC, type = "HC1")[2,2]



######## Coefplot Modelo 2 ###################
model2 <- lm(model2, data = repdata) 

# lmtest: coeftest (errores standar robustos para heterocedasticidad)    
model2.tab <- coeftest(model2, vcov=vcovHC(model2, type='HC1')) # vcovHC : heterocedasticidad
# type='HC1': matriz var y cov de Huber-White
model2.tab

model2_coef <- model2.tab[2,1]
model2_coef_se = model2.tab[2,2]

model2_lower = coefci(model2, df = Inf, vcov. = vcovHC, type = "HC1")[2,1]   # fila 2, columna 1
model2_upper = coefci(model2, df = Inf, vcov. = vcovHC, type = "HC1")[2,2]


# Tabla de resultados
table<- matrix(0, 2, 4) # matriz llena de ceros con 3 filas y 4 columnas

table[1,1]<- model1_coef
table[1,2]<- model1_coef_se

table[2,1]<- model2_coef
table[2,2]<- model2_coef_se

table[1,3]<- model1_lower
table[1,4]<- model1_upper

table[2,3]<- model2_lower
table[2,4]<- model2_upper

colnames(table)<- c("Estimate","se","lower_bound","upper_bound")
rownames(table)<- c("OLS any_prio", "OLS war_prio")

# de matriz a dataframe (tab), para poder graficar
tab = as.data.frame(table)

# Exportación a Latex (overleaf)
xtable(table)



###  Coef-plot  ###

theme_set(theme_bw(20)) # tema con fondo blanco y cuadro con bordes en negro

# aes: ejes
options(repr.plot.width = 8, repr.plot.height =5)  # tamaño del gráfico

tab %>% ggplot(aes(x=rownames(tab), y=Estimate)) +
  geom_point(size=2, color = 'red') +
  geom_errorbar(aes(ymin=lower_bound, ymax=upper_bound), width = 0.05, color="black", size = 0.8) +
  labs(x="", y="") + ggtitle("Global Precipitation Climatology Project coefficient (95% CI)")  +
  theme(text=element_text(size =15), plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=0, linetype="dashed", color = "black", size=1) +
  scale_x_discrete(limits = c("OLS any_prio", "OLS war_prio")) + # order x - axis
  theme(panel.grid.major = element_blank(),   # borra las cuadrículas en el fondo
        panel.grid.minor = element_blank())


ggsave("Coef_plot.png"
       , height = 8  # alto
       , width = 12  # ancho
       , dpi = 320   # resolución
)





