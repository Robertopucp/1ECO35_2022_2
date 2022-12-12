#!pip install openpyxl
#importar la librería pandas 
import pandas as pd
import os

user = os.getlogin()   # Username
#se cambia el directorio de trabajo 

os.chdir(f"C:/Users/{user}/Desktop/trabfinal") 	

#se exporta los dataframes para los años desde 2014 hasta 2021, para luego editarlos

#2014
    
det2014 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2014.xlsx", sheet_name='Hoja1')

det2014.drop([0],axis=0)
det2014=det2014.drop([0],axis=0)
print (det2014)

#renombrar columnas 
det2014.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2014.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 
#se eliminan las columnas bimestrales, para solo quedarse con las anuales
det2014.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

#se eliminan las columnas de Establecimiento de Salud e Instituciones educativas  
det2014.drop([10, 11],axis=0)
det2014=det2014.drop([10, 11],axis=0)

det2014.drop([13],axis=0)
det2014=det2014.drop([13],axis=0)

det2014.drop([1],axis=0)
det2014=det2014.drop([1],axis=0)


det2014=det2014.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2014.rename(columns={"INFORMACION BIMESTRAL 2014 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)

det2014.rename(columns={"Anual": "2014"}, inplace=True)

#este proceso de replica para los siguientes años
#2015

det2015 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2015.xlsx", sheet_name='Hoja1')

det2015.drop([0],axis=0)
det2015=det2015.drop([0],axis=0)
print (det2015)

#renombrar columnas 
det2015.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2015.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2015.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2015=det2015.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2015.drop([10, 11],axis=0)
det2015=det2015.drop([10, 11],axis=0)

det2015.drop([13],axis=0)
det2015=det2015.drop([13],axis=0)

det2015.drop([1],axis=0)
det2015=det2015.drop([1],axis=0)


det2015.rename(columns={"INFORMACION BIMESTRAL 2015 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)


det2015.rename(columns={"Anual": "2015"}, inplace=True)

#2016

det2016 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2016.xlsx", sheet_name='Hoja1')

det2016.drop([0],axis=0)
det2016=det2016.drop([0],axis=0)
print (det2016)

#renombrar columnas 
det2016.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2016.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2016.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2016=det2016.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2016.drop([10, 11],axis=0)
det2016=det2016.drop([10, 11],axis=0)

det2016.drop([13],axis=0)
det2016=det2016.drop([13],axis=0)

det2016.drop([1],axis=0)
det2016=det2016.drop([1],axis=0)

det2016.rename(columns={"INFORMACION BIMESTRAL 2016 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)

det2016.rename(columns={"Anual": "2016"}, inplace=True)

#2017

det2017 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2017.xlsx", sheet_name='Hoja1')

det2017.drop([0],axis=0)
det2017=det2017.drop([0],axis=0)
print (det2017)

#renombrar columnas 
det2017.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2017.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2017.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2017=det2017.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2017.drop([10, 11],axis=0)
det2017=det2017.drop([10, 11],axis=0)

det2017.drop([13],axis=0)
det2017=det2017.drop([13],axis=0)

det2017.drop([1],axis=0)
det2017=det2017.drop([1],axis=0)


det2017.rename(columns={"INFORMACION BIMESTRAL 2017 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)

det2017.rename(columns={"Anual": "2017"}, inplace=True)


#2018

det2018 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2018.xlsx", sheet_name='Hoja1')

det2018.drop([0],axis=0)
det2018=det2018.drop([0],axis=0)
print (det2018)

#renombrar columnas 
det2018.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2018.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2018.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2018=det2018.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2018.drop([10, 11],axis=0)
det2018=det2018.drop([10, 11],axis=0)

det2018.drop([13],axis=0)
det2018=det2018.drop([13],axis=0)

det2018.drop([1],axis=0)
det2018=det2018.drop([1],axis=0)

det2018.rename(columns={"INFORMACION BIMESTRAL 2018 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)
det2018.rename(columns={"Anual": "2018"}, inplace=True)



#2019

det2019 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2019.xlsx", sheet_name='Hoja1')

det2019.drop([0],axis=0)
det2019=det2019.drop([0],axis=0)
print (det2019)

#renombrar columnas 
det2019.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2019.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2019.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2019=det2019.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2019.drop([10, 11],axis=0)
det2019=det2019.drop([10, 11],axis=0)

det2019.drop([13],axis=0)
det2019=det2019.drop([13],axis=0)

det2019.drop([1],axis=0)
det2019=det2019.drop([1],axis=0)

det2019.rename(columns={"INFORMACION BIMESTRAL 2019 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)


det2019.rename(columns={"Anual": "2019"}, inplace=True)


#2020
det2020 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2020.xlsx", sheet_name='Hoja1')

det2020.drop([0],axis=0)
det2020=det2020.drop([0],axis=0)
print (det2020)

#renombrar columnas 
det2020.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2020.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2020.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2020=det2020.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2020.drop([10, 11],axis=0)
det2020=det2020.drop([10, 11],axis=0)

det2020.drop([13],axis=0)
det2020=det2020.drop([13],axis=0)

det2020.drop([1],axis=0)
det2020=det2020.drop([1],axis=0)


det2020.rename(columns={"INFORMACION BIMESTRAL 2020 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)

det2020.rename(columns={"Anual": "2020"}, inplace=True)

#2021

det2021 = pd.read_excel(f"C:/Users/{user}/Desktop/trabfinal/VRAEM 2021.xlsx", sheet_name='Hoja1')

det2021.drop([0],axis=0)
det2021=det2021.drop([0],axis=0)
print (det2021)

#renombrar columnas 
det2021.rename(columns={"Unnamed: 7": "Anual"}, inplace=True)

det2021.rename(columns={"Unnamed: 1": "I BIMESTRE", "Unnamed: 2":"II BIMESTRE", "Unnamed: 3": "III BIMESTRE", "Unnamed: 4": "IV BIMESTRE", "Unnamed: 5": "V BIMESTRE", "Unnamed: 6": "VI BIMESTRE"}, inplace=True)
 

det2021.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)
det2021=det2021.drop(['I BIMESTRE','II BIMESTRE', 'III BIMESTRE','IV BIMESTRE','V BIMESTRE', 'VI BIMESTRE'], axis=1)

det2021.drop([10, 11],axis=0)
det2021=det2021.drop([10, 11],axis=0)

det2021.drop([13],axis=0)
det2021=det2021.drop([13],axis=0)

det2021.drop([1],axis=0)
det2021=det2021.drop([1],axis=0)

det2021.rename(columns={"INFORMACION BIMESTRAL 2021 - VRAEM: InfoJUNTOS": "Reporte"}, inplace=True)

det2021.rename(columns={"Anual": "2021"}, inplace=True)



#utilizamos merge para poder agrupar los dataframe (de dos en dos)
det1514=pd.merge(det2014, det2015, on='Reporte', how='inner')
det1614=pd.merge(det1514, det2016, on='Reporte', how='inner')
det1714=pd.merge(det1614, det2017, on='Reporte', how='inner')
det1814=pd.merge(det1714, det2018, on='Reporte', how='inner')
det1914=pd.merge(det1814, det2019, on='Reporte', how='inner')
det1420=pd.merge(det1914, det2020, on='Reporte', how='inner')
det1421=pd.merge(det1420, det2021, on='Reporte', how='inner')


#finalmente, det1421 representa el dataframe que agrupa los dataframe para cada año desde 2014 hasta 2021 (en términos anuales) 
#trasponemos el dataframe 

dataframefinal=det1421.transpose()

print(dataframefinal)

#se obtiene de el dataframefinal 



