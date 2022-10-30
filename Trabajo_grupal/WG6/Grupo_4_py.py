# -*- coding: utf-8 -*-
"""
###############################################################################
#                                                                             #
#                             WG#6 - Grupo 4                                  #
#                                                                             #
###############################################################################

Integrantes:
    
    Luana Morales
    Seidy Ascensios
    Marcela Quintero
    Flavia Oré
    
"""

#%% Pregunta 1 y 2 (Merge dataset Y Salario por hora del trabajador dependiente)


!pip install weightedcalcs
import os   # for usernanme y set direcotrio
import pandas as pd
import numpy as np
import weightedcalcs as wc # ponderador
from tqdm import tqdm  # controlar el tiempo en un loop

"1) Set Directorio"

user = os.getlogin()   # Username


os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG6") # Set directorio



"ENAHO 2020"

"2) Load dataset de ENAHO"



enaho_2020 = pd.read_stata(r"../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta")


enaho01 = pd.read_stata(r"../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False)


labels01 = pd.read_stata(r"../../../../enaho/2020/737-Modulo01/737-Modulo01/enaho01-2020-100.dta",
                           convert_categoricals=False, iterator=True)




enaho34 = pd.read_stata(r"../../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)


labels34 = pd.read_stata(r"../../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False, iterator=True)




"4) Merge section"

"Left merge"

#enaho34: master data
#enaho01: using data

enaho_merge_2020 = pd.merge(enaho34, enaho01,
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       validate = "m:1")
                       suffixes=('', '_y'),
)

index_columns = np.where( merge_base_2020.columns.str.contains('_y$', regex=True))[0]

merge_base_2020.drop(merge_base_2020.columns[index_columns], axis = 1, inplace = True)


"ENAHO 2019"

enaho_2019 = pd.read_stata(r"../../../../enaho/2019/737-Modulo01/737-Modulo01/enaho01-2019-100.dta")


enaho01_1 = pd.read_stata(r"../../../../enaho/2019/737-Modulo01/737-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False)


labels01_1 = pd.read_stata(r"../../../../enaho/2019/737-Modulo01/737-Modulo01/enaho01-2019-100.dta",
                           convert_categoricals=False, iterator=True)




enaho34_1 = pd.read_stata(r"../../../../enaho/2019/737-Modulo34/737-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False)


labels34_1 = pd.read_stata(r"../../../../enaho/2019/737-Modulo34/737-Modulo34/sumaria-2019.dta",
                           convert_categoricals=False, iterator=True)

"4) Merge section"

"Left merge"

#enaho34_1: master data
#enaho01_1: using data

enaho_merge_2019 = pd.merge(enaho34_1, enaho01_1,
                       on = ["conglome", "vivienda", "hogar"],
                       how = "left", 
                       validate = "m:1")
                       suffixes=('', '_y'),
)

index_columns = np.where( merge_base_2019.columns.str.contains('_y$', regex=True))[0]

merge_base_2019.drop(merge_base_2019.columns[index_columns], axis = 1, inplace = True)


# Append


merge_append = merge_base_2020.append(merge_base_2019, ignore_index = True)

merge_append['dpto'] = merge_append['ubigeo'].str[:2]

#ignore_index= True : no haya conflictos de indexing 

merge_append.to_stata("append_enaho.dta", write_index = False)

# Deflactar

deflactores_base2020_new = pd.read_stata(r"../../../../enaho/2020/737-Modulo34/737-Modulo34/ConstVarGasto-Metodologia actualizada/Gasto2020/Bases/deflactores_base2020_new.dta",
                           convert_categoricals=False)


"4) Merge section deflactores"


# merge usando como llaves a las variables dpto y aniorec. 
#merge_append: master data
#deflactores_base2020_new: using data

merge_append_deflac = pd.merge(merge_append, deflactores_base2020_new,
                       on = ["dpto", "aNo"],
                       how = "left", 
                       validate = "m:1")


merge_append_deflac["ingreso_month"] = merge_append_deflac["inghog1d"]/(12*merge_append_deflac["mieperho"]*merge_append_deflac[ld]*merge_append_deflac[i00])

merge_append_deflac["gasto_month"]  = merge_append_deflac["gashog2d"]/(12*merge_append_deflac["mieperho"]*merge_append_deflac[ld]*merge_append_deflac[i00])

#%% Pregunta 3 - Group by

#Importamos los programas necesarios 

import pandas as pd
from pandas import DataFrame,Series
import numpy as np
import weightedcalcs as wc 
from tqdm import tqdm
import re 
import os  

# Seteamos el directorio

os.chdir(f"C:/Users/Marcela Quintero/Documents/GitHub/1ECO35_2022_2/Lab7")

#Leemos la base de datos

enaho_2 = pd.read_stata(r"../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta", convert_categoricals=False)

#Vemos la base de datos

enaho_2


#Vemos los labels antes de realizar el groupby

labels2 = pd.read_stata(r"../../../enaho/2020/737-Modulo02/737-Modulo02/enaho01-2020-200.dta",
                           convert_categoricals=False, iterator=True)

labels2.variable_labels()

labels2.value_labels().keys()

enaho_2.keys()


#Utilizamos group by para seleccionar la mayor edad de cada hogar


hogares =  enaho_2.groupby(['conglome','vivienda','hogar'],as_index=False).p208a.max()


print(hogares)


#Hacemos un merge con el módulo 34 para obtener los datos que nos faltan (pobreza)

#Para ello primero cargamos la base de datos (módulo 34) y obtenemos sus labels

enaho34 = pd.read_stata(r"../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False)

labels34 = pd.read_stata(r"../../../enaho/2020/737-Modulo34/737-Modulo34/sumaria-2020.dta",
                           convert_categoricals=False, iterator=True)

labels34.variable_labels()

labels34.value_labels().keys()

enaho34.keys()


#Ahora filtramos la base con groupby para quedarnos solo con lo que necesitamos (el estado de pobreza)

hogares34 =  enaho34.groupby(['conglome','vivienda','hogar'],as_index=False).pobreza.sum()

print (hogares34)


#Ahora, procedemos a realizar el merge entre hogares y hogares 34

enaho_merge = pd.merge(hogares, hogares34, 
                         on = ["conglome", "vivienda", "hogar"],
                       how = "inner", 
                       validate = "1:1")

print (enaho_merge)


#Procedemos a crear la dummy que verifica si el hogar es pobre y cuenta con algún miembro del hogar mayor a 65 años.

enaho_merge['dummy_pension'] = (enaho_merge['p208a'] >= 65) & (enaho_merge['pobreza'] < 3)


#VIsualizamos la dummy que es true si se cumplen ambas condiciones y false si no se cumplen

print(enaho_merge['dummy_pension'])









