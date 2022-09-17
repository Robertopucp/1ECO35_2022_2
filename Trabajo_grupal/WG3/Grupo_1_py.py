#%% Grupo 1. Miembros del grupo:

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Egusquiza 
# 20163377, Jean Niño de Guzmán

#%% Pregunta 1

## 1.1

#Se importan las librerias necesarias para el código y se le da algunos alias (para facilitar el tipeo)
import numpy as np
import pandas as pd
import os 
import random as rd

#Se extrae el usuario para posteriormente pegarlo en el nuevo directorio de la base de datos y pueda correr a cualquier persona con acceso al repositorio del curso.
user = os.getlogin()   
##Se setea un directorio para que se cargue la base de datos desde el repositorio del curso y se utilice el usuario de la PC en donde se corra el código.
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data") 

#Se indica que se extraiga la base de datos "Region_Junin" 
data = pd.read_excel("../data/Region_Junin.xlsx")

#NOMBRES DE VARIABLES
#Se crea una lista con los nombres de los valores del dataframe
#Se indica que se impriman los nombres de las variables de cada columna
a = data.columns.values
print(a)

## 1.2

#TIPOS DE LAS VARIABLES
#Se indinca que se impriman los tipos de cada variable.
print(data.dtypes)

#ESTADISTICAS
#Se crea la matriz con las estadisticas de cada variable (se indica esto con el all)
stats = data.describe(include = 'all')
print(stats)


## 1.3

# Para detectar qué valores son Nan aplicamos .isnull o .isna
null = data.isnull()
# Imprime true cuando hay missing values
null  

# Para contar el número de missing values, tanto de filas como columnas
data1 = data.isnull().sum().sum()
# Imprimimos el resultado de sumar los Nan 
print(data1) 

# Borramos todas las filas o columnas con missing values
# Utilizamos inplace=True para que los valores se guarden en la base de datos original 
data.dropna(inplace=True) 

# Corroboramos que ya no hay más missing values
data.isnull().sum().sum()


## 1.4

# Renombramos los nombres de las variables solicitadas 
# Guardamos los cambios en la base de datos original con inplace=True
data.rename(columns={'Place': 'comunidad', 'men_not_read':'homxlee', 'women_not_read':'mujerxlee', 'total_not_read':'totalxlee'}, inplace=True)
data


## 1.5

# Se muestra los valores únicos de las 2 variables solicitadas
# Valores únicos de la var. 'comunidad'
# Referenciamos a la última base de datos modificada: 'data'
print(data.comunidad.unique())

# Valores únicos de la var. 'District'
# Referenciamos a la última base de datos modificada: 'data'
print(data.District.unique())

## 1.6

#Crear porcentajes solicitados, usando las variables del dataframe
porct_mujxlee = (data.mujerxlee)/(data.totalxlee)
porct_mujxlee =pd.DataFrame(porct_mujxlee)
 
porct_hmxlee = (data.homxlee)/(data.totalxlee)
porct_hmxlee =pd.DataFrame(porct_hmxlee)

total_pob = (data.peruvian_men)+(data.peruvian_women)+(data.foreign_men)+(data.foreign_women)
porct_nativos = (data.natives)/total_pob
porct_hmxlee =pd.DataFrame(porct_nativos)

# Añadimos las nuevas variabes a la base de datos
data= pd.concat([data,porct_mujxlee,porct_hmxlee,porct_nativos], axis=1)
print(data)

## 1.7

#a, Filtro solamente de acuerdo a esos valores, que he colocado en la lista Distritos.
Distritos = ["CIUDAD DEL CERRO","JAUJA", "ACOLLA", "SAN GERÓNIMO", "TARMA", "OROYA", "CONCEPCIÓN"]
Pregunta_7_a = data.loc[data["District"].isin(Distritos)]

#b, Solo quedarme con aquellas observaciones, cuyas variables mestizo y nativos toma un valor estrictamente mayor a 0.
Pregunta_7_b = Pregunta_7_a[(Pregunta_7_a["natives"] > 0) & (Pregunta_7_a["mestizos"] > 0)]

#c, Solo quedarme con las columnas distrito y comunidad
Pregunta_7_c = Pregunta_7_b[["District", "comunidad"]]

#d, exportar en excel
Pregunta_7_c.to_excel(r'../data/Base_cleaned_WG3.xlsx', index = False, header = True)


#%% PREGUNTA 2

# Primero, crearé una matriz de 100 filas y 50 columnas. También, crearé un vector de 100 columnas.
def hacer_matriz (m, n):
    # M: # de filas
    # N: # de columnas
    vacio = np.zeros(0)
    numero_iteraciones = np.arange(m)
    for i in numero_iteraciones:
        filas = np.random.rand(n)
        vacio = np.append(vacio, [filas])
    vacio = vacio.reshape(m,n)
    return vacio
 
M = hacer_matriz(100, 50)
N = np.random.rand(100)

# La función para los vectores:         
# list() nos da la forma final de "fila" (aunque en realidad es un narray).
# Aplicamos la función .min() y .max() para obetener el máximo y mínimo valor de todo el vector. 
# Definimos estos valores previamente en los parámetros a y b.
# Luego, pasamos a hacer la reescalación, que es el objetivo de nuestra función lambda.

vector_reescalado = list(map(lambda x, a = np.min(N), b = np.max(N): (x - a)/(b - a), N))
vector_reescalado 

# Por otro lado, no sería conveniente aplicar list con las matrices porque ocurre el problema que el output se presenta de tal manera que cada observación de la lista es literalmente un vector fila completo.
# La función para la matriz:

matriz_reescalada = np.apply_along_axis(lambda x, a = np.min(M, axis=0), b = np.max(M, axis=0): (x - a)/(b - a), 1, M)
matriz_reescalada

# Con los axis = 0, dentro de np.min() y np.max(), me da el valor mínimo y máximo de cada columna.
# Con el parámetro "1" de apply_along_axis, creo que haría que la función se itere por fila. 
# En todo caso, solo le pongo el valor"1" como criterio porque funciona, pues, de lo contrario, 
# si le pusiero "0" como parámetro de apply_along_axis, es como si generara conflicto y presenta error.

""" OJO:
 Una observación interesante es que si se usa como parámetro al 0 esperando que coja las columnas, en realidad, 
 estaría haciendo la reescalación con los valores máximos y mínimos de cada fila. 
 La forma a la que me refiero sería esta: np.apply_along_axis(lambda x, a = np.min(N), b = np.max(N): (x - a)/(b - a), 0, N)

 En el caso de poner un 1, obtenemos el mismo resultado. Estaría cogiendo por filas.
 La forma a la que me refiero sería esta: np.apply_along_axis(lambda x, a = np.min(N), b = np.max(N): (x - a)/(b - a), 1, N)
"""
# Sobre esta observación, podríamos hacer la prueba a una escala pequeña.
# Mantenmos la misma estructura de la función anterior, y aplicamos a una matriz 2x3: [ [1, 2, 3], [4, 5, 6] ]
# Claramente, deberíamos esperar que el resultado sea: [[0., 0., 0.], [1., 1., 1.]]
prueba_matriz = np.array( [ [1, 2, 3], [4, 5, 6] ] )
prueba_reescalada = np.apply_along_axis(lambda x, a = np.min(prueba_matriz, axis=0), b = np.max(prueba_matriz, axis=0): (x - a)/(b - a), 1, prueba_matriz )

# Como se observa, el output es el correcto.


#%% PREGUNTA 3

# Creación de lista con los valores aleatorios a insertar en el Vector
# De 0 a 500 es el rango de valores, 100 es la cantidad de datos
b = rd.sample(range(0,500),100)     
# Se ordenan los datos de a lista de menor a mayor con el comando sort().
b.sort()                                

# Creación del vector a partir de la lista 
a = np.array(b)                    
print('Vector =', a) 

# Reescalar y estandarizar
# Definimos la función que va depender de los argumentos de args y kwargs 
def funcion( *args, **kwargs):    

# Se ponen condicionales para determinar si se escala o estandariza la el vector.
    if (kwargs[ 'funcion' ] == "escalar"):          
        vector = np.array(list(args))  
        for numero in vector:

# Cuando se quiera escalar el vector se tomaran los valores del vector aleatorio y se aplicara la función correspondiente del escalado
            print('Escalar =',(numero - np.min(vector))/(np.max(vector) - np.min(vector)))
            
    elif (kwargs[ 'funcion' ] == "estandarizar"):
        vector = np.array(list(args))  
        for numero in vector:

# Cuando se quiera estandarizar la función se tomaran los valores del vector aleatorio y se aplicará la función correspondiente de la estandarización
            print('Estandizado =',(numero - np.mean(vector))/np.std(vector))

# Verificación 
# El primer argumento hace referencia al *args y el segundo argumento hace referencia al **kwargs 
funcion(a, funcion = "escalar")
funcion(a, funcion = "estandarizar")



