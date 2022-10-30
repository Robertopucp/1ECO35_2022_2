# -*- coding: utf-8 -*-
"""
Created on Fri Oct 21 17:27:46 2022

@author: Usuario
"""

# Tarea 6 
import os # for usernanme y set direcotrio
import pandas as pd
import numpy as np
import weightedcalcs as wc # ponderador
from tqdm import tqdm  # controlar el tiempo en un loop

user = os.getlogin()   # Username

os.chdir(f"D:/Users/W10/Documents/GitHub/1ECO35_2022_2/Lab7") # Set directorio




#%% Pregunta 1
# Establecemos las bases que usaremos enaho01_19 y enaho34_19
enaho01_19 = pd.read_stata(r"../../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False) 

enaho34_19 = pd.read_stata(r"../../../datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False)

# Hacemos el merge entre ambas
merge_hog_19 = pd.merge(enaho01_19, enaho34_19, 
                     on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")

# Establecemos las bases que usaremos enaho01_20 y enaho34_20
enaho01_20 = pd.read_stata(r"../../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False) 

enaho34_20 = pd.read_stata(r"../../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)

# Hacemos el merge entre ambas
merge_hog_20 = pd.merge(enaho01_20, enaho34_20, 
                     on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")

# Realizamos el append para los dos años
merge_append_bases = merge_hog_19.append(merge_hog_20, ignore_index = True)

# Establecemos la base de los deflactores
enaho34_deflactores_2020 = pd.read_stata(r"../../../datos/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta",
                           convert_categoricals=False)

merge_append_bases['dpto'] = merge_append_bases['ubigeo'].str[:2] #Generamos indicador de región
merge_append_bases['dpto'] = merge_append_bases['dpto'].astype(float) #Convertimos a float para merge
merge_append_bases['aniorec'] = merge_append_bases['aÑo'] #Generamos indicador de año
merge_append_bases['aniorec'] = merge_append_bases['aniorec'].astype(float) #Convertimos a float para merge

print (enaho34_deflactores_2020.dtypes)
print (merge_append_bases.dtypes)

#Ahora, con los nombres de variables editados, realizamos el merge final por departamento y año

merge_hog_deflactores_2 = pd.merge(merge_append_bases, enaho34_deflactores_2020, 
                     on = ["dpto", "aniorec"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "m:1") 

merge_hog_deflactores = merge_hog_deflactores_2[["conglome", "vivienda", "hogar" , 
                  "ubigeo", "dominio" ,"estrato" ,"dpto", "aniorec",
                  "inghog1d", "gashog2d", "mieperho" , "ld", "i00"]] #Conservamos las variables que nos interesan

merge_hog_deflactores['ingreso_real_mensual'] = merge_hog_deflactores["inghog1d"] / (merge_hog_deflactores["mieperho"]*12*merge_hog_deflactores["ld"]*merge_hog_deflactores["i00"])
#Creamose el ingreso real menusal
merge_hog_deflactores['gasto_real_mensual'] = merge_hog_deflactores["gashog2d"] / (merge_hog_deflactores["mieperho"]*12*merge_hog_deflactores["ld"]*merge_hog_deflactores["i00"])
#Creamose el gasto real menusal




#%% Pregunta 2: Salario por hora del trabajador dependiente

# Establecemos las bases que usaremos enaho05_20
enaho05_20 = pd.read_stata(r"../../../datos/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta",
                           convert_categoricals=False) 
print (enaho05_20.dtypes)

# Conservamos las variables que usaremos
enaho05_20 = enaho05_20[["aÑo", "mes", "conglome", "vivienda", "hogar" , 
                  "ubigeo", "dominio" ,"estrato", "i524e1", "i538e1", "i513t", "i518"]] 

#Editamos la base de datos para reemplazar los missing por ceros
enaho05_20["i524e1"].replace({np.nan: 0}, inplace =True)
enaho05_20["i538e1"].replace({np.nan: 0}, inplace =True)
enaho05_20["i513t"].replace({np.nan: 0}, inplace =True)
enaho05_20["i518"].replace({np.nan: 0}, inplace =True)


enaho05_20['ingreso_anual'] = enaho05_20["i524e1"] + enaho05_20["i538e1"]
#Generamos el ingreso anual

enaho05_20['horas_trabajoxsemana'] = enaho05_20["i513t"] + enaho05_20["i518"] 
#Generamos horas de trabajo por semana

enaho05_20['salarioxhora_trabajo'] = enaho05_20['ingreso_anual'] / (enaho05_20['horas_trabajoxsemana']*52)
#Generamos salario por hora de trabajo

enaho05_20['salarioxhora_trabajo'].replace({0: np.nan}, inplace =True)
#Reemplazamos los valores de 0 por missing nan

print(enaho05_20['salarioxhora_trabajo'].value_counts())





#%%Pregunta 3: Groupby

# Establecemos las bases que usaremos enaho02_20
enaho02_20 = pd.read_stata(r"../../../datos/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta",
                           convert_categoricals=False) 

# Generamos la agrupación para hogares y creamos los miembros totales y la edad máxima de los miembros
enaho_pension_65_20 = enaho02_20.groupby( [ "conglome", "vivienda", "hogar" ],
                              as_index = False ).agg(
                        total_miembros = ('conglome', np.size), 
                        edad = ('p208a', np.max))
                                  
# Realizamos el merge entre enaho_pension_65_20 y enaho34_20                                 
enaho_pension_65_20_2 = pd.merge(enaho_pension_65_20, enaho34_20, 
                     on = ["conglome","vivienda","hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "m:1") 

# Conservamos las variables que nos interesan
enaho_pension_65_20_2 = enaho_pension_65_20_2[["aÑo","conglome", "vivienda", "hogar" , 
                  "ubigeo", "dominio" ,"estrato" , "inghog1d",
                  "gashog2d", "mieperho", "linea", "edad", "total_miembros"]]

#Generamos ingreso_mensual y gasto_mensual
enaho_pension_65_20_2["ingreso_mensual"] = enaho_pension_65_20_2["inghog1d"]/(12*enaho_pension_65_20_2["mieperho"])

enaho_pension_65_20_2["gasto_mensual"]  = enaho_pension_65_20_2["gashog2d"]/(12*enaho_pension_65_20_2["mieperho"])

enaho_pension_65_20_2["pobre"] = np.where(
    enaho_pension_65_20_2["gasto_mensual"] < enaho_pension_65_20_2["linea"], 
                                    1, 0) #Generamos dummy para "pobre" con 1 y "no pobre" con 0

enaho_pension_65_20_2["mayor_de_65"] = np.where(
    enaho_pension_65_20_2["edad"] > 65, 
                                    1, 0) #Generamos dummy para "mayor_de_65" con 1 , "no_mayor_de_65" con 0

enaho_pension_65_20_2["apto_pension_65"] = np.where(
    (enaho_pension_65_20_2["pobre"] == 1) & (enaho_pension_65_20_2["mayor_de_65"] == 1), 
                                    1, 0) #Generamos dummy para "apto_pension_65"con 1 si se cumple las condiciones y "no_apto_pension_65" con 0

print(enaho_pension_65_20_2["apto_pension_65"].value_counts())


