# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 09:49:56 2022

@author: Grupo 8
Integrantes: 
            Mariel León
            Erika Olivera
            Jorge Moya
            Maria Nechochea

"""
#%%Pregunta1

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import os

user = os.getlogin()   # Username
print(user)

#Primero corremos el directorio e importamos la base de datos
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data")
junin_data = pd.read_excel('Region_Junin.xlsx')

#1.-Obtenemos los nombres y tipos de mis variables
print(junin_data.info()) 

#2.-Mostramos los principales datos estadisticos: mediana, media, minimo, max, primer quintil,tercer quintil
print(junin_data.describe())

#3.-Verificamos qué variables presentan missing values. Al correr cada código, se mostrará el número de missing values que presenta cada variable.

print(junin_data['Region'].isna().sum())
print(junin_data['District'].isna().sum())
print(junin_data['Place'].isna().sum())
print(junin_data['4_6_years_men'].isna().sum())
print(junin_data['4_6_years_women'].isna().sum())
print(junin_data['4_6_years_total'].isna().sum())
print(junin_data['6_14_years_men'].isna().sum())
print(junin_data['6_14_years_women'].isna().sum())
print(junin_data['6_14_years_total'].isna().sum())
print(junin_data['man_read'].isna().sum())
print(junin_data['women_read'].isna().sum())
print(junin_data['total_read'].isna().sum())
print(junin_data['men_not_read'].isna().sum())
print(junin_data['women_not_read'].isna().sum())
print(junin_data['total_not_read'].isna().sum())
print(junin_data['man_write'].isna().sum())
print(junin_data['women_write'].isna().sum())
print(junin_data['total_write'].isna().sum())
print(junin_data['men_not_write'].isna().sum())
print(junin_data['women_not_write'].isna().sum())
print(junin_data['total_not_write'].isna().sum())
print(junin_data['instruction_men'].isna().sum())
print(junin_data['instruction_women'].isna().sum())
print(junin_data['instruction_total'].isna().sum())
print(junin_data['no_instruction_men'].isna().sum())
print(junin_data['no_instruction_women'].isna().sum())
print(junin_data['no_instruction_total'].isna().sum())
print(junin_data['finished_instr_men'].isna().sum())
print(junin_data['finished_instr_women'].isna().sum())
print(junin_data['finished_instr_total'].isna().sum())
print(junin_data['not_finished_instr_men'].isna().sum())
print(junin_data['not_finished_instr_women'].isna().sum())
print(junin_data['not_finished_instr_total'].isna().sum())
print(junin_data['peruvian_men'].isna().sum())
print(junin_data['peruvian_women'].isna().sum())
print(junin_data['foreign_men'].isna().sum())
print(junin_data['foreign_women'].isna().sum())
print(junin_data['whites'].isna().sum())
print(junin_data['natives'].isna().sum())
print(junin_data['mestizos'].isna().sum())
print(junin_data['blacks'].isna().sum())

#4.-Cambiamos nombres a las siguientes variables:
#comunidad en lugar de place, homxlee en lugar de men_not_read, 
#mujerxlee en lugar de woman_not_read y totalxlee en lugar de total_not_read

print(junin_data.rename(columns = {'Place':'Comunidad', 'men_not_read':'Homxlee', 'women_not_read':'Mujerxlee', 'total_not_read': 'Totalxlee'}, inplace = True))

#5.-Muestre los valores únicos de las siguientes variables ( comunidad , District)

print( junin_data.Comunidad.unique() )
print( junin_data.District.unique() )

#6.-Crear columnas con las siguiente información:
    #el % de mujeres del que no escriben ni leen (mujerxlee/totalxlee) 
    
#para hallar el % de las mujeres que no leen multiplicamos por 100 a la división (mujerxlee/totalxlee)
junin_data['%mujeresnoleen'] = 100 * junin_data['Mujerxlee'] / junin_data['Totalxlee'] 
#para hallar el % de las mujeres que no escriben multiplicamos por 100 a la división (mujerxlee/totalxlee)
junin_data['%mujeresnoescriben'] = 100 * junin_data['women_not_write'] / junin_data['total_not_write'] 

#% de varones que no escriben ni leen (homxlee/totalxlee)
#se realiza el mismo procedimiento que para mujeres
junin_data['%hombresnoleen'] = 100 * junin_data['Homxlee'] / junin_data['Totalxlee'] 
junin_data['%hombresnoescriben'] = 100 * junin_data['men_not_write'] / junin_data['total_not_write']

#% de nativos respecto al total de la población. 
#primero creamos una variable "población total" que suma mujeres y hombres peruanos y extranjeros
junin_data['poblacióntotal']= junin_data['peruvian_women'] + junin_data['peruvian_men'] + junin_data['foreign_women'] + junin_data['foreign_men']
#hallamos el % de nativos respecto al total de la población
junin_data['%nativos'] = 100 * junin_data['natives'] / junin_data['poblacióntotal'] 

#7.-Crear una base de datos con la siguiente información:
#a. Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción

Base_nueva = junin_data[junin_data["District"].isin(["CIUDAD DEL CERRO", "JAUJA", "SAN GERÓNIMO", "TARMA", "OROYA", "CONCEPCIÓN"])]

# b. Luego quedarse con las comunidades que cuentan con nativos y mestizos.

Base_nueva_con_nativos = Base_nueva[Base_nueva["natives"] > 0 ]
Base_nueva_con_mestizos_y_nativos = Base_nueva_con_nativos[Base_nueva_con_nativos["mestizos"] > 0 ]

# c. Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.

Base_final = Base_nueva[["District", "Comunidad", "%mujeresnoleen", "%mujeresnoescriben", "%hombresnoleen", "%hombresnoescriben", "poblacióntotal", "%nativos"]]

# d. Guardar la base de datos en formato csv en la carpeta data.

junin_data.to_csv("../data/Base_cleaned_WG(8).csv")



#%%Pregunta 2

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect  # Permite conocer los argumentos de una función , classes, etc

#creamos vector de 100 observaciones
vector = np.arange (100) 

#creamos una matriz "M"
M = np.arange(0,5000).reshape (100, 50) #esta tiene valores del 0 al 4999 y se utiliza el "reshape" para que sea una matriz de 100x50

#Reescalamos los datos del vector utilizando map
def sdv(x,min, max):
    
    out = (x-min)/max-min
    
    return out 

list( map( lambda x, v1 = np.min(vector), v2 = np.max(vector): sdv(x,v1, v2) , vector)  )  

vector1 = (vector - np.min(vector))/np.max(vector)-np.min(vector)

#Reescalamos datos de la matriz M utilizando apply_along_axis
np.min(M, axis=0)   # axis = 0 (se aplica por columnas)
print(np.min(M, axis=0) )
np.max(M, axis=0)
print(np.max(M, axis=0))

M_std = np.apply_along_axis(lambda m: (m-m.min())/(m.max()-m.min()),0, M)

#%%Pregunta 3

import numpy as np

# Usamos kwargs para definir las operaciones y args para el vector
def calculator( *args, **kwargs):
    
    print( type( args ) )
    print( type( kwargs ) )
    
    # Para estandarizar
    if ( kwargs[ 'function' ] == "estandarizar" ) :
        
        # Get the first value
        result = (args - np.mean(args))/np.std(args)
    # Para reescalar
    elif ( kwargs[ 'function' ] == "reescalar" ) :

        result = (args - np.min(args))/(np.max(args)-np.min(args))
   
    # Mensaje de error por tipo de argumento
    else:
        raise ValueError( f"The function argument {kwargs[ 'function' ]} is not supported." )
        
    return result

# Que corra el código
calculator( 4, 5, 6, 7, 8, function = "estandarizar" )

calculator( 4, 5, 6, function = "reescalar"  )
