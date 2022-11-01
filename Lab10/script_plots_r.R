################  Clase 10 gráficos ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 

# clear environment

rm(list=ls(all=TRUE)) 

# install.packages("writexl")

# install.packages("librarian") para cargar librerias

librarian::shelf(
  tidyverse
  , lubridate,
  readxl,
  writexl,
  tidyverse # dplyr, stringr, ggplot2, purrr, rvest (download from web)
)


user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab10") ) # set directorio


fin_data <- read_excel("../data/finanzas_data_2.xlsx", sheet = "Hoja1")

dim(fin_data)

colnames(fin_data) <- tolower(colnames(fin_data)) 

# Trabajando la base de datos 

# Para detectar meses en españos necesitamos cambiar Set por Sep
# Luego, colocalos un punto luego del mes 

filter_data  <- fin_data |>
  slice((n() - 900):n()) |> 
  mutate(
    fecha = str_replace_all(fecha, "Set", "Sep"),
    date = str_to_lower(fecha),
    date2 = paste(str_sub(date, 1, 5), ".", str_sub(date, 6, -1), sep = "") # -1 hasta el ultimo caracter
    , fecha = dmy(date2) # aplicando la libreria lubridate
  ) |> 
  select(1:5) |>  
  pivot_longer(!fecha) |> # reshape wide to long
  mutate(
    value = as.numeric(value) # convertir de character a numerico (float)
  )

# conocer el tipo de las variables

sapply(filter_data, class)


# Se define los colores basado en codificación RGB

mi_cl <- 
  c(
    "#b87333"  # marron
    , "#ffd700" # amarillo
    , "#bac4c8" # plateado
    , "#5b7582"  # plomo oscuro 
  )

# Gráfico finanzas 1 ----


filter_data  |> 
  mutate(
    currencies = factor(name, labels = c("Cobre","Oro","Plata","Zinc"))
  ) |> 
  ggplot() +
  aes(fecha, value, group = currencies, color = currencies) +
  geom_line(size = 1, show.legend = F) +  # se grafico en formato de series
  facet_wrap(~ currencies, scales = "free_y") + # se separa en 4 gráficos
  scale_x_date(date_breaks = "40 weeks") +  # separación de las fechas
  labs(
    x = "", y = ""
    , title = "Commodities"
    , subtitle = "Cottizaciones internacionales ($)"
    , caption = "Fuente: BCRP "
  ) +
  scale_color_manual(    # se asigna el color de la serie
    values = mi_cl
  ) +
  scale_y_continuous(labels = scales::dollar) + # formato de fondo blanco 
  theme_minimal() +  # formato de gráfico
  theme( 
    panel.background = element_rect("white", color = NA) #  en blanco el fondo del cuadro
    , panel.border = element_blank()
    , plot.background = element_rect("white") # toda el marco de la imagen en blanco
    , panel.grid.major = element_blank()  # panel blanco
    , panel.grid.minor = element_blank()  # panel blanco
    , plot.margin = margin(.3, 1, .1, .3, "cm")  # margenes de lados
    , axis.line = element_line(colour = "black") # bordes del cuadro
    , axis.text.x = element_text(hjust = .5, angle = 12) # inclinación de la fecha
    , plot.caption = element_text(hjust = 0) # ubicación de la fuente
    , text=element_text(size =10), plot.title = element_text(hjust = 0.5),
    plot.subtitle= element_text(hjust = 0.5) # Titulos o sub centralizados
  )

# save plot

ggsave(
  here::here(
    "plots"
    , "financial.png"
  )
  , height = 8  # alto
  , width = 12  # ancho
  , dpi = 320   # resolución (calidad de la imagen)
)



# Gráfico finanzas 2 ----


data_index <- read_excel("../data/finanzas_data_2.xlsx", sheet = "Sheet1")



data_latam <- data_index |>
  mutate( fecha = str_replace_all(fecha, "Set", "Sep") |>
            str_to_lower()
          , fecha = paste("01.", str_sub(fecha, 1, 3), ".", str_sub(fecha, -2, -1), sep = "") |>
            lubridate::dmy()
  ) |>
  pivot_longer(!fecha) |> # reshape wide to long
  mutate(
    name = str_replace_all(name, "^.{5}", "") ,
    index = as.numeric(value) ,
    pais = case_when(
      name =="ven" ~ "Venezuela"
      , name =="mexico" ~ "Mexico"
      , name =="ecuador" ~ "Ecuador"
      , name =="col" ~ "Colombia"
      , name =="brasil" ~ "Brasil"
      , name =="arg" ~ "Argentina"
      , name =="peru" ~ "Perú"
      , name =="latam" ~ "Latam"
    )
    , pais = fct_reorder2(pais, fecha, index) 
    # se catecoriza por nombre de país, fecha y valor del indicador de riesgo
  ) 



data_index$vallue <- NULL
data_index$name <- NULL








# levels(rp_latam$.id)
theme_ft <- function(...) {
  text_color <- "#68625D"
  color_cases <- "#71C8E4"
  color_cases_text <- "#258BC3"
  color_deaths <- "#CE3240" 
  theme_minimal(base_family = "Outfit Medium", base_size = 16) + 
    theme(
      plot.background = element_rect(color = NA, fill = "#FFF1E5"),
      panel.background = element_rect(color = NA, fill = NA),
      panel.grid = element_blank(),
      panel.grid.major.y = element_line(color = "#E3DACE", size = 0.3),
      text = element_text(color = text_color, lineheight = 1.3),
      plot.title = element_textbox(color = "#040000", family = "Outfit Medium", 
                                   face = "plain", size = 20, width = 1),
      plot.title.position = "plot",
      plot.subtitle = element_markdown(family = "Outfit Medium"),
      plot.caption = element_markdown(
        family = "Outfit", hjust = 1, size = 11.5, color = "#5E5751"),
      plot.caption.position = "plot",
      axis.title = element_blank(),
      axis.text.x = element_text(hjust = 0, color = text_color, size = 14),
      axis.text.y.left = element_markdown(family = "Outfit Medium"),
      axis.text.y.right = element_markdown(family = "Outfit Medium"),
      axis.ticks.x = element_line(size = 0.3),
      axis.ticks.length.x = unit(1.8, "mm"),                     
      plot.margin = margin(t = 12, b = 6, l = 7, r = 15, "mm"),
      strip.text = element_blank(),   # remove default facet titles
      ...
    )
}  



clrs <- c(
  "#056c8d"
  , "#009c3b"
  , "#e63d31"
  , "#0039A6"
  , "#009c3b"
  , "#A52A2A"
)

names(clrs) <- levels(data_latam$pais)

lb_a <- function(y, z){
  annotate(
    "text"
    , x = as_date("2022-03-15")
    , y = y
    , size = 5
    , label = names(clrs)[z]
    , color = clrs[z]
    , hjust = 1
  )
}


data_latam |> 
  ggplot() +
  aes(fecha, index, group = pais, color = pais) +
  geom_point(data = filter(data_latam, fecha == max(fecha)),
             aes(fecha, index, color = pais), shape = 15, size = 4) +
  ggalt::geom_xspline(size = 1, alpha = .8) +
  scale_color_manual(
    values = clrs 
  ) +
  labs(
    x = "", y = "", 
    title = "Latinoamerica: Riesgo país"
    , subtitle = "Diferencial de rendimientos del índice de bonos de mercados emergentes"
    , caption = "Fuente: BCRP"
  ) +
  scale_x_date(date_breaks = "48 months", date_labels = "%B %Y") +
  scale_y_continuous(breaks = seq(150, 800, by = 250)) +
  lb_a(450, 1) +
  lb_a(290, 2) +
  lb_a(220, 3) +
  lb_a(150, 4) +
  theme(
    legend.position = "none"
  ) 


ggsave(
  here::here(
    "plots"
    , "financial_riesgo_pais.png"
  )
  , height = 8  # alto
  , width = 12  # ancho
  , dpi = 320   # resolución (calidad de la imagen)
)


