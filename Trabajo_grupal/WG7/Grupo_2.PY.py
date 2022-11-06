# Ejercicios 5-9


# import libraries


import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import swifter  # for parallel procesing
import unidecode # to drop tildes




user = os.getlogin()   # Username
print(user)

# Set directorio y cargar panel dataset

os.chdir(/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data/data/) # Set directorio

data = pd.read_excel(/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data/data/data_administrativa.xlsx)) # Subir base de datos
data


#Pasamos a recurrir a tomar parte de lo inicial


#%% Ejericio 1
#Convertimos las observaciones string de la columna Nombre a letras minúsculas
data['Nombre'] = data['Nombre'].str.lower()

#Alternativamente podemos aplicar el siguient comando:
data.columns = map(str.lower, data.columns)


#%% Ejericio 2

data['nombre'].head(30)
 #notamos que en las observaciones de la columna 'nombre'hay caracteres como: /, -, !, así como número

#A través de los siguientes comandos podemos extraer estos caracteres
data['name'] = data['nombre'].swifter.apply(lambda x: re.sub('/','',x))
#con el comando anterior extraemos al caracter '/'
data['name'] = data['name'].swifter.apply(lambda x: re.sub('-','',x))
#con el comando anterior extraemos al caracter '-'
data['name'] = data['name'].apply(lambda x: re.sub('[0-9]','',x))
#con el comando anterior extraemos los números del string
data['name'] = data['name'].swifter.apply(lambda x: re.sub('!','',x))
#con el comando anterior extraemos al caracter '!'
data['name'] = data['name'].swifter.apply(lambda x: re.sub(' .','',x))
#con el comando anterior extraemos el punto '.'

data[['nombre','name']].head(30)
#Ahora la columna 'name'contiene únicamente los nombres de las personas

#%% Ejericio 3

#Ahora estamos interesados en pulir la información de la fecha

#Primero eliminamos el componente de minutos y segundos '00:00' a través del siguiente código
data["bdate"] = data["born_date"].str.replace("\s00:00", "")

data['bdate'].head(30) #Pero también notamos que hay observaciones con los caracteres '#% y !

#Eliminamos entonces el caracter !
data['bdate'] = data['bdate'].swifter.apply(lambda x: re.sub(' !','',x))

#Así como la cadena de caracteres "#%
data['bdate'] = data['bdate'].swifter.apply(lambda x: re.sub(' "#%','',x))

data['bdate'].head(30) #Ahora contamos con el string apropiado, pero aún debemos convertirlo en formato fecha

data['bdate'].info() #Efectivamente, no está en formato date

#Proponemos dos alternativas para convertir el string en formato date:
    
    #Alternativa 1: usar el comando astype especificando el formato datetime64[ns]
data['new_date']=data['bdate'].astype('datetime64[ns]')

    #Alternativa 2: usar el comando pd.to_datetime pidiendo que se infiera el tipo de formato date que se empleará
    #Esta opción es especialmente relevante cuando el set string no es homogeneo
data['new_date2'] = pd.to_datetime(data['bdate'], infer_datetime_format=True)


data[['new_date','new_date2']].info() #notamos que ahora las observaciones están en formato dummy

#%% Ejericio 4

#Ahora nos concentraremos en limpiar la columna de edad
#Los caracteres que queremos eliminar son los siguientes:!#, -, .., ! 
#También queremos eliminar el texto de las observaciones
    
#Pero el primer paso es convertir los valores de la columna age de object a string
data['age'].info()
#De esta forma podremos extarer partes de la cadena de texto luego
data = data.astype({'age':'string'}) #convertimos la variable age a string

#Luego, extraigamos los caracteres innecesarios:
data['age'] = data['age'].swifter.apply(lambda x: re.sub('!#','',x))
data['age'] = data['age'].swifter.apply(lambda x: re.sub(' -','',x))
data['age'] = data['age'].swifter.apply(lambda x: re.sub('!','',x))

data['age'] = data['age'].str.replace(r'\D', '')

#Por último, y para facilitar el análisis anterior, convertimos las observaciones a formato integer

data = data.astype({'age':'int'})
data['age'].info()


#%% Ejercicio 5 
# Crear dummies según el rango del sentenciado en la organización criminal
#dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
#dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor de 1 si el sentenciado fue sicario
#dum5: toma el valor de 1 si el sentenciado realizó extorsión
#dum6: toma el valor de 1 si el sentenciado fue miembro regular
#dum7: toma el valor de 1 si el sentenciado fue novato o principiante

#Creamos todas las dummies con con un condicional ifelse y detect para todo el valor de la variable o con la letra que empiece
#Para dum1 que detecte si la variable es "lider de la banda criminal" y si es asi toma 1 sino 0
#Para dum2 que detecte si la variable es "cabecilla local" y si es asi toma 1 sino 0
#Para dum3 que detecte si la variable es "cabecilla regional" y si es asi toma 1 sino 0
#Para dum4 que detecte si la variable empieza con las letras "sic" y si es asi toma 1 sino 0
data["dum1"] = np.where(data["rank"] == "Lider de la banda criminal",1, 0)
data["dum2"] = np.where(data["rank"] == "Cabecilla local",1, 0)
data["dum3"] = np.where(data["rank"] == "Cabecilla regional",1, 0)
data["dum4"] = np.where(data["rank"] == "Sicario",1, 0)


#Para dum5 que detecte si la variable empieza con la letra "e", ya que hay observaciones con extorsion o extorsionador, y si es asi toma 1 sino 0
#Para dum6 que detecte si la variable empieza con las letra "m" y si es asi toma 1 sino 0
data['dum5'] = np.where(data['rank'].str.contains('^extor'),1,0)
data["dum6"] = np.where(data["rank"] == "miembro",1, 0)

#Para dum7 que detecte si la variable empieza con las letras "n" o "p", ya que hay observaciones donde no esta bien escrito novato, y si es asi toma 1 sino 0
data['dum7'] = np.where(data['rank'].str.contains('nov|noa|princ'),1,0)




#%% Ejercicio 7 
# Extraer el usuario del correo electrónico.
data.correo_abogado = data.correo_abogado.astype('str') # Primero se procede a convertir  en string
data['user_correo']= data['correo_abogado'].swifter.apply(lambda x: re.search("(\w+)\@\.*", str(x)).group(1))


#%% Ejercicio 8
# Crear una columna que contenga solo la información del número de dni (por ejemplo: 01-75222677), en este caso se extraen los rangos de numeros como se indica en la estructura.
data['dni_nuevo'] = data['dni'].swifter.apply(lambda x: re.sub('dni','',x))


#%% Ejercicio 9
#  A partir de la columna observaciones, crear las siguiente variables:

    
# crimen: debe contener información del delito cometido, y para ello se indica la seccion de texto que debe extraer 
def crimen(x): # Esta es la función crimen

data['crimen'] = data['observaciones'].apply(lambda x: crimen(x)) 
data['crimen'] = data['observaciones'].apply(crimen)

# n_hijos: cantidad de hijos del criminal
def n_hijos(w): # Función n_hijos

data['n_hijos'] = data['observaciones'].apply(lambda y: n_hijos(y))
data['n_hijos'] = data['observaciones'].apply(n_hijos)
 

# edad_inicio : edad de inicio en actividades criminales

def edad_inicio(p):  # Función edad_inicio
data['edad_inicio'] = data['observaciones'].apply(lambda z: edad_inicio(z))
data['edad_inicio'] = data['observaciones'].apply(edad_inicio)
