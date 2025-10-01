NB. Basic.
cocurrent 'base'
]params =: 'hash' ,&< ('initsize' ; 4) , ('occupancy' ; 0.66) , ('keytype' ; 'integer') , ('valueshape' ; 3) , ('keyshape' ; 2) ,: ('valuetype' ; 4)
mydict =: params conew 'jdictionary'

1 2 3 put__mydict 2 3
get__mydict 2 3
4 5 6 put__mydict 1 3
get__mydict 1 3

2 3 4 put__mydict 4 5
3 4 5 put__mydict 5 6

get__mydict 2 3 , 4 5 ,: 5 6
get__mydict 1 3

4 5 6 put__mydict 6 7

del__mydict 5 6
get__mydict 5 6
