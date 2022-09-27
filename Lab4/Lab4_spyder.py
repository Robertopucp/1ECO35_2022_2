# -*- coding: utf-8 -*-
"""
Loop replacemnet and Class

@author: Roberto
"""

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect  # Permite conocer los argumentos de una función , classes, etc 



#%% Loop replacement


vector = np.arange(100)

map( lambda x: np.sqrt(x) , vector) 

list( map( lambda x: np.sqrt(x) , vector)   )    


np.sqrt(vector)


'''
Ejemplos
'''


'''
Función 1
'''

def cube(x):
    
    out = x*(1/3) - 0.5*x
    
    return out 

list( map( lambda x: cube(x) , vector)   )  

def sdv(x,mean,sd):
    
    out = (x-mean)/sd
    
    return out 

'''
Función 2, de estandarización
'''

map( lambda x, v1 = np.mean(vector), v2 = np.std(vector): sdv(x,v1, v2) , vector)

list( map( lambda x, v1 = np.mean(vector), v2 = np.std(vector): sdv(x,v1, v2) , vector)  )  


vector1 = (vector - np.mean(vector))/np.std(vector)


'''
Función 3, extrae lo numeros de un texto

La función extrae los numeros de texto

'''
import re # Regex


texto_vector = np.array(["Municipio San Luis: 12450","Municipio La victoria: 1450",
                         "Municipio La Molina: 3550","Municipio Ate: 506"])


list( map( lambda x: re.sub('([a-z-A-Z])|(:)|[ ]',"", x) , texto_vector)   )

'''
Función 3, If statement

Valores menos a 50 asigne el numero 1 y asignar missing values para valores mayor i igual a 50
'''

vector = np.arange(100)

def function2(x):
    
    if x < 50:
         out = 1
    else:
         out = np.nan # Missing values

    return out 

list( map( lambda x: function2(x) , vector)   )

# re.sub( patron de texto, sustitución, texto)

''' Loop replacement in Matrix '''

import numpy as np

np.random.seed(15632)
x1 = np.random.rand(500) # uniform distribution  [0,1]
x2 = np.random.rand(500) # uniform distribution [0,1]
x3 = np.random.rand(500) # uniform distribution [0,1]
x4 = np.random.rand(500) # uniform distribution [0,1]


X = np.column_stack((np.ones(500),x1,x2,x3,x4))

print(X.shape)

'''

En el caso de aplicar funciones como mean, std, y entre otros se puede aplicar pro filas o columnas

axis = 0 se aplica la función a cada columa
axis = 1 se aplica la función por filas

Numpy apply for matrix

numpy.apply_along_axis(func1d, axis, arr, *args, **kwargs)
 
'''

# mead y desviación estandar por columnas


np.mean(X, axis=0)   # axis = 0 (se aplica por columnas)
np.std(X, axis=0)

# mead y desviación estandar por filas

np.mean(X, axis=1) 
len( np.mean(X, axis=1) )
np.std(X, axis=1)



'''

Tres formas de estandarizar una matriz 

'''
   
XNormed = (X - np.mean(X, axis=0))/np.std(X, axis=0)

X_std = np.apply_along_axis(lambda x, prom = 3, desv = 100: (x-prom)/desv,0, X)
  
    
X_std_1 = np.apply_along_axis(lambda x: (x-x.mean())/x.std(),0, X)

            
def standarize(x):
       out = (x - np.mean(x))/np.std(x)
          
       return out
   
X_std_2 = np.apply_along_axis(standarize,0, X)
    
# axis = 0, se aplicará la función a los elementos de cada columna

'''

Apply to DataFrame

'''
  
  
# list of name, degree, score
var1 = np.random.rand(50000)
var2 = np.arange(0,50000)
var3 =  np.random.rand(50000)
  
# dictionary of lists 
dict = {'v1': var1, 'v2': var2, 'v3': var3} 
    
df = pd.DataFrame(dict)

df.apply(np.sum, axis = 0)  # columna por columna 
df.apply(np.sum, axis = 1)  # fila por fila

# Se genera el cuadrado de la variable v2

df['nueva_var'] = df['v2'].apply(lambda x : x**2)

# Cuadradro a los elementos de cada columna


df.apply(lambda x : x**2, axis = 0)


# Estandarización de los elementos de cada columna

'''
Lambda y la inclusión de la función
'''

df.apply(lambda row: (row - np.mean(row))/np.std(row), axis =0)

'''
Lambda y la función construida por separado
'''

def standarize(x):
    out = (x - np.mean(x))/np.std(x)
    
    return out

df.apply(standarize, axis = 0)


df.apply(lambda row: standarize(row), axis =0)

#%% Handle dataset 

'''
 We use US census data from the year 2012 to analyse the effect of gender 
 and interaction effects of other variables with gender on wage jointly.
 The dependent variable is the logarithm of the wage, the target variable is *female*
 (in combination with other variables). All other variables denote some other 
 socio-economic characteristics, e.g. marital status, education, and experience. 
 For a detailed description of the variables we refer to the help page.
 '''
 
import pyreadr  # Load R dataset
import os # for usernanme y set direcotrio

user = os.getlogin()   # Username

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab4") # Set directorio

cps2012_env = pyreadr.read_r("../data/cps2012.Rdata") # output formato diccionario


cps2012_env  # es un diccionario. En la llave "data" está la base de datos 
cps2012 = cps2012_env[ 'data' ] # extrae información almacenada en la llave data del diccionario cps2012_env
dt = cps2012.describe()
 
# Borrar variables constantes 

variance_cols = cps2012.var().to_numpy() # to numpy
X = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ]

# np.where( variance_cols != 0   ) resulta la posición de lasa columnas con varianza != 0

np.where( variance_cols != 0   )[0] # array

# np.where() permite obtener la posición de columnas que cumplen la condición

# Retirar la media de las variables 

def demean(x):
    dif = x - np.mean( x ) # tima la media de la columna 
    return dif 

X = X.apply( demean, axis = 0 )  # axis :0 se aplica la función por columna

X.to_stata("../data/clean_data.dta", write_index = False)

# write_index = False , permite que la base gaurdada no genera una columna para el indexing


#%% *args 

"""
The special syntax *args in function definitions in python is used to pass a variable number 
of arguments to a function. The object *args is a tuple that contains all the arguments.
 When you build your code, you should consider *args as a tuple.
"""

'''
*args : tipo tuple o array
'''

"Keyword: *args, incluir una cantidad variable de argumentos"


def calculator( *args ):
    
    print( f"args is a {type( args )}" )
    
    
    vector = np.array( list(args) )  # *args : tuple
    
    minimo = np.min(vector)
    
    maximo = np.max(vector)
    
    result = np.prod(vector)
    
    
    return result, minimo, maximo


calculator( 8, 9, 50, 10, 12 ,15,20,100,120)

'''
*args se puede usar otro nombre siempre que se use * al inicio
'''


def calculator( *list_vars ):
    
    print( f"args is a {type( list_vars )}" )
    
    
    vector = np.array( list_vars )  # *args : tuple
    
    minimo = np.min(vector)
    
    maximo = np.max(vector)
    
    result = np.prod(vector)
    
    
    return result, minimo, maximo


calculator( 8, 9, 50, 40, 10, 1)


#%%  *Kwargs


'''
**Kwargs is an acronym of keyword arguments. 
It works exactly like *Args but instead of accepting a variable number of positional arguments, 
it accepts a variable number of keyword or named arguments.
'''

'''
**kwargs: tipo diccionario 
'''

def calculator( *list_vars, **kwargs):
    
    print( type( list_vars ) )
    print( type( kwargs ) )
    
    if ( kwargs[ 'function' ] == "media" ) :
        
        # Get the first value
        result = np.mean( list_vars )
    
    elif ( kwargs[ 'function' ] == "adicion" ) :

        result = sum(list_vars)
    else:
        raise ValueError( f"The function argument {kwargs[ 'function' ]} is not supported." )
        
        # Mensaje de error por tipo de argumento

    return result


calculator( 4, 5, 6, 7, 8, function = "adicion" )

calculator( 4, 5, 6, function = "media" )

calculator( 4, 5, 6, 7, 8, function = "inversa" )

calculator( np.arange(10), function = "media" )

'''
Example using dataset cps2012
'''



def transform(Data, *select, **function) -> pd.DataFrame: #output DataFrame 
    
    select = list(select)  # se transforma a una lista
    Data_select = Data[select] # se filtra por columnas 
    
    if function['method'] == "demean":
        
        X = Data_select.apply(lambda row: row - np.mean(row), axis =0)
        
    elif function['method'] == "estandarize":
        
        X = Data_select.apply(lambda row: (row - np.mean(row))/np.std(row), axis =0)
        
    return X


transform(cps2012, "lnw", "exp1","exp2", method = "estandarize")



#%%  Class

class class_name:
    
    def __init__(self, parameter1, parameter2):
        None
        
## Atributos

import numpy as np 

A = np.arange( 8, 25 )

print(A.size)
A.shape
A.mean()
        
dir(A)    # lista de atributos a partir de all, any, ...


"""
Method:
A function which is defined inside a class body. 
If called as an attribute of an instance of that class,
 the method will get the instance object as its first argument (which is usually called self). 
 See function and nested scope.
"""

from sklearn import linear_model
print(dir(linear_model))


#### __init__

class MyFirstClass:
    
    def __init__( self, name, age ):
        self.name = name
        self.age = age
    
    # best way to define a method
    def print_name_1( self ):
        print( f'I am { self.name }.' )
    
    # wrong way to define a method 
    def print_name_2(self):
        print( f'This is my { self.name }.' )
    
    
    # the worst way to call a parameter
    # we need to define them as attributes
    def print_name_3( self ):
        print( f'This is my { self.name }.' )
        
student = MyFirstClass( name = "Jose" , age = 22)

'''
Recuperamos los parámetros 
'''

student.age
student.print_name_1()

    
class MyFirstClass:
    
    def __init__( self, name, age, school ):
        self.name = name
        self.age = age
        self.school = school
    
    # how to define a method
    def print_name_1( self ):
        print( f'I am { self.name }.' )
    
    # other method
    def person_age( self ):
        print( f' I am { self.name } , I am { self.age } old. ' )
    
    # method
    def person_school( self ):
        print( f' I am {self.name} , I study at {self.school}. ' )
      
    # wrong way to define a method 
    def print_name_2(self):
        print( f'This is my { self.name }.' )
    
    # the worst way to call a parameter
    # we need to define them as attributes
    def print_name_3( self ):
        print( f'This is my { self.name }.' )        


student = MyFirstClass( name = "Jose" , age = 22, school = "Saco Oliveros" )

student.name
student.age

print(student.age)
print(student.school)
student.person_age()
student.print_name_1()

# Modificar propiedades directamente

student.age = "Pablo"

'''
OLS class
'''

W = [1,2,3]

from scipy.stats import t # t - student 

class OLS(object):
    
    def __init__(self, X,Y, W):
        
        self.X = X
        self.Y = Y
        
    def Algebralineal(self):
        
        self.n = self.X.shape[0]
        k = self.X.shape[1]
        X1 = np.column_stack((np.ones(self.n ), self.X.to_numpy() ))  # self.X.to_numpy()  # DataFrame to numpy
        Y1 = self.Y.to_numpy().reshape(self.n  ,1)
        self.X1 = X1
        self.Y1 = Y1
        self.beta = np.linalg.inv(X1.T @ X1) @ ((X1.T) @ Y1 )
        self.nk = self.n - k 
        
    def R2(self):
        
        self.Algebralineal()  # run function 
           
        y_est =  self.X1 @ self.beta
        error = self.Y1 - y_est
        self.SCR = np.sum(np.square(error))
        SCT = np.sum(np.square(self.Y1 - np.mean(self.Y1))) 

        R2 = 1 - self.SCR/SCT

        return R2           

    def Table(self, **Kargs):
        
        # run functions
        
        self.R2()
        self.Algebralineal()
        
        
        
        scr = self.SCR
        sigma =  scr / self.nk
        Var = sigma*np.linalg.inv(self.X1.T @ self.X1)
        sd = np.sqrt( np.diag(Var) )
        t_est = np.absolute(self.beta/sd)
        pvalue = (1 - t.cdf(t_est, df=self.nk) ) * 2
            
        if (Kargs['Output'] == "DataFrame"):

               df = pd.DataFrame( {"OLS": self.beta.flatten() , "standar_error" : sd.flatten()} )
                
                
        elif (Kargs['Output'] == "Diccionario"):
    
            df ={"OLS": self.beta.flatten() , "standar_error" : sd.flatten() ,
                                    "Pvalue" : pvalue.flatten()}
    
    
        return df    
            

#flatten():  De multi array a simple array 


Dataset = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ]

X = Dataset.iloc[:,1:10]
Y = Dataset[['lnw']]

Reg1 = OLS(X,Y)

Reg1.X

Reg1.Algebralineal()
Reg1.X1

Reg1.R2()


Reg1.Table(Output = "Diccionario")['OLS'] 
Reg1.Table(Output = "Diccionario")['Pvalue'] 
Reg1.Table(Output = "Diccionario")['standar_error'] 
         
Reg1.Table(Output = "DataFrame")

# Know arguments from function or class

inspect.getfullargspec(OLS)
inspect.getfullargspec(transform)

help(np)  # inspeccionar una liberia 


dir(OLS) # isnspeccionar metodos e instancias



