#####     TRABAJO FINAL    #####
################################

##  PREGUNTA 2  ##


# Primero importamos las librerias que usaremos para este ejercicio
import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import re 
import os 



user = os.getlogin()

# Primero setearemos el directorio
os.chdir(f"C:/Users/User/Desktop/Trabajo_final")

# Definimos la primera variable que leerá los los archivos xls descargados de la base de datos de INFO-juntos
# para el caso del VRAEM y seleccionaremos la posicion cero de la base para poder espeficiarnos en la tabla a trabajar.
df1 = pd.read_html('Detalle2014.xls')
detalle_2014 = df1[0]
# Ahora eliminaremos las columnas y las filas que no usaremos para el ejerecicio con ".drop"
# A las filas restantes le cambiaremos de nombre, para luego invertir la matriz de datos a traves del
#cambio del orden de las filas con las columnas.
detalle_2014 = detalle_2014.drop( [1,2,3,4,5,6], axis=1)
detalle_2014 = detalle_2014.drop( [0,1,2,11,12,14], axis=0)
detalle_2014=detalle_2014.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2014 = detalle_2014.drop( [0], axis=1)
detalle_2014 = pd.DataFrame.transpose(detalle_2014)

# Repetiremos el proceso para cada base de datos descargada, es decir para cada año de analisis:
# 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021.

# Para 2015
df2 = pd.read_html('Detalle2015.xls')
detalle_2015 = df2[0]

detalle_2015 = detalle_2015.drop( [1,2,3,4,5,6], axis=1)
detalle_2015 = detalle_2015.drop( [0,1,2,11,12,14], axis=0)
detalle_2015=detalle_2015.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2015 = detalle_2015.drop( [0], axis=1)
detalle_2015 = pd.DataFrame.transpose(detalle_2015)

# Para 2016
df3 = pd.read_html('Detalle2016.xls')
detalle_2016 = df3[0]

detalle_2016 = detalle_2016.drop( [1,2,3,4,5,6], axis=1)
detalle_2016 = detalle_2016.drop( [0,1,2,11,12,14], axis=0)
detalle_2016=detalle_2016.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2016 = detalle_2016.drop( [0], axis=1)
detalle_2016 = pd.DataFrame.transpose(detalle_2016)

# Para 2017
df4 = pd.read_html('Detalle2017.xls')
detalle_2017 = df4[0]

detalle_2017 = detalle_2017.drop( [1,2,3,4,5,6], axis=1)
detalle_2017 = detalle_2017.drop( [0,1,2,11,12,14], axis=0)
detalle_2017=detalle_2017.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2017 = detalle_2017.drop( [0], axis=1)
detalle_2017 = pd.DataFrame.transpose(detalle_2017)

# Para 2018
df5 = pd.read_html('Detalle2018.xls')
detalle_2018 = df5[0]

detalle_2018 = detalle_2018.drop( [1,2,3,4,5,6], axis=1)
detalle_2018 = detalle_2018.drop( [0,1,2,11,12,14], axis=0)
detalle_2018=detalle_2018.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2018 = detalle_2018.drop( [0], axis=1)
detalle_2018 = pd.DataFrame.transpose(detalle_2018)

# Para 2019
df6 = pd.read_html('Detalle2019.xls')
detalle_2019 = df6[0]

detalle_2019 = detalle_2019.drop( [1,2,3,4,5,6], axis=1)
detalle_2019 = detalle_2019.drop( [0,1,2,11,12,14], axis=0)
detalle_2019=detalle_2019.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2019 = detalle_2019.drop( [0], axis=1)
detalle_2019 = pd.DataFrame.transpose(detalle_2019)

# Para 2020
df7 = pd.read_html('Detalle2020.xls')
detalle_2020 = df7[0]

detalle_2020 = detalle_2020.drop( [1,2,3,4,5,6], axis=1)
detalle_2020 = detalle_2020.drop( [0,1,2,11,12,14], axis=0)
detalle_2020=detalle_2020.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2020 = detalle_2020.drop( [0], axis=1)
detalle_2020 = pd.DataFrame.transpose(detalle_2020)

# Para 2021
df8 = pd.read_html('Detalle2021.xls')
detalle_2021 = df8[0]

detalle_2021 = detalle_2021.drop( [1,2,3,4,5,6], axis=1)
detalle_2021 = detalle_2021.drop( [0,1,2,11,12,14], axis=0)
detalle_2021=detalle_2021.rename( index={ 3:'Departamentos atendidos', 4:'Provincias Atendidas', 
                                         5:'Distritos Atendidos', 6: 'CPP con hogares afiliados', 
                                         7: 'Hogares afiliados', 8:'CCNN con hogares afiliafos', 
                                         9:'CCPP con hogares abonados', 10:'Hogares abonados', 
                                         13:'Transferencia S/'})
detalle_2021 = detalle_2021.drop( [0], axis=1)
detalle_2021 = pd.DataFrame.transpose(detalle_2021)


# Una vez especificados todos las bases para los años 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021 emplearemos
# un merge para agrupar las bases y presentarlas todas juntas en funcion al año.

## Primero agruparemos de 2 en 2.
merge1 = pd.merge(detalle_2014, detalle_2015, how = "outer")
merge2 = pd.merge(detalle_2016, detalle_2017, how = "outer")
merge3 = pd.merge(detalle_2018, detalle_2019, how = "outer")
merge4 = pd.merge(detalle_2020, detalle_2021, how = "outer")

## Luego, de los merge obtenidos, realizamos otro merge con las nuevas bases de los primeros merge.
merge5 = pd.merge(merge1, merge2, how = "outer")
merge6 = pd.merge(merge3, merge4, how = "outer")

## Por ultimo, juntaremos los merge de la segunda parte en uno solo para tener un merge final que agrupe todas las bases.
merge_total = pd.merge(merge5, merge6, how = "outer")

# Ahora crearemos una lista llamada Year que agrupará en orden desde el año 2014 al 2021.
Year = ['2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021']

# Asignamos la lista Year al merge final con todas las bases juntas.
merge_total['Year'] = Year

# Por ultimo, asignamos el nombre de Imagen2 al resultado fnal, que es la agrupacion del merge final con todas
# las bases y una nueva variable que asigne los años a la base de datos.
Imagen2 = pd.DataFrame(merge_total)

#reproducimos el resultado.
Imagen2




############### FIN ###################




