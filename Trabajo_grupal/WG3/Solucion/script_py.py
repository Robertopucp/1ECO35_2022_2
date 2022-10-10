# -*- coding: utf-8 -*-
"""

@author: Roberto
"""


import os # for usernanme y set direcotrio
import pandas as pd
import numpy as np


user = os.getlogin()   # Username

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG3/Solucion") # Set directorio



# a. cargamos la base de datos excel


junin_data = pd.read_excel(r"../../../data/Region_Junin.xlsx")


#1. nombre de las variables 

junin_data.columns


# 2. Tipo de variables y principales estadísticos

junin_data.info() 


junin_data.describe() 


# 3. Verificar si las columnas presenta missing values

# cantidad de missing values por cada variable 

junin_data.isna().sum()



# 4. Cambio de nombre de las variables 

junin_data.rename(columns = {'Place':'comunidad','men_not_read': 'homxlee', 
                  'women_not_read':'mujerxlee', 'total_not_read':'totalxlee'}, inplace = True)


# 5. Valores unicos de las vriables comunidad y district

junin_data['comunidad'].unique()


junin_data['District'].unique()


# 6. Variables porcentuales

junin_data['var1'] = (junin_data['mujerxlee']/junin_data['totalxlee'])*100


junin_data['var2'] = (junin_data['homxlee']/junin_data['totalxlee'])*100


# \ permite continuar un codigo extendo en lineas diferentes

junin_data['var3'] = (junin_data['natives']/(junin_data['peruvian_men']+junin_data['peruvian_women']\
                            +junin_data['foreign_men']))*100


# 7. creear base de datos


junin_data = junin_data[ junin_data["District"].isin(["Ciudad del Cerro",
                                                      "Jauja", "Acolla", "San Gerónimo", 
                                                      "Tarma", "Oroya" , "Concepción"])] 




junin_data = junin_data[(junin_data.natives > 0) & (junin_data.mestizos > 0)]


junin_data.to_csv("../../../data/data.csv")



# Reescalar vector y matriz 


def escalar(x):
    out = (x - min(x))/(max(x)-min(x))
    return out


list( map(lambda x: escalar(x),
          np.arange(50)) )



matrix = np.random.randint(1,1000, 5000).reshape(100,50)

np.apply_along_axis(lambda x: (x-x.min())/(x.max() - x.min()), 0, matrix)


# 3. Keywords en python 


def keywords( *list_vars, **kwargs):
    
    
    if ( kwargs[ 'function' ] == "escalar" ) :
        
        # Get the first value
        
        
        result = list( map(lambda x: escalar(x),
                  list_vars) )
        
    
    elif ( kwargs[ 'function' ] == "estandarizar" ) :

        result = list( map(lambda x: (x - np.mean(x))/np.std(x), list_vars))
        
    else:
        raise ValueError( f"La función {kwargs[ 'function' ]} no se identifica." )
        
        # Mensaje de error por tipo de argumento

    return result




keywords( np.arange(10), function = "estandarizar")



keywords( np.arange(10), function = "escalar")





















































