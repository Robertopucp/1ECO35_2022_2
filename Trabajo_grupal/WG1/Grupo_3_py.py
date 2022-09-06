#!/usr/bin/env python
# coding: utf-8

# In[8]:


import random

def crear_lista():
    lista=[]
    for i in range (20):
        valor=random.randint(0,500)
        lista.append(valor)
    return lista


def funcion(elemento):
    valor_funcion=0
    if 0<=elemento<=100:
        elemento=elemento**0.5
    elif elemento>100 and elemento<=300:
            elemento=elemento-5
    elif elemento>300:
            elemento=50
    valor_funcion=elemento
    return valor_funcion
    
def ejecutar_programa():
    lista=crear_lista()
    lista_resultante=[]
    for i in range(20):
        lista_resultante.append(funcion(lista[i]))
    return lista_resultante
print(ejecutar_programa())
    


# In[9]:


import random
#primero generar 100 datos aleatorios 
for i in range(1,100):
    x = random.randint(1,500);
    print(str(x) + "\t");
import numpy as np

matriz1= np.array([[1,2,3],[2,2,3]])
#luego generar matriz 100x50
import random
n = 50
m = 100
#a = n*m
matriz = []

for i in range(n):
    matriz.append([])
    for j in range(m):
        matriz[i].append(random.randint(0, 100))

print(matriz)


# In[ ]:




