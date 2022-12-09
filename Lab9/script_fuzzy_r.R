################  Clase 9 Fuzzy match ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 

# clear environment
rm(list=ls(all=TRUE)) 

# Load libraries ----


library(tidyverse)
library(readxl)
library(stringdist)  # indicadores de similaridad 
library(fuzzyjoin) # merge dataste using names o text column


user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab9") ) # set directorio

# Load excel files ----

master <- read_excel("../data/Fuzzy/nombres.xlsx", sheet = "Hoja1")


usdata <- read_excel("../data/Fuzzy/nombres.xlsx", sheet = "Hoja2")


# Comparamos nombres 
# Caso 1

name1 <- "Juan Pablo Villanueva Melcochita"
name2 <- c("juan pablo! villanueva 5 melcochita..", "Jose fabricio")


# Uso de help para 
# help("stringdist")

# Fuzzy match ----

# distances basado en Levenshtein distance


stringdist(name1, name2,  method = "lv")

# Jaro-Winkler method

similarites <- 1 - stringdist(name1, name2,  method = "jw")

print(similarites)

# cosine method

similarites <-  1 - stringdist(name1, name2,  method = "cosine")

print(similarites)

# help('stringdist-metrics')

# Caso 2: ausencia de palabras

name2 <- "Juan melcochita"

stringdist(name1, name2,  method = "lv")

# Jaro-Winkler method

similarites <- 1 - stringdist(name1, name2,  method = "jw")

print(similarites)

# cosine method

similarites <-  1 - stringdist(name1, name2,  method = "cosine")
print(similarites)


# Caso 3: ordenamiento diferentes


name2 <- "Villanueva Juan Pablo"

# distances basado en Levenshtein distance

stringdist(name1, name2,  method = "lv")

# Jaro-Winkler method

similarites <- 1 - stringdist(name1, name2,  method = "jw")

print(similarites)

# cosine method

similarites <-  1 - stringdist(name1, name2,  method = "cosine")
print(similarites)

# Caso4: Repitición de palabras


name2 <- "Villanueva Villanueva Juan Pablo PABLO"

# distances basado en Levenshtein distance

stringdist(name1, name2,  method = "lv")

# Jaro-Winkler method

similarites <- 1 - stringdist(name1, name2,  method = "jw")

print(similarites)

# cosine method

similarites <-  1 - stringdist(name1, name2,  method = "cosine")
print(similarites)


# Fuzzy join ----


# Levenshtein distance

data_match_lv <- stringdist_join(
  master, usdata,
  by = "Nombre",
  method = "lv",
  mode = "left",max_dist=99, # maxima cantidad de cambios
  ignore_case = T, distance_col='lv_score'
)

# Jaro-Winkler method

data_match_jw <- stringdist_join(
  master, usdata,
  by = "Nombre",
  method = "jw",
  mode = "left",
  ignore_case = T, distance_col='jw_score'
)

# cosine method

data_match_cs <- stringdist_join(
  master, usdata,
  by = "Nombre",
  method = "cosine",
  mode = "left",
  ignore_case = T, distance_col='cs_score'
)


# seleccioanndo los 3 mejores matches

data_match_lv <- stringdist_join(
  master, usdata,
  by = "Nombre",
  method = "lv",
  mode = "left",max_dist=99, # maxima cantidad de cambios
  ignore_case = T, distance_col='lv_score'
) %>%
  group_by(Nombre.x) %>%
  slice_min(order_by=lv_score, n=3)







