#### Tarea 7 _  Grupo _ 9 #####
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  5 21:45:24 2022

@author: acwe
"""

# Librerias

import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import swifter  # for parallel procesing
import unidecode # to drop tildes
from datetime import datetime  # library for time

user = os.getlogin()   # Username
print(user)

# Directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab8") # Set directorio

data = pd.read_excel("../data/crime_data/data_administrativa.xlsx") # Subir base de datos
data

#--------------------------------
#          Pregunta 1
#--------------------------------

# Convertir el nombre de las variables a minúscula

data.columns = map(str.lower, data.columns)
data.columns


#--------------------------------
#          Pregunta 2
#--------------------------------

# Fíjese que el nombre de la persona tiene presiones y número, retire todo aquello que no permita identificar el nombre correcto.

# Reempazamos por vacío todo aquello que sea diferente de letras y espacio; es decir, presiones y número
data['nombre'] = data['nombre'].apply(lambda x: re.sub('[^a-zA-Z\s]','',x))
data['nombre']


#--------------------------------
#          Pregunta 3
#--------------------------------

# Limpiar la fecha de nacimiento de aquellos elementos que la ensucien. Luego crear otra variable con el formato de fecha.

# Reemplazamos por vacío a los elementos que ensucian la fecha de nacimiento {00:00,"#%,!}
data['born_date'] = data['born_date'].apply(lambda x: re.sub('(00:00)|("#%)|(!)','',x))
data['born_date']


#crear otra variable con formato fecha
data['fecha'] = pd.to_datetime(data['born_date'], dayfirst = True).dt.strftime('%d/%m/%Y')
data['fecha']


#--------------------------------
#          Pregunta 4
#--------------------------------

# Limpiar la columna de edad, el cual tiene factores que no permiten identificar la edad correcta.

# Reempazamos por vacío todo aquello que sea diferente de dígitos
data['age'] = data['age'].apply(lambda x: re.sub('\D','',str(x)))
data['age']


#--------------------------------
#          Pregunta 5
#--------------------------------

#dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
#dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor de 1 si el sentenciado fue sicario
#dum5: toma el valor de 1 si el sentenciado realizó extorsión
#dum6: toma el valor de 1 si el sentenciado fue miembro regular
#dum7: toma el valor de 1 si el sentenciado fue novato o principiante


# rank: Rango del sentenciado en la banda criminal.

data['rank']

data['dum1'] =  np.where(data['rank'].str.contains('^l', regex=True),1,0)  
data['dum1'].value_counts()  #todos los líderes empiezan con'l'

data['dum2'] =  np.where(data['rank'].str.contains('local', regex=True),1,0)
data['dum2'].value_counts()  #todos los cabecillas locales dice 'local'

data['dum3'] =  np.where(data['rank'].str.contains('regional', regex=True),1,0)
data['dum3'].value_counts()  #todos los cabecillas regionales dice 'regional'

data['dum4'] =  np.where(data['rank'].str.contains('^s', regex=True),1,0)
data['dum4'].value_counts()  #todos sicarios empizan con s

data['dum5'] =  np.where(data['rank'].str.contains('ext', regex=True),1,0)
data['dum5'].value_counts()  #todos extorcion empiezan con ext

data['dum6'] =  np.where(data['rank'].str.contains('^m', regex=True),1,0)
data['dum6'].value_counts()  #todo miembro aparece empieza con m

searchfor = ['principiante', 'no([\w*]*)to']
data['dum7'] =  np.where(data['rank'].str.contains('|'.join(searchfor), regex=True),1,0)
data['dum7'].value_counts()  #todo principiante aparece como principiante y novato tiene la forma no([\w*]*)to



"######## 7. Extraer el usuario del correo electrónico ########"

def usuario(x):
    
    match = re.search("(\w+)\@\.*", x)
  
    return match.group(1)


data['usario_correo'] = data['correo_abogado'].apply(lambda x: usuario(x))
data['usario_correo']


"######## 8. Contenga información del DNI ########"



def dni(x):
    
    match = re.search('\.*\s(\d+\-\d+)', x)
    
    return match.group(1)


data['DNI'] = data['dni'].apply(lambda x: dni(x))
data['DNI'] 


"######## 9. A partir de la columna observaciones, crear las siguiente variables #######"



"9.1. crimen: debe contener información del delito cometido"


def crimen(x):
    match = re.search('(robo)', x)
    match1 = re.search('((?<=por)[\w*\s]+)', x)
        
    if match is not None:
        return match.group(1)
    
    elif match is None and (match1 is not None):
        return match1.group(1)
    

data['crimen'] = data['observaciones'].apply(lambda x: crimen(x))   
data['crimen']


#Nota, se tuvo que usar match1 y match porque existía conflictos para extraer la
#observación 14 (que no tenía coma) y 19 en el que el delito estaba descrito al inicio
#con if se busca que la prioridad sea que si la palabra robo sale, 
#entonces, eso aparece en la columna 'crimen'
#luego, la segunda opcion es que si aparece otro delito (no robo), aparece ello en
#match1 y eso se retorna en la columna crimen


"9.2. n_hijos: cantidad de hijos del criminal"        

def hijos(x):
    
    match1 = re.search('\.*tiene\s([0-9]*)\shij[o/p]s', x)
    
    if match1 is None:   # para los que no tienen hijos aparece 'None'
       
        return None
    
    else: 
    
        return match1.group(1)

data['n_hijos'] = data['observaciones'].apply(lambda x: hijos(x))
data['n_hijos'] 


"9.3. edad_inicio : edad de inicio en actividades criminales"

def edad(x):

    match = re.search('\.*([0-9]*)\saños', x)
    
    if match is None:   # para los que no figura edad aparece 'None'
       
        return None
    
    else: 
    
        return match.group(1)

data['edad_inicio'] = data['observaciones'].apply(lambda x: edad(x))
data['edad_inicio']
