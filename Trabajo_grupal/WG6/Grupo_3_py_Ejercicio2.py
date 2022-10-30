#!/usr/bin/env python
# coding: utf-8

# In[7]:


#Primero importamos las librerías con la que vamos a trabajar: 

import pandas as pd
import numpy as np


# In[8]:


#Es preciso mencionar que la base de datos con la que vamos a trabajar 
#es el módulo de empleo(modulo05,enaho01a-2020-500):

#Dato que el archivo de la base de datos se nos presenta en formato stata, 
#tendremos que utilizar el comando pd.read_stata para que python pueda leer dicha base de datos: 

enahomódulo05_2020 = pd.read_stata(r"/Users/diegoyeliseo/Desktop/Archivo Stata Ejercicio Salario/enaho01a-2020-500.dta",
                             convert_categoricals=False) 
                    

print (enahomódulo05_2020.dtypes)

# Para poder mostrar la base de datos: 

enahomódulo05_2020


# In[9]:


#Es preciso mencionar, que como nota nos indica de que debemos filtrar la base de datos con las variables
#que necesitará para que sus programas no vuelvan lentos por lo pesado de los datos. En este sentido,
#para quedarnos con las variables a utilizar, escribimos el siguiente código: 

#Cabe mencionar, que las variables que aparecen entre corchetes están ordenadas de izquierda a derecha:

enahomódulo05_2020 = enahomódulo05_2020[["aÑo", "mes", "conglome", "vivienda", "hogar" , 
                  "ubigeo", "dominio" ,"estrato", "i524e1", "i538e1", "i513t", "i518"]] 

#Para mostrar la base de datos: 

enahomódulo05_2020


# In[16]:


#El primer paso para calcular el salario por hora es reemplazar por 0 todos los NA o missing en las variables relevantes
#que ya fueron mencionadas anteriormente. Para lograr ello, utilizamos los siguientes códigos: 

#Estas son las 4 variables que son como insumos para calcular el salario por hora: 

enahomódulo05_2020["i524e1"].replace({np.nan: 0},inplace =True)
enahomódulo05_2020["i538e1"].replace({np.nan: 0},inplace =True)
enahomódulo05_2020["i513t"].replace({np.nan: 0},inplace =True)
enahomódulo05_2020["i518"].replace({np.nan: 0},inplace =True)


# In[14]:


#El segundo paso para calcular el salario por hora, es realizar los cálculos respectivos: 

#Según los datos del problema, salario por hora del trabajador dependiente: suma de i524e1 i538e1/ ( ( suma i513t i518)*52)
#En este sentido apuntamos a lograr dicho cálculo: 

#Por ello, en primera instancia vamos a crear una variable llamada ingreso_anual_principal_segundoempleo
#que sea la suma de las variables i524e1 y i538e1:

enahomódulo05_2020['ingreso_anual_principal_segundoempleo'] = enahomódulo05_2020["i524e1"] + enahomódulo05_2020["i538e1"]

#En segunda instancia, vamos a crear una variable llamada cantidad_horastrabajadas_principal_segundoempleo
#que sea la suma de las variables i513t y i518: 

enahomódulo05_2020['cantidad_horastrabajadas_principal_segundoempleo'] = enahomódulo05_2020["i513t"] + enahomódulo05_2020["i518"]

#De esta manera, ya podemos pasar a resolver el cálculo deseado que era el siguiente: 

#suma de i524e1 i538e1/ ( ( suma i513t i518)*52)

#Entonces, vamos a reemplazar la suma de i524e1 i538e1 por ingreso_anual_principal_segundoempleo
#y vamos a reemplazar la suma i513t i518 por cantidad_horastrabajadas_principal_segundoempleo: 

enahomódulo05_2020['salarioporhora'] = enahomódulo05_2020['ingreso_anual_principal_segundoempleo'] / (enahomódulo05_2020['cantidad_horastrabajadas_principal_segundoempleo']*52)


# In[15]:


#El último paso para calcular el salario por hora, es que si un salario por hora resulta 0, hay que convertirlo a missing: 

enahomódulo05_2020['salarioporhora'].replace({0: np.nan}, inplace =True)

print(enahomódulo05_2020['salarioporhora'].value_counts())

