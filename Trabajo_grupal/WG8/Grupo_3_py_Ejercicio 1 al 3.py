#!/usr/bin/env python
# coding: utf-8

# In[92]:


# En primera instancia, vamos a importar todas las librerías que usaremos: 


# In[93]:


import pandas as pd 

import pyreadr

import math

import matplotlib.pyplot as plt

import numpy as np

import seaborn as sns


# ### Pregunta 1: En un gráfico muestre el histograma de frecuencias absolutas del salario y , en otro gráfico, el histograma del logaritmo del salario. Comente las diferencias y por qué.

# In[94]:


# De esta manera abrimos una base de datos que esta en formato R en Python: 

# Desde ya mencionar, que nuestra base de datos recibirá el nombre de "result"

result = pyreadr.read_r("/Users/diegoyeliseo/Desktop/Archivo R Tarea 8/wage2015_subsample_inference.Rdata")


print(result.keys())

data = result["data"]

print(data)


# In[95]:


data.head() #ver variables (nos interesan wage & lwage)


# In[96]:


get_ipython().run_line_magic('matplotlib', 'inline')
params = {'legend.fontsize': 'x-large',
          'figure.figsize': (10, 7.5),
         'axes.labelsize': 'x-large',
         'axes.titlesize':'x-large',
         'xtick.labelsize':'x-large',
         'ytick.labelsize':'x-large'}
plt.rcParams.update(params)


# In[97]:


# realizamos el primer histograma del salario por hora

(counts, bins, patches) = plt.hist(data['wage'], bins = 100, color ='orange', rwidth=0.75)
plt.xlabel('Salario por Hora')
plt.ylabel('Frecuencia')
plt.title('Histograma #1 - Frecuencia absoluta')
plt.show() #mostramos el histograma del salario 


# In[98]:


# realizamos el segundo histograma del salario por hora en logaritmos

(counts, bins, patches) = plt.hist(data['lwage'], bins = 100, color ='green', rwidth=0.75)
plt.xlabel('Salario por Hora en Logaritmos')
plt.ylabel('Frecuencia')
plt.title('Histograma #2 - Frecuencia absoluta')
plt.show() #mostramos el histograma del salario en logaritmo

# La diferencia entre ambos histogramas se debe a la conversión de la variable 'wage' a logaritmos --> 'lwage', puesto que al transformar una variable cuantitativa a logaritmos se tiene una distribución de datos más simétrica. Esta transformación monótona permite realizar una mejor regresión lineal entre variables de interés, pues se acota el rango de la variable (wage) a uno más pequeño, esto reduce la sensibilidad de la estimación ante observaciones atípicas. 


# ### Pregunta 2: En una sola imagen, el gráfico de densidad del logaritmo del salario por hora de las mujeres que terminaron la universidad y el caso de los hombres.

# In[99]:


fig = plt.subplots(figsize=(8,5)) # Para el tamaño del gráfico


sns.kdeplot(data = data[data.clg == 1],
            x = 'lwage',
            hue = 'sex',
            alpha = 0.6,
            edgecolor="0.1",
            linewidth=1,
             fill=True
            )


plt.legend(labels=['mujeres','hombres'],  title = "", frameon=True, bbox_to_anchor=(1.0, 0.98))

plt.title('Log salario por hora', size=11)

plt.ylabel('Kernel Density')

plt.xlabel('')

# Comentario del gráfico: En el gráfico de densidad, se observa la diferencia de salario por hora de hombres y mujeres representado en azul y naranja. En este, se tiene que las mujeres llegan a un pico de 0,4, mientras el de los hombres es menor hasta 0.35 aproximadamente.


# ### Pregunta 3: En un gráfico Pie, muestre el porcentaje de personas según nivel educativo.

# In[100]:

Datos: 

# shs: Si la persona tiene secundaria incompleta (Some high school)
# hsg: secundaria completa (High schoool graduate)
# scl: Universitaria incompleta (Some college)
# clg: Universitaria completa (College gratuate)
# ad: Grado educativo avanzado (Advanced degree - master or Phd)


# In[101]:

# Estamos diciendo que result1 va a ser igual a nuestra base de datos inicial

result1 = result['data']

# Estamos asignándole un número a cada elemento: 

result1.loc[result1["hsg"] == 1, "hsg"] = 2   
result1.loc[result1["scl"] == 1, "scl"] = 3
result1.loc[result1["clg"] == 1, "clg"] = 4
result1.loc[result1["ad"] == 1, "ad"] = 5

# Estamos diciéndole a Python de que el nivel educativo va a ser igual a la suma de esas 5 variables: 

result1['nivel_educativo'] = result1['shs'] + result1["hsg"] + result1["scl"] + result1["clg"] + result1["ad"]

# Estamos agrupando cada tipo de ocupación:
  
base = result1.groupby('nivel_educativo')['nivel_educativo'].size() 

# Le ponemos un nombre a los elementos del gráfico: 

labels=['Some high school','High schoool graduate' , 'Some college', 'College gratuate', 'Advanced degree - master or Phd' ]

fig, ax = plt.subplots( figsize=(10,10) ) # El tamaño de la caja 

base.plot(kind='pie', labels=labels, autopct='%.1f %%')

plt.title("Porcentaje de personas según nivel educativo") # Para ponerle título al gráfico

plt.ylabel("")

plt.show() # Para mostrar el gráfico

# Podemos ver que hay un mayor grupo de personas con universitaria completa, siendo un total de 31.8% del total. En segundo lugar, hay un total de 27.8% de personas que cuentan con universitaria incompleta. Esta brecha como vemos no es muy amplia. En última instancia se encuentran personas que tienen secundaria incompleta, siendo este porcentaje del 2.3% del total. Estos porcentajes guardan sentido lógico ya que Estados Unidos al ser un país primermundista, contribuye de manera significativa en la educación de su población, razón por la cual, se espera que un mayor porcentaje tenga universitaria completa. 