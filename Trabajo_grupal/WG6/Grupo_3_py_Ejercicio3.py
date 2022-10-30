#!/usr/bin/env python
# coding: utf-8

# In[125]:


#En primer lugar, en términos generales, el programa pensión 65 se focaliza en hogares pobres 
#con algún miembro del hogar mayor a 65 años. Usted debe crear una dummy si el hogar cumple 
#tales características. Para ello use el módulo 2 (características de los miembros del hogar).

#Primero, aplique groupby , luego realice un merge con el módulo 34, y finalmente, debe crear la variable dummy.


# In[126]:


#Primero importamos las librerías con la que vamos a trabajar: 

import pandas as pd
import numpy as np


# In[127]:


#Dado que nuestra base de datos está en formato stata, para poder trabajarla en python tenemos que
#utilizar el comando pd.read_stata

enahomódulo02_2020 = pd.read_stata(r"/Users/diegoyeliseo/Desktop/Archivos Stata Ejercicio Groupby/enaho01-2020-200.dta",
                           convert_categoricals=False) 

#Para mostrar la base de datos ponemos: 

enahomódulo02_2020


# In[128]:


# En primera instancia, vamos a aplicar groupby a hogares:

#Para ello, vamos a denotar una nueva variable llamada pensión65. Además de ello, generamos la variable de miembros_totales y la edad máxima: 

pensión65= enahomódulo02_2020.groupby( [ "conglome", "vivienda", "hogar" ],
                                      as_index = False ).agg(
                                      miembros_totales = ('conglome', np.size), 
                                      edad = ('p208a', np.max))


# In[129]:


#Dado que nuestra segunda base de datos también está en formato stata, tenemos que utilizar el comando pd.read_stata para poder trabajar en python: 

enahomódulo34_2020 = pd.read_stata(r"/Users/diegoyeliseo/Desktop/Archivos Stata Ejercicio Groupby/sumaria-2020.dta",
                           convert_categoricals=False) 


#Para mostrar la base de datos ponemos: 

enahomódulo34_2020


# In[130]:


# En segunda instancia, se realizará un merge del módulo 2(características de los miembros del hogar) con el módulo 34.
#En este sentido, vamos a realizar un merge entre pensión65 y enahomódulo34_2020:

#Vamos a establecer una nueva variable llamada pensión65_1 que va a ser el merge entre ambas bases de datos:

pensión65_1 = pd.merge(pensión65,enahomódulo34_2020 , 
                     on = ["conglome","vivienda","hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "m:1") 


# In[131]:


# Por lo mencionado en la nota, vamos a filtrar la base de datos con las variables que se necesitarán
#para que los programas no sean lentos:

#Todas las variables en corchete son mis variables relevantes con las que voy a trabajar: 

pensión65_1 = pensión65_1[["aÑo","conglome", "vivienda", "hogar" , 
                  "ubigeo", "dominio" ,"estrato" , "inghog1d",
                  "gashog2d", "mieperho", "linea", "edad", "miembros_totales"]]


# In[132]:


#Por último vamos a crear la variable dummy:

#En este sentido, empezamos creando el ingreso y gasto mensual de los hogares:

# Para ingreso mensual, el cálculo a realizar es el siguiente:

pensión65_1["ingreso_del_mes"]=pensión65_1["inghog1d"]/(12*pensión65_1["mieperho"])

# Para gasto mensual, el cálculo a realizar es el siguiente:

pensión65_1["gasto_del_mes"]=pensión65_1["gashog2d"]/(12*pensión65_1["mieperho"])


# In[133]:


# Por último, vamos a generar las variables dummies:

# Es relevante mencionar que en términos generales, el programa pensión 65 
# se focaliza en hogares pobres con algún miembro del hogar mayor a 65 años.

# En primera instancia, la primera dummy que vamos a generar es 
# si el hogar es pobre le ponemos 1 y si el hogar no es pobre le ponemos 0

# Vamos a crear una variable llamada hogar_pobre que va a ser igual a 1 si es que la variable gasto_del_mes 
# es menor a la línea de pobreza, y es igual a 0 si la variable gasto_del_mes es mayor a la línea de pobreza.

pensión65_1["hogar_pobre"]=np.where(pensión65_1["gasto_del_mes"]<pensión65_1["linea"],1,0)


# En segunda instancia, generamos la dummy si hay algún miembro del hogar que sea mayor de 65 años
# le ponemos 1, y si es menor de 65 años le ponemos 0

#Vamos a crear una variable llamada miembrodelhogar_supera_los_65años que va a ser igual a 1 si es que la variable edad es mayor 
# a 65 años y es igual a 0 si es menor a 65 años. 

pensión65_1["miembrodelhogar_supera_los_65años"]=np.where(pensión65_1["edad"]> 65,1,0)

# En tercera instancia, generamos la dummy de si se cumple las condiciones de Pensión 65 le ponemos 1
# y si no se cumple las condiciones le ponemos 0

#Vamos a crear una variable llamada formaparte_de_pension65  que va a ser igual 
# a 1 si se cumple que el hogar sea pobre y que cuente con algún miembro que sea mayor a 65 años,
# y le pondremos 0 para el caso contrario. 


pensión65_1["formaparte_de_pension65"]=np.where((pensión65_1["hogar_pobre"] == 1) & (pensión65_1["miembrodelhogar_supera_los_65años"] == 1),1,0)


# In[134]:


# A modo de ver si los cambios se han realizado en la base de datos, pongamos lo siguiente:

pensión65_1

