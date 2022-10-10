# -*- coding: utf-8 -*-
"""
Estructura de Clase OLS

@author: Roberto
"""


import pandas as pd
import numpy as np
import pyreadr  # Load R dataset
import os # for usernanme y set direcotrio



class RegClass( object ):
    
    def __init__( self, X : pd.DataFrame , y : pd.Series , select_vars , sd_robust  ):
    
    
        if not isinstance( X, pd.DataFrame ):
            raise TypeError( "X must be a pd.DataFrame." )

        if not isinstance( y , pd.Series ):
            raise TypeError( "y must be a pd.Series." )
            
        
        # asignamos los atributos
        
        self.X = X 
        self.y = y
        self.select_vars = select_vars
        self.sd_robust = sd_robust
        
        # Try: ejecuta la seleccion de variables usando .loc (filtro de columnas por nombres)
        # Entonces, si select_var es una lista de variables, entonces se ejecuta la linea 1
        # Por otro lado, soi select_vars es una lista de posiciones de columnas, entonces 
        # la linea 1 no podrá ejecutarse y se ejecutará la linea 2. 
        
        try:
            
            self.X = self.X.loc[ : , self.select_vars ]  # 1)
        
        except Exception:
        
             self.X = self.X.iloc[:, self.select_vars]   # 2)
             
    
        
        self.X[ 'Intercept' ] = 1

        cols = self.X.columns.tolist() 
        new_cols_orders = [cols[ -1 ]] + cols[ 0:-1 ] 
        self.X = self.X.loc[ : , new_cols_orders ]  

        self.X_np = self.X.values
        self.y_np = y.values.reshape( -1 , 1 )
        self.columns = self.X.columns.tolist()
        
    # método que estima el vector de coeficientes
    
    def coefficients(self):
        
            X_np = self.X_np
            y_np = self.y_np
    
            # beta_ols
            beta_ols = np.linalg.inv( X_np.T @ X_np ) @ ( X_np.T @ y_np )
            
            self.beta_OLS = beta_ols
        
    def output1(self):
            
            self.coefficients()
            beta_OLS  = self.beta_OLS

            X_np = self.X_np
            y_np = self.y_np

            
            # errors
            e = y_np - ( X_np @ beta_OLS )
            
            # error variance
            N = X.shape[ 0 ]
            total_parameters = X.shape[ 1 ]
            error_var = ( (e.T @ e)[ 0 ] )/( N - total_parameters )
            
            # Matriz de Varianza y covarianza
            
            var_OLS =  error_var * np.linalg.inv( X_np.T @ X_np )
            
            # standard errors
            
            self.beta_se = np.sqrt( np.diag( var_OLS ) )
            
            # intervalo de confianza
            
            self.up_bd = beta_OLS.ravel() + 1.96*self.beta_se
            
            self.lw_bd = beta_OLS.ravel() - 1.96*self.beta_se
            
            
            
    def output2(self):
            
            self.coefficients()

            X_np = self.X_np
            y_np = self.y_np
            beta_OLS  = self.beta_OLS
            
            
            # errors
            y_est = X_np @ beta_OLS
            
            e = y_np - y_est
            
            e_square = np.array( list( map( lambda x: x**2 , e)) )
            
            # Matrix de white 
            
            matrix_robust = np.diag(list(e_square.flatten()))
            
            # Matrix de varianza y covarainza robusta ante heterocedasticidad
            
            Var_robust = np.linalg.inv(X_np.T @ X_np) @ X_np.T @ matrix_robust @ X_np @ np.linalg.inv(X_np.T @ X_np)
                      
            # standard errors
            
            self.beta_se = np.sqrt( np.diag( Var_robust ) )
            
            self.up_bd = beta_OLS.ravel() + 1.96*self.beta_se
            
            self.lw_bd = beta_OLS.ravel() - 1.96*self.beta_se
            
    def output3(self):
            
            self.coefficients()
            
            y_np = self.y_np
            X_np = self.X_np
            N = X_np.shape[ 0 ]
            y_est = X_np @ self.beta_OLS 
            
            SCR = sum(list( map( lambda x: x**2 , y_np - y_est)   ))
            SCT = sum(list( map( lambda x: x**2 , y_np - np.mean(y_est)   )))
            self.R2 = 1-SCR/SCT
            self.rmse = (SCR/N)**0.5
            
    
    def table(self):
            

            self.output3()  # ejecutamos el metodo que calcula el R2 y root-mse
            self.coefficients()  # ejectuamos el metodo que estima el vector de coeficientes
            
            
            if self.sd_robust == True : 
                
                self.output2()  # ejecutamos el metodo de errors estandar corregido ante heteroce.
            
                table_data ={  'Coef.'    : self.beta_OLS.ravel() , 
                   "Std.Err." : self.beta_se.ravel(),
                   "Lower_bound"   : self.lw_bd.ravel(),
                   "Upper_bound"   : self.up_bd.ravel()
                }
                
                
                # defining index names
                index_names = self.columns
    
                # defining a pandas dataframe 
                reg_OLS = pd.DataFrame( table_data , index = index_names )
                
                # output
                
                
                table_dict = {"Table":reg_OLS, "R2": self.R2, "MSE": self.rmse}

            else:
                
                self.output1() # ejecutamos el metodo de errors estandar sin corrección ante heterocedasticidad
                
                table_data ={  'Coef.'    : self.beta_OLS.ravel() , 
                   "Std.Err." : self.beta_se.ravel(),
                   "Lower_bound"   : self.lw_bd.ravel(),
                   "Upper_bound"   : self.up_bd.ravel()
                }
                
                
                # defining index names
                index_names = self.columns

                # defining a pandas dataframe 
                reg_OLS = pd.DataFrame( table_data , index = index_names )
                
                # output
                
                
                table_dict = {"Table":reg_OLS, "R2": self.R2, "MSE": self.rmse}
                
                
                

            return table_dict
        
        
    

user = os.getlogin()   # Username

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal/WG4/Solucion") # Set directorio

cps2012_env = pyreadr.read_r("../../../data/cps2012.Rdata") # output formato diccionario


cps2012 = cps2012_env[ 'data' ].iloc[0:500]  # seleccionamo solo 500 observaciones

       
Y = cps2012['lnw']
X = cps2012.iloc[:,np.arange(1,18)]   # No consideramos el logaritmo del salario 


Regression1 = RegClass(X, Y , ["female","hsg","cg","exp1","exp2"] , sd_robust = True)
Regression1.table()


Regression2 = RegClass(X, Y , ["female","hsg","cg","exp1","exp2"] , sd_robust = False)
Regression2.table()


Regression3 = RegClass(X, Y , [1,2,5,8,10] , sd_robust = False)
Regression3.table()


Regression4 = RegClass(X, Y , [1,2,5,8,10] , sd_robust = True)
Regression4.table()










