#%% Grupo 1. Miembros del grupo:

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Egusquiza 
# 20163377, Jean Niño de Guzmán

#%% Pregunta 2

##### Para vector:

# Previamente, definimos a una vector de 100 elementos.
vector <- matrix(rnorm(100), 1, 100)

# Utilizamos lapply para aplicar una función sobre el vector predefinido z
# Definimos los parámetros de la función, que serán n, min y max. 
# Luego, escribimos la ecuación para reescalar, el cual será el output de nuestra función.
# Finalmente, debemos definir afuera los parámetros min y max, que son los valores mínimos y máximos de cada columna.

reescalar_vector <- lapply (vector, function(n, min, max){
  out = (n - min)/(max - min)
  return(out)
}, min = min(vector), max = max(vector))

##### Para matriz:
# De manera parecida al ejercicio anterior, creamos ahora una matriz con 100 filas y 50 columnas.
matriz <- matrix(rnorm(500), 100, 50)

# Ahora, aplicamos apply, ya que se trata de una matriz.
# Con Margin = 2 tomará a la columna como criterio.
# Luego, definimos qué hará nuestra función, de modo que, al emplear min() y max(),
# tomará el valor máximo y mínimo de cada columna por el margins = 2 definido previamente.

reescalar_matriz <- apply (matriz, 2, function(n){
  (n-min(n))/(max(n)-min(n))
} )