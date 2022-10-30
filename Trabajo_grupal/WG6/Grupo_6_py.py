# -*- coding: utf-8 -*-
"""
Created on Sun Oct 30 09:55:19 2022

@author: oa_da
"""

#!pip install weightedcalcs

import pandas as pd
import numpy as np
import chardet # to get string character format 
import re  # for regular expression 
import os # for usernanme y set direcotrio

# Comenzamos cargando el dataset 2019

user = os.getlogin()   # Username
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG6")

enaho2019= pd.read_stata(("../../enaho/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta"))
sumaria2019= pd.read_stata(("../../enaho/2019/687-Modulo01/687-Modulo34/sumaria-2019.dta"))

# se realiza el merge entre ambas modulos para el año 2019

enaho_2019 = pd.merge(enaho2019, sumaria2019,
                       on = ["conglome", "vivienda", "hogar"], 
                       how = "left", 
                       suffixes=('', '_y')) #se determinan los sufijos

#se filtran por ciertas variables 
enaho_2019 = enaho_2019[["conglome", "vivienda", "hogar" ,"ubigeo", 
                   "aÑo" , "mieperho", "inghog1d", 
                   "gashog2d", "ld"]]


#Ahora, se carga el dataset 2020

enaho2020= pd.read_stata(("../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta"))
sumaria2020= pd.read_stata(("../../enaho/2020/737-Modulo01/737-Modulo34/sumaria-2020.dta"))

# se realiza el merge entre ambas modulos para el año 2020

enaho_2020 = pd.merge(enaho2020, sumaria2020,
                       on = ["conglome", "vivienda", "hogar"], 
                       how = "left", 
                       suffixes=('', '_y')) #se determinan los sufijos

#nuevamente se procede a filtrar según las variables indicadas

enaho_2020 = enaho_2020[["conglome", "vivienda", "hogar" ,"ubigeo", 
                   "aÑo" , "mieperho", "inghog1d", 
                   "gashog2d", "ld"]]

#una vez juntadas las bases de datos para cada año se realizará el append

merge_append = enaho_2020.append(enaho_2019, 
                                 ignore_index = True)
merge_append

#se deflactaran las variables de manera espacial y temporal
#primero se llamará  la base de datos de deflactores con año base 2020

deflactores_base2020_new = pd.read_stata(r"../../../../enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta",
                           convert_categoricals=False)

#

merge_append_deflac = pd.merge(merge_append, deflactores_base2020_new,
                       on = ["dpto", "aNo"],
                       how = "left", 
                       validate = "m:1")




