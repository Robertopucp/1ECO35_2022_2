# -*- coding: utf-8 -*-
"""
Created on Wed Sep 21 17:03:33 2022

@author: JCarlosHPCorei3
"""

import pandas as pd
import numpy as np
import pyreadr
import os # for usernanme y set direcotrio

user = os.getlogin()   # Username
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab4")
cps2012_env = pyreadr.read_r("../data/cps2012.RData")
type(cps2012_env)  #diccionario
cps2012 = cps2012_env['data'] #se puede leer en dataframe ahora

#Limpieza de base
cps2012.drop(['year'], axis=1, inplace = True )  #dropear columna de año 2012 para todos los valores
cps2012['married'] = cps2012['married'].astype('int')   #convertir bool en enteros
cps2012['ne'] = cps2012['ne'].astype('int')
cps2012['sc'] = cps2012['sc'].astype('int')
cps2012=cps2012.head(2000)

#Se pide mostrar DataFrame de variables explicativas
X = cps2012.iloc[ : , 1: ]  

#Se pide lista de valores para seleccionar 'x' de la Dataframe de variables explicativas
lista = [ 1, 5, 17,20]   #lista con valores de 0-20

#Se pide el vector de la variable Y
y = cps2012.iloc[:, 0]
y

class RegClass( object ):  # == RegClass():
    
    def __init__( self, X : pd.DataFrame , y : pd.Series , lista: list, robust = True ):
    
        if not isinstance( X, pd.DataFrame ):
            raise TypeError( "X must be a pd.DataFrame." )

        if not isinstance( y , pd.Series ):
            raise TypeError( "y must be a pd.Series." )
            
        # asignando los cuatro atributos de la clase:
        self.X = X
        self.y = y 
        self.lista = lista
        self.robust = robust
        
        # agregar columna de unos en self.X:
        self.X[ 'Intercept' ] = 1               #agrega columnas de puros 1s con nombre de intercepto 
        cols = self.X.columns.tolist()          #sale las etiquetas 
        new_cols_orders = [cols[ -1 ]] + cols[ 0:-1 ] #hace que intercepto salga 1ero
        # cols[ -1 ]: la última, sale "Intercept", cols[ 0:-1 ]: son todas las etiquetas, menos la ultima
        self.X = self.X.loc[ : , new_cols_orders ] #ahora sí con todos los datos, intercepto 1ero
        
        
        # agregar variables de x seleccionadas, y y nombres de x
        self.X_np=self.X.iloc[:,lista].values #creo q' son todas las filas y valores del # de columnas especificadas de la lista
        self.y_np=y.values.reshape(-1,1)      #lo hizo vector
        self.columns=self.X.iloc[:,lista].columns.tolist() #sale ['exp3', 'ne', 'ad', 'we']-->sera el nombre de columnas
        
    def reg_beta_OLS( self ):
        
        # reasignar nombres a atributos    
        X_np=self.X_np
        y_np=self.y_np
            
        # beta_ols
        beta_ols = np.linalg.inv( X_np.T @ X_np ) @ ( X_np.T @ y_np ) #sale en vector
        self.beta_ols=beta_ols
            
        # columnas de X
        index_names = self.columns 
            
        # Output
        beta_OLS_output = pd.DataFrame( beta_ols , index = index_names , columns = [ 'Coef.' ] ) #p/ q' ahora salga en tabla, el nombre de la columan es coef
                 
        # agregar Dataframe de coeficientes como atributo 
        self.beta_OLS_output = beta_OLS_output
        
        return beta_OLS_output
           
    def var_standar(self): 
     
        #llamar método anterior
        self.reg_beta_OLS()  
                
        #reasignar nombres a atributos del método anterior
        X_np = self.X_np
        y_np = self.y_np
        beta_OLS = self.beta_OLS_output.values.reshape(- 1, 1) # convierte dataframe en vector

        #### Operaciones ####
        e = y_np - ( X_np @ beta_OLS )             # vector de errores: error_i = Y_i - Y_estimado_i
        self.e=e

        N = X.shape[ 0 ]                           # numero de filas
        k = X.shape[ 1 ]                           # numero de columnas
        ee=(e.T @ e)[ 0 ]                          # sumatoria e^2 ... q' es [0]? si lo quitas, es vector, si pones 1 no sale
        self.ee=ee
        error_var = (ee)/( N - k )                 # s^2= e^2/(n-k)...sale vector de 1 valor

        ### 1. matriz de varianza y cov estándar  ###
        var_OLS = error_var*np.linalg.inv( X_np.T @ X_np ) # var_OLS(betas) = s^2 * (X'X)-1....sale vector 4x4 creo

        ### 2. error estandar de cada coeficiente ###
        sd = np.sqrt( np.diag(var_OLS) )           # desv(betas)=diagonal_var(betas)^(1/2)... np.diag toma la diagonal de la matriz
        self.sd=sd
                
        ### 3. intervalos de confianza ###, salen en vectores
        superior= beta_OLS.ravel() + 1.96 * sd  #ravel() lo volvio vector (de 1x4)
        self.superior=superior
        inferior= beta_OLS.ravel() - 1.96 * sd
        self.inferior=inferior

        
    def var_robust(self):
        
        #llamar a método anterior
        self.reg_beta_OLS()  
                
        #y reasignar nombres a atributos del método anterior
        X_np = self.X_np
        y_np = self.y_np
        beta_OLS = self.beta_OLS_output.values.reshape(- 1, 1) # convertir dataframe a vector

        #### Operaciones ####
        e = y_np - ( X_np @ beta_OLS )             # vector de errores: error_i = Y_i - Y_estimado_i
        self.e=e

        N = X.shape[ 0 ]                           # numero de filas
        ee=(e.T @ e)[ 0 ]                          # sumatoria e^2
        self.ee=ee

        self.w=np.eye(N)*ee          #np.eye(N): sale matris I 2000x2000 => ese ee sale en diagonal, repetido
        
        ### 1. matriz de varianza y cov robusta  ###
        var_robust=np.linalg.inv(X_np.T @ X_np) @ X_np.T @(np.eye(N)*ee) @ X_np @ np.linalg.inv(X_np.T@X_np) 
        #=(X'X)^-1 *X'I*ee*X(X'X)^-1  o (X'X)^-1 *X'w*X(X'X)^-1
        
        self.vr=var_robust                         # var_OLS(betas) = (X'X)-1* X' * White * X * (X'X)-1
                
        ### 2. error estandar de cada coeficiente ###
        sd = np.sqrt( np.diag(var_robust) )        # desv(betas)=var(betas)^(1/2)
        self.sd=sd
                
        ### 3. intervalos de confianza ###
        superior= beta_OLS.ravel() + 1.96 * sd
        self.superior=superior
        inferior= beta_OLS.ravel() - 1.96 * sd
        self.inferior=inferior

    def reg_estad(self):
        
        #llamar a método anterior
        self.reg_beta_OLS()
        
        N = self.X_np.shape[ 0 ]                    # Numero de filas
        
        y_est=self.X_np @ self.beta_ols             # fila de Y_estimados
        
        self.SCR = np.sum(np.square(self.y_np - y_est ))           # Sumatoria Cuadrado de Residuos
        
        self.SCT = np.sum(np.square(self.y_np - np.mean(y_est)))   # Sumatoria Cuadrado Totales      
           
        #### Root-MSE ####  
        root_mse = np.sqrt(self.SCT/ N)
        self.root_mse=root_mse
    
        #### R cuadrado ####  *****
        R2 = 1- self.SCR/self.SCT
        self.R2=R2
        
        fit = {"Root_MSE":root_mse, "R2": R2}     
        
        return fit
           
    def reg_OLS(self):
        
        # a. Se corren las funciones y ordenan valores para colocarlos en una tabla:
        self.reg_estad()
        self.reg_beta_OLS() 
        
             # a.1. coeficiente estimados
        beta_ols = self.beta_ols
        
        # b. Varianza de acuerdo a errores estandar o robustos
        
            # b.1. errores estandar y límites
        self.var_standar()
        
        sd_standar=self.sd.reshape( -1, 1 )
        
        superior_standar=self.superior.reshape( -1, 1 )
        inferior_standar=self.inferior.reshape( -1, 1 )
        
            # b.2. errores robustos y límites
        self.var_robust()
             
        sd_robust=self.sd.reshape( -1, 1 )
        
        superior_robust=self.superior.reshape( -1, 1 )
        inferior_robust=self.inferior.reshape( -1, 1 )
        
        # c. Colocar valores en una tabla de acuerdo a errores estandar o robustos
        
        if self.robust:      
            table_data ={  "Coef."    : beta_ols.ravel() ,
                       "Std.Err." : sd_standar.ravel(),
                       "Interv. sup."  : superior_standar.ravel(),
                       "Interv. inf."  : inferior_standar.ravel() }
        
        # d. crear dataframe 
            reg_OLS = pd.DataFrame( table_data , index = self.columns )
             
        # e. crear diccionario
            dic = {"OLS": reg_OLS, "root MSE": self.root_mse, "R2": self.R2}
            
        else:
            table_data ={  "Coef."    : beta_ols.ravel() ,
                       "Std.Err." : sd_robust.ravel(),
                       "Interv. sup."  : superior_robust.ravel(),
                       "Interv. inf."  : inferior_robust.ravel() }
        
        # d. crear dataframe 
            reg_OLS = pd.DataFrame( table_data , index = self.columns )
             
        # e. crear diccionario
            dic = {"OLS": reg_OLS, "root MSE": self.root_mse, "R2": self.R2}
            
        return dic      

#DEMOSTRACIÓN:
A = RegClass( X, y ,lista, robust=True)   # correr datos
A

#Usando funcion general
A.X_np

#Usando la funcion reg_beta_OLS para hallar los coeficientes betas estimados
A.reg_beta_OLS()

#Usando la funcion var_standar
A.var_standar()
A.superior     # límite superior

#Usando la funcion var_robust
A.var_robust()
A.superior     # límite superior 

#Usando la funcion reg_OLS para ver el diccionario que incluye:
A = RegClass( X, y ,lista, robust=True)
A.reg_OLS()    # diccionario cuando hay evaluación con errores robustos

A.reg_OLS()['OLS']   #ver primer elemento del diccionario que es un dataframe

A = RegClass( X, y ,lista,robust=False)
A.reg_OLS()    # diccionario cuando hay evaluación estandar