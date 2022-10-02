#!/usr/bin/env python
# coding: utf-8

# ### Parte de la Tarea 5 - SPPS File

# In[27]:


pip install pyreadstat

# Tarea 5 - SPSS File
    # Integrantes:
       # Enrique Ríos 
       # Fabio Salas
       # Amalia Castillo
       # Angie  Quispe

# Usted debe trabajar una base data_administrativa que está en la carpeta data. Esta base de datos contiene es una encuesta realizado a miembros del hogar durante años años 2019 y 2020.
# Mostrar las variables que presentan missing values
# Se le pide mostrar las etiquetas de dos variables (var labels) y las etiquetas de los valores en dos variables (value's labels).
# Se le pide detectar personas que fueran entrevistadas en ambos años. Para ello, se pide detectar duplicados a partir del identificador por persona : conglome, vivienda, hogar y codperso.
# Ordene la base de datos a partir de las variables que identifican cada miembro y la variable de año (year). Así podrá observar a cada individuo en ambos años.
# Finalmente crear una base de datos para cada año y guardar en la carpeta data con los siguientes nombres data_2019_(numero de grupo) y data_2020_(numero de grupo).


# In[29]:


import numpy as np
import pandas as pd
import os
import pyreadstat as py

user = os.getlogin()   # Username

# Setear directorio


# ### Se importa los datos a analizar

# In[33]:


os.chdir(f"/Users/enriquerios/Desktop/PUCP 2022.2/R y Python/1ECO35_2022_2/data") # Fijar directoriO


# In[34]:


df,meta=py.read_sav('data_administrativa.sav')


# ### Se revisa la dimensión de la data

# In[35]:


df.shape


# ### Se evalua los datos faltantes

# In[36]:


vacios = pd.DataFrame(df.isnull().sum()).sort_values(0,ascending=False)
vacios.columns = ['vacios']
vacios['vacios%'] = round(vacios['vacios']/df.shape[0], 2)*100
vacios # Datos vacios y vacios % en la tabla


# ###  Etiquetas de las dos variables: Var labels y values labels

# #### Primero : Value labels

# In[37]:


meta.value_labels['labels0'] # Variable geográficaa


# In[38]:


meta.value_labels['labels1'] # variable de habitantes


# #### Segundo: Variable labels

# In[39]:


meta.variable_value_labels['DOMINIO'] #variable del dominio


# In[40]:


meta.variable_value_labels['ESTRATO'] # ahora es variable denominada estrato


# ### Se procede a  detectar y eliminar los duplicados

# In[41]:


m=df.duplicated(df.columns[~df.columns.isin(['conglome','vivienda','hogar','codperso'])],
                        keep='first')


# In[42]:


m_true=m[m==True]


# #### Se encuentra que NO existen duplicados

# In[43]:


m_true


# #### Código para borrar duplicados

# In[44]:


# df = df.drop_duplicates(df.columns[~df.columns.isin(['conglome','vivienda','hogar','codperso'])],
#                        keep='first')
# Se agregó el código para borrar duplicados


# ### Creación de dataframe 2019 y 2020

# In[45]:


df2019=df.copy()
df2020=df.copy()


# In[46]:


df2019.drop(df[df['year']=='2020'].index,inplace=True)
df2020.drop(df[df['year']=='2019'].index,inplace=True)


# In[47]:


df2019.head()


# In[48]:


df2020.head()


# #### Guardamos la nueva data creada

# In[49]:


py.write_sav(df2019,'data_2019_2.sav')
py.write_sav(df2020,'data_2020_2.sav')


# In[ ]:





# In[ ]:




