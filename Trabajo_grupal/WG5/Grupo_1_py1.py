# -*- coding: utf-8 -*-

#%% Grupo 1. Miembros del grupo:

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Eguzquiza 
# 20163377, Jean Niño de Guzmán

    #%% Parte 1
import os
import pyreadr
import pandas as pd
import numpy as np
import scipy.stats as stats
from scipy.stats import t 

user = os.getlogin()   # Usuario del dispositivo
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/data") # Definimos el directorio

# Leemos el archivo de Workspace R 
dr = pyreadr.read_r("../data/cps2012.Rdata")

# Convertimos en un dataframe
dr = dr['data'] 


#Filtando la base de datos
# Saca la varianza de cada vector y lo pasa a un array
var_cols = dr.var().to_numpy()

# Se filtran las columnas con valores constantes (muchos 1), nos aseguramos de tener variables continuas

df = dr.iloc[:,np.where(var_cols != 0)[0]]
X = df.iloc[:,1:10] # Filtra por posiciones
y = df[['lnw']] # Filtra por el nombre de la variable

#%% 

class RegClass( object ):
    
    # Colocamos los atributos definidos en la clase. X se incluye privatizado
    __slots__ = [ '__X',  'y',  'intercept', 'X_np',  'y_np',  'columns',   'reg_beta_OLS', 'reg_var_OLS', 'reg_OLS', 'pregunta_3_var_covar_robust', 'pregunta_3_parte_2', 'rmse', '__mostrar_resultados'  ]
    
    #Se definen X como un data frame y Y como una serie, y se indica que en este caso si habrá intercepto
    def __init__( self, X : pd.DataFrame , y : pd.Series , intercept = True  ):
    
        #Creación de atributos de acuerdo a la base de datos (añadiendo intercepto)
        
        # Privatizamos el atributo X (dataframe de variables explicativas)
        self.__X = X
        self.y = y
        self.intercept = intercept
        
        #Se indica que se apliquen las funciones si se cuenta con intercepto, y en caso contrario no hacer nada
        if self.intercept:

            self.__X[ 'Intercept' ] = 1
            #Coloación del Intercepto como la primera columna
            cols = self.__X.columns.tolist() # nombre de varaible a lista 
            new_cols_orders = [cols[ -1 ]] + cols[ 0:-1 ] # Se juntan las listas 
            self.X = self.__X.loc[ : , new_cols_orders ] # usamos .loc que filtra por nombre de filas o columnas 

        else:
            pass
        
        # Creación de nuevos atributos 
        
        self.X_np = self.__X.values  # Dataframe a multi array
        self.y_np = y.values.reshape( -1 , 1 ) # de objeto serie a array columna 
        self.columns = self.__X.columns.tolist() # nombre de la base de datos como objeto lista
        
    def reg_beta_OLS( self ):
        
        #Se llaman a los atributos antes creados para el cálculos de los betas con a matriz X y la columna y
        X_np = self.X_np
        y_np = self.y_np
        
        
        #Estimación de los Betas
        beta_ols = np.linalg.inv( X_np.T @ X_np ) @ ( X_np.T @ y_np )

        #Se llama al atributos de las columnas antes creado para hacer un dataframe con los betas estimados
        index_names = self.columns
        
        #Se crea un dataframe con los betas estimados de cada variable en la columna y
        beta_OLS_output = pd.DataFrame( beta_ols , index = index_names , columns = [ 'Coef.' ] )
        
        #Se pone el vector de coeficientes estimados como un atributo
        self.beta_OLS = beta_OLS_output
        
        return beta_OLS_output
    
    def reg_var_OLS( self ):
        #Se llaman a los betas calculados anteriormente
        self.reg_beta_OLS()
        
        #Se crean nuevos valores y atributos para el calculos de la varianza 
        X_np = self.X_np
        y_np = self.y_np
        
        # Se traen los valores estimados de los betas 
        beta_OLS = self.beta_OLS.values.reshape( - 1, 1 ) 

        # Calculos de los errores
        e = y_np - ( X_np @ beta_OLS )#############################################################
        
        # creo el atributo error porque me servirá más adelante
        self.error = e ################################################################
        
        # Calculo de la varianza de los errores. 
        N = X_np.shape[ 0 ] 
        
        total_parameters = X_np.shape[ 1 ]
        error_var = ( (e.T @ e)[ 0 ] )/( N - total_parameters )

        # Se calculan las varianzas y covarianzas
        var_ols =  error_var * np.linalg.inv( X_np.T @ X_np )

        #Se trae el atributo de columnas antes creado para añadirlo al nuevo dataframe
        index_names = self.columns
        
        #Se coloca en un dataframe las varianzas de todas las variables así y su respectiva covarianza 
        var_OLS_output = pd.DataFrame( var_ols , index = index_names , columns = index_names )
        
        #Se pone la matriz de varianzas y covarianza como un atributo con los valores en el dataframe calculado antes
        self.var_OLS = var_OLS_output
        
        return var_OLS_output        
        
    def reg_OLS( self ):
        
        # Se llaman los betas y varianzas estimados anteriormente
        self.reg_beta_OLS()
        self.reg_var_OLS()
        
        #Se llama a un atributo antes creado de X
        X = self.X_np
        
        #Se traen los valores antes calculados en los dos métodos anteriores (Betas y Varianza)
        beta_OLS = self.beta_OLS.values.reshape( -1, 1 )
        var_OLS = self.var_OLS.values
        
        #Creación de los errores estándar 
        beta_se = np.sqrt( np.diag( var_OLS ) )
        
        # Se calcula el test statistic para cada coeficiente para poder calcular los intervalos de confianza
        t_stat = beta_OLS.ravel() / beta_se.ravel()

        #Creación del p-value para creación de intervalos de confianza
        N = X.shape[ 0 ]
        k = beta_OLS.size
        pvalue = (1 - t.cdf(t_stat, df= N - k) ) * 2
        # defining index names
        index_names = self.columns
       

        # Creación de los intervalos de confianza de acuerdo a los betas estimados
        
        int1 = beta_OLS.ravel() + 1.96*beta_se
        int2 = beta_OLS.ravel() - 1.96*beta_se

        table_data ={  'Coef.'    : beta_OLS.ravel() , 
                       "Std.Err." : beta_se.ravel(),
                       "t"        : t_stat.ravel(),
                       "P>|t|"    : pvalue.ravel(), 
                       "[0.025"   : int1.ravel(),
                       "0.975]"   : int2.ravel()
                    }
        
        # defining a pandas dataframe 
        reg_OLS1 = pd.DataFrame( table_data , index = index_names )

        # Ponemos como atributo
        self.reg_se_interv = reg_OLS1
        
        return reg_OLS1 
    
    def pregunta_3_var_covar_robust( self ):
    
        X = self.X_np
            
        """
        De manera más fácil sería llamar al error como atributo calculado en la función anterior
        """
        # Necesito el atributo error (e)
        self.reg_var_OLS
        e = self.error
        
        # Número de observaciones = N
        N = X.shape[ 0 ] 
        
        # Matriz Varianza-Covarianza robusta: (X'X)^-1 * X' * Matriz_White * X * (X'X)^-1         
        
        # Matriz propuesta por White: error^2 * M.Identidad(MxM)
        # Para crearla, primero debo crear una matriz de paso: e x e'
        Matriz_de_paso = e @ e.T
        
        # En caso de que hubiera 4 observaciones:
        # e1^2 e1e2 e1e3 e1e4 
        # e2e1 e2^2 e2e3 e2e4 
        # e3e1 e3e2 e3^2 e3e4 
        # e4e1 e4e2 e4e3 e4^2
        
        # Ahora, debo diagonalizarla: 
        
        lista = np.arange(N)
        for i in lista:
            for j in lista: 
                if(i == j): 
                    Matriz_de_paso[i][j] = Matriz_de_paso[i][j]
                else:
                    Matriz_de_paso[i][j] = 0
        
        # De esa manera, obtendría la matriz de White
        # e1^2   0   0    0 
        #  0   e2^2  0    0 
        #  0     0  e3^2  0 
        #  0     0   0   e4^2
        Matriz_White = Matriz_de_paso
        
        # Ahora, calcularé la matriz robusta: 
        # Primero, (X'X)^-1
        Inversa = np.linalg.inv( X.T @ X )
        
        # (X'X)^-1 * X' * Matriz_White * X * (X'X)^-1         
        var_OLS_robusta = Inversa @ X.T @ Matriz_White @ X @ Inversa
        
        # Nombres de las columnas
        index_names = self.columns
        
        var_robusta = pd.DataFrame(var_OLS_robusta , index = index_names , columns = index_names )
        
        # Crearé un atributo con el valor de la matriz var-covar robusta.
        self.var_OLS_robusta = var_robusta

        return var_robusta
    
    def pregunta_3_parte_2( self ):
     
        # Los atributos de las funciones anteriores
        self.reg_beta_OLS()
        self.pregunta_3_var_covar_robust
        
        # X tomará el valor del atributo X_np
        X = self.X_np
        
        # La variable beta_OLS tomará los valores del output anterior transformado, aqui, a vector fila.
        beta_OLS = self.beta_OLS.values.reshape( -1, 1 )
        
        # La variable var_robust será igual al output de la función anterior 
        var_robust = self.var_robust
        
        """
        OJO: voy a calcular la desviación estándar con la matriz de var-covar robusta:
        """
        
        # Desviación estándar de los coeficientes estimados: (var(beta^))^0.5
        beta_desv_std = np.sqrt( np.diag( var_robust ) )

        N = X.shape[ 0 ] # Número de observaciones
        k = X.shape[ 1 ] # Número de regresores
    
        # Intervalos de confianza:
        
        # t_tabla -> Distribución T-Student al 95% de confianza.
        # bound = Desv. Estandar*t_tabla
        bound = beta_desv_std * stats.t.ppf( ( 1 + 0.95 ) / 2., N - k )
        
        # Límite superior =  Coeficiente + Desv. Estandar*t_stat
        lim_sup_robust = beta_OLS.ravel() + bound
        
        # Límite superior =  Coeficiente - Desv. Estandar*t_stat
        lim_inf_robust = beta_OLS.ravel() - bound   
    
        
        tabla = { 'desv. std. robusto' : beta_desv_std.ravel(),
                  'límite superior robusto' : lim_sup_robust.ravel(),
                  'límite inferior robusto' : lim_inf_robust.ravel()}
        
        # defining index names
        index_names = self.columns
       
        resultados_robustos = pd.DataFrame(tabla, index = index_names )

        # Crearé un atributo con el valor de la matriz var-covar robusta.
        self.result_robustos_OLS = resultados_robustos
        
        return resultados_robustos
    
    def rmse(self):
         
        suma = 0 
         
        for v in self.y_np:
            suma = suma + v
        
        media = suma/self.y_np.len()
        
        #columna = self.y_np
        
        columna = np.ones(self.y_np.len())
        
        y_dif= self.y_np - media * columna.T 
        
        sct = y_dif.T @ y_dif
        
        sce = self.error.T @ self.error
        
        R_2 = 1- (sce / sct)
        
        root = pow(sct/self.y_np.len(), 0.5)
        
        self.R_cuadrado = R_2
        
        self.root_mse = root
        
        R_2_root = {self.R_cuadrado, self.root_mse}
        
        return R_2_root

    def __mostrar_resultados (self):

    #Corremos las funciones pertinentes
        self.reg_OLS()
        self.pregunta_3_parte_2()
        self.rmse()
    
    # Generamos los resultados de los coeficientes estimados, errores estándar e intervalos de confianza, el R2 y el RMSE
        result_df ={  'Coef.'     : self.beta_OLS.flatten(), 
                      'desv. std. robusto' : self.beta_desv_std.flatten(),
                      'límite superior robusto' : self.lim_sup_robust.flatten(),
                      'límite inferior robusto' : self.lim_inf_robust.flatten()
             }
    # defining index names
        index_names = self.columns
        
    # Definimos estos dentro de un dataframe
        OLS_results = pd.DataFrame( result_df , index = index_names )
        return OLS_results
    
    # Creamos un diccionario que muestra todos los resultados
    
        final_results ={"OLS": OLS_results , "R_2" : self.R_cuadrado.flatten() ,
                                    "Root-MSE" : self.R_2_root.flatten()}

        return final_results
    
    
#Probando la clase
regress = RegClass(X, y)

# Hallamos los coeficientes de la regresión
regress.reg_beta_OLS()
        
# Hallamos la matriz de varianza y covarianza estándar, los errores estándar de cada coeficiente, e intervalos de confianza.
regress.reg_var_OLS()
regress.var_OLS

regress.reg_OLS()
regress.reg_se_interv

# Hallamos la matriz de varianza y covarianza robusta, los errores estándar de cada coeficiente, e intervalos de confianza.
regress.pregunta_3_var_covar_robust()
regress.var_robusta
regress.result_robustos_OLS

# Hallamos el R2, root MSE (mean square error)
regress.rmse()
regress.R_cuadrado    
regress.root_mse  

# Mostramos los resultados en un diccionario
regress.__mostrar_resultados()
regress.final_results
        
        
