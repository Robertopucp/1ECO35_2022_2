#%% Grupo 1. Miembros del grupo:

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Egusquiza 
# 20163377, Jean Ni?o de Guzm?n

#%% Pregunta 2

##### Para vector:

# Previamente, definimos a una vector de 100 elementos.
vector <- matrix(rnorm(100), 1, 100)

# Utilizamos lapply para aplicar una funci?n sobre el vector predefinido z
# Definimos los par?metros de la funci?n, que ser?n n, min y max. 
# Luego, escribimos la ecuaci?n para reescalar, el cual ser? el output de nuestra funci?n.
# Finalmente, debemos definir afuera los par?metros min y max, que son los valores m?nimos y m?ximos de cada columna.

reescalar_vector <- lapply (vector, function(n, min, max){
  out = (n - min)/(max - min)
  return(out)
}, min = min(vector), max = max(vector))

##### Para matriz:
# De manera parecida al ejercicio anterior, creamos ahora una matriz con 100 filas y 50 columnas.
matriz <- matrix(rnorm(500), 100, 50)

# Ahora, aplicamos apply, ya que se trata de una matriz.
# Con Margin = 2 tomar? a la columna como criterio.
# Luego, definimos qu? har? nuestra funci?n, de modo que, al emplear min() y max(),
# tomar? el valor m?ximo y m?nimo de cada columna por el margins = 2 definido previamente.

reescalar_matriz <- apply (matriz, 2, function(n){
  (n-min(n))/(max(n)-min(n))
} )