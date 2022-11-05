################  Clase 10 gráficos (World Bank) ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza

# clear environment

rm(list=ls(all=TRUE))

librarian::shelf(
    tidyverse
    , haven

)

# Set directorio ----

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab10") ) # set directorio


# load dataset

enaho <- read_dta("../../data/ENAHO/enaho.dta", encoding = "latin1")

# dpluy mutate

enaho <- enaho %>% mutate(empresa = case_when(empresa == 1 ~ "Microempresa",
                                              empresa == 2 ~ "Pequeña empresa", empresa == 3 ~ "Mediana empresa",
                                              empresa == 4 ~ "Gran empresa")) %>%
    mutate(area = case_when(area == 0 ~ "Rural",
                            area == 1 ~ "Urbano"))

# Plot 1


enaho %>% filter(year == 2019 & ! is.na(empresa)) %>%
    ggplot(aes(x= empresa)) + geom_bar() + theme_classic()


ggsave("../plots/plot_barras.png"
       , height = 8  # alto
       , width = 12  # ancho
       , dpi = 50   # resolución (calidad de la imagen)
)

# Barras ----

enaho %>% filter(year == 2019 & ! is.na(empresa)) %>%
    ggplot(aes(x= reorder(empresa, empresa, function(x) length(x)) )) + geom_bar()
+ labs(x = "Clasificación de Empresa", y = " ", title = "Bar plot - size business") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) + theme_classic()


enaho %>% filter(year == 2019 & ! is.na(empresa)) %>%
    ggplot(aes(x= reorder(empresa, empresa, function(x) -length(x)) )) +
    geom_bar(width=0.7) + labs(x = "Clasificación de Empresa", y = " ") +
    theme_classic() + theme(axis.text.x = element_text(angle = 90, hjust = 1))



# Plot 2


enaho %>%  filter(year == 2019 & ! is.na(empresa))  %>%
    ggplot(aes(x= reorder(empresa, empresa, function(x) -length(x)) )) +
    geom_bar( width=0.5 , fill="steelblue") +
    labs(x = "Tipo de Empresa", y = " ", title = "Cantidad de empresas según clasificación") +
    theme(axis.title = element_text(size = 15, color = "black", face = "italic")) +   # change text format axis
    theme(text=element_text(size =12), plot.title = element_text(hjust = 0.5))   # center title


# Plot2 con etiquetas en las barras

enaho %>%  filter(year == 2019 & ! is.na(empresa))  %>%
    ggplot(aes(x= reorder(empresa, empresa, function(x) -length(x)) )) +
    geom_bar( width=0.5 , fill="steelblue") + labs(x = "Tipo de Empresa", y = " ", title = "Cantidad de empresas según clasificación") +
    theme(axis.title = element_text(size = 15, color = "blue", face = "italic")) +
    theme(text=element_text(size =12), plot.title = element_text(hjust = 0.5)) +
    geom_text(aes(x= empresa,label=..count..), stat='count', color="black", hjust = 0.5, vjust = -0.5 )


# Gráfico de barras por zona

enaho %>%  filter(year > 2016 & ! is.na(empresa))  %>%
    ggplot() +
    geom_bar(aes(x= empresa, fill = area), width=0.5, colour="black") +
    labs(x = "Tipo de Empresa", y = " ", title = "Cantidad de empresas según clasificación") +
    theme(axis.title = element_text(size = 15, color = "blue", face = "italic")) +
    theme(text=element_text(size =12), plot.title = element_text(hjust = 0.5))

# Distribuciones ----

enaho %>%  filter(year == 2019 & !is.na(l_salario) ) %>%
    ggplot() + geom_histogram(aes(x=l_salario), bins = 30) +
    labs(x = " ", y = "Absolute frequency", title = "Log real - wage") +
    theme(text=element_text(size =12), plot.title = element_text(hjust = 0.5))


enaho %>%  filter(year == 2019 & !is.na(l_salario) ) %>%
    ggplot() + geom_histogram(aes(x=l_salario), bins = 30, color = "black", fill = "steelblue") +
    labs(x = " ", y = "Absolute frequency", title = "Log real - wage") +
    theme(text=element_text(size =12), plot.title = element_text(hjust = 0.5))  +
    geom_vline(aes(xintercept = mean(l_salario)),
               linetype = "dashed", size =2 , color = "red") +
    theme(legend.position = "top")


enaho %>%  filter(year == 2019 & !is.na(l_salario) ) %>%
    ggplot(aes(x=l_salario)) + geom_histogram(aes(color = empresa, fill = empresa),
                                              alpha = 0.4, position = "identity") +
    labs(x = " ", y = "Absolute frequency", title = "Log real - wage") +
    theme(text=element_text(size =12), plot.title = element_text(hjust = 0.5))


# Sector económico ----

enaho <- enaho %>% mutate(sector = case_when(sector == 1 ~ "Agricultura y pesca", sector == 2 ~ "Minería",
                                             sector == 3 ~ "Manufactura", sector == 4 ~ "Construcción",
                                             sector == 5 ~ "Comercio", sector == 6 ~ "Transporte y comunicaciones",
                                             sector == 7 ~ "Finanzas y seguros" , sector == 8 ~ "Servicios" ))


enaho %>% filter(year == 2019 & !is.na(sector)) %>% filter(sector %in% c("Construcción","Comercio", "Minería"))  %>%
    ggplot(aes(x=l_salario, fill = sector , colour=sector)) +
    geom_density(alpha=0.4, color = "black") +
    ggtitle("Log-wage density ") + theme(text=element_text(size =10), plot.title = element_text(hjust = 0.5)) +
    labs(x = "",
         y = "Density")

ggsave("imagen1.png", width = 10, height = 10, dpi = 200)





