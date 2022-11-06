##############################  WG # 7 ######################################

#%% Grupo 4

# Flavia Oré - 20191215
# Seidy Ascencios - 20191622
# Luana Morales - 20191240
# Marcela Quintero - 20191445

#%%% PREGUNTA 1
##############################################################################
#                                                                            #
#                                 PREGUNTA 1                                 #
#             Convertir el nombre de las variables a minúscula               #
#                                                                            #
##############################################################################

# Recursos necesarios:
    
import os #Para el nombre de usuario y set directorio

!pip install fuzzywuzzy
!pip install python-Levenshtein
!pip install swifter
!pip install unidecode 

from rapidfuzz import fuzz
from rapidfuzz import process #Para cargar librerías de fuzzymatch
import re
import numpy as np
import pandas as pd
import swifter #Librería para procesos paralelos
import unidecode #Dropear tildes
import itertools

## Seteamos el directorio:
user = os.getlogin()   # Username

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data/crime_data")

## Abrimos la base de datos en Excel:

data = pd.read_excel(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data/crime_data/data_administrativa.xlsx", sheet_name='Hoja1')

## Converminos el nombre de las variables en minúscula.

data.columns = map(str.lower, data.columns)
print(data)

## Observamos que los nombres de las variables ya están en minúscula.

#%%% PREGUNTA 2
##############################################################################
#                                                                            #
#                                 PREGUNTA 2                                 #
#             Fíjese que el nombre de la persona tiene puntuaciones          #
#           y número, retirar todo aquello que no permita identificar        #
#                            el nombre correcto                              #
#                                                                            #
##############################################################################

def function1(row):
    
    row = row.strip() 
    row = unidecode.unidecode(row)
    row = re.sub('[^a-zA-Z\s]', '',row).lower()
    return row

data['nombre'] = data['nombre'].apply(function1)

## Notamos que todo está en minúscula y limpio de caracteres no deseados.

#%%% PREGUNTA 3
##############################################################################
#                                                                            #
#                                 PREGUNTA 3                                 #
#             Limpiar la fecha de nacimiento de aquellos elementos           #
#              que la ensucien. Luego crear otra variable con el             #
#                            el formato de fecha                             #
#                                                                            #
##############################################################################

data['born_date'] = data['born_date'].apply(lambda x: re.sub('(00:00)|("#%)|(!)','',x))

## Notamos que limpiamos la variable de la fecha de nacimiento. 

## Ahora, crearemos otra variable con el formato de fecha:
    
data['born_date'] = pd.to_datetime(data['born_date']
                                             , dayfirst = True).dt.strftime('%d/%m/%Y')


#%%% PREGUNTA 4
##############################################################################
#                                                                            #
#                                 PREGUNTA 4                                 #
#             Limpiar la columna de edad, el cual tiene puntuaciones         #
#                que no permiten identificar la edad correcta.               #
#                                                                            #
##############################################################################


## Se quitó todo caracter especial y que no sea número. Además, se agregó "str" para evitar
## que aparezca el error "TypeError expected string or bytes-like object":

data['age'] = data['age'].apply(lambda x: re.sub('[^0-9]','',str(x)))

## Notamos que queda la edad limpia.

#%%% PREGUNTA 5
##############################################################################
#                                                                            #
#                                 PREGUNTA 5                                 #
#              Crear dummies según el rango del sentenciado en               #
#                         la organización criminal                           #
#                                                                            #
##############################################################################

#dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
#dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor de 1 si el sentenciado fue sicario
#dum5: toma el valor de 1 si el sentenciado realizó extorsión
#dum6: toma el valor de 1 si el sentenciado fue miembro regular
#dum7: toma el valor de 1 si el sentenciado fue novato o principiante

## Primero, notamos que están mal escritas ciertas variables, por lo que las corregimos para
## poder generar las dummies:

df = pd.DataFrame(data)
df.loc[df['rank'] == 'noato', 'rank'] = 'novato'
df.loc[df['rank'] == 'novto', 'rank'] = 'novato'
df.loc[df['rank'] == 'extorsionador', 'rank'] = 'extorsion'

## Hecho esto, procedemos a crear las dummies:
dummies = pd.get_dummies(df['rank'])

## Ahora, cambiamos el nombre de las columnas a dum1-dum7 según lo indicado:

dummies.rename = dummies.set_axis(['dum2', 'dum3', 'dum5', 'dum1', 'dum6', 'dumx', 'dumz', 'dum4'], axis=1, inplace= True)

## Como nos piden que los novatos y principiantes estén en una misma dummy, los llamamos 'dumx'
## y 'dumz' temporalmente para poder juntarlos después en 'dum7':

dummies["dum7"] = dummies["dumx"] + dummies["dumz"]

## Por último, eliminamos "dumx" y "dumz":
    
dummies.drop(['dumx'], axis=1, inplace=True)
dummies.drop(['dumz'], axis=1, inplace=True)

## Observamos que ya tenemos un df de dummies según el rango en la organización
## criminal del sentenciado.


#%%% PREGUNTA 7
##############################################################################
#                                                                            #
#                                 PREGUNTA 7                                 #
#                  Extraer el usuario del correo electrónico                 #
#                                                                            #
##############################################################################

## Creamos una columna dentro del df que solo contenga los usuarios:
    
df['user_correo']= data['correo_abogado'].apply(lambda x: re.search("(\w+)\@\.*", str(x)).group(1))

## Observamos que se extrajo lo requerido.

#%%% PREGUNTA 8
##############################################################################
#                                                                            #
#                                 PREGUNTA 8                                 #
#           Crear una columna que contenga solo la información del           #
#                 número de dni (por ejemplo: 01-75222677)                   #
#                                                                            #
##############################################################################

## Agregamos una columna a la que llamaremos: dni_num, y eliminaremos las palabras
## "dni es" para solo quedarnos con el número.

df['dni_num']= data['dni'].apply(lambda x: re.sub('dni es','',x))

## Podemos ver añadida la nueva columna con los números de DNI.

#%%% PREGUNTA 9
##############################################################################
#                                                                            #
#                                 PREGUNTA 9                                 #
#                  A partir de la columna observaciones, crear               #
#                         las siguientes variables                           #
#                                                                            #
##############################################################################

#crimen: debe contener información del delito cometido -> después de "por" y antes de la coma :lookahead
#n_hijos: cantidad de hijos del criminal -> después de "tiene", solo número :lookahead
#edad_inicio : edad de inicio en actividades criminales -> antes de "años", solo número: lookbehind


df['crimen'] = df['observaciones'].apply(lambda x: re.search("(?<!por )\d+\:\d+",x))

df['n_hijos'] = df['observaciones'].apply(lambda x: re.search("(?<!tiene )\d+\:\d+",x))

df['edad_inicio'] = df['observaciones'].apply(lambda x: re.search("(?<=años )[\d+\:]+",x))


