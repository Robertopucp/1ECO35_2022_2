#!/usr/bin/env python
# coding: utf-8

# ### Pregunta 4: En un gráfico, muestre el diagrama de cajas (box - plot) del logaritmo del salario por hora de las personas con el mayor nivel educativo (ad) según genero. Nótese que el gráfico debe contener dos box-plot uno para los hombres y otro para las mujeres.

# In[5]:


#Importamos las librerías que vamos a utilizar: 

import pandas as pd 

import pyreadr

import math

import matplotlib.pyplot as plt

import numpy as np

import seaborn as sns


# In[6]:


# De esta manera abrimos una base de datos que esta en formato R en Python: 

result = pyreadr.read_r("/Users/diegoyeliseo/Desktop/Archivo R Tarea 8/wage2015_subsample_inference.Rdata")


print(result.keys())

# Para poder mostrar la base de datos: 

data = result["data"]

print(data)


# In[7]:


result.keys()

# Estamos diciendo que result1 va a ser igual a mi base de datos inicial: 

result1 = result['data']

result1 = result1[["wage", "lwage", "sex" , 
                  "exp1", "exp2" ,"exp3" ,"exp4", "shs",
                  "hsg", "scl", "clg" , "ad"]]


# In[8]:


result2 = result1[result1['ad'] == 1]

fig, ax = plt.subplots(figsize=(10,6)) # Este código se usa para elegir el tamaño de la caja. 

box = sns.boxplot(x='sex', y='lwage', data = result2  ,palette='rainbow')

plt.xlabel('Sexo de la persona') # Código para que el eje x reciba el nombre de Sexo de la persona

plt.ylabel('Log del salario por hora') # Código para que el eje y reciba el nombre de Logaritmo del salario por hora

(box.set_xticklabels(["Hombre", "Mujer"])) # Código que nos permite poner nombre a las etiquetas del eje x. En este caso, las etiquetas son hombre y mujer.

# Del plot box anterior, podemos notar que la mediana para los hombres está en aproximadamente 3.5. El máximo ingreso (en logaritmos) estaría cerca a las 5 unidades y existe presencia de 2 outliners por encima de dicha cantidad. Asimismo, el ingreso mínimo estaría en 2 unidades pero con presencia de varios outliners que llegan cerca a la unidad. Por otro lado, en el caso de las mujeres, la mediana se acerca más a las 3 unidades mientras que el salario máximo esta por las 4.5 unidades con presencia de outliners; el salario mínimo esta por encima del de los hombres.Encontramos simetría en los datos.