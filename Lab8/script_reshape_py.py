# -*- coding: utf-8 -*-
"""

@author: Roberto
"""

import pandas as pd
import numpy as np
import chardet # to get string character format 
import re
import os # for usernanme y set direcotrio

# Subimos la base de datos


user = os.getlogin()   # Username

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab8") # Set directorio

panel = pd.read_stata("../../../datos/panel/743-Modulo1478/sumaria-2016-2020-panelf.dta")



panel.columns = map(str.lower, panel.columns)  # any capittal letter to lower


panel.rename(columns = {'año_16':'year_16', 'año_17':'year_17', 'año_18':'year_18', 'año_19':'year_19',
                       'año_20':'year_20'}, inplace = True)

# rename hogar_16 to build a identifier per household 

panel.rename(columns = {'hogar_16':'hogar'}, inplace = True)

panel.rename(columns = {'conglome':'cong', 'vivienda':'viv', 'hogar':'hog'}, inplace = True)

print( list(panel.columns) )


## 1.0 Substract letters an number, but not special characters 

filter_list = list( map( lambda x: re.sub('.{3}$',"", x) , list(panel.columns))   )
    
# drop duplicates in a list

new_list = list(dict.fromkeys(filter_list))

new_list = new_list[2::] # keep interest variables 


## Reshape Wide to long 


reshape_panel = pd.wide_to_long(panel, stubnames = new_list, i = ['cong', 'viv', 'hog'] , j = 'period' , sep = '_').reset_index()


reshape_panel