# -*- coding: utf-8 -*-
"""
Created on Sat Nov  5 16:28:16 2022

@author: Jose Pastor
"""

import pandas as pd
import numpy as np
import re              # for regular expressions (REGEX)
import os              # for directorio
import swifter         # for parallel procesing
import unidecode       # to drop tildes
from datetime import datetime  # library for time



# "1.0 Set Directorio y leyendo datos"
user = os.getlogin()   # Username
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab8") # Set directorio
data = pd.read_excel("../data/crime_data/data_administrativa.xlsx") # Subir base de datos


# 1. 
# Convertir el nombre de las variables a minúscula
data.columns = map(str.lower, data.columns)   


# 2.
# Fíjese que el nombre de la persona tiene puntuaciones y número, retirar todo aquello 
# que no permita identificar el nombre correcto.
data['solo_nombre'] = data['nombre'].swifter.apply(lambda x: re.sub('[0-9]|\/|\-|\.|\!','',x))  # eliminando números y signos en específico


# 3.
# Limpiar la fecha de nacimiento de aquellos elementos que la ensucien. 
data['fecha'] = data['born_date'].swifter.apply(lambda x: re.findall('[0-9]+/[0-9]+/[0-9]+', str(x)))
data['fecha'] = data['fecha'].apply(lambda x: ''.join(x) )    # extrae los valores de la lista

# Luego crear otra variable con el formato de fecha.
data['fecha_formato'] = pd.to_datetime(data['fecha'], dayfirst = True).dt.strftime('%d/%m/%Y')


# 4.
# Limpiar la columna de edad, el cual tiene puntuaciones que no permiten identificar la edad correcta.
data['edad'] = data['age'].swifter.apply(lambda x: re.findall('[0-9]+',str(x)))  # eliminando números y signos en específico
data['edad'] = data['edad'].apply(lambda x: ''.join(x) )      # extrae los valores de la lista


# 5.
# Crear dummies según el rango del sentenciado en la organización criminal
data["dummy1"] = data['rank'].str.contains(r"banda criminal").map({True: 1, False: 0})
data["dummy2"] = data['rank'].str.contains(r"cabecilla local").map({True: 1, False: 0})
data["dummy3"] = data['rank'].str.contains(r"cabecilla regional").map({True: 1, False: 0})
data["dummy4"] = data['rank'].str.contains(r"sicario").map({True: 1, False: 0})
data["dummy5"] = data['rank'].str.contains(r"extorsion|extorsionador").map({True: 1, False: 0})
data["dummy6"] = data['rank'].str.contains(r"miembro").map({True: 1, False: 0})
data["dummy7"] = data['rank'].str.contains(r"novato|novto|noato|principiante").map({True: 1, False: 0})


# 7.
# Extraer el usuario del correo electrónico.
data['usuario_correo'] = data['correo_abogado'].swifter.apply(lambda x: re.findall('(\w+)\@\.*',str(x)))
data['usuario_correo'] = data['usuario_correo'].apply(lambda x: ''.join(x) )   # extrae los valores de la lista


# 8. 
# Crear una columna que contenga solo la información del número de dni (por ejemplo: 01-75222677)
data['DNI'] = data['dni'].swifter.apply(lambda x: re.findall('[0-9]+-[0-9]+', str(x)))
data['DNI'] = data['DNI'].apply(lambda x: ''.join(x) )    # extrae los valores de la lista


# 9.
# A partir de la columna observaciones, crear las siguientes variables:
# - crimen: debe contener información del delito cometido
def sentenciado(x):
    
    try:
        match = re.search("(?<=sentenciado por )[a-z\s]*", x)
        
        return match.group()
    
    except:
        
        pass

data['crimen'] = data['observaciones'].apply(sentenciado)




# - n_hijos: cantidad de hijos del criminal
def n_hijos(x):
    
    try:
        match = re.search("(?<=tiene )[0-9]*", x)
        
        return match.group()
    
    except:
        
        pass

data['n_hijos'] = data['observaciones'].apply(n_hijos)




# - edad_inicio : edad de inicio en actividades criminales
def edad_inicio(x):
    
    try:
        match = re.search("[0-9]+(?= años)", x)
        
        return match.group()
    
    except:
        
        pass

data['edad_inicio'] = data['observaciones'].apply(edad_inicio)





