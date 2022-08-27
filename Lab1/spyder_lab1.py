# -*- coding: utf-8 -*-
"""
# Laboratorio 1 Python

##  Types of variables

@author: Roberto Mendoza
"""
#%% Types of variables

########################################################
"""
 1.0 Types of variables 
"""

a1 = 3.141
type(a1)


a2 = 3.1416165516
type(a2)

# from float to int 

c = int(a2)
type(c)

b1 = 10000
type(b1)

# from int to float 

float(b1)

b2 = 8
type(b2)

c1 = "My first python code"
print(c1)  # show that varaible's content
type(c1) # providing varaibles's type 

# including a space using \n

c1 = "First python code"
c2 = "at R y python Class"
print(c1,'\n',c2)

# join string 

print(c1 + " : " + c2)


# f-using 


print(f'{c1} : semester 2022-1')

d = 2022

print(f'{c1} : semester {d}-1')

print('{} : semester {}-1'.format(c1,d))

c1[0:5]

#first character
print('Fisrt letter is :',c1[0])

#first word
print('Fisrt word is :',c1[0:5])


#%% Bool variables 

########################################################
""" 
2. 0 Bool variables 
"""

"a" == "a"

1 > 1

z1 = (1==1)
int(z1)

z2 = (10 > 20)
int(z2)

z3 = (100 != 100)
int(z3)


#%% Tuple

########################################################
"""
 3.0 Tuple
"""

#### It is an ordered and immutable Python object

T1 = (1,4,8,10,20,15,4,5,3,8)
print(T1)
type(T1)

# aritmethic operations

print('Suma:', sum(T1),"\n", "Minimo:", min(T1), '\n', "Maximo:", max(T1))

len(T1) # lenght of tuple

"""
Indexing tuple
"""

T1[0:5] # give us elements from 0 position until 4 position 

T1[1] # get tuple's element 

T1[0:3]

# It is not possible to change
T1[0] = 4

T1[-1] # last element

#position
T1.index(8)


#%% List
"""
 4.0 List
"""

#### It is an ordered and mutable Python container.

L1 = []
print(L1)
type(L1)

dis1 = ["ATE", 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO']
dis1

dis2 = ['ATE', 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO','CHACLACAYO','CHORRILLOS','CIENEGUILLA'
        ,'COMAS','EL_AGUSTINO','INDEPENDENCIA']
print(dis2)
len(dis2)

dis2[1]

# Change elements
dis2[0] = "CALLAO"
print(dis2)

# Indexing

dis2[1]

dis2[2:5]   #(5-1=4)

dis2[-1]

dis2[-5:-1]

## sorting

num = [13,5,5,8,9,10,5,8,13,1,20]
num.sort()
print(num)

## append new elements 

num.append(102)
print(num)

## append new lists

num2 = [10,20,30]
num.extend(num2)
print(num)

print(num.index(102))

print("Suma:", sum(num),'\n', "Minimo:", min(num), '\n', "Maximo:", max(num))

#%% Diccionario
########################################################
## 5.0 Dictionarities

Postal_code = {'Majes': 40520, 'Mollendo': 40701, 'Islay': 40704, 'Cotahuasi': 40801, 'Alca': 40802 }
type(Postal_code)

Postal_code
Postal_code.keys()

# Get information from key
Postal_code['Alca']
Postal_code.get('Alca')

# Drop key
Postal_code.pop('Islay')
Postal_code

# add new elements 
Postal_code.update( { "CHARCANA" :  40803 } )

#diccioanrio dentro de otro diccionario

Postal_code.update( {"LOMAS": {"UBIGEO": 40311, "Poverty Rate" : "18.2%", "Population" : "20 mil"}})

Postal_code.get('LOMAS').get('Poverty Rate')

Postal_code['LOMAS']['Poverty Rate']

# keys
cities = ['Fray Martin','Santa Rosa de Puquio','Cuchicorral','Santiago de Punchauca','La Cruz (11 Amigos)','Cerro Cañon','Cabaña Suche','San Lorenzo','Jose Carlos Mariategui','Pascal','La Esperanza','Fundo Pancha Paula','Olfa','Rio Seco','Paraiso','El Rosario','Cerro Puquio','La Campana','Las Animas','Vetancio','Roma Alta','San Jose','San Pedro de Carabayllo','Huacoy','Fundo Pampa Libre','Ex Fundo Santa Ines','Reposo','Carmelito','Santa Elena','Don Luis','Santa Ines Parcela','Asociacion Santa Ines','Roma Baja','Residencial Santa Lucia','San Francisco','Santa Margarita - Molinos','Sipan Peru','Fundo Cuadros','Bello Horizonte','El Hueco','Ex Fundo Mariategui','Naranjito','Vista Hermosa','El Sabroso de Jose Carlos Mariategui','Granja Carabayllo','Agropecuario Valle el Chillon','Camino Real','Copacabana','El Trebol','Tablada la Virgen','San Fernando de Carabayllo','San Fernando de Copacabana','La Manzana','Chacra Grande','Torres de Copacabana','San Pedro de Carabayllo','San Lorenzo','Chaclacayo','Chorrillos','Cieneguilla','Lindero','Pichicato','San Isidro','San Vicente','Piedra Liza','Santa Rosa de Chontay (Chontay)','La Libertad','El Agustino','Independencia','Jesus Maria','La Molina','La Victoria','Lince','Las Palmeras','Chosica','Lurin','Los Almacigos','Rinconada del Puruhuay','Fundo Santa Genoveva','Los Maderos','Casco Viejo','Vista Alegre','Buena Vista Alta','Lomas Pucara','Fundo la Querencia','Magdalena del Mar','Pueblo Libre','Miraflores','Pachacamac','Puente Manchay','Tambo Inga','Pampa Flores','Manchay Alto Lote B','Invasion Cementerio','Manchay Bajo','Santa Rosa de Mal Paso','Cardal','Jatosisa','Tomina','Pucusana','Honda','Quipa','Los Pelicanos','Playa Puerto Bello','Ñaves','Granja Santa Elena','Alvatroz II','Poseidon - Lobo Varado','Playa Minka Mar','Playa Acantilado','Puente Piedra','Punta Hermosa','Capilla Lucumo','Cucuya','Pampapacta','Avicola San Cirilo de Loma Negra - 03','Avicola San Cirilo de Loma Negra - 02','Avicola San Cirilo de Loma Negra - 01','Pampa Mamay','Cerro Botija','Agricultores y Ganaderos','Pampa Malanche Avicola Puma','Punta Negra','Chancheria','Rimac','San Bartolo','Plantel 41','Granja 4','Granja 5','Granja 07','Granja 44','Granja 47','Santa Maria I','Las Torres Santa Fe','San Francisco de Borja','San Isidro','San Juan de Lurigancho','Ciudad de Dios','San Luis','Barrio Obrero Industrial','San Miguel','Santa Anita - los Ficus','Santa Maria del Mar','Don Bruno','Santa Rosa','Santiago de Surco','Surquillo','Villa el Salvador','Villa Maria del Triunfo', 'Pueblo libre']
# values
postal_code1 = [15001,15003,15004,15006,15018,15019,15046,15072,15079,15081,15082,15083,15088,15123,15004,15011,15012,15019,15022,15023,15026,15476,15479,15483,15487,15491,15494,15498,15047,15049,15063,15082,15083,15121,15122,15313,15316,15318,15319,15320,15321,15324,15320,15320,15320,15320,15320,15320,15121,15320,15320,15121,15320,15320,15121,15121,15122,15122,15121,15121,15121,15320,15320,15320,15320,15320,15320,15121,15121,15121,15320,15121,15319,15121,15121,15121,15320,15320,15121,15121,15121,15121,15320,15320,15320,15122,15122,15122,15122,15122,15122,15122,15122,15121,15121,15122,15122,15121,15121,15122,15122,15121,15122,15122,15122,15472,15476,15054,15056,15057,15058,15063,15064,15066,15067,15593,15594,15593,15593,15593,15593,15593,15593,15593,15311,15312,15313,15314,15316,15324,15326,15327,15328,15332,15003,15004,15006,15007,15008,15009,15011,15018,15022,15311,15328,15331,15332,15333,15046, 15001]

# Return a dictionarie
ct_pc = dict( zip( cities , postal_code1) )

ct_pc

#%% Numpy
########################################################
## 6.0 Numpy (array, matrices)

import numpy as np

# 1D array
a = np.array( [1, 2, 3, 4, 5] )
print(a)


np.mean(a)
np.std(a)
np.std(a,ddof=1)

# 2D array
M = np.array( [ [1, 2, 3], [4, 5, 6] ] )

print(M)
type(M)
# dimensiones
M.shape

# Create a 1D NumPy array with values from 0 to 20 (exclusively) incremented by 2:
y = np.arange( 0, 20, 2 )
print(y.shape)
print(y)

y[0]

np.array_split

# deafult one by one 

y = np.arange( 1, 11)
print(y)

np.arange(11)
range(11)

"""
Repeat elements np.repeat(number, times) , np.tile(number : vector , times)
"""

np.repeat(2, 4)
np.repeat(range(11), 4)

np.tile(np.array([1,2]), 4)
np.tile(range(11),5)

"""
Split array
"""

np.array_split(np.arange( 100, 1000),50)

"""
# Mattrix
"""

A = np.array([np.arange(0,10), np.arange(10,20), np.arange(30,40), np.arange(-20,-10), np.arange(2,21,2)])
A

A[2:5,:]  # rows selecrtion


A[:,0:6]  # columns selecrtion

M1 = np.zeros( (8, 2) )
print(M1)

M2 = np.ones( (8, 4) )
print(M2)

## Join matrix

M3 = np.hstack((M1,M2))
M3


# vstack

M4 = np.array([[2,2,3,4,5,1],[1,5,5,9,8,2]])
print(M4)

M5 = np.vstack((M3,M4))
print(M5)
M5.T

# Create a 1D NumPy array of ones of length 10:
w = np.ones(10)
print(w)
type(w)

# Create the identity matrix of size 8:
I = np.eye(8)
print(I)

# Reshape

I3 = I.reshape(32, 2)
print(I3)

#Transpose
print(I3.T)
(I3.T).shape

#%% OlS 

import random 

np.random.seed(175)

x1 = np.random.rand(500) # uniform distribution  [0,1]
x2 = np.random.rand(500) # uniform distribution [0,1]
x3 = np.random.rand(500) # uniform distribution [0,1]
x4 = np.random.rand(500) # uniform distribution [0,1]
e = np.random.normal(0,1,500) # normal distribution mean = 0 and sd = 1

# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e

X = np.column_stack((np.ones(500),x1,x2,x3,x4))
X

beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
print(beta)
