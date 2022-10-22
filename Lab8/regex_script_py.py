# -*- coding: utf-8 -*-
"""
Created on Fri Oct 21 19:17:11 2022

@author: Roberto
"""



# import libraries

import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import swifter  # for parallel procesing

user = os.getlogin()   # Username
print(user)

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab8") # Set directorio

data = pd.read_excel("../data/Centro_salud/Centro_salud_mental.xls") # Subir base de datos
data



 # from capital letters to lower 

data.columns = map(str.lower, data.columns)

#%% regex re.sub


"1.0 extraccción del numero"

# Extraer solo texto de una celda que contiene numero y texto 

data['inst1'] = data['institución_ruc'].apply(lambda x: re.sub('[0-9]*','',x))

"[0-9]*: ninguno, uno o más digitos"


# Usando una librería de parallel procesing para que la computadora sea rápida

data['inst1'] = data['institución_ruc'].swifter.apply(lambda x: re.sub('[0-9]*','',x))
data['inst1'] = data['institución_ruc'].swifter.apply(lambda x: re.sub('[0-9]+','',x))

# Alternativas 1

data['inst2'] = data['institución_ruc'].apply(lambda x: re.sub('\d*','',x))


# Alternativas 2

data['inst3'] = data['institución_ruc'].apply(lambda x: re.sub('[^a-zA-Z]*','',x))


"2.0 extraccción del texto"


# Alternativas 1

data['ruc1'] = data['institución_ruc'].apply(lambda x: re.sub('[a-zA-Z]*','',x))


# Alternativas 2

data['ruc2'] = data['institución_ruc'].apply(lambda x: re.sub('[a-zA-Z]+','',x))

# Alternativas 3

data['ruc3'] = data['institución_ruc'].apply(lambda x: re.sub('\D','',x))


# Alternativas 4

data['ruc4'] = data['institución_ruc'].apply(lambda x: re.sub('[^0-9]','',x))

# Sustituir caracteres diferentes a la fecha

data['fecha_apertura'] = data['fecha_apertura'].apply(lambda x: re.sub('(:00:00)|(!%&)|(00/00/00)','',x))

#%% re.findall


data['coordinates'] = data['gps'].apply(lambda x: re.findall('-\d+.\d+,-\d+.\d+',x))

# columa de string con nan, pero nan es float (en STATA sucede lo mismo)

data['coordinates'] = data['gps'].apply(lambda x: re.findall('-\d+.\d+,-\d+.\d+', str(x)  ))


data['coordinates'] = data['gps'].apply(lambda x: re.findall('-\d+.\d+,-\d+.\d+', str(x))  )
    

data.info()

#%% re.search

def phone(x):
    
    match = re.search('\.*\s(\d+\-\d+)', x)
    
    return match.group(1)


data['phone'] = data['telefono'].apply(lambda x: phone(x))


def reso_info(x):
    
    match = re.search('DS-([0-9]+)-([0-9]+)\s([A-Z]+)', x)
    
    return match.group(1), match.group(2), match.group(3)


data['code_res'] = data['resolucion'].apply(lambda x: reso_info(x)[0])

data['year_res'] = data['resolucion'].apply(lambda x: reso_info(x)[1])

data['entidad_res'] = data['resolucion'].apply(lambda x: reso_info(x)[2])


#%% str.contains

data['Gob_regional_jur'] =  np.where(data['institución_ruc'].str.contains('^G', regex=True),1,0)


data['Minsa_jur'] =  np.where(data['institución_ruc'].str.contains('^M'),1,0)

# Nos quedamos con los centros de salud mental que tienen GPS (georeferenciación)

data2 = data[data['gps'].str.contains('[0-9]', na = False)]

# na = False no toma cuenta los missing

##% Fechas 


from datetime import datetime




##% Segunda aplicación

junin = pd.read_excel("../data/Region_Junin.xlsx")



# select districs that contanis "AC"

junin.loc[ junin['District'].str.contains('AC') ]


junin.loc[junin['Place'].str.contains('pacha')]


junin.loc[junin['Place'].str.contains('pacha', flags = re.I)]

 #re.I ignoring capital o lower letters 
 
 
 # Ignoring format re.I 

junin.loc[junin['District'].str.contains('CIUDAD', flags = re.I)]



# If regex is False, then contains seeks "^hu" literaly 
# # Beginning word with hu

junin.loc[junin['District'].str.contains('^hu', flags = re.I, na = False, regex = True)]


# Ending word

junin.loc[junin['Place'].str.contains('ro$', flags = re.I, na = False, regex = True)]


junin.loc[junin['Place'].str.contains('ca$', flags = re.I, na = False, regex = True)]

# match : a , . o a.

newbase  = junin.loc[junin['Place'].str.contains('^a\.*', flags = re.I, na = False, regex = True)]


# match : a. (strict)

newbase  =  junin.loc[junin['Place'].str.contains('a\.+', flags = re.I, na = False, regex = True)]

# match a or .

newbase  =  junin.loc[junin['Place'].str.contains('a\.?', flags = re.I, na = False, regex = True)]


