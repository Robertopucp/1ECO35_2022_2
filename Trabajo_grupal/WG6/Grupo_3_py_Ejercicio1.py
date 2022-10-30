#!pip install weightedcalcs

import os   # for usernanme y set direcotrio
import pandas as pd
import numpy as np
from tqdm import tqdm  # controlar el tiempo en un loop


user = os.getlogin()

os.chdir(f"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf") # Set directorio


" AÑO 2020"

enaho_2020 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")

enaho01 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False)

labels01 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False, iterator=True)
labels01.variable_labels()

labels01.value_labels().keys()

labels01.value_labels()['p110']

"Modulo 34 Sumaria 2020"

enaho34 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)

labels34 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False, iterator=True)

labels34.variable_labels()

"Merge 01 + 34"


num = ["34"]

merge_hog2020 = enaho01

for i in tqdm(num):
    merge_hog2020 = pd.merge(merge_hog2020, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")
"AÑO 2019"
    
enaho0119 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False)

labels0119 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2019/687-Modulo01/687-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False, iterator=True)
labels0119.variable_labels()

labels0119.value_labels().keys()

labels0119.value_labels()['p110']

"Modulo 34 sumaria 2019"

enaho3419 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False)

labels3419 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2019/687-Modulo34/687-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False, iterator=True)

labels3419.variable_labels()

num = ["34"]

merge_hog2019 = enaho0119
for i in tqdm(num):
    merge_hog2019 = pd.merge(merge_hog2019, globals()[f'enaho{i}'], 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       suffixes=('', '_y'),
                       validate = "1:1")
    
"Append"
    
merge_append = merge_hog2020.append(merge_hog2019, ignore_index = True)




"INGRESO Y GASTO MENNSUAL"

merge_append["ingreso_month"] = merge_append["inghog1d"]/(12*merge_append["mieperho"])

merge_append["gasto_month"]  = merge_append["gashog2d"]/(12*merge_append["mieperho"])

"DEFLACTOR ESPACIAL Y TEMPORAL"

"ESPACIAL"
merge_append["gasto_month_defl"]  = merge_append["gasto_month"]*(merge_append["ld"])

"TEMPORAL"

deflactor = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo34/737-Modulo34/Gasto2020/Bases/deflactores_base2020_new.dta",
                           convert_categoricals=False)
num = ["34"]

merge_base = merge_append

merge_append['dpto'] = merge_append.ubigeo.str.slice(0,2)

merge_append['aniorec'] = merge_append['aÑo']

merge_append['dpto']=merge_append['dpto'].astype(int)
merge_append['aniorec']=merge_append['aniorec'].astype(int)
merge_append = merge_append.merge(deflactor, how='inner', on=None, left_on=['dpto', 'aniorec'], right_on=['dpto', 'aniorec'], left_index=False, right_index=False, sort=False, suffixes=('_x', '_y'), copy=True, indicator=False, validate=None)

"DIVIDA POR mieperho, 12, LD e i00"

merge_append["ingreso_month_def"] = merge_append["ingreso_month"]/(merge_append["mieperho"])
merge_append["ingreso_month_def2"] = merge_append["ingreso_month"]/12
merge_append["ingreso_month_def3"] = merge_append["ingreso_month"]/(merge_append["ld"])
merge_append["ingreso_month_def4"] = merge_append["ingreso_month"]/(merge_append["i00"])

merge_append["gasto_month_def"] = merge_append["gasto_month"]/(merge_append["mieperho"])
merge_append["gasto_month_def2"] = merge_append["gasto_month"]/12
merge_append["gasto_month_def3"] = merge_append["gasto_month"]/(merge_append["ld"])
merge_append["gasto_month_def4"] = merge_append["gasto_month"]/(merge_append["i00"])

print(merge_append)

"Groupby"

enaho02 = pd.read_stata(r"C:/Users/oscar/OneDrive/Desktop/PARCIAL MADATA/enahodf/datos/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta",
                           convert_categoricals=False)

groupby = enaho02.groupby(['p208a'])[['hogar']].head()