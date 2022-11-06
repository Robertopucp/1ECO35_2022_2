# -*- coding: utf-8 -*-
"""
Created on Sat Nov  5 03:27:12 2022

@author: Fernando Guerrero
"""

import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import swifter  # for parallel procesing
import unidecode # to drop tildes
from datetime import datetime  # library for time

user=os.getlogin() #username
os.chdir(f"D:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data/crime_data")
data = pd.read_excel("data_administrativa.xlsx")
data

#%% Punto 1
#Convertimos el nombre de las variables a miníscula
data.columns = map(str.lower, data.columns)

#%% Punto 2
data['nombre'] = data['nombre'].apply(lambda x: re.sub('[^a-zA-Z\s]','',x))
#%% Punto 3 (Identificamos correctamente la fecha)
data.born_date = data.born_date.str.replace ("[^0-9]\W+","")
data['born_date'] = pd.to_datetime(data['born_date']).dt.date
#%% Punto 4

data['age1'] = data['age'].apply(lambda x: re.sub('\D','',str(x)))

data['borndate2'] = data['born_date'].apply(lambda x: re.sub('(:00:00)|(!%&)|(00/00/00)','',x))
#%% Punto 5
df = pd.DataFrame({'rank': ['líder de la banda criminal', 'cabecilla local', 'cabecilla regional', 'sicario', 'extorsión', 'regular', 'novato'],
                   })
pd.get_dummies(df)
#%% Punto 7
data['correo_abogado'] = data['correo_abogado'].apply(lambda x: re.sub('@.+','',x))
#%% Punto 8
data['dni'] = data['dni'].apply(lambda x: re.sub('\dni es','',x))
