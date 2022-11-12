################  Clase 10 gráficos (World Bank) ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza

# clear environment

rm(list=ls(all=TRUE))


# usamos librarian para cargar librerias, y si no estan instalados, la liberia lo hara por nosotros


# Si no tienen librarian solo deben instalarlo

#install.packages("librarian")

librarian::shelf(
    tidyverse
    , WDI
    , forcats
    , writexl

)

# Set directorio ----

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab10") ) # set directorio


help(WDI)

data <- WDI(indicator = "NY.GDP.PCAP.KD", start = 2018, end = 2018)

# extraemos la información del GDP para el 2018

country_code <- as_tibble(WDI_data$country)

# WDI_data$country : extraemos información a nivel país

# filtro de la base de datos

data_plot <- data |>
    rename(GDP = NY.GDP.PCAP.KD) |>  # usando merge de la libreria dpplyr (inner merge)
    inner_join(country_code, by = "iso2c") |> # key word: iso2c código del país
    filter(region != "Aggregates") |> # nos quedamos solo con países
    top_n(-30, GDP) |> # se extrae 30 paises con los menores niveles de GDP
    mutate(country = fct_reorder(country.x, GDP)) # ordenando country a partir de GDP (orden ascendente)

# Esto para ordenar las barras de manera ascendente


# writexl::write_xlsx(data_plot, "wb_countries.xlsx")


attributes(data_plot)  # conociento los atributos de una base de datos. En general de cualquier objeto en R.

# Plot

data_plot |> ggplot() +
     aes(x = country, y = GDP, fill = region) +  # se agrupará por región (color)
    geom_bar(stat = "identity", alpha = .6, width = .5)  + # with: ancho de barra, alpha: transparencia de gráfico
    geom_text(
        aes(label = format(round(GDP, 1), nsmall = 1)),  # nsmall: cantidad de decimales
        hjust = - 0.35,
        size = 3  # tamaño
    ) +
    coord_flip(ylim = c(0, 2000)) + #coord_flip: El eje x es ahora el eje Y. Luego se define el rango del eje y
    geom_hline(yintercept = 0, alpha = 0.5) + # añadimos un intercepto vertical
    xlab("")  + # retiramos el label country
    ylab("GDP per capita (constant 2000 US$) in 2020") +
    theme_classic() + # fondo de blanco
    scale_fill_brewer(palette = "Set2", name = "Region") + # Set2 paleta de colores
    theme(
        axis.line.y = element_blank(), # retira la recta vertical del eje
         axis.ticks.y = element_blank(), # se retira las lineas punteadas del eje vertical
         legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 10) # cambiamos el tamaño del titulo en el eje horizontal
    )


# Ejemplo 2: scater plot

librarian::shelf(
    ggrepel
    , scales
)


data <- WDI(indicator = "NY.GDP.PCAP.KD", start = 1980, end = 2020)

# trabajamos la base de datos

data_plot <- data %>%
    rename(GDP = NY.GDP.PCAP.KD) %>%
    inner_join(country_code, by = "country") %>%
    filter(year %in% c(1980, 2020), region != "NA") %>%
    group_by(iso3c.x) %>%
    pivot_wider(names_from = "year", values_from = "GDP") %>% # long to wide
    ungroup() |> # se desactiva el agrupamiento
    rename (pc_gdp_1980 = `1980`, pc_gdp_2020 = `2020`) |>
    mutate(pc_gdp_2020 = pc_gdp_2020/1000, pc_gdp_1980 = pc_gdp_1980/1000)


country_stress <- c("USA","CHN","BRA") # lables (etiquetas)

# graficos

ggplot(data_plot , aes(x = pc_gdp_1980, y = pc_gdp_2020)) +
    geom_point(aes(alpha = 0.8, color = (iso3c.x %in% country_stress)), show.legend = FALSE) +
    geom_abline(slope = 1, color = "gray") +
    geom_text_repel(aes(label = ifelse(iso3c.x %in% country_stress, iso3c.x, ""))) +
    scale_y_continuous(
        limits = c(0, 100),
        breaks = c(0, 25,50, 75,100),
        labels = expression(0, 25,50,75, 100)
    ) +
    scale_x_continuous(
        limits = c(0, 100),
        breaks = c(0, 25,50,75, 100),
        labels = expression(0, 25,50,75, 100)
    ) +
    scale_color_manual(values = c("gray", "red")) +
    xlab("GDP per capita (constante 2000 miles-US$)  1980") +
    ylab("GDP per capita (cosntante 2000 milesUS$)  2020") +
    theme_classic() +
    theme(
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 10)
    )




ggsave("../plots/scatter.png"
    , height = 8  # alto
    , width = 12  # ancho
    , dpi = 320   # resolución (calidad de la imagen)
)























