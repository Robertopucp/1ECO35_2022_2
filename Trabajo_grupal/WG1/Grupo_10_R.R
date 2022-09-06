#Pregunta 4
#crear una base de datos a usar exportados de excel
data <- read.delim("clipboard")
data
str(data)
names(data)


#regresión por MCO
reg1 = lm(data = data, formula= v001 - V002+V003+V004+V007+V008+V009+V010)
summary(reg1)
