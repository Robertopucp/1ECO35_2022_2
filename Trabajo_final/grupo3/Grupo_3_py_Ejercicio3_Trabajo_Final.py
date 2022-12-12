#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import contextily as cx  # Fondo Goole maps, fondo de mapa
import geopandas as gpd  # manejo de datos georeferenciados
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.lines import Line2D


dist_mita = gpd.read_file(r'C:\Users\oscar\OneDrive\Documentos\GitHub\1ECO35_2022_2\data\Mita\mita.gdb', layer=5)

pot1 = r'C:\Users\oscar\OneDrive\Documentos\GitHub\1ECO35_2022_2\Trabajo_final\datos\Mita\pot_line.shp'
pot2 = r'C:\Users\oscar\OneDrive\Documentos\GitHub\1ECO35_2022_2\Trabajo_final\datos\Mita\huan_line.shp'
pot3 = r'C:\Users\oscar\OneDrive\Documentos\GitHub\1ECO35_2022_2\Trabajo_final\datos\Mita\MitaBoundary.shp'

varpot1 = gpd.read_file(pot1)
varpot2 = gpd.read_file(pot2)
varpot3 = gpd.read_file(pot3)

# Estandarizando

varpot1 = varpot1.to_crs('EPSG:4326')
varpot2 = varpot2.to_crs('EPSG:4326')
varpot3 = varpot3.to_crs('EPSG:4326')

fig = plt.figure()

ax = fig.add_subplot(111)
var0 = gpd.pd.concat([varpot1, varpot2])

var0.plot(color = 'black', markersize = 6, ax = ax, marker = 'o', label = 'Study Boundary')
varpot3.plot(color = 'grey', linewidth = 2, ax = ax, label = 'Mita Boundary')

cx.add_basemap(ax=ax, crs='EPSG:4326', source=cx.providers.OpenTopoMap)

plt.xticks([])
plt.yticks([])

fig.text(0.70,0.31,'Potosi',color = 'red', size = 7,
        bbox=dict(facecolor='none', edgecolor='none', pad=5.0))
fig.text(0.60,0.26,'Uyuni\nSalt Flat',color = 'red', size = 8,
        bbox=dict(facecolor='none', edgecolor='none', pad=5.0))
fig.text(0.26,0.73,'Huancavelica',color = 'blue', size = 8,
        bbox=dict(facecolor='none', edgecolor='none', pad=5.0))

plt.legend(loc='upper left', title = '', frameon = True, bbox_to_anchor = (0,0.15), prop={'size':9})

plt.show()

