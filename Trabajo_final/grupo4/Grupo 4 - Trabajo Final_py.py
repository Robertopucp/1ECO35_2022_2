## GRUPO 4:
    
## Integrantes:

# 20191215 - Flavia Lucıa Ore Mora
#20191445 - Marcela Giuliana Quintero Balletta
#20191240 - Luana Lisette Morales Ancajima
#20191622 - Seidy Isabel Ascencios Angeles

###############################################################################
#                                                                             #
#                                PREGUNTA 1                                   #
#                                                                             #
###############################################################################

#%%  Importamos las librerías necesarias 

import pandas as pd 
import numpy as np
import re 
from tqdm import tqdm  # controlar el tiempo en un loop
import os


# linear model library

import statsmodels.api as sm  # linear regression utiliza todas las columnas de base de datos 
import statsmodels.formula.api as smf  # linear regression usa uan formula
from sklearn import datasets, linear_model # models 
from sklearn.metrics import mean_squared_error, r2_score
from linearmodels.iv import IV2SLS # for IV regression

import warnings
warnings.filterwarnings('ignore') # eliminar warning messages 


# Export latex table and plot
pip install pystout
from pystout import pystout

import matplotlib.pyplot as plt
import seaborn as sns

user = os.getlogin()   # Username
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab10") # Set directorio


#%%  Pregunta 1.1


# laod dataset

repdata = pd.read_stata(r"../data/dataverse_files/mss_repdata.dta",
                           convert_categoricals=False)

# convert_categoricals=False: No se lee las etiquetas de valor 

repdata


# summmary statistics

repdata.describe()

# Tipo de variables

repdata.info()

repdata.dtypes


# Extraer year
# con .month se puede extraer el mes 
# con .day se puede extraer el día 

repdata['time_year'] = pd.DatetimeIndex(repdata['year']).year - 1978
repdata['time_year']

print (time_year)


dummys = pd.get_dummies(repdata["ccode"].astype(int), prefix = "ccode", dummy_na=False)
dummys.columns

# se convierte a entero repdata["ccode"].astype(int)

# ccode: código por país 

# dummy_na=False 

# capturar varibbles omitidas invariantes de cada país 

dummys

len(dummys.columns)


repdata = pd.concat([ repdata , dummys], axis = 1 )

# concantenar ambas bases de datos de manera horizontal (axis = 1)


# Creación del trend_country effects : multiplicación de las dummy por país y la variable temporal 
# capturar variables omitidas variantes en el tiempo por cada país. 

i = 0

while i < 41:  # 41 por el tema de indexing pues en python la posición inicial es cero. 
    var = dummys.columns[i]+"_"+"time"  # creamos el nombre de cada variable
    repdata[var]  = repdata[dummys.columns[i]]*repdata["time_year"] 
    
    
    # multiplicacón de variables: dummy país * variable temporal

    i = i + 1

#Observamos los trend_country effects creados

print(repdata[var])


# Observamos para país y la variable temporaral. 

repdata[['ccode','time_year']].iloc[0:40,:]


# Seleccionamos las variables para las estadísticas descriptivas

table1 = repdata.loc[:,["NDVI_g", "tot_100_g", "trade_pGDP", "pop_den_rur","land_crop", "va_agr", "va_ind_manf"]]

table1 


# Seleccionamos los estadísticos de interés: media, error estándar y cantidad de observaciones

summary_table = table1.describe().loc[["mean","std","count"]]
summary_table


summary_table = table1.describe().loc[["mean","std","count"]].T
summary_table
# .t permite tranponer el DataFrame


table1.columns


table1.columns

new_names = ["Tasa de variación de índices de vegetación", "Términos de intercambio","Porcentaje de las exportaciones recpecto al PBI","Densidad poblacional rural",
"Porcentaje de tierra cultivable en uso","Valor agregado del sector agrícola respecto PBI","Valor agregado del sector manufacturero respecto PBI"]

# Unión de listas bajo la estructura diccionario

dict( zip( table1.columns, new_names) )


# Customize summary table 

index_nuevos_nombres = dict( zip( table1.columns, new_names) )

columns_nuevos_nombres = {
    "mean": "Mean",
    "std": "Standard Deviation",
    "count": "Observations",
}

# Rename rows (indexes) and columns
summary_table.rename(index=index_nuevos_nombres, columns=columns_nuevos_nombres, inplace=True)

summary_table

# Export the DataFrame to LaTeX
# \ permite esccribir código extenso en lineas diferentes

summary_table.style.format(subset="Mean", precision=2).format(subset="Standard Deviation", precision=2).format(subset="Observations", precision=0).to_latex(
    "summary2.tex",
caption="Descriptive Statistics",
    column_format = "lccc"   # l: left, c:center , 
) 


#Columns format

summary_table.style.format(subset="Mean", precision=2).format(subset="Standard Deviation", precision=2).format(subset="Observations", precision=0)



#%% Pregunta 1.2 

# Anteriormente creamos el country_time_trends, ahora crearemos los efectos fijos por país (country fixed effect):

index_columns = np.where( repdata.columns.str.contains(
    '_time$'))[0]

# Indice con nombre de variables que terminan con _time

country_trend = repdata.columns[index_columns] # se extrae el nombre de todas las variables que terminan con _time
country_trend 


#Planteamos el modelo 1 donde la variable "y" es Civil conflict > 25 deaths
formula_model1 = "any_prio ~ GPCP_g + GPCP_g_l + C(ccode)" + ' + ' + ' + '.join( country_trend )


ols_model1 = smf.ols(formula_model1, data=repdata).fit(cov_type='cluster', cov_kwds={'groups': repdata['ccode']})

print(ols_model1.summary())


#Planteamos el Modelo 2 donde la variable "y" es Civil conflict > 1000

formula_model2 = "war_prio ~ GPCP_g + GPCP_g_l + C(ccode)" + ' + ' + ' + '.join( country_trend )


ols_model2 = smf.ols(formula_model2, data=repdata).fit(cov_type='cluster', cov_kwds={'groups': repdata['ccode']})

print(ols_model2.summary())


##Cabe resaltar que ambas regresiones están clusterizadas y usan los errores estándar robustos.

#Calculamos los root mean squared errors para ambas regresiones


anyprio= repdata["any_prio"]
warprio= repdata["war_prio"]


rmse_ol1 = round(mean_squared_error(anyprio, ols_model1.predict())**0.5,2)
print (rmse_ol1)

rmse_ol2 = round(mean_squared_error(warprio, ols_model2.predict())**0.5,2)
print (rmse_ol2)


##Procedemos a hacer la tabla


# Lista de variables explicativas a mostrarse en la tabla

explicativas = ['GPCP_g','GPCP_g_l']

# Etiquetas a las variables 

etiquetas = ['Growth in rainfall, t','Growth in rainfall, t-1']


labels = dict(zip(explicativas,etiquetas))
labels 

pystout (models = [ols_model1,ols_model2], file='regression_table_3.tex', digits=3,
        endog_names=[ "Civil Conflict > 25 deaths ", "Civil Conflict > 1000 deaths"],
        exogvars =explicativas ,  # selecionamos las variables 
        varlabels = labels,  # etiquetas a las variables
        mgroups={"Dependent Variable " : [1,2] }, # titulo a las regresiones
        modstat={'nobs':'Observations','rsquared':'R\sym{2}'}, # estadísticos 
        addrows={'Country fixed effects':['yes','yes'], 'Country-specific time trends' :
                 ['yes','yes'],
                 'Root mean square error': [rmse_ol1,rmse_ol2]}, # añadimos filas 
        addnotes=['Note.—Huber robust standard errors are in parentheses.',
                  'Regression disturbance terms are clustered at the country level.',
                 'A country-specific year time trend is included in all specifications (coefficient estimates not reported).',
                 '* Significantly different from zero at 90 percent confidence.',
                 '** Significantly different from zero at 95 percent confidence.',
                 '*** Significantly different from zero at 99 percent confidence.'],
        title='Rainfall and Civil Conflict (Reduced-Form)',
        stars={.1:'*',.05:'**',.01:'***'}
       )
    

    
#%% Pregunta 1.3


# Fijamos los coeficientes y errores estándar del modelo 1

model1 = smf.ols(formula_model1, data=repdata).fit(cov_type='cluster', cov_kwds={'groups': repdata['ccode']}).summary2().tables[1]
model1_coef = model1.iloc[41,0]  # fila posición 1 y columna posición 0
model1_coef_se = model1.iloc[41,1] # fila posición 1 y columan posición 1

# Obtenemos el lower y upper bound del modelo 1
model1_lower = model1.iloc[41,4]
model1_upper = model1.iloc[41,5]


# Fijamos los coeficientes y errores estándar del modelo 2
model2 = smf.ols(formula_model2, data=repdata).fit(cov_type='cluster', cov_kwds={'groups': repdata['ccode']}).summary2().tables[1]
model2_coef = model2.iloc[41,0]  # fila posición 1 y columna posición 0
model2_coef_se = model2.iloc[41,1] # fila posición 1 y columan posición 1

# Obtenemos el lower y upper bound del modelo 2
model2_lower = model2.iloc[41,4]
model2_upper = model2.iloc[41,5]

#Creamos una tabla con los datos ya extraídos

table = np.zeros( ( 2, 4 ) )

table[0,0] = model1_coef
table[0,1] = model1_coef_se 
table[0,2] = model1_lower
table[0,3] = model1_upper 

table[1,0] = model2_coef
table[1,1] = model2_coef_se  
table[1,2] = model2_lower
table[1,3] = model2_upper 



table_pandas = pd.DataFrame( table, columns = [ "Estimate","Std. Error","Lower_bound" , "Upper_bound"])
table_pandas.index = [ "Dependent Variable: Civil Conflict ≥25 Deaths","Dependent Variable: Civil Conflict ≥1000 Deaths"]

table_pandas.reset_index(inplace = True)
table_pandas.rename(columns = {"index" : "Model"}, inplace = True)

table_pandas.round(8)


# Realizamos el coef plot 

fig, ax = plt.subplots(figsize=(7, 6))

ax.scatter(x=table_pandas['Model'], 
         marker='o', s=10,  # s: modificar tamaño del point
         y=table_pandas['Estimate'], color = "black")

eb1 = plt.errorbar(x=table_pandas['Model'], y=table_pandas['Estimate'],
            yerr = 0.5*(table_pandas['Upper_bound']- table_pandas['Lower_bound']),
            color = 'black', ls='', capsize = 4)


plt.axhline(y=0, color = 'black').set_linestyle('--')  # linea horizontal 
# Set title & labels
plt.title('GPCP_g Coefficient (95% CI)',fontsize=12)



#%% Pregunta 2

# !pip install openpyxl

#import pandas as pd
#import os

user = os.getlogin()   # Username

os.chdir(f"C:/Users/{user}/Documents/final_py")


## Importamos las bases de datos de Excel a Python:
## Como se trabajó con un archivo propio llamado "Detalle", el código no correrá a menos de tenerlo en una carpeta
## llamada "final_py":
    
df2014 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2014')
df2015 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2015')
df2016 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2016')
df2017 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2017')
df2018 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2018')
df2019 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2019')
df2020 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2020')
df2021 = pd.read_excel(f"C:/Users/{user}/Documents/final_py/Detalle.xlsx", sheet_name='Detalle2021')


## Conservamos a la columna ANUAL:

df2014 = df2014.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2015 = df2015.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2016 = df2016.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2017 = df2017.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2018 = df2018.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2019 = df2019.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2020 = df2020.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])
df2021 = df2021.drop(columns = ["I BIMESTRE", "II BIMESTRE", "III BIMESTRE", "IV BIMESTRE", "V BIMESTRE", "VI BIMESTRE"])


## Eliminamos las filas de Establecimiento de Salud e Instituciones educativas:
    
df2014 = df2014.drop([8,9], axis=0)
df2015 = df2015.drop([8,9], axis=0)
df2016 = df2016.drop([8,9], axis=0)
df2017 = df2017.drop([8,9], axis=0)
df2018 = df2018.drop([8,9], axis=0)
df2019 = df2019.drop([8,9], axis=0)
df2020 = df2020.drop([8,9], axis=0)
df2021 = df2021.drop([8,9], axis=0)


## Mergeamos los df:
    
df2014 = df2014.rename(columns={'ANUAL':'2014'})
df2015 = df2015.rename(columns={'ANUAL':'2015'})
df2016 = df2016.rename(columns={'ANUAL':'2016'})
df2017 = df2017.rename(columns={'ANUAL':'2017'})
df2018 = df2018.rename(columns={'ANUAL':'2018'})
df2019 = df2019.rename(columns={'ANUAL':'2019'})
df2020 = df2020.rename(columns={'ANUAL':'2020'})
df2021 = df2021.rename(columns={'ANUAL':'2021'})

## Como solo se puede utilizar el comando merge para 2 dfs, juntamos cada tabla en grupos de 2 en 2:
    
merge1 = pd.merge(df2014, df2015)
merge2 = pd.merge(df2016, df2017)

first_merge = pd.merge(merge1, merge2)

## El segundo grupo:
    
merge3 = pd.merge(df2018, df2019)
merge4 = pd.merge(df2020, df2021)

second_merge = pd.merge(merge3, merge4)

## La tabla final:
    
dfs_merged = pd.merge(first_merge, second_merge)


## Transponiendo la tabla para que quede como la de las indicaciones:
    
dfs_merged.set_index(dfs_merged.columns[0])
dfs_merged = dfs_merged.T 

## Cambiamos de nombre al index

dfs_merged = dfs_merged.rename(index={'Unnamed: 0':'Año'})




