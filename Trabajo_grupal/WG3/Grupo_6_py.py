# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 19:29:11 2022

@author: HP
"""

#%%
##### PREGUNTA 1 #####
import numpy as np
import pandas as pd
from pandas import DataFrame,Series

junin_data = pd.read_excel("/Users/lorenzochiroque/Documents/GitHub/1ECO35_2022_2/data/Region_Junin.xlsx") #Dirección mía, pero podremos editarla en base a la ubicación de nuestra base de datos ;p

junin_data #Abrimos la base de datos, con esto apreciamos todas las columnas "nom. variables" y alunas filas "".
### item 1  -> "Nombre de todas las variables"

junin_data.head() 
print( junin_data.shape ) # filas y columnas

### item 2  -> "Mostrar el tipo de variables (type) así como presentar los principales estadísticos"

junin_data.info() # podremos ver el tipo de variable con la que estamos trabajando.
junin_data.describe() #con describe podremos visualizar los principales estadísticos.

### item 3  -> "Verifique si las columnas presentan missing values".

junin_data.isna().sum()

# Podremos ver que todas las variables con un número mayor a 0, poseen algún missing value. Donde claramente indican cuántos missing values presentan. Así, vemos que la variable PLACE es la que posee más.

### item 4  -> "Cambie el nombre de las variables (place, men_not_read, women_not_read y total_not_read)".

junin_data.rename(columns = {'Place':'comunidad', 'men_not_read':'homxlee', 'women_not_read':'mujerxlee', 'total_not_read':'totalxlee'}, inplace = True)

junin_data.info() #confirmamos el cambio de nombre, al ver las variables


### item 5  -> "Muestre los valores únicos de las siguientes variables (comunidad , District)".
junin_data["comunidad"].unique()
junin_data["District"].unique()

# # item  6 -> "Crear columnas con la información indicada"

#Manera 1 de crear: generando las variables gracias a assign y lambda.
junin_data = junin_data.assign(porcentaje_mujerxlee=lambda x: x.mujerxlee / x.totalxlee * 100)
junin_data = junin_data.assign(porcentaje_homxlee=lambda x: x.homxlee / x.totalxlee * 100)
junin_data = junin_data.assign(porcentaje_nativos=lambda x: x.natives / (x.peruvian_men + x.peruvian_women + x.foreign_men + x.foreign_women)*100)

junin_data

#Manera 2 de crear: utilizando las variables y dividiendolas directamente.
junin_data['porcentaje_mujerxlee'] = junin_data['mujerxlee'] / junin_data['totalxlee'] * 100
junin_data['porcentaje_homblee'] = junin_data['homxlee'] / junin_data['totalxlee'] * 100
junin_data['porcentaje_nativos'] = junin_data['natives'] / (junin_data['peruvian_men'] + junin_data['peruvian_women'] + junin_data['foreign_men'] + junin_data['foreign_women'])* 100

junin_data

### item 7 -> "Crear la base de datos con la información presentada"

# a. Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción
is_district = (junin_data.District.isin(["ACOLLA","CIUDAD DEL CERRO", "JAUJA", "SAN GERÓNIMO", "TARMA", "OROYA", "CONCEPCIÓN"]))
junin_dataa=junin_data[is_district]
junin_dataa

# b. Luego quedarse con las comunidades que cuentan con nativos y mestizos.
junin_datab = junin_dataa[(junin_dataa["natives"] > 0) & (junin_dataa["mestizos"] > 0)]
junin_datab

#c. Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.
junin_datac = junin_datab.loc[:,['District','comunidad']]
junin_datac

#d. Guardar la base de datos en formato csv en la carpeta data. (Use el siguiente nombre Base_cleaned_WG(numero de grupo)
junin_datac.to_csv("/Users/lorenzochiroque/Documents/GitHub/1ECO35_2022_2/data/Base_cleaned_WG(6).csv")

#%%
##### PREGUNTA 2 python #####

import numpy as np

np.random.seed(500)
np.random.rand(100)

# Cremos el vector que cuenta con  100 observaciones
vector = np.arange(100)

# Fijamos el minimo y maximo de nuestro vector
minimo = np.min(vector)
maximo = np.max(vector)

# Definimos la funcion X
def function(x):

# Realizamos la reescala para esa funcion.     
    escalar = (x-min(x))/(max(x)-min(x))    
    return escalar

list( map( lambda x: function(x) , vector)   )

# Creamos las variables hasta X4, de modo que todas tienen distribución uniforme
np.random.seed(500)
x1 = np.random.rand(100) # uniform distribution  [0,1]
x2 = np.random.rand(100) # uniform distribution [0,1]
x3 = np.random.rand(100) # uniform distribution [0,1]
x4 = np.random.rand(100) # uniform distribution [0,1]

X = np.column_stack((np.ones(100),x1,x2,x3,x4))


np.min(X, axis=0)   # axis = 0 (se aplica por columnas)
np.max(X, axis=0)

#%%
##### PREGUNTA 3 #####

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect  

# Definiendo la funcion args para la aplicacion de operaciones al vector
def function(*args):
    print(args)
    for u in args:
        print(u)

# Creando un vector de 6 elementos utilizando la librería numpy
a = np.random.randint(0,20,5)
print(a)

# Definiendo y Construyendo la función mediante **kwargs
def f(*x,**kwargs):
   return (x-np.mean(x))/np.std(x)
for i in a:
    print (f(a))

