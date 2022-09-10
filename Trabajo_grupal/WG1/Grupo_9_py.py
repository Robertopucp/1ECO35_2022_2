# -*- coding: utf-8 -*-
"""
Trabajo Grupal_9

"""
#Importar galerias
import numpy as np
import pandas as pd
import random
from scipy.stats import t

#1.############################################################################
def function1(x):
    for i in x:
        if i in range(0,101):
            print(np.sqrt(i))
        
        elif i in range(101,301):
            print(i-5)
            
        elif i >300:   
            print(50)    

#generar vector con numeros del 0 a 500 y con talla del vector de 20 datos
A=np.random.randint(0,501,20)   
#aplicar la funcion creada
function1(A)


#2.############################################################################
def fescalar(M: np.ndarray,est = True): #condicionar a que sea vector o matriz
  
    if not isinstance( M , np.ndarray ) :      
        raise TypeError( "Error: el tipo de variable no es un vector o matriz.")
    
    elif est is False:
        
        Z = np.zeros((M.shape[0], M.shape[1]))
        for i in range(M.shape[1]):
            a = np.ndarray.min(M[:,i])
            b = np.ndarray.max(M[:,i])
            Z[:,i] = np.around((M[:,i]-a)/(b-a),2)

        return Z
    
    elif est is True:
        Z = np.zeros(M.shape[0])
        for i in range(M.shape[0]):
            a = np.ndarray.min(M)
            b = np.ndarray.max(M)
            Z[i] = round((M[i]-a)/(b-a),2)
        
        return Z


#Caso matriz:
B=np.random.randint(1,100, size=(100,50))
print(fescalar(B, est=False))

#Caso vector:
C=np.random.randint(1,101,100)
print(fescalar(C, est=True))



#3.############################################################################
#Y, Proceso generador de datos con 5 variables (1 + x1 + x2 + x3 + x4 )

np.random.seed(170)   #semilla

x1 = np.random.rand(10000)    #uniforme distribucion
x2 = np.random.rand(10000)  
x3 = np.random.rand(10000)  
x4 = np.random.rand(10000) 
x5 = np.random.rand(10000)  
e = np.random.normal(0,1,10000) # normal distribution


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4  + e
print(Y.size)  #10 mil observaciones

#Informacion omitiendo una variable x4
mat = np.column_stack((Y, np.ones(10000),x1,x2,x3)) 

muestra = (10, 50, 80 , 120 , 200, 500, 800, 1000, 5000)

for m in muestra:
    
    elegidos=random.sample(range(10000), m)     #vector de indices de las posiciones de las observaciones elegidos en la muestra
    observ= mat[elegidos,:]                     #matriz con observaciones elegidas
   
    #vector de X
    X = observ[:,1:] 
    #vector de Y
    Y = observ[:,0]                             
    
    #1. Construir beta
    beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
    beta

    #2. Error estandar
    y_est =  X @ beta                                                        #2.b. Y estimado = vector 
        
    n  = X.shape[0]                                                          #2.c. numero de observaciones
        
    k  = X.shape[1] - 1                                                      #2.d. x - unos
        
    nk = n - k                                                               #2.e. grados de libertad
        
    sigma2 =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk           #2.f. SCR/ (n-k) = e'e /(n-k) = s^2 =sigma^2
        
    Var   = sigma2*np.linalg.inv(X.T @ X)                                     #2.g. Var_Cov(betas) = s^2 * (X'X)-1
    
    sd    = np.sqrt( np.diag(Var) )                                          #2.h. desv(betas)=var(betas)^(1/2)

    #3. Tamano de la muestra m
    tamano=np.ones(len(beta))*m                                              # se crea vector para colocarlo en la tabla
    
    
    df    = pd.DataFrame( {"Muestra_tamano": tamano, "OLS": beta , "standar_error" : sd })  
    print(df)

#4.
# Y, proceso generador de datos con 8 variables 

np.random.seed(170)

x1 = np.random.rand(800)  
x2 = np.random.rand(800)  
x3 = np.random.rand(800)  
x4 = np.random.rand(800) 
x5 = np.random.rand(800)  
x6 = np.random.rand(800) 
x7 = np.random.rand(800) 
e = np.random.normal(0,1,800) # normal distribution

Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 2*x5 + 3*x6 + 1.5*x7 + e
print(Y.size)   #800 observaciones

X = np.column_stack((np.ones(800),x1,x2,x3,x4,x5,x6,x7))
X

#1. Definir funcion          
    #Incluye,
        #argumento de que incluye intercepto por default
        #argumento de heterocedasticidad     (es homocedastico por default)
        
def ols(M,Y, inter=True, homo=True):
    
#2. Estimaciones
    #Beta
    beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )                             #2.a. estimar beta
        
    y_est =  X @ beta                                                        #2.b. Y estimado  y Y media
    y_mean=np.mean(Y) 
    
    n  = X.shape[0]                                                          #2.c. numero de observaciones
    k  = X.shape[1] - 1                                                      #2.d. numeros de x - unos 
    nk = n - k                                                               #2.e. grados de libertad
    
    ee= list( map( lambda x: x**2 , Y - y_est))                              #2.f. Vector de residuos^2
        
    SCR =  sum(ee)                                                           #2.g. Sumatoria Cuadrado de Residuos
    SCT =  sum(list( map( lambda x: x**2 , Y - y_mean)))                     #2.h. Sumatoria Cuadrados Totales
    
    # Root-MSE    
    root_mse = np.sqrt(SCR/ n)                                          
    
    # R cuadrado
    R_cuadrado = 1- SCR/SCT
    
    diccionario   = {'R2': R_cuadrado ,'Rootmse': root_mse  }
        
    if inter and homo: 
        
        sigma2 =  SCR / nk                                                    #2.f. SCR/ (n-k) = e'e /(n-k) = s^2
        
        Var   = sigma2*np.linalg.inv(X.T @ X)                                 #2.g. Var_Cov(betas) = s^2 * (X'X)-1
      
        sd    = np.sqrt( np.diag(Var) )                                       #2.h. desv(betas)=var(betas)^1/2 , solo diag
                                                                                        
        t_est = np.absolute(beta/sd)                                          #2.i. t_est = |beta-0|/sd ==> para cada beta 
        
        pvalue= (1 - t.cdf(t_est, df=nk) ) * 2                                #2.j. p_value ==> para cada beta
     
        superior= beta + 1.96 * sd                                            #2.h. límites 
        inferior= beta - 1.96 * sd
        
        df = pd.DataFrame( {"Estimacion_OLS": beta , "standar_error" : sd , "Pvalue" : pvalue, "Limit_sup": superior, "Limit_inf": inferior}) 
      
    elif inter and (homo is False):   

        White= np.eye(n)*ee                                                      #2.a. Matriz de corrección de White
        
        VarCorg=np.linalg.inv(X.T @ X) @ X.T @White @ X @ np.linalg.inv(X.T@X)   #2.g. Var_Cov(betas) corregida             
        
        sd    = np.sqrt( np.diag(VarCorg) )                                      #2.h. desv(betas)=var(betas)^1/2 , solo diag
                                                                                        
        t_est = np.absolute(beta/sd)                                             #2.i. t_est =|beta-0|/sd ==> para cada beta 
        
        pvalue= (1 - t.cdf(t_est, df=nk) ) * 2                                   #2.j. p_value ==> para cada beta
     
        superior= beta + 1.96 * sd                                               #2.h limites
        inferior= beta - 1.96 * sd
        
        df = pd.DataFrame( {"Estimacion_OLS": beta , "standar_error" : sd , "Pvalue" : pvalue, "Limit_sup": superior, "Limit_inf": inferior}) 
      
    print(df, "\n", diccionario)
    
 
    
#Caso homocedastico
ols(X,Y)

#Caso heterocedastico
ols(X,Y,homo=False)             
#Cuando hay heterocedasticidad, la varianza modificada afecta el error estandar, pvalue, limites.
#No cambia los R2 y Rootmse pues solo explican como los betas estimados ajustan la linea de regresion, 
#y con la matriz de white los betas no han cambiado.









