# -*- coding: utf-8 -*-
"""
Created on Sat Sep  3 18:06:21 2022

@author: oa_da
"""

import numpy as np
 
def fdiscontinuous():
    x=np.arange(0,500,1)
    l=len(x)
    y=l
    for i in range(l):
        if (x[i]>0 and x[i]<100):
            print(y[i]==x[i]**1/2)
        elif (x[i]>100 and x[i]<300):
            print(y[i]==x[i]-5)
        elif (x[i]>300 and x[i]<500):
            print(y[i]==50)
    #El vector aleatorio se desarrollará a continuación 
vector=np.random.randint(0,500,20)
print (vector)
for range(vector) in fdiscontinuous():
print(range(vector))

