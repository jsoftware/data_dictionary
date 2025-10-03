NB. INITIALIZATION.
NB. Test name attribute.
cocurrent 'base'

NB. y is name of dictionary without locale (different locales are added in the test).
test_dict_name =: {{)m
op_names_boxed =. (y , '_del') ; (y , '_get') ; y , '_put'
op_names_string =. ' ' joinstring op_names_boxed
check_names_z_ =: [: (3 -: +/@,) op_names_boxed E."0 1 nl

params =. 'hash' ,&< 'name' ; y , '_abc_'
dict =. params conew 'jdictionary'
echo check_names_abc_ ''
echo destroy__dict ''
erase_abc_ op_names_string

params =. 'hash' ,&< 'name' ; y
dict =. params conew 'jdictionary'
echo check_names_base_ ''
echo destroy__dict ''
erase_base_ op_names_string

params =. 'hash' ,&< 'name' ; y , '__'
dict =. params conew 'jdictionary'
echo check_names__ ''
echo destroy__dict ''
erase__ op_names_string

EMPTY
}}

test_dict_name 'mydict'
test_dict_name 'my_d_ict'
test_dict_name 'd_i_c_t'

NB. BASIC GET, PUT, DEL.
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
