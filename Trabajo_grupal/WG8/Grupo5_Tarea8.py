# -*- coding: utf-8 -*-
"""
Created on Sat Nov 12 19:49:51 2022

@author: Usuario
"""

import os # for usernanme y set direcotrio
import pandas as pd
import numpy as np
import weightedcalcs as wc
import pyreadr
import matplotlib.pyplot as plt  # libreria de gráficos 
import seaborn as sns  # libreria 2 para gráficos 
import datetime as dt # manejar fechas 
import warnings
warnings.filterwarnings('ignore') # eliminar warning messages 

user = os.getlogin()

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab7") 

poblacion_USA = pyreadr.read_r("../data/wage2015_subsample_inference.Rdata")

poblacion_USA.keys()

poblacion_USA_2 = poblacion_USA['data']

#Pregunta 1

poblacion_USA_2.head() 

get_ipython().run_line_magic('matplotlib', 'inline')
params = {'legend.fontsize': 'x-large',
          'figure.figsize': (10, 7.5),
         'axes.labelsize': 'x-large',
         'axes.titlesize':'x-large',
         'xtick.labelsize':'x-large',
         'ytick.labelsize':'x-large'}
plt.rcParams.update(params)

#histograma del salario por hora
(counts, bins, patches) = plt.hist(poblacion_USA_2['wage'], bins = 100, color ='lightblue', rwidth=0.8)
plt.xlabel('Salario por Hora')
plt.ylabel('')
plt.title('Pregunta 1 - Histograma de salario')
plt.show()

#histograma del salario por hora en logaritmos
(counts, bins, patches) = plt.hist(poblacion_USA_2['lwage'], bins = 100, color ='pink', rwidth=0.8)
plt.xlabel('Salario por Hora en Logaritmos')
plt.ylabel('')
plt.title('Pregunta 1 - Histograma de logaritmo del salario')
plt.show() 

#Claramente, se aprecia que al comparar el logaritmo del salario con el salario observamos que el dato con logaritmos
#parece tener una distribución más cercana a la de una distribución normal. Esta es la conocido distribución log-normal
#y se reduce la variación típica de los salarios por los valores muy altos en pocas personas.

#Pregunta 2

fig = plt.subplots(figsize=(10,6))

#Solo tomamos como data a la población con universidad completa
sns.kdeplot (data = poblacion_USA_2[poblacion_USA_2['clg'] == 1],
            x = 'lwage',
            hue = 'sex',
            alpha = 0.6,
            edgecolor="0.1",
            linewidth=1,
             fill=True
            )


plt.legend(labels=['mujeres','hombres'],  title = "", frameon=True, bbox_to_anchor=(1.0, 0.95))
plt.title('Log salario por hora', size=10)
plt.ylabel('D')
plt.xlabel('')

# Entonces, obtenemos la distribución del salario de mujeres y hombre con universidad completa. 
# A simple vista, pareciera que la media del salario en logaritmo de los hombres es mayor.

#Pregunta 3

poblacion_USA_3 = poblacion_USA_2

#Generamos valores distintos para cada nivel educativo
poblacion_USA_3.loc[poblacion_USA_3["hsg"] == 1, "hsg"] = 1
poblacion_USA_3.loc[poblacion_USA_3["hsg"] == 1, "hsg"] = 2   
poblacion_USA_3.loc[poblacion_USA_3["scl"] == 1, "scl"] = 3
poblacion_USA_3.loc[poblacion_USA_3["clg"] == 1, "clg"] = 4
poblacion_USA_3.loc[poblacion_USA_3["ad"] == 1, "ad"] = 5

#Generamos una variable que campture estas diferencias sumando los valores anteriores
poblacion_USA_3['nivel_educativo'] = poblacion_USA_3['shs'] + poblacion_USA_3["hsg"] + poblacion_USA_3["scl"] + poblacion_USA_3["clg"] + poblacion_USA_3["ad"]

#  
base = poblacion_USA_3.groupby('nivel_educativo')['nivel_educativo'].size() # cantidad de personas por tipo nivel educativo

fig, ax = plt.subplots( figsize=(10,10) )

base.plot(kind='pie', autopct='%.1f %%')
plt.title("nivel_educativo")
plt.ylabel("")
plt.show()

fig.savefig(r'../plots/imagen_python.png', dpi=800, bbox_inches='tight') 
# Esta sería la leyenda 
#"secundaria_incompleta" si tenemos el valor de 1
#"secundaria_completa" si tenemos el valor de 2
#"universidad_incompleta" si tenemos el valor de 3
#"universidad_completa" si tenemos el valor de 4
#"posgrado" si tenemos el valor de 5

# dpi: la resolución ; es decir, la calidad o nitidez de la imagen 
# bbox_inches:tight Ninguna parte del grpáfico se pierde

#Pregunta 4

fig, ax = plt.subplots(figsize=(10,6))
box = sns.boxplot(x='sex', y='lwage', data = poblacion_USA_2[ poblacion_USA_2['ad'] == 5] ,palette='rainbow')
plt.xlabel('Sexo del individuo')
plt.ylabel('Logaritmo del salario por hora')
(box.set_xticklabels(["Hombre", "Mujer"])) # etiqueta eje x 

#Recordemos que la dummy toma el valor de 1 si hablamos de una mujer. Entonces, observamos que los hombres con el mismo
#nivel educativo tienen una media del logaritmo del salario por hora mayor que el de las mujeres. Entonces, podemos 
#decir que la media del logaritmo del salario de los hombres perdura a lo largo de los niveles educativos universidad
#completa y posgrado. De todas formas habría que analizar a fondo esta dsiparidad. Algunos círculos académicos sostienen
#que esta diferencia podría explicarse por los trabajos que desempeñan los dos sexos. Es decir, las mujeres tienden a 
#elegir trabajos peor remunerados. Esto no justifica la disparidad de salarios, pero, en cualquier caso, el tema es popular
#actualmente y necesita investigación a fondo para determinar si lo único que determina el salario es el sexo del individuo.








