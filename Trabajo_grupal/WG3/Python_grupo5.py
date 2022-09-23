# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 18:45:09 2022

@author: Usuario
"""

#Pregunta 1
import numpy as np
import pandas as pd
from pandas import DataFrame,Series  
import os # for usernanme y set direcotrio


# Debemos construir el directorio donde se trabajará

user = os.getlogin()   # Username
print(user)

# Extraemos los datos del directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab3") # Set directorio
#Utilizamos pd.read_excel porque se trata de un documento de excel
data_junin = pd.read_excel("../data/Region_Junin.xlsx")
data_junin


data_junin.info() #mostrar el type de las variables
print( data_junin.shape )

#Acá mostramos el nombre de las columnas que tiene la data
list(data_junin)

data_junin.describe() #se presenta las principales estadísticas
#Con null y na nos muestra si se encuentra missing en nuestra data frame; además, sumamos la cantidad de missing
print( data_junin.isnull() )
print( data_junin.isna() )
data_junin.isna().sum() 

 #En este paso cambiamos el nombre de las variables con rename 
data_junin.rename(columns={'Place':'comunidad',
                           'men_not_read':'homxlee',
                           'women_not_read':'mujerxlee',
                           'total_not_read':'totalxlee'},
                  inplace=True)
data_junin.columns

#Aquí creamos una nueva data frame que solo contenga las columnas comunidad y District
data_junin1=data_junin.loc[:,['comunidad','District']]
#Vamos a crear tres nuevas columnas

#junin_data['mujeres%queleen'] = junin_data['women_not_read']/junin_data['total_not_read']
data_junin['mujeres que no escriben ni leen'] = data_junin['mujerxlee'] / data_junin['totalxlee'] 
data_junin['varones que no escriben ni leen'] = data_junin['homxlee'] / data_junin['totalxlee'] 
data_junin['Nativos con respecto al total de la población'] = data_junin['natives']/(data_junin['peruvian_men'] + data_junin['peruvian_women'] + data_junin['foreign_men'] + data_junin['foreign_women'])

#La 7 nos pide crear una nueva data frame con filas
data_junin2 = data_junin.loc[ ( data_junin[ "District" ] == "CIUDAD DEL CERRO")
                             | ( data_junin[ "District" ] == "JAUJA" ) 
                             | ( data_junin[ "District" ] == "ACOLLA" ) 
                             | ( data_junin[ "District" ] == "CONCEPCIÓN" ) 
                             | ( data_junin[ "District" ] == "SAN GERÓNIMO" ) 
                             | ( data_junin[ "District" ] == "TARMA" ) 
                             | ( data_junin[ "District" ] == "OROYA" ) ]

data_junin3 = data_junin2.loc[ ( data_junin[ "natives" ] > 0 )
                             & ( data_junin[ "mestizos" ] > 0 ) ]

data_junin4=data_junin3.loc[:,['comunidad','District','mujeres que no escriben ni leen','varones que no escriben ni leen','Nativos con respecto al total de la población']]

data_junin4.to_csv("../data/Base_cleaned_WG(5)") 


#Pregunta 2

np.random.seed(1000) #Establecemos un random seed
pep=np.random.rand(100) #Primero definimos el vector
a=np.min(pep) #Definimos el minimo
b=np.max(pep) #Definimos el maximo

#Definimos la función de reescalación relacionando un x con el mín y max
def reescalación(x):
    return (x-a)/(b-a)

#Aplicamos la función "reescalación" a cada componente del vector pep con map y list
respuesta = list(map(reescalación, pep))

print (respuesta)

pepa=np.random.rand(100,50) #Primero definimos la matriz

c=np.min(pepa, axis=0)
d=np.max(pepa, axis=0)

#Aplicamos la función "lambda x" a cada componente de cada columna de la matriz pepa
# "lambda x" se definió como la relación (x-x.min())/(x.max()-x.min()) 
respuesta2 = np.apply_along_axis(lambda x: (x-x.min())/(x.max()-x.min()),0, pepa) 

print(respuesta2)

#Pregunta 3

def funcion (*args, **kwargs): #definimos la funcion que pide el ejercicio
    
    vector = list(args) #se convierten a lista, ya que args es una tupla
    
    def sdv(x,mean,sd): #definimos la funcion de estandarizacion
        
        out = (x-mean)/sd
        
        return out 
    
    def escalar (x,mini,maxi): #definimos la funcion de escalamiento
        escala = (x-mini)/(maxi-mini)
        
        return escala
    
    
    
    if kwargs ['function'] == "estandarizar":
                       
        result = list( map( lambda x, v1 = np.mean(vector), v2 = np.std(vector): sdv(x,v1, v2) , vector) ) 
        
    elif kwargs ['function'] == "reescalar":
        
        result = list (map (lambda x, maximo = np.max(vector), minimo = np.min(vector): escalar(x,minimo,maximo), vector))
    
    else:
        raise ValueError( f"El argumento de la funcion {kwargs[ 'function' ]} no esta disponible." )
        
        # Mensaje de error por tipo de argumento
        
    return result

funcion(1,2,3,4,5,6,7,8,9,10, function = "estandarizar")
funcion (1,3,5,7,9,11,13,15,17,19, function = "reescalar")