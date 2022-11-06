# -*- coding: utf-8 -*-
"""
Created on Sat Nov  5 19:07:51 2022

@author: Grupo 8
"""

import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import swifter  # for parallel procesing
import unidecode # to drop tildes
from datetime import datetime 

user = os.getlogin()   # Username
print(user)

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data/crime_data") # Set directorio

data_administrativa = pd.read_excel("data_administrativa.xlsx") # Subir base de datos

#Pregunta 1:

data_administrativa.columns = map(str.lower, data_administrativa.columns)

#Pregunta 2:
    
data_administrativa['nombre'] = data_administrativa['nombre'].apply(lambda x: re.sub('\d','',x))
data_administrativa['nombre'] = data_administrativa['nombre'].apply(lambda x: re.sub('[^a-zA-Z\s]','',x))

#Pregunta 3:
    
data_administrativa['born_date'] = data_administrativa['born_date'].apply(lambda x: re.sub('(00:00)|(!)|("#%)','',x))

data_administrativa['born_date_month_year'] = pd.to_datetime(data_administrativa['born_date']
                                             , dayfirst = True).dt.strftime('%d/%m/%Y')
#Pregunta 4:
   
data_administrativa['age'] = data_administrativa['age'].apply(lambda x: re.sub('\D','',str(x)))

#Pregunta 5:

#Dummy 1:    
data_administrativa['lider_banda_crim'] =  np.where(data_administrativa['rank'].str.contains('lider de la banda criminal', regex=True),1,0)

#Dummy 2:
data_administrativa['cabecilla_local'] =  np.where(data_administrativa['rank'].str.contains('cabecilla local', regex=True),1,0)

#Dummy 3:
data_administrativa['cabecilla_regional'] =  np.where(data_administrativa['rank'].str.contains('cabecilla regional', regex=True),1,0)

#Dummy 4:
data_administrativa['sicario'] =  np.where(data_administrativa['rank'].str.contains('sicario', regex=True),1,0)

#Dummy 5:
data_administrativa['extorsion'] =  np.where(data_administrativa['rank'].str.contains('extorsion', regex=True),1,0)

#Dummy 6:
data_administrativa['miembro_regular'] =  np.where(data_administrativa['rank'].str.contains('miembro', regex=True),1,0)

#Dummy 7:
data_administrativa['novato_o_principiante'] =  np.where(data_administrativa['rank'].str.contains('(^novato)|(^principiante)', regex=True),1,0)

#Pregunta 7:

# extraer usuario de correo 

correo = "correo_abogado"

data_administrativa['correo'] = data_administrativa['correo_abogado'].apply(lambda x: re.search("(\w+)\@\.*", str(x)).group(1) )

#Pregunta 8:
    
#Crear una columna que contenga solo la información del número de dni 

numdni = "dni"
data_administrativa['numdni'] = data_administrativa['dni'].apply(lambda x: re.search("\.*([\d+\-\d+]*)$", str(x)).group() )

#Pregunta 9:

#crear variable crimen ( debe contener información del delito cometido)
x = "tiene 4 hijos, sentenciado por sicariato"

re.search('\.*[P/p]or\s([\w+\s]+)', x).group(1)

def crimen_obs(x):
    
    output =  re.search('\.*[P/p]or\s([\w+\s]+)',x)
    
    return output.group(1)
 
data_administrativa['crimen'] = data_administrativa['observaciones'].apply(lambda x: crimen_obs(x)[0])

data_administrativa['crimen'] = data_administrativa['observaciones'].apply(lambda x: re.search("\.*[P/p]or\s([\w+\s]+)",x).group())

#n_hijos: cantidad de hijos del criminal
data_administrativa['n_hijos'] = data_administrativa['observaciones'].apply(lambda x: re.search("\d*[Tt]iene\s([0-9]*)", str(x)).group(1) )

#edad_inicio : edad de inicio en actividades criminales
data_administrativa['edad_inicio1'] = data_administrativa['observaciones'].apply(lambda x: re.search("\.*([\w*\s]*)\s[A/a]ños", str(x)).group(1) )
data_administrativa['edad_inicio'] = data_administrativa['edad_inicio1'].apply(lambda x: re.search("[0-9]+", str(x)).group(1) )

