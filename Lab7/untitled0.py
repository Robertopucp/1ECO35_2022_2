# -*- coding: utf-8 -*-
"""
Created on Sat Sep 24 

@author: Roberto

@script: Clean ENAHO
"""


import os # for usernanme y set direcotrio
import pandas as pd
import numpy as np

user = os.getlogin()   # Username


os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab7") # Set directorio

# Set directorio
#%% Merge 



" Read Stata dataset usando pandas"

"Se puede observar que pandas lee las etiquetas de las valores de cada variables"

enaho_2020 = pd.read_stata(r"../../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

"Debemos colocar convert_categoricals=False. Esto por deafult es True" 

enaho01 = pd.read_stata(r"../../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False)


labels01 = pd.read_stata(r"../../../datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False, iterator=True)


labels01.variable_labels()

labels01.value_labels().keys()

labels01.value_labels()['p110']


#identificador por miembro del hogar: conglome, vivienda, hogar, codperso

"Elegimos la base de datos como Master Data: módulo 02: características de los miembros del hogar"

enaho02 = pd.read_stata(r"../../../datos/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta",
                           convert_categoricals=False)

"Hacemos merge con el resto de base módulos (using data)"

"Presenta información de coordenadas"

enaho03 = pd.read_stata(r"../../../datos/2020/737-Modulo03/737-Modulo03/enaho01a-2020-300.dta",
                           convert_categoricals=False)


enaho04 = pd.read_stata(r"../../../datos/2020/737-Modulo04/737-Modulo04/enaho01a-2020-400.dta",
                           convert_categoricals=False)


enaho05 = pd.read_stata(r"../../../datos/2020/737-Modulo05/737-Modulo05/enaho01a-2020-500.dta",
                           convert_categoricals=False)

enaho34 = pd.read_stata(r"../../../datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)


enaho37 = pd.read_stata(r"../../../datos/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta",
                           convert_categoricals=False)

# labels

labels37 = pd.read_stata(r"../../../datos/2020/737-Modulo37/737-Modulo37/enaho01-2020-700.dta",
                           convert_categoricals=False, iterator=True)

labels37.variable_labels()


# identificador por hogar: conglome, vivienda, hogar

enaho_merge = pd.merge(enaho02, enaho01,
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       validate = "m:1")


enaho_merge['latitud'].isna().sum()

# enaho02: base de datos con información de miembros del hogar
# enaho01: base de datos a nivel de hoagres
# on: variable que permite identificar las observaciones en común en las bases de datos
# how: cómo se realizará el merge
# validate: modo de unificar las bases de datos. 

#cols_to_use = enaho02.columns.difference(enaho01.columns)

enaho_merge = pd.merge(enaho02, enaho01,
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       validate = "m:1", suffixes=('', '_y'))

# suffixes: renombrar las variables comunes en las bases de datos 

# merge que selecciona las variables en el using data

enaho_merge_2 = pd.merge(enaho02, enaho01[["conglome", "vivienda", "hogar",'longitud','latitud']],
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       validate = "m:1")

#%% Tipos de Merge


# output basico de STATA (_merge =1) Keepus Master

enaho_merge_left = pd.merge(enaho01, enaho37, 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       validate = "1:1")

# output basico de STATA (_merge =2) Keepus using

enaho_merge_right = pd.merge(enaho01, enaho37, 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "right", 
                       validate = "1:1")


# output basico de STATA (_merge =3)

enaho_merge_inner = pd.merge(enaho01, enaho37, 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "inner", 
                       validate = "1:1")

enaho_merge_outer = pd.merge(enaho01, enaho37, 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "outer", 
                       validate = "1:1")

datos= np.array([enaho_merge_left.shape[0], 
          enaho_merge_right.shape[0],
          enaho_merge_inner.shape[0],
          enaho_merge_outer.shape[0],          
          ])

pd.DataFrame(index = ['Left','Right','Inner','Outer'],
             data = datos, columns = ["observaciones"]
             )

# 

# output basico de STATA (_merge = 1,2,3)

enaho_merge_3 = pd.merge(enaho01, enaho37, 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "outer", 
                       validate = "1:1")

enaho_merge_3.shape


## merge con dataset a nivel hogar enaho01, enaho34, enaho37


num = ["34","37"]

merge_hog = enaho01

for i in num:
    merge_hog = pd.merge(merge_hog, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")


#merge using individual dataset

#%% Merge using different Key variables 

enaho03.rename(columns={"conglome":"cong", "vivienda":"viv", "hogar":"hog","codperso":"perso"}, 
               inplace = True)

merge_1 = pd.merge(enaho02, enaho03, 
                         left_on = ["conglome", "vivienda", "hogar","codperso"],
                         right_on = ["cong","viv","hog","perso"],
                       how = "left", 
                       validate = "1:1")

enaho03.rename(columns={"cong":"conglome", "viv":"vivienda", "hog":"hogar","perso":"codperso"}, 
               inplace = True)


# Merge a nivel miembros del hogar

num = ["03","04","05"]
merge_ind = enaho02

for i in num:
    merge_id = pd.merge(merge_ind, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar","codperso"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")

# Merge hogares e individuos 

merge_base_2020 = merge_id.merge(merge_hog, 
                            on = ["conglome", "vivienda", "hogar"],
                            how = "left",
                            validate = "m:1",
                            suffixes=('', '_y'),
                            )

## Filter ##

index_columns = np.where( merge_base_2020.columns.str.contains('_y$', regex=True))[0]

merge_base_2020.drop(merge_base_2020.columns[index_columns], axis = 1, inplace = True)


###########################################
############# Merge 2020 ##################
###########################################

enaho01 = pd.read_stata(r"../../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False)

enaho02 = pd.read_stata(r"../../../datos/2019/687-Modulo02/687-Modulo02/enaho01-2019-200.dta",
                           convert_categoricals=False)
 
enaho03 = pd.read_stata(r"../../../datos/2019/687-Modulo03/687-Modulo03/enaho01a-2019-300.dta",
                           convert_categoricals=False)

enaho04 = pd.read_stata(r"../../../datos/2019/687-Modulo04/687-Modulo04/enaho01a-2019-400.dta",
                           convert_categoricals=False)


enaho05 = pd.read_stata(r"../../../datos/2019/687-Modulo05/687-Modulo05/enaho01a-2019-500.dta",
                           convert_categoricals=False)

enaho34 = pd.read_stata(r"../../../datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False)


enaho37 = pd.read_stata(r"../../../datos/2019/687-Modulo37/687-Modulo37/enaho01-2019-700.dta",
                           convert_categoricals=False)


enaho02 = enaho02[["conglome", "vivienda", "hogar" , "codperso",
                  "ubigeo", "dominio" ,"estrato" ,"p208a", "p209",
                  "p207", "p203", "p201p" , "p204",  "facpob07"]]

enaho03 = enaho03[["conglome", "vivienda", "hogar" , "codperso",
                  "p301a", "p301b", "p301c" , "p300a"]]


enaho05 = enaho05[["conglome", "vivienda", "hogar" , "codperso",
                  "i524e1", "i538e1", "p558a5" , "i513t", "i518",
                  "p507", "p511a", "p512b", "p513a1", "p505" , "p506", "d544t", "d556t1",
                  "d556t2" , "d557t" , "d558t" , "ocu500" , "i530a" , "i541a"]]

num = ["34","37"]

merge_hog = enaho01

for i in num:
    merge_hog = pd.merge(merge_hog, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")
    

num = ["03","04","05"]
merge_ind = enaho02

for i in num:
    merge_id = pd.merge(merge_ind, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar","codperso"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")

# Merge hogares e individuos 

merge_base_2020 = merge_id.merge(merge_hog, 
                            on = ["conglome", "vivienda", "hogar"],
                            how = "left",
                            validate = "m:1",
                            suffixes=('', '_y'),
                            )

## Filter ##

index_columns = np.where( merge_base_2020.columns.str.contains('_y$', regex=True))[0]

merge_base_2020.drop(merge_base_2020.columns[index_columns], axis = 1, inplace = True)

###########################################
############# Merge 2019 ##################
###########################################

enaho01 = pd.read_stata(r"../../../datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False)

enaho02 = pd.read_stata(r"../../../datos/2019/687-Modulo02/687-Modulo02/enaho01-2019-200.dta",
                           convert_categoricals=False)
 
enaho03 = pd.read_stata(r"../../../datos/2019/687-Modulo03/687-Modulo03/enaho01a-2019-300.dta",
                           convert_categoricals=False)

enaho04 = pd.read_stata(r"../../../datos/2019/687-Modulo04/687-Modulo04/enaho01a-2019-400.dta",
                           convert_categoricals=False)


enaho05 = pd.read_stata(r"../../../datos/2019/687-Modulo05/687-Modulo05/enaho01a-2019-500.dta",
                           convert_categoricals=False)

enaho34 = pd.read_stata(r"../../../datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False)


enaho37 = pd.read_stata(r"../../../datos/2019/687-Modulo37/687-Modulo37/enaho01-2019-700.dta",
                           convert_categoricals=False)




enaho02 = enaho02[["conglome", "vivienda", "hogar" , "codperso",
                  "ubigeo", "dominio" ,"estrato" ,"p208a", "p209",
                  "p207", "p203", "p201p" , "p204",  "facpob07"]]

enaho03 = enaho03[["conglome", "vivienda", "hogar" , "codperso",
                  "p301a", "p301b", "p301c" , "p300a"]]


enaho05 = enaho05[["conglome", "vivienda", "hogar" , "codperso",
                  "i524e1", "i538e1", "p558a5" , "i513t", "i518",
                  "p507", "p511a", "p512b", "p513a1", "p505" , "p506", "d544t", "d556t1",
                  "d556t2" , "d557t" , "d558t" , "ocu500" , "i530a" , "i541a"]]

num = ["34","37"]

merge_hog = enaho01

for i in num:
    merge_hog = pd.merge(merge_hog, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")

num = ["03","04","05"]
merge_ind = enaho02

for i in num:
    merge_id = pd.merge(merge_ind, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar","codperso"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")

# Merge hogares e individuos 

merge_base_2019 = merge_id.merge(merge_hog, 
                            on = ["conglome", "vivienda", "hogar"],
                            how = "left",
                            validate = "m:1",
                            suffixes=('', '_y'),
                            )

index_columns = np.where( merge_base_2019.columns.str.contains('_y$', regex=True))[0]

merge_base_2019.drop(merge_base_2019.columns[index_columns], axis = 1, inplace = True)


# Ubigeo de provincia 


merge_base_2019['ubigeo_pr'] = merge_base_2019['ubigeo'].str[:2]


merge_base_2019['ubigeo_pr_2'] = merge_base_2019['ubigeo'].str[:2] + "00"


merge_base_2020['ubigeo_pr'] = merge_base_2020['ubigeo'].str[:2]

# merge_base_2019 = merge_base_2019[merge_base_2019.ubigeo_pr == "15"]
# merge_base_2020 = merge_base_2020[merge_base_2020.ubigeo_pr == "15"]




#%% Append


merge_append = merge_base_2020.append(merge_base_2019,  ignore_index= True)

merge_append.to_stata("../data/append_enaho.dta", write_index=False)












































































"References: "

# https://pandas.pydata.org/docs/reference/api/pandas.read_stata.html



