# -*- coding: utf-8 -*-
"""
Created on Sat Oct  1 19:16:21 2022

@author: HP
"""

################  TAREA 6 #####################
######### Curso: Laboratorio de R y Python #########
################ GRUPO 6 ##################### 

#%% Pregunta 1

#--------------- Recordando todo lo avanzado en la Tarea 4
# Primero es necesario que importemos las librerias para crear las clases, definir atributos y finalmente crear los modelos

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect
import pyreadr  # Cargar la base de datos de R
import os # Para identificar el directorio

# Llamamos el paquete que nos permitirá llevar a cabo la regresión lineal
from scipy.stats import t #Refiriendo al estadistico t-student

# Comenzamos a crear la clase, en la parte de class RegClass, podemos omitir object, pues es lo mismo      
class RegClass( object ):
    
    def __init__( self, X : pd.DataFrame , y : pd.Series , intercept = True  ):
    def __init__(self, explicativas, vector, extraer, booleano):

self.explicativas = explicativas
        self.vector = vector
        self.booleano = booleano

   # Indicamos que X sea un data frame e Y sea una lista, proponiendo una condicional para ambos)
        if not isinstance( X, pd.DataFrame ):
            raise TypeError( "X must be a pd.DataFrame." )

        if not isinstance( y , pd.Series ):
            raise TypeError( "y must be a pd.Series." )
            
   # asignando atributos de la clase correspondientes
        
        self.X = X
        self.y = y
        self.intercept = intercept
    
        if self.intercept:

            self.X[ 'Intercept' ] = 1
# Se coloca la columna Intercept en la primera columna 
            cols = self.X.columns.tolist() # nombre de varaible a lista 
            new_cols_orders = [cols[ -1 ]] + cols[ 0:-1 ] # juntando listas
            
# new_cols_orders = [cols[ -1 ]].extend(cols[ 0:-1 ]) # append lista a una lista 
            
# [cols[ -1 ]] la jala la ultima fila , cols[ 0:-1 ]  primera fila hasta la penultima fila 
            
            self.X = self.X.loc[ : , new_cols_orders ] # usamos .loc que filtra por nombre de filas o columnas 

        else:
            pass

# Ahora se está creando nuevos atributos y filtramos los nombres
        
        self.X_np = self.X.values  # Dataframe a multi array
        self.y_np = y.values.reshape( -1 , 1 ) # de objeto serie a array columna 
        self.columns = self.X.columns.tolist() # nombre de la base de datos como objeto lista
        
##### Método 1 #####
##################
# Se busca estimar los coeficientes de la regresión 
# Definimos la regresión 
    
    def reg_beta_OLS( self ):
        # X se define como Matriz, mientras Y como vector columna 
        
        X_np = self.X_np
        y_np = self.y_np

# Utilizando el beta_ols
        beta_ols = np.linalg.inv( X_np.T @ X_np ) @ ( X_np.T @ y_np )

        # columnas de X
        index_names = self.columns
# Aqui definimos la salida o el output
        beta_OLS_output = pd.DataFrame( beta_ols , index = index_names , columns = [ 'Coef.' ] )
        
# Finalmente, queda un Dataframe de coeffientes como atributo 
        
        self.beta_OLS = beta_OLS_output
        
        return beta_OLS_output

##### Método 2 #####
##################
# Se busca hallar la matriz de varianzas y covarianzas, en modo estándar: 
# Primero buscamos hallar el error estandar y la varianza a continuación
    
    def reg_var_OLS( self ):
    
# PRIMERO, Se corre la función reg_beta_OLS para estimar el vector de coeficientes
        
        self.reg_beta_OLS()
        
        X_np = self.X_np
        y_np = self.y_np
                
# beta_ols
        beta_OLS = self.beta_OLS.values.reshape( - 1, 1 ) # Dataframe a vector columna 

# Analizamos los errores 
        e = y_np - ( X_np @ beta_OLS )

# Luego, se evalua la varianza del error
        N = X.shape[ 0 ]
        total_parameters = X.shape[ 1 ]
        error_var = ( (e.T @ e)[ 0 ] )/( N - total_parameters )

# SEGUNDO, para hallar la Varianza
        var_OLS =  error_var * np.linalg.inv( X_np.T @ X_np )

# columns names 
        index_names = self.columns
# Tendremos el output desde la creación del atributo VAR
        var_OLS_output = pd.DataFrame( var_OLS , index = index_names , columns = index_names )
## variance output como nuevo atributo del objeto
        self.var_OLS = var_OLS_output

# TERCERO, ahora corremos la funcion OLS, para hallar la varianza y desviacion estandar        
    def reg_OLS( self ):
        
# Se corren las funciones
        self.reg_beta_OLS()
        self.reg_var_OLS()
        X = self.X_np
        
# Varianza y Coeficientes betas
        beta_OLS = self.beta_OLS.values.reshape( -1, 1 )
        var_OLS = self.var_OLS.values
        
# Hallando error estándar
        beta_se = np.sqrt( np.diag( var_OLS ) )

# FINALMENTE, para analizar la significacia se calcula el test statistic para cada coeficiente
        t_stat = beta_OLS.ravel() / beta_se.ravel()      
        
        # .ravel() te multiarray a simple array
        
        # p-value:
        N = X.shape[ 0 ]
        k = beta_OLS.size
        self.nk = N-k
        pvalue = (1 - t.cdf(t_stat, df= N - k) ) * 2

# ADEMÁS, se evalúa el intervalo de confianza para los coeficientes estimados (bajo un 95% con un valor de 1.96)
        
        up_bd = beta_OLS.ravel() + 1.96*beta_se
        lw_bd = beta_OLS.ravel() - 1.96*beta_se

        table_data ={  'Coef.'    : beta_OLS.ravel() ,  # .ravel() :: .flatten()
                       "Std.Err." : beta_se.ravel(),
                       "t"        : t_stat.ravel(),
                       "P>|t|"    : pvalue.ravel(), 
                       "[0.025"   : lw_bd.ravel(),
                       "0.975]"   : up_bd.ravel()
                    }
        
        # defining index names
        index_names = self.columns
        
        # defining a pandas dataframe 
        reg_OLS = pd.DataFrame( table_data , index = index_names )

        return reg_OLS

##### Método 3 #####
##################
# Aqui nos piden un método para hallar la matriz de varianza y covarianza robusta
def M_ROBUST_COV(self):
# ESTIMACIÓN DEL VECTOR DE COEFICIENTES. 
       self.beta_OLS_Reg()

# usamos atributos pero con el nombre simplificado
        X_np = self.X_np
        y_np = self.y_np

# VARIANZA ROBUSTA, tomando de base a la matriz propuesta de White para muestras grandes
# V = np.zeros ((X_np.shape[1]. X_np. shape(1)))
        self.y_est = X_np @ self.beta_OLS

        matrix_robust = np.diag(list( map( lambda x: x**2 , y_np - self.y_est)))
 
        self.robust_var = np.linalg.inv(X_np.T @ X) @ X_np.T @ matrix_robust @ X_np @ np.linalg.inv(X_np.T @ X_np)

##### Método 4 #####
##################
# Se definirá el método que permita hallar la matriz de varianza y covarianza estándar, los errores estándar de cada coeficiente, e intervalos de confianza. Determinamos que X sea un data frame, mientras Y sea una columna, de modo que tambien se utiliza el args
#Se crea atributo de vector de variable Y
         X1 = self.Y.to_numpy().reshape(self.n  ,1) # Se mantiene como DataFrame. Se crea atributo de variables explicativas
         self.X = X
         self.Y = Y #Se crea el atributo para extraer el vector de la variable Y
         self.beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

         self.nk = self.n - k #Para determinar grados de libertad
# Se definirá un método que halle el R2 y root MSE (mean square error)

    def R2(self):
         
         self.coeficientes()              
         y_est =  self.X @ self.beta
         error = self.Y - y_est
         self.SCR = np.sum(np.square(error))
         SCT = np.sum(np.square(self.Y - np.mean(self.Y))) 
         R2 = 1 - self.SCR/SCT

         return R2   
# Ahora, para hallar el root MSE, primero hay que llamar al paquete que nos permitirá encontrarlo
from sklearn.metrics import mean_squared_erro
#Definimos el método

def MSE(true,predicted):
        
        MSE = mean_squared_error(true,predicted, squared=False)
        
        return MSE

##### Método 5 #####
##################
# Primero se necesita cargar la base de datos, por ello utilizamos el user que se utilice sin necesidad de cambiar el usuario del computador
user = os.getlogin()
os.chdir(f"Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab4")  #Tomar en cuenta que al trabajar en una Mac o sistema IOs, no se usa el C:" 

cps2012_UNO = pyreadr.read_r("../data/cps2012.Rdata") 
cps2012 = cps2012_UNO['data']
dt = cps2012.describe

#ES NECESARIO FILTRAR LAS VARIANZAS DISTINTAS A 0

variance_cols = cps2012.var().to_numpy()
dataset = cps2012.iloc[:, np.where(variance_cols !=0 )[0]]
## aca poner un dataset específico desde el general, podría ser con iloc y squeeze()


#%%
#--------------- Se privatizará el atributo X

############# Privatizando el atributo X (Data frame)

### EN MÉTODO 1: INICIALMENTE, Comenzamos a crear la clase, class RegClass     
class RegClass( object ):

#Ahora comenzamos a cambiar la estructura de privatización, cambiando a los atributos de X
  def __init__( self, X : pd.DataFrame , y : pd.Series , intercept = True  ):
  def __init__(self, explicativas, vector, extraer, booleano):
# asignando atributos de la clase correspondientes
        
        self.__X = X
        self.y = y
        self.intercept = intercept
        if self.intercept:

            self.X[ 'Intercept' ] = 1
# Se coloca la columna Intercept en la primera columna 
            cols = self.__X.columns.tolist() # nombre de varaible a lista 
            new_cols_orders = [cols[ -1 ]] + cols[ 0:-1 ] # juntando listas
            
# new_cols_orders = [cols[ -1 ]].extend(cols[ 0:-1 ]) # append lista a una lista 
            
# [cols[ -1 ]] la jala la ultima fila , cols[ 0:-1 ]  primera fila hasta la penultima fila 
            
            self.__X = self.__X.loc[ : , new_cols_orders ] # usamos .loc que filtra por nombre de filas o columnas 

        else:
            pass

# Ahora se está creando nuevos atributos y filtramos los nombres
        
        self.__X_np = self.__X.values  # Dataframe a multi array
        self.y_np = y.values.reshape( -1 , 1 ) # de objeto serie a array columna 
        self.columns = self.__X.columns.tolist() # nombre de la base de datos como objeto lista
### EN MÉTODO 2:        
def reg_var_OLS( self ):
    
# PRIMERO, Se corre la función reg_beta_OLS para estimar el vector de coeficientes
        
        self.reg_beta_OLS()
        
        X_np = self.__X_np
        y_np = self.y_np
                
# beta_ols
        beta_OLS = self.beta_OLS.values.reshape( - 1, 1 ) # Dataframe a vector columna 

# Analizamos los errores 
        e = y_np - ( X_np @ beta_OLS )

# Luego, se evalua la varianza del error
        N = X.shape[ 0 ]
        total_parameters = X.shape[ 1 ]
        error_var = ( (e.T @ e)[ 0 ] )/( N - total_parameters )

# SEGUNDO, para hallar la Varianza
        var_OLS =  error_var * np.linalg.inv( X_np.T @ X_np )

# columns names 
        index_names = self.columns
# Tendremos el output desde la creación del atributo VAR
        var_OLS_output = pd.DataFrame( var_OLS , index = index_names , columns = index_names )
## variance output como nuevo atributo del objeto
        self.var_OLS = var_OLS_output

# TERCERO, ahora corremos la funcion OLS, para hallar la varianza y desviacion estandar        
    def reg_OLS( self ):
        
# Se corren las funciones
        self.reg_beta_OLS()
        self.reg_var_OLS()
        X = self.__X_np
        
# Varianza y Coeficientes betas
        beta_OLS = self.beta_OLS.values.reshape( -1, 1 )
        var_OLS = self.var_OLS.values
        
# Hallando error estándar
        beta_se = np.sqrt( np.diag( var_OLS ) )

# FINALMENTE, para analizar la significacia se calcula el test statistic para cada coeficiente
        t_stat = beta_OLS.ravel() / beta_se.ravel()      
        
        # .ravel() te multiarray a simple array
        
        # p-value:
        N = X.shape[ 0 ]
        k = beta_OLS.size
        self.nk = N-k
        pvalue = (1 - t.cdf(t_stat, df= N - k) ) * 2
### EN METODO 3
def M_ROBUST_COV(self):
# ESTIMACIÓN DEL VECTOR DE COEFICIENTES. 
       self.beta_OLS_Reg()

# usamos atributos pero con el nombre simplificado
        X_np = self.__X_np
        y_np = self.y_np

# VARIANZA ROBUSTA, tomando de base a la matriz propuesta de White para muestras grandes
# V = np.zeros ((X_np.shape[1]. X_np. shape(1)))
        self.y_est = X_np @ self.beta_OLS

        matrix_robust = np.diag(list( map( lambda x: x**2 , y_np - self.y_est)))
 
        self.robust_var = np.linalg.inv(X_np.T @ X) @ X_np.T @ matrix_robust @ X_np @ np.linalg.inv(X_np.T @ X_np)

### EN METODO 4
         X1 = self.Y.to_numpy().reshape(self.n  ,1) # Se mantiene como DataFrame. Se crea atributo de variables explicativas
         self.__X = X
         self.Y = Y #Se crea el atributo para extraer el vector de la variable Y
         self.beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

         self.nk = self.n - k #Para determinar grados de libertad
# Se definirá un método que halle el R2 y root MSE (mean square error)

    def R2(self):
         
         self.coeficientes()              
         y_est =  self.__X @ self.beta
         error = self.Y - y_est
         self.SCR = np.sum(np.square(error))
         SCT = np.sum(np.square(self.Y - np.mean(self.Y))) 
         R2 = 1 - self.SCR/SCT

         return R2   
# Ahora, para hallar el root MSE, primero hay que llamar al paquete que nos permitirá encontrarlo
from sklearn.metrics import mean_squared_erro
#Definimos el método

def MSE(true,predicted):
        
        MSE = mean_squared_error(true,predicted, squared=False)
        
        return MSE        

#%%
#--------------- Se privatizará el método de diccionario 
### EN MÉTODO 5
# A continuación el punto clave: Colocar la instancia __slot__ con todos los atributos que hayan creado en su estructura de clase. 

    __slots__ = [ '__X',  'y',  'intercept', 'X_np',  'y_np',  'columns',   'beta_OLS']  # colocar todos los atributos que hayan definido en se clase. Observen que X se incluye privatizado
   
ghjkl
#%% Pregunta 2
from IPython.display import display, HTML

display(HTML(data="""
<style>
    div#notebook-container    { width: 75%; }
    div#menubar-container     { width: 95%; }
    div#maintoolbar-container { width: 65%; }
</style>
"""))

import numpy as np
import pandas as pd
from pandas import DataFrame,Series
import savReaderWriter as sav

!pip install pyreadstat # open spss dataset // #por si necesitamos instalar
!pip install savReaderWriter // #por si necesitamos instalar

data_administrativa = pd.read_spss( r"../data/enapres_2020_ch_100/736-Modulo1618/CAP_100_URBANO_RURAL_3.sav" )

# cargamos usando pandas

data_administrativa

with sav.SavHeaderReader(r"../data/data_administrativa.sav", ioUtf8=True) as header:
    metadata = header.all()
    labels_data_administrativa = metadata.valueLabels
    var_labels_data_administrativa = metadata.varLabels

# Mostrar las variables que presentan missing values

# Opción 1 -> info, todo lo que no presente 42153 datos (N), necesariamente presentará missing values.

data_administrativa.info(verbose=True,null_counts=True) 

# Opción 2 -> isnull para explorar sobre todas las variables que presenten missing values.
data_administrativa.isnull

# Mostrar las etiquetas de dos variables (var labels) y las etiquetas de los valores en dos variables (value's labels).

labels_data_administrativa.keys #utilizamos keys para conocer las variables 
var_labels_data_administrativa.keys

#ya que nos piden dos de cada uno, necesitamos conocer los nombres.

labels_data_administrativa['AREA'] # mostramos las etiquetas de los valores
labels_data_administrativa['ESTRATO']

var_labels_data_administrativa['REGIONNATU'] # mostramos las etiquetas de dos variables
var_labels_data_administrativa['TSELV']

data_administrativa.attrs[ 'value_labels' ] = labels_data_administrativa # guardamos todas las lables.
data_administrativa.attrs[ 'var_labels' ] = var_labels_data_administrativa 

#  Detectar personas que fueran entrevistadas en ambos años. Para ello, se pide detectar duplicados a partir del identificador por persona : conglome, vivienda, hogar y codperso.

Nos piden crear un identificador por persona "Conglo, viv, hog, codper"

Con esto, buscamos identificar aquellos que se repitan.

data_administrativa[ data_administrativa.loc[:, ['CONGLOMERADO' , 'VIVIENDA', 'HOGAR', 'P100_C']].duplicated(keep = False)] 

# keep False para mostrar todos los duplicados.

data_administrativa[ data_administrativa.loc[:, ['CONGLOMERADO' , 'VIVIENDA', 'HOGAR', 'P100_C']].duplicated(keep = False) ]\
[['CONGLOMERADO' , 'VIVIENDA', 'HOGAR', 'P100_C']]

# Ordene la base de datos a partir de las variables que identifican cada miembro y la variable de año (year). Así podrá observar a cada individuo en ambos años.

data_administrativa[ data_administrativa.loc[:, ['CONGLOMERADO' , 'VIVIENDA', 'HOGAR', 'P100_C']].duplicated() ]


# crear una base de datos para cada año y guardar en la carpeta data con los siguientes nombres data_2019_(numero de grupo) y data_2020_(numero de grupo).
import pyreadstat

pyreadstat.write_sav(df,  r"../../data/enapres_2020_ch_100/736-Modulo1618/CAP_100_URBANO_RURAL_3.sav")