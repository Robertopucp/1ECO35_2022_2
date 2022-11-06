#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 23 14:31:37 2022

@author: lorenzochiroque
"""


import pandas as pd
import numpy as np
import re 
import os 



user = os.getlogin()   # Username

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab8") # Set directorio

data = pd.read_excel("../../../data/crime_data/data_administrativa.xlsx")

#Donde: 
### Nombre -> nombre completo del sentenciado
### born_date -> fecha de nacimiento
### AGE -> edad del sentenciado
### rank -> Rango del sentenciado en la banda criminal.


####################################################################################################
### 1. Convertir el nombre de las variables a minúscula (COLUMNAS)
####################################################################################################



data = pd.read_excel("/Users/lorenzochiroque/Documents/GitHub/1ECO35_2022_2/data/crime_data/data_administrativa.xlsx")
data.columns = map(str.lower, data.columns)



####################################################################################################
### 2. Fíjese que el nombre de la persona tiene puntuaciones y número, retirar todo aquello que no permita identificar el nombre correcto.
####################################################################################################



data['nombre'] = data['nombre'].apply(lambda x: re.sub('[0-9]','',x))



####################################################################################################
### 3. Limpiar la fecha de nacimiento de aquellos elementos que la ensucien. Luego crear otra variable con el formato de fecha.
####################################################################################################


data.born_date = data.born_date.str.replace ("[^0-9]\W+","")

data['born_date'] = pd.to_datetime(data['born_date']).dt.date


####################################################################################################
### 4. Limpiar la columna de edad, el cual tiene puntuaciones que no permiten identificar la edad correcta.
####################################################################################################



data['age1'] = data['age'].apply(lambda x: re.sub('\D','',str(x)))

data['borndate2'] = data['born_date'].apply(lambda x: re.sub('(:00:00)|(!%&)|(00/00/00)','',x))



####################################################################################################
### 5. Crear dummies según el rango del sentenciado en la organización criminal

#####  dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
#####  dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#####  dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#####  dum4: toma el valor de 1 si el sentenciado fue sicario
#####  dum5: toma el valor de 1 si el sentenciado realizó extorsión
#####  dum6: toma el valor de 1 si el sentenciado fue miembro regular
#####  dum7: toma el valor de 1 si el sentenciado fue novato o principiante

####################################################################################################

data["dum1"] = np.where(data["rank"] == "lider de la banda criminal",1, 0)
data["dum2"] = np.where(data["rank"] == "cabecilla local",1, 0)
data["dum3"] = np.where(data["rank"] == "cabecilla regional",1, 0)
data["dum4"] = np.where(data["rank"] == "sicario",1, 0)
data["dum5"] = np.where(((data["rank"] == "extorsion") | (data["rank"] == "extorsionador")),1, 0)
data["dum6"] = np.where(data["rank"] == "miembro",1, 0)
data["dum7"] = np.where(((data["rank"] == "novato") | (data["rank"] == "noato") | (data["rank"] == "novto") | (data["rank"] == "principiante")),1, 0)



####################################################################################################
### 7. Extraer el usuario del correo electrónico.
####################################################################################################



data['usuario_correo'] = data['correo_abogado'].apply(lambda x: re.sub('[^a-zA-Z\s]','',str(x)))



####################################################################################################
### 8. Crear una columna que contenga solo la información del número de dni (por ejemplo: 01-75222677)
####################################################################################################

data['dni_limpio'] = data['dni'].apply(lambda x: re.sub('[a-zA-Z]','',x))

####################################################################################################
### 9. A partir de la columna observaciones, crear las siguiente variables:
######### crimen: debe contener información del delito cometido
######### n_hijos: cantidad de hijos del criminal
######### edad_inicio : edad de inicio en actividades criminales
####################################################################################################


### -> falta ##### 


