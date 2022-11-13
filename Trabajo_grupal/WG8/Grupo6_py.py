# -*- coding: utf-8 -*-
"""
Created on Sun Nov 13 11:59:28 2022

@author: HP
"""


#########################################################################
     Tarea 8 - Grupo 6
########################################################################

! pip install pyreadr

#----------------------------------------------
# Antes de responder a las preguntas tenemos que cargar la base de datos, observar los nombre de etiquetas de la base

import numpy as np   
import pandas as pd
import pyreadr
from pandas import Series, DataFrame
import matplotlib.pyplot as plt # Es librería para gráficos
import seaborn as sns # Es librería para gráficos
import datetime as dt # Es librería para fechas
import warnings 
warnings.filterwarnings('ignore') # Para eliminar mensajes de alerta

#----------------------------------------------
# Pregunta 1: En gráfico muestre el histograma de frecuencias absolutas del salario y, en otro gráfico, el histograma del logaritmo del salario. Comente las diferencias y por qué
# Indicamos la base de datos con la que trabajaremos y colocaremos un nombre a la base de datos de la encuesta de población para EEUU (2015)

result = pyreadr.read_r("../data//wage2015_subsample_inference.Rdata") 
base = result['base']
data.dtypes
print(base)

# Para El PRIMER GRAFICO  de histograma de frecuencias absolutas del salario (wage) utilizamos comando kind= hist 
# se coloca el título al gráfico y el título a la coordenada de salario

fig, ax = plt.subplots( figsize=(8,8) ) # para establecer el tamaño del gráfico
base['wage'].plot(kind = 'hist', bins = 30) # se le coloca 30 para ver mejor la distribución 
plt.title('Salario por hora')
txt="Elaboración propia del grupo 6"  
plt.figtext(0.5, 0.01, txt, wrap=True, horizontalalignment='center', fontsize=12)
plt.show()

# Para El SEGUNDO GRAFICO  de histograma de frecuencias absolutas del logaritmo del salario (lwage) utilizamos comando kind= hist 
# indicamos el tamaño del gráfico
fig, ax = plt.subplots( figsize=(8,8) )
base['lwage'].plot(kind = 'hist', bins = 50) # se le coloca 50 para ver mejor la distribución 
plt.title('Logaritmo del salario por hora')
txt="Elaboración propia del grupo 6"  
plt.figtext(0.5, 0.01, txt, wrap=True, horizontalalignment='center', fontsize=12)
plt.show()

# Comentario - En el caso del histograma del logaritmo del salario se muestra el comportamiento de una distribución normal. Mientras que en el caso del histograma de salario unicamente, se muestra la distribución hacia un lado solamente. Esto también porque con el logaritmo podemos observar los incrementos a partir de la variación de 1 unidad.

#----------------------------------------------
# Pregunta 2: En una sola imagen, el gráfico de densidad del logaritmo del salario por hora de las mujeres que terminaron la universidad y el caso de los hombres
# Indicamos el tamaño del gráfico, seguido de utilizar el comando kdeplot para gráfico de densidad

plt.figure(figsize=(10, 5))
sns.kdeplot(base.lwage[base.sex == 1], label='Mujer', shade=True,
            x = 'bwghtlbs',
            alpha = 0.4,
            edgecolor="0.1",
            linewidth=1,
            color = 'red'
           )
sns.kdeplot(base.lwage[base.sex == 0], label='Hombre', shade=True,           
            x = 'bwghtlbs',
            alpha = 0.4,
            edgecolor="0.1",
            linewidth=1,
            color = 'blue'
           )

plt.legend(labels=['Mujer','Hombre'],  title = "", frameon=True, bbox_to_anchor=(1.0, 0.98))
plt.title('Grafico de densidad por sexos', size=15)
plt.ylabel('Kernel Density')
plt.xlabel('Logaritmo del salario por sexos')


#----------------------------------------------
# Pregunta 3: En un gráfico Pie, muestre el porcentaje de personas según nivel educativo
# Sabemos quehay 5 niveles educativos, por lo que deberíamos tener una sola variable que agrupe a las demás categorías, mediante comando groupby

base.columns
columnas = ['shs','hsg', 'scl', 'clg', 'ad']
base_2 = base.filter(columnas)
base_2['nivel_educa']=base_2['shs']+base_2['hsg']+base_2['scl']+base_2['clg']+base_2['ad']
base_2
#Donde
# shs: Si la persona tiene secundaria incompleta (Some high school)
# shg: secundaria completa (High schoool graduate)
# scl: Universitaria incompleta (Some college)
# clg: Universitaria completa (College gratuate)
# ad: Grado educativo avanzado (Advanced degree - master or Phd)

basee = base_2.groupby('ad')['ad'].size() # cantidad por tipo de ocupación
labels=['No posee un grado educativo avanzado','Posee un grado educativo avanzado']

fig, ax = plt.subplots( figsize=(5,5) )

ax = plt.pie(basee, labels=labels, autopct='%.1f %%')
plt.title("Secundaria incompleta")
plt.ylabel("")
plt.show()

base2 = base_2.groupby('shs')['shs'].size() 
labels2=['No Posee secundaria incompleta','Posee secundaria incompleta']

fig, ax = plt.subplots( figsize=(5,10) )

ax = plt.pie(base2, labels=labels2, autopct='%.1f %%')
plt.title("Secundaria incompleta")
plt.ylabel("")
plt.show()

base3 = base_2.groupby('scl')['scl'].size() # cantidad por tipo de ocupación
labels3=['No posee Universitaria incompleta','Posee Universitaria incompleta']

fig, ax = plt.subplots( figsize=(5,5) )

ax = plt.pie(base3, labels=labels3, autopct='%.1f %%')
plt.title("Universitaria incompleta")
plt.ylabel("")
plt.show()

base4 = base_2.groupby('clg')['clg'].size() # cantidad por tipo de ocupación
labels4=['No posee educacion universitaria completa','Posee educacion universitaria completa']

fig, ax = plt.subplots( figsize=(5,5))
ax = plt.pie(base4, labels=labels4, autopct='%.1f %%')
plt.title("Universitaria completa")
plt.ylabel("")
plt.show()





#----------------------------------------------
# Pregunta 4: En un gráfico, muestre el diagrama de cajas (box - plot) del logaritmo del salario por hora de las personas con el mayor nivel educativo (ad) según genero. Nótese que el gráfico debe contener dos box-plot uno para los hombres y otro para las mujeres


fig, ax = plt.subplots(figsize=(10,6))

box = sns.boxplot(x="sex", y="lwage", data=base[base['ad'] == 1 ] ,palette='rainbow', showfliers=False)

plt.xlabel('sexo')
plt.ylabel('Logaritmo del salario por hora')

(box.set_xticklabels(["Mujer", "Hombre"]))
