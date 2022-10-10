# -*- coding: utf-8 -*-
"""

Privatización de métodos y variables

Detección de duplicados en archivo spss

@author: Roberto
"""

import pandas as pd
import numpy as np
import pyreadr  # Load R dataset
import os # for usernanme y set direcotrio



class RegClass( object ):
    
    # Una de las aplicaciones de la isntancia slot es fijar métodos
    # Para ello se debe especificar todos los atributos creados. 
    # Caso contrario, la estrucutra de clase no reconocerá ningun atributo
    
    __slots__ = [ "__X", "y", "select_vars", "sd_robust", "X_np", "y_np" ,
                 "columns", "beta_OLS", "beta_se", "up_bd", "lw_bd",
                 "R2", "rmse"                 
                 ]
    
    
    def __init__( self, X : pd.DataFrame , y : pd.Series , select_vars , sd_robust  ):
    
    
        if not isinstance( X, pd.DataFrame ):
            raise TypeError( "X must be a pd.DataFrame." )

        if not isinstance( y , pd.Series ):
            raise TypeError( "y must be a pd.Series." )
            
        
        # asignamos los atributos
        
        self.__X = X   # atributo X fijado 
        self.y = y
        self.select_vars = select_vars
        self.sd_robust = sd_robust
        
        # Try: ejecuta la seleccion de variables usando .loc (filtro de columnas por nombres)
        # Entonces, si select_var es una lista de variables, entonces se ejecuta la linea 1
        # Por otro lado, soi select_vars es una lista de posiciones de columnas, entonces 
        # la linea 1 no podrá ejecutarse y se ejecutará la linea 2. 
        
        try:
            
            self.__X = self.__X.loc[ : , self.select_vars ]  # 1)
        
        except Exception:
        
             self.__X = self.__X.iloc[:, self.select_vars]   # 2)
             
    
        
        self.__X[ 'Intercept' ] = 1

        cols = self.__X.columns.tolist() 
        new_cols_orders = [cols[ -1 ]] + cols[ 0:-1 ] 
        self.__X = self.__X.loc[ : , new_cols_orders ]  

        self.X_np = self.__X.values
        self.y_np = self.y.values.reshape( -1 , 1 )
        self.columns = self.__X.columns.tolist()
        
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

# Intentaremos observar el atributo X

Regression1.X

Regression1.__X

# ! No podemoa acceder al atributo X

# Intento de alterar el atributo X


Regression1.__X = 1

# ! Tampoco podemos alteralo

# creamos una función 

def function(x):
    
       None 


# intentaremos alterar el método table 

Regression1.table = function


# No podemos alterar el método table !!!

#%% Deteccion de duplicados 

import savReaderWriter as sav  
import pyreadstat

# se sube la base de datos 

data = pd.read_spss( r"../../../data/data_administrativa.sav" )


# Usamos sav.SavHeaderReader para leer las estiquetas 

with sav.SavHeaderReader( r"../../../data/data_administrativa.sav", ioUtf8=True) as header:
    metadata = header.all() # save dataset
    value_labels_data = metadata.valueLabels  # get labels from varaibles's values 
    var_labels_data = metadata.varLabels # get labels from variables 

# value_labels_data, var_labels_data son objetos diccionarios

var_labels_data.keys() 

var_labels_data['P209']
var_labels_data['P206']

value_labels_data.keys()

value_labels_data['P209']
value_labels_data['P206']

# Asignamos las etiquetas a la base de datos


data.attrs[ 'value_labels' ] = value_labels_data # value's labels 
data.attrs[ 'var_labels' ] = var_labels_data # var labels

#Observamos las estiquetas asignadas a la base de datos 

data.attrs[ 'value_labels' ]
data.attrs[ 'var_labels' ]

# Observamos los atributos asignados a la base de datos 

data.attrs


# Mostrar las observaciones que presentan duplicados y sus duplicados respectivos

data_1 = data[ data.loc[:, ['CONGLOME' ,'VIVIENDA' , 'HOGAR','CODPERSO']].duplicated(keep = False) ]

# se ordena por identificador de persona y año
# De esta manera, se observa la información de la persona como un panel de datos 

data_1.sort_values(['CONGLOME' ,'VIVIENDA' , 'HOGAR','CODPERSO','year'], inplace = True)

data_2019 = data_1[data_1['year'] == "2019"]

pyreadstat.write_sav(data_2019,  r"../../../data/data2019.sav")

data_2020 = data_1[data_1['year'] == "2020"]

pyreadstat.write_sav(data_2020,  r"../../../data/data2020.sav")









