# -*- coding: utf-8 -*-
"""
Created on Wed Aug 24 22:17:21 2022

@author: Roberto
"""
#%% If statement

"""
If statement

"""


import random
import numpy as np
import math

y = np.random.randint(-10, 10, 10)

if np.mean(y) >0 :
    
    dummy = 1
    
else :
    dummy = 1
        
print(dummy)

"""
Nested If statement

"""

# v = 2
v = np.nan
# v = "String"
# v = False


if isinstance( v, int ):
    print(v, " es numero entero (no missing)")
elif math.isnan(v):
    print(v, " es un missing")
elif isinstance( v, str ):
    print(v, " es un string") 
elif isinstance( v, bool ):
    print(v, " es un logical")     
else:
    print("Sin resultado")        
#%% While Loop

### If I have my savings today of S/.1,000.00. How much will my savings be worth
### in 10 years at an interest rate of 2.5%?

"     S_{y+1}	=S_{y}(1+i) "

#  sasve
S = 1000

# Periods
n = 10

# interes rate
i = 0.025


year = 1
while year < n:
    S =  S * i
    year += 1
    print( year, S)
    
    










