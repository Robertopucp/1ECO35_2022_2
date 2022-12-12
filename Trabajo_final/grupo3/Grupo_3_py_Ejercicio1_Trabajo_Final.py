#!/usr/bin/env python
# coding: utf-8

# In[208]:


# import libraries 

import pandas as pd
import numpy as np


# In[209]:


#Leyendo la data en Python

data = pd.read_stata("/Users/diegoyeliseo/Desktop/Final Python/mss_repdata.dta",
                    convert_categoricals=False)


# In[210]:


#Para mostrar la base de datos:

data


# ### <a id='1.3'> 1.1 Tabla de Estadísticas </a> 

# In[211]:


# summmary statistics

data.describe()



# In[212]:


# Tipo de variables


data.info()

data.dtypes


# In[213]:


# Seleccionamos las variables para las estadísticas descriptivas

table1 = data.loc[:,["NDVI_g", "tot_100", "trade_pGDP","pop_den_rur", "land_crop", "va_agr", "va_ind_manf"]]

table1 


# In[214]:


# seleccionamos los estadísticos de interés: media, error o desviación estándar y cantidad o total de observaciones

summary_table = table1.describe().loc[["mean","std","count"]]
summary_table


# In[215]:


# .t permite transponer el DataFrame

summary_table = table1.describe().loc[["mean","std","count"]].T
summary_table



# In[216]:


table1.columns


# In[217]:


table1.columns

new_names = ["Tasa de variación del índice de vegetación","Términos de intercambio","Porcentaje de las exportaciones respecto al PBI",
"Densidad poblacional rural","Porcentaje de tierra cultivable en uso","Valor agregado del sector agrículta respecto PBI",
"Valor agregado del sector manufacturero respecto PBI"]


# In[218]:


# unión de listas bajo la estructura diccionario

dict( zip( table1.columns, new_names) )


# In[219]:


# Customize summary table 

index_nuevos_nombres = dict( zip( table1.columns, new_names) )

columns_nuevos_nombres = {
    "mean": "Mean",
    "std": "St. Dev.",
    "count": "Observations",
}

# Rename rows (indexes) and columns
summary_table.rename(index=index_nuevos_nombres, columns=columns_nuevos_nombres, inplace=True)


# In[220]:


summary_table


# In[221]:


# Export the DataFrame to LaTeX
# \ permite esccribir código extenso en lineas diferentes

summary_table.style.format(subset="Mean", precision=2).format(subset="St. Dev.", precision=2).format(subset="Observations", precision=0).to_latex(
    "summary2.tex",
caption="Descriptive Statistics",
    column_format = "lccc"   # l: left, c:center , 
) 


# In[222]:


#Columns format

summary_table.style.format(subset="Mean", precision=2).format(subset="St. Dev.", precision=2).format(subset="Observations", precision=0)


# ### <a id='1.3'> 1.2. Replicación de la tabla 3 </a> 

# In[386]:


# instalar statsmodels 

get_ipython().system('pip install statsmodels')

# Export latex table 

get_ipython().system('pip install pystout')


# In[387]:


# Librerias a utilizar: 

# import linear models library // Son las librerias para las regresiones lineales

import statsmodels.api as sm  # linear regression utiliza todas las columnas de base de datos 
import statsmodels.formula.api as smf # linear regression usa una formula


from sklearn import datasets, linear_model # models 
from sklearn.metrics import mean_squared_error, r2_score


import warnings
warnings.filterwarnings('ignore') # eliminar warning messages 


# Export latex table 

from pystout import pystout


from tqdm import tqdm  # controlar el tiempo en un loop
import re 



# In[388]:


# Creando una variable dummy por país: 

# se convierte a entero data["ccode"].astype(int)

# ccode: código por país 

# dummy_na=False 

# capturar variables omitidas invariantes de cada país 


dummys = pd.get_dummies(data["ccode"].astype(int), prefix = "ccode", dummy_na=False)
dummys.columns


# In[389]:


# Para contar las dummys que haya:

len(dummys.columns)


# In[390]:


# concantenar ambas bases de datos de manera horizontal (axis = 1)

data = pd.concat([ data , dummys], axis = 1 )


# In[391]:


data


# In[392]:


# Creación del trend_country effects : multiplicación de las dummy por país y la variable temporal 
# capturar variables omitidas variantes en el tiempo por cada país. 

i = 0

while i < 41:  # 41 por el tema de indexing pues en python la posición inicial es cero. 
    var = dummys.columns[i]+"_"+"time"  # creamos el nombre de cada variable
    data[var]  = data[dummys.columns[i]]*data["time_year"] 
    
    # multiplicacón de variables: dummy país * variable temporal

    i = i + 1


# In[393]:


# observamos por país y la variable temporal. 

data[['ccode','time_year']].iloc[0:40,:]


# In[394]:


# Pasamos a estimar el primer modelo OLS que tiene como variable dependiente a any_prio: 

#Las características del modelo: 

#No variables de control
#Si efectos fijos por país y trend-time


formula_ols4 = "any_prio ~ GPCP_g + GPCP_g_l  + C(ccode)" + ' + ' +  ' + '.join( country_trend )

ols_model4 = smf.ols(formula_ols4, data=data).fit(cov_type='cluster', cov_kwds={'groups': data['ccode']})

print(ols_model4.summary())


rmse_ol4 = round(mean_squared_error( y, ols_model4.predict())**0.5,2)

print(rmse_ol4)


# In[395]:


# Pasamos a estimar el segundo modelo OLS que tiene como variable dependiente a war_prio: 

#Las características del modelo: 

#No variables de control
#Si efectos fijos por país y trend-time

formula_ols5 = "war_prio ~ GPCP_g + GPCP_g_l  + C(ccode)" + ' + ' +  ' + '.join( country_trend )

ols_model5 = smf.ols(formula_ols5, data=data).fit(cov_type='cluster', cov_kwds={'groups': data['ccode']})

print(ols_model5.summary())


rmse_ol5 = round(mean_squared_error( y, ols_model5.predict())**0.5,2)

print(rmse_ol5)


# In[396]:


# Lista de explicativa a mostrarse en la tabla

explicativas = ['GPCP_g', 'GPCP_g_l']

# etiquetas a las variables 

etiquetas = ['Growth in rainfall, t','Growth in rainfall, t-1']


labels = dict(zip(explicativas,etiquetas))
labels 


# In[397]:


# Las tablas en latex se guardan en el archivo regression_table
# endog_names: nombre de las variables endógenas. En este caso solo son numerales
# exogvars: selecciona las variables explicativas 

pystout(models = [ols_model4,ols_model5], file='regression_table.tex', digits=3,
        endog_names=['OLS','OLS'],
        exogvars =explicativas ,  # sellecionamos las variables 
        varlabels = labels,  # etiquetas a las variables
        mgroups={'Dependent Variable':[1,2]}, # titulo a las regresiones
        modstat={'nobs':'Observarions','rsquared':'R\sym{2}'}, # estadísticos 
        addrows={'Country fixed effects':['yes','yes'], 'Country-specific time trends' :
                 ['yes','yes'],
                 'Root mean square error': [ rmse_ol4,rmse_ol5 ]}, # añadimos filas 
        addnotes=['Note.—Huber robust standard errors are in parentheses.',
                  'Regression disturbance terms are clustered at the country level.',
                 'A country-specific year time trend is included in all specifications (coefficient estimates not reported).',
                 '* Significantly different from zero at 90 percent confidence.',
                 '** Significantly different from zero at 95 percent confidence.',
                 '*** Significantly different from zero at 99 percent confidence.'],
        title='Rainfall and Civil Conflict (Reduced-Form)',
        stars={.1:'*',.05:'**',.01:'***'}
       )


# ### <a id='1.3'> 1.3 Coefplot </a> 

# In[ ]:


# Aca se tiene que instalar statsmodels: 

get_ipython().system('pip install statsmodels')


# In[439]:


# Librerias a utilizar:

import pandas as pd
import numpy as np

#plots library

import matplotlib.pyplot as plt
import seaborn as sns

# import linear models library

import statsmodels.api as sm
import statsmodels.formula.api as smf


from sklearn import datasets, linear_model # models 
from sklearn.metrics import mean_squared_error, r2_score


# In[440]:


# Linear Regression: 


smf.ols('GPCP_g~ dummys', data).fit(cov_type = 'HC1')  # HC0: white , HC1: Hubert - White 
model1 = smf.ols('GPCP_g~ dummys', data).fit(cov_type = 'HC1').summary()
print(model1)


# In[441]:


smf.ols('GPCP_g~ dummys', data).fit(cov_type = 'HC1').summary2().tables[1]


# In[442]:



# First Model

model1 = smf.ols('any_prio ~ GPCP_g', data).fit(cov_type = 'HC1').summary2().tables[1]
model1_coef = model1.iloc[1,1]  # fila posición 1 y columan posición 1
model1_coef_se = model1.iloc[1,2] # fila posición 1 y columan posición 2

# HC1: standar error robust aginst heterocedasticity

#Intervalo de confianza ajustado por heterocedasticidad: 

model1_lower = model1.iloc[1,1]
model1_upper = model1.iloc[1,2]


# In[443]:


# Second Model

model2 = smf.ols('war_prio ~ GPCP_g', data).fit(cov_type = 'HC1').summary2().tables[1]
model2_coef = model2.iloc[1,1]  # fila posición 1 y columan posición 1
model2_coef_se = model2.iloc[1,2] # fila posición 1 y columan posición 2

# HC1: standar error robust aginst heterocedasticity

#Intervalo de confianza ajustado por heterocedasticidad: 

model2_lower = model2.iloc[1,1]
model2_upper = model2.iloc[1,2]


# In[446]:


# Creamos una matris 2x4 con valores 0

table = np.zeros( (2, 4 ) )

# Ordenamos los rsultados obtenidos

table[1,1] = model1_coef
table[1,2] = model1_coef_se 

table[2,1] = model2_coef
table[2,2] = model2_coef_se  

table[1,3] = model1_lower
table[1,4] = model1_upper 

table[2,3] = model2_lower
table[2,4] = model2_upper 

#Asignamos los nombres correspondientes a las filas y columnas: 


table_pandas = pd.DataFrame( table, columns = [ "Estimate","Std. Error","Lower_bound" , "Upper_bound"])
table_pandas.index = [ "OLS Civil Conflict ≥ 25","OLS Civil Conflict ≥ 1000"]

table_pandas.reset_index(inplace = True)
table_pandas.rename(columns = {"index" : "Model"}, inplace = True)

table_pandas.round(8)


# In[445]:


fig, ax = plt.subplots(figsize=(7, 6))

ax.scatter(x=table_pandas['Model'], 
         marker='o', s=20,  # s: modificar tamaño del point
         y=table_pandas['Estimate'], color = "blue")

eb1 = plt.errorbar(x=table_pandas['Model'], y=table_pandas['Estimate'],
            yerr = 0.5*(table_pandas['Upper_bound']- table_pandas['Lower_bound']),
            color = 'blue', ls='', capsize = 4)

# ls='': no une los puntos rojos 
#  yerr genera el gráfico del intervalo de confianza 

plt.axhline(y=0, color = 'black').set_linestyle('--')  # linea horizontal 
# Set title & labels
plt.title('Coeficiente estimado de la variable GPCP_g',fontsize=12)


# In[ ]:




