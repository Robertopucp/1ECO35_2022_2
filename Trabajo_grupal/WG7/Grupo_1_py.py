###########################################  GRUPO 1 ############################################

#####################################  Miembros del grupo  ######################################

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Egusquiza 
# 20163377, Jean Nino de Guzman

#!pip install swifter

# Importamos las librerías que vamos a utilizar 
import pandas as pd
import numpy as np
import re  # for regular expressions (REGEX)
import os  # for directorio
import swifter  # for parallel procesing
from datetime import datetime

user = os.getlogin()   
print(user)

# Set directorio

#Se extrae el usuario para posteriormente pegarlo en el nuevo directorio de la base de datos y pueda correr a cualquier persona con acceso al repositorio del curso.
user = os.getlogin()   
##Se setea un directorio para que se cargue la base de datos desde el repositorio del curso y se utilice el usuario de la PC en donde se corra el código.
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data") 

#Se lee la base de datos data_administrativa, y se cargue como un dataframe
df = pd.read_excel("../data/crime_data/data_administrativa.xlsx")

##PREGUNTA 1:
#Se pasa de mayúsulas a minúsculas a los nombres de las variables
df.columns = map(str.lower, df.columns)
# map es el loop replacement que permite aplicar la función str.lower a cada elemento de la lista data.columns

##PREGUNTA 2:
#Se indica que se reemplace la columna nombre con los mismo registros con excepción de los números [0-9] y signos .,!,¡ y -
df['nombre'] = df['nombre'].swifter.apply(lambda x: re.sub('[0-9,/,.,!,¡,-]','',x))

##PREGUNTA 3:
#Se indica que se reemplace la columna born_date por los mismos registros exceptuando los signos !,#,",% y -, pues no permiten identificar a la persona.
df['born_date'] = df['born_date'].swifter.apply(lambda x: re.sub('[!,#,",%,-]','',x))
#Se cambia el formato de los registros a formate de fecha (datetime)

df['born_date'] = pd.to_datetime(df['born_date'], dayfirst = True).dt.strftime('%d/%m/%Y')

##PREGUNTA 4:
#Se pasan todos los datos de la columa age a formato string para poder trabajar con todo en conjunto.
df.age = df.age.astype('str')
#Se reemplaza la columna age por los mismos registros exceptuando las letras de la a-z tanto minúsculas como mayúsculas y de los signos. 
df['age'] = df['age'].swifter.apply(lambda x: re.sub('[a-zA-Z,!,#,",%,.,-]','',x))

##PREGUNTA 5:
#Se crean las dummies en base a las categorías establecidas en el ejercicio
df["dum1"] = np.where(df["rank"] == "lider de la banda criminal",1, 0)
df["dum2"] = np.where(df["rank"] == "cabecilla local",1, 0)
df["dum3"] = np.where(df["rank"] == "cabecilla regional",1, 0)
df["dum4"] = np.where(df["rank"] == "sicario",1, 0)
#Para la dummy5, se indica que se coloque 1 en caso los registros contengan la palabra "extor", pues en algunos casos están extorsion y extorsionador, por lo que la dummy se aplicaría a ambos casos
df['dum5'] = np.where(df['rank'].str.contains('^extor'),1,0)
df["dum6"] = np.where(df["rank"] == "miembro",1, 0)
#Para la dummy7 se coloca que se coloque 1 en caso los registros contengan las palabras "nov", "noa" y "princ", pues aparecen novato, novto, noato y principante, por lo que la dummy considera todos estos. 
df['dum7'] = np.where(df['rank'].str.contains('nov|noa|princ'),1,0)

##PREGUNTA 6:

#En el Github no especifíca una pregunta 6, se salta a la 7.

##PREGUNTA 7:
#Convertimos a string el correo
df.correo_abogado = df.correo_abogado.astype('str')

#Se indica que cree una nueva columna que contenga el usuario de cada correo
df['usuario']= df['correo_abogado'].swifter.apply(lambda x: re.search("(\w+)\@\.*", str(x)).group(1))

##PREGUNTA 8:
#Se indica que se cree una nueva columna que contenga lo mismo de los registros de la columna dni, pero exceptuando las letras, por lo que queda unicamente números y signos.
df['dni0'] = df['dni'].swifter.apply(lambda x: re.sub('[a-zA-Z]','',x))

##PREGUNTA 9:
#Para crear las columnas con la variable crimen, n_hijos y edad_inicio establecemos una función por cada una de ellas

def crimen(x): #Definimos la función crimen 
    try:
        match_1 = re.search("(?<=sentenciado por)(\s+\w+).?",x) #Utilizamos look around para que extraiga el texto de nuestro interés
        return match_1.group() #Le pedimos que lo busque en cualquier orden en el que aparezca
    
    except:
        pass #En caso, no encuentre el texto solicitado ponga None (vacío)
    
#Creamos la columna crimen a partir de la columna de observaciones del DataFrame
#Incorporamos los datos de nuestra función establecida líneas arriba
df['crimen'] = df['observaciones'].apply(lambda x: crimen(x)) 
df['crimen'] = df['observaciones'].apply(crimen)


def n_hijos(y): #Definimos la función n_hijos
    try:
        match_2 = re.search("(?<=tiene ).*\d", y) #Utilizamos look around para que extraiga el texto de nuestro interés
        return match_2.group()
    
    except:
        pass #En caso, no encuentre el texto solicitado ponga None (vacío)

#Creamos la columna n_hijos a partir de la columna de observaciones del DataFrame
#Incorporamos los datos de nuestra función establecida líneas arriba
df['n_hijos'] = df['observaciones'].apply(lambda y: n_hijos(y))
df['n_hijos'] = df['observaciones'].apply(n_hijos)

    
def edad_inicio(z): #Definimos la función edad_inicio
    try:
        match_3 = re.search("(?<=actividades ilegales ).*(años)", z) #Utilizamos look around para que extraiga el texto de nuestro interés
        return match_3.group()
    
    except:
        pass #En caso, no encuentre el texto solicitado ponga None (vacío)

#Creamos la columna edad_inicio a partir de la columna de observaciones del DataFrame
#Incorporamos los datos de nuestra función establecida líneas arriba
df['edad_inicio'] = df['observaciones'].apply(lambda z: edad_inicio(z))
df['edad_inicio'] = df['observaciones'].apply(edad_inicio)

