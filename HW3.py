import pandas as pd
from pandas import Series, DataFrame

data = {'a': [1,4,9],
        'b': [3,8,7],
        'c': [5,2,3],
        'd': [9,9,4]}
frame = pd.DataFrame(data)
frame
frame2 = DataFrame(data,columns=['a','b','c','d','E'])
frame2
val = Series(['abcd', 'cabd', 'cdba'])
frame2['E']=val
frame2.sort_values(by='E')