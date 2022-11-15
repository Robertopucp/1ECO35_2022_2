# -*- coding: utf-8 -*-
"""
Tarea de Regex 

@author: Roberto

"""

# import libraries

import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import unidecode # to drop tildes
from datetime import datetime  # library for time

user = os.getlogin()   # Username

print(user)

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG7/Solucion") # Set directorio


crimen_data = pd.read_excel("../../../data/crime_data/data_administrativa.xlsx") # Subir base de datos


# 1. 

crimen_data.columns = map(str.lower, crimen_data.columns)

#2.0 nombres limpios

# Primero retiramos las tildes 


crimen_data['nombre'] = crimen_data['nombre'].apply(unidecode.unidecode)


crimen_data['nombre_clean'] = crimen_data['nombre'].apply(lambda x: re.sub('[^a-zA-Z\s]','',x))

# 3.0 fecha de nacimiento limpio

crimen_data['born_date'] = crimen_data['born_date'].apply(lambda x: re.sub('\"#%|!|00:00|','',x))


crimen_data['new_date'] = pd.to_datetime(crimen_data['born_date']
                                             , dayfirst = True).dt.strftime('%d/%m/%Y')

# 4.0 edad

crimen_data['age'] = crimen_data['age'].apply(lambda x: re.sub('\D','', str(x)))

# 5.0 Dummies por rango criminal 

# Si bien toda está en minuscula, en la trabajo usted puede enfrentarse con mayuscula o minuscula 
# En ese caso es mejo pasar todo a minuscula 
# Tambien es recomendable retirar los espacios vacíos al inicio o final 
# !!! Esto de los espacios vacios al incio y al final no siempre es visible. Igual hagalo

# Un ejemplo

words = [' ffk ','ksksksk ']

list(map(str.strip, words)) # se ha retirado los espacios vacios 

# Conversión a minuscula 

crimen_data['rank'] = crimen_data['rank'].str.lower().str.strip()

#retirar tildes 

crimen_data['rank'] = crimen_data['rank'].apply(unidecode.unidecode)
 
# retirar espacios vacios al inicio y fin 



crimen_data['dum1'] =  np.where(
    crimen_data['rank'].str.contains('criminal$',
                                         ),1,0)


crimen_data['dum2'] =  np.where(
    crimen_data['rank'].str.contains('local$',
                                         ),1,0)

crimen_data['dum3'] =  np.where(
    crimen_data['rank'].str.contains('regional$',
                                         ),1,0)

crimen_data['dum4'] =  np.where(
    crimen_data['rank'].str.contains('sicario',
                                         ),1,0)


crimen_data['dum5'] =  np.where(
    crimen_data['rank'].str.contains('^extor',
                                         ),1,0)

crimen_data['dum6'] =  np.where(
    crimen_data['rank'].str.contains('miembro',
                                         ),1,0)


crimen_data['dum7'] =  np.where(
    crimen_data['rank'].str.contains('^princ|^nov|^noa',
                                         ),1,0)

# 7.0 
    
crimen_data['user'] = crimen_data['correo_abogado'].apply(lambda x: re.search("(\w+)\@\.*", x).group(1))

# 8.0 


crimen_data['dni'] = crimen_data['dni'].apply(lambda x:  re.search("(?<=dni es )[\d+\-]+",x).group() )


# 9.0 

# tipo de sentencia 

def sentencia(x):
    
    try:
        group = re.search("(?<=sentenciado por )[\w+\s]+",x).group() 
        return group

    except:
        
        pass
    
crimen_data['crimen'] = crimen_data['observaciones'].apply(sentencia)

# cantidad de hijos

def cant_hijos(x):
    
    
    try:
        
        group = re.search("(?<=tiene |tener )\d+",x).group() 
    
        return group

    except:
        
        pass
    
crimen_data['cant_hijos'] = crimen_data['observaciones'].apply(cant_hijos)

# inicio de actividades 

def inicio(x):
    
    try:
        
        group = re.search("\d+(?= años)",x).group() 
    
        return group

    except:
        
        pass
    
crimen_data['edad_inicio'] = crimen_data['observaciones'].apply(inicio)












