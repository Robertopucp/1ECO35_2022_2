
"""
Ejercicio 1 

"""

import random
import numpy as np



# Definimos las 3 funciones del ejercicio
def f1(x):
    return x**(0.5)

def f2(x):
    return x-5

def f3(x):
    return 50


# Se crea vector aleatorio con 20 números del 0 a 500
a= np.random.randint(0,500,20)

#Resolvemos las ecuaciones con el vector poniendo condicionales dado el rango

for i in range(0,20):
    if a[i] <=100:
        print(" función 1:")
        print(f1(i))
    
    if a[i]<=300:
        print(" función 2:")
        print(f2(i))
        
    else:
       print(" función 3:")
       print(f3(i))
       