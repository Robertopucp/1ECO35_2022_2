# -*- coding: utf-8 -*-
"""
@author: Roberto
"""

import pandas as pd
import numpy as np
import os 

user = os.getlogin()   # Username


os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2") # Set directorio


#%% Load datasets

enaho_19_01 = pd.read_stata(r"../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False)


enaho_19_34 = pd.read_stata(r"../../datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False)

deflactor = pd.read_stata(
    r"../../datos/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta",
                           convert_categoricals=False)


###### Año 2019 ######

enaho_19_01.rename(columns={'aÑo':'year'}, inplace=True)

# seleccionamos variables del módulo 1

enaho_19_01 = enaho_19_01[['year','conglome','vivienda','hogar','ubigeo']]


# seleccionamos variables del módulo sumaria


enaho_19_34 = enaho_19_34[['conglome','vivienda','hogar','mieperho','inghog1d','gashog2d','ld']]


# Merge ambas bases 

enaho_merge_19 = pd.merge(enaho_19_01, enaho_19_34,
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left")

###### Año 2020 ######

enaho_20_01 = pd.read_stata(r"../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False)


enaho_20_34 = pd.read_stata(r"../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)

enaho_20_01.rename(columns={'aÑo':'year'}, inplace=True)

# seleccionamos variables del módulo 1

enaho_20_01 = enaho_20_01[['year','conglome','vivienda','hogar','ubigeo']]


# seleccionamos variables del módulo sumaria


enaho_20_34 = enaho_20_34[['conglome','vivienda','hogar','mieperho','inghog1d','gashog2d','ld']]


# Merge ambas bases 

enaho_merge_20 = pd.merge(enaho_20_01, enaho_20_34,
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left")


##### Append #####

enaho_append = enaho_merge_19.append(enaho_merge_20, ignore_index = True)


## merge con la abse de deflactores 


# seleccionamos dos primeros digitos y lo comvertimos a numero pues la variable ubigeo es string (texto)

enaho_append['ubigeo_dep'] = enaho_append['ubigeo'].str[:2].astype(int)

enaho_append['year'] # es un string 

# para hacer el merge, la variables deben comaprtir el mismo formato 
# la variable departamento de la base deflactor debe ser numero entero
# mientras la variable year debe ser un string 


deflactor['dpto'] = deflactor['dpto'].astype(int)

deflactor['aniorec'] = deflactor['aniorec'].astype(int).astype(str) 
# notese que aniorec es float, luego se onvierte a entero y finalmente a string para eliminar decimal (.0)


deflactor.info()  # verifica los formatos de las variables 


enaho_append = pd.merge(enaho_append,deflactor, left_on =['year','ubigeo_dep'] ,
                                right_on =['aniorec','dpto'] ,   how = "left", validate = "m:1")


# Creación de variables 


enaho_append['ing_pc_real'] = enaho_append['inghog1d']/(12*enaho_append['ld']*enaho_append['i00']*enaho_append['mieperho'])


enaho_append['gast_pc_real'] = enaho_append['gashog2d']/(12*enaho_append['ld']*enaho_append['i00']*enaho_append['mieperho'])


#%% Salario por hora (pregunta 2)

 
enaho_20_05 = pd.read_stata(r"../../datos/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta",
                           convert_categoricals=False)



# sum() permite sumar columnas ignorando los missings

enaho_20_05['suma_ingreso']  = enaho_20_05[["i524e1", "i538e1"]].sum(axis=1)

# axis 1: suma horizontal o por fila 

enaho_20_05['total_horas']  = enaho_20_05[["i513t", "i518"]].sum(axis=1)


enaho_20_05['hour_wage'] = enaho_20_05['suma_ingreso']/(enaho_20_05['total_horas']*52)

# Si alguno salario por hora es cero, se reemplaza por missing 

enaho_20_05['hour_wage'].replace(0, np.nan, inplace = True)


#%% Group-by

enaho_20_02 = pd.read_stata(r"../../datos/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta",
                           convert_categoricals=False)

enaho_20_34 = pd.read_stata(r"../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)

# nanmax ignora missings.

df1 = enaho_20_02.groupby( [ "conglome", "vivienda", "hogar" ],
                          as_index = False ).agg( edad_max = ( 'p208a', np.nanmax))


    
df2 = enaho_20_02.groupby( [ "conglome", "vivienda", "hogar" ],
                          as_index = False ).agg( edad_max = ( 'p208a', np.max ))


# Los resultados son iguales pues la columna edad no presenta missings 

# Si queremos que la edad maxima del hogar sea dato de cada miembro del hogar

enaho_20_02["edad_maxima_hogar"] = enaho_20_02.groupby(
    [ "conglome", "vivienda", "hogar"])['p208a'].transform(np.nanmax)

# Merge Sumaria (modulo 34)


enaho_pension = pd.merge(df2,enaho_20_34, on =["conglome", "vivienda", "hogar"],
                         how = "left", validate = "1:1")

# Usamos numpy where con la condición de maxima edad mayor a 65 y hogar pobre (1: pobre extremo, 2 :pobre)

enaho_pension['hogar_benf_pen'] = np.where( 
    (enaho_pension['edad_max'] >=65) & (enaho_pension['pobreza'].isin([1,2]))
    , 1,0)
    
# Reemplazamos missing si edad_max o pobreza tiene missings 

# enaho_pension[['edad_max','pobreza']].isnull().any(axis=1) si alguna variable es missing 
# entonces reemplaza missing np.nan en la observación correspondiente 

enaho_pension['hogar_benf_pen'].mask(
    enaho_pension[['edad_max','pobreza']].isnull().any(axis=1), np.nan, inplace=True)

# Observamos el total de hogarares a focalizar por el programa Pension 65

enaho_pension['hogar_benf_pen'].value_counts()































