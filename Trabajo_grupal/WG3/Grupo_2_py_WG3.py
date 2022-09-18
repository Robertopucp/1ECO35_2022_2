# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 19:16:16 2022

@author: MSI
"""

"""
EJERCICIO 1

"""
#Importamos 
import numpy as np
import pandas as pd
import os
from pandas import DataFrame,Series


# In[5]:


pip install openpyxl


# In[3]:


junin =  pd.read_excel("D:/Users/Usuario/Documents/GitHub/1ECO35_2022_2/data/Region_Junin.xlsx") 
#Primero importamos la base de datos, reconiciendo el formato (excel)
junin


# 1. Obtener el nombre de todas las variables

# In[4]:


#Veremos el nombre de cada variable (columna) y el tipo a que corresponde 
junin.info()
#este comando también nos permite identifcar el número de variables por tipo
#dtypes: float64(24), int64(15), object(3)
#Lo que significa que la mayor parte de nuestras observaciones son numéricas 39 (=24+15) y sólo tres son objetos


# 2. Mostrar el tipo de variables (type) así como presentar los principales estadísticos.

# In[5]:


#El desarrollo anterior mostraba el tipo de cada variable, pero hacemos uso del comando describe para entender como se comporta la distribución de los valores de cada variable numérica (conocer sus principales estadísticos)
junin.describe() 


# In[6]:


#Ahora bien, las variables región, distrito y place son object y no aparecerán en el análisis descriptivo a menos que lo especifiquemos en la función describe
junin.describe(include='O')


# In[7]:


junin.describe(include='all') #el argumento include también nos permite generar una tabla con todo tipo de variable (sea object o numérica)


# 3. Verifique si las columnas presentan missing values

# In[8]:


#Pedimos un listado de las columnas que tienen al menos un missing value
[col for col in junin.columns if junin[col].isnull().any()]


# In[12]:


#Adicionalmente, buscamos un código que nos permitiera profundizar el conocimiento de los missing values en la base. En Stack overflow encontramos la siguiente función, que explicaremos brevemente
#missing_table genera un cuadro resumen de estadísticos para los missing value. Busca agregar observaciones que sean missing y representarlas como totales y porcentajes del total de observaciones
#Además, especifica el tipo de variable
def missing_table(df):
        zero_val = (df == 0.00).astype(int).sum(axis=0)
        mis_val = df.isnull().sum() 
        mis_val_percent = 100 * df.isnull().sum() / len(df)
        mz_table = pd.concat([zero_val, mis_val, mis_val_percent], axis=1)
        mz_table = mz_table.rename(
        columns = {0 : 'Zero Values', 1 : 'Missing Values', 2 : '% of Total Values'})
        mz_table['Total Zero Missing Values'] = mz_table['Zero Values'] + mz_table['Missing Values']
        mz_table['% Total Zero Missing Values'] = 100 * mz_table['Total Zero Missing Values'] / len(df)
        mz_table['Data Type'] = df.dtypes
        mz_table = mz_table[
            mz_table.iloc[:,1] != 0].sort_values(
        '% of Total Values', ascending=False).round(1)
        print ("Tu dataframe tiene " + str(df.shape[1]) + " columnas y " + str(df.shape[0]) + " filas.\n"      
            "Hay " + str(mz_table.shape[0]) +
              " columnas que tienen valores missing.")
#         mz_table.to_excel('D:/sampledata/missing_and_zero_values.xlsx', freeze_panes=(1,0), index = False)
        return mz_table

missing_table(junin)


# 4. Cambie el nombre de las siguientes variables:
# * place : comunidad
# * men_not_read: homxlee
# * women_not_read: mujerxlee
# * total_not_read: totalxlee
# 

# In[13]:


#Hay distintas alternativas para modificar el nombre de columnas, nosotros optamos por usar la función rename. De esta forma
#sólo debemos especificar los nuevos nombres de las variables relacionándolos con los nombres originales
junin.rename(columns = {'Place':'comunidad', 'men_not_read':'homxlee', 'women_not_read':'mujerxlee', 'total_not_read':'totalxlee'}, inplace = True)
junin.head(2)


# In[15]:


#De paso, modificaremos el nombre de la primera columna
junin.rename(columns = {'Unnamed: 0':'ID'}, inplace = True)
junin.head(2)


# In[16]:


junin.head(1)


# 5. Muestre los valores únicos de las siguientes variables ( comunidad , District)

# In[17]:


print(junin.comunidad.unique())
#Aquí empleamos la función unique, esta recoge los valores únicos de la variable especificada (en este caso fue comunidad)


# In[30]:


#Hacemos lo propio con la variable District
print(junin.District.unique())


# 6. Crear columnas con las siguiente información: el % de mujeres del que no escriben ni leen (mujerxlee/totalxlee) % de varones que no escriben ni leen (homxlee/totalxlee) y % de nativos respecto al total de la población. Para el total de la población sumar (peruvian_men + peruvian_women + foreign_men + foreign_women)

# In[21]:


junin["w_nowrite_noread"] = round(junin["mujerxlee"] / junin["totalxlee"], 2)
#Calculamos el % de mujeres que no escriben ni leen empleando dos columnas del dataframe. Por conveniencia decidimos redondear a dos dígitos después de la coma
junin


# In[19]:


junin["population"]= junin["peruvian_men"] + junin["peruvian_women"] + junin["foreign_men"] + junin["foreign_women"] 
#Consideramos que contar con la población total como variable podría ser de utilidad en un análisis futuro, por eso la calculamos como la suma de la población nacional más extranjera, tanto para mujeres como hombres


# In[20]:


#Luego, el % de nativos respecto al total de la población es simplemente una división de las variables natives y population
junin["percent_natives"] = round(junin["natives"] / junin["population"], 2)
junin


# 7. Crear una base de datos con la siguiente información:
# 
# *  Quedarse con la información de los distritos de Ciudad del Cerro, Jauja, Acolla, San Gerónimo, Tarma, Oroya y Concepción
# *  Luego quedarse con las comunidades que cuentan con nativos y mestizos.
# *  Solo quedarse con las variables trabajadas en el punto 6), nombre de distrito y comunidad.
# *  Guardar la base de datos en formato csv en la carpeta data. (Use el siguiente nombre Base_cleaned_WG(numero de grupo)

# In[24]:


#El primer filtro propuesto considera la intersección y no la unión, dado que solo se emplea una variable. Es decir,
#Nos interesa conservar las osbervaciones que provengan de Ciudad del Cerro o Jauja o Acolla,...
junin = junin[(junin['District']=='CIUDAD DEL CERRO') | (junin['District']== 'JAUJA') | (junin['District']=='ACOLLA') | (junin['District']=='SAN GERÓNIMO') | (junin['District']=='TARMA') | (junin['District']=='CONCEPCIÓN') | (junin['District']=='OROYA')]


# In[25]:


junin


# In[27]:


#El segundo filtro requiere que descartemos las observaciones que muestran un cero tanto en nativos como en mestizos
junin = junin[(junin['natives']>=1) & (junin['mestizos']>=1)]


# In[28]:


junin


# In[37]:


#Aquí estamos definiendo un nuevo dataframe que contemple unicamente las columnas District y comunidad del anterior dataframe (también llamado junin)
junin = junin[['District', 'comunidad']]


# In[39]:


junin.to_csv("D:/Users/Usuario/Documents/GitHub/1ECO35_2022_2/data/Base_cleaned_WG2_python.csv")
#Exportamos el archivo en formato csv a la carpeta señalada


"""
EJERCICIO 2

"""

import random


#fijamos semilla
np.random.seed(123) 

# Creamos vector con 100 observaciones
v1 = np.random.rand(100) 

#Para crear mi matriz voy a empezar con un vector base
X = np.random.rand(100) 
# Crearmos matriz en base a ese vector para que sea 100x50 
X = X.reshape(-1, 1) ** np.arange(0, 50)


# Confirmamos el tamaño de la matriz
print(X)
print(X.shape) # con este comando confirmamos que nuestra matriz es 100x50


#Ya tengo mi matriz llamada X. Ahora, estandarizo la matriz con la función que me piden
#La funcion que me piden es la siguiente: (X - np.min(X)) / (np.max(X) - np.min(X))
#Con el comando apply_along_axis efectuo la funcion a cada COLUMNA(por ello, coloco 2 ) a mi matriz X

X_Solution_1 = np.apply_along_axis(lambda X: (X - np.min(X)) / (np.max(X) - np.min(X)),0, X)


"""
EJERCICIO 3

"""
# Definimos las funciones con los comandos especiales 

def tarea3(*args, **kwargs):       #Mi función serà tarea3 y podrà tener varios argumentos y con kwargs defino las funcione sbu operaciones que tendrà
    
    print(type(args))
    vec = np.array(list(args))   #primero mi variable tipo tuple la paso a lista y luego a vector para aplicar mi funcion
    
    if  kwargs ['function'] == "stand" :  #defino mi primera funcion con nombre stand
    
        resultado = (vec - np.mean(vec))/ np.std(vec) #cuando elija esta función se realizaran las operaciones presentadas para estandarizar
    
    elif  kwargs ['function'] == "scalar": # mi segunda función será scalar 
        
        resultado = (vec - np.min(vec)) / (np.max(vec) - np.min(vec))  #en esta parte presento las operaciones de mi función
        
    else: #si no se elije ninguna de las otras funciones saldráa el siguiente mensaje
        raise ValueError( f"The function argument {kwargs[ 'function' ]} is not supported." )
        
    return resultado    #define que me bote el resultado 

re1= tarea3( 11, 3, 6, 34, 82, function = "stand" )  #ejemplos de aplicación de mi función
re2= tarea3( 9, 2, 16, 17, 22, function = "scalar")

v1= np.random.rand(10) #ahora utilizo un vector 
tarea3(v1, function= "stand" )












