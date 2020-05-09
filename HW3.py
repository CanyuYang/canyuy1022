import numpy as np
import pandas as pd
from pandas import Series, DataFrame

data = np.random.randint(1,10,size=(3,4))
data
frame = pd.DataFrame(data,columns=['d','c','b','a'])
frame
frame = frame.sort_index(axis=1)
frame2 = DataFrame(frame,columns=['a','b','c','d','E'])
frame2
val = Series(['abcd', 'cabd', 'cdba'])
frame2['E']=val
frame2
