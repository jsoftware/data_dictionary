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
assert. check_names_abc_ ''
assert. destroy__dict ''
erase_abc_ op_names_string

params =. 'hash' ,&< 'name' ; y
dict =. params conew 'jdictionary'
assert. check_names_base_ ''
assert. destroy__dict ''
erase_base_ op_names_string

params =. 'hash' ,&< 'name' ; y , '__'
dict =. params conew 'jdictionary'
assert. check_names__ ''
assert. destroy__dict ''
erase__ op_names_string

EMPTY
}}

test_dict_name 'mydict'
test_dict_name 'my_d_ict'
test_dict_name 'd_i_c_t'

NB. BASIC GET, PUT.
cocurrent 'base'
]params =: 'hash' ,&< ('initsize' ; 10) , ('occupancy' ; 0.66) , ('keytype' ; 'integer') , ('valueshape' ; 3) , ('keyshape' ; 2) ,: ('valuetype' ; 4)
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
get__mydict 5 6

destroy__mydict ''

NB. GET, PUT, DEL IN BATCHES.
NB. Keys are boxed strings, values are integers.

NB. https://code.jsoftware.com/wiki/Essays/DataStructures
coclass 'refdictionary'
create =: 0:
destroy =: codestroy
okchar =: ~. (,toupper) '0123456789abcdefghijklmnopqrstuz'
ok =: ] [ [: assert [: *./ e.&okchar
intern =: [: ('z' , ok)&.> boxxopen
has =: _1 < nc@intern
set =: {{ empty (intern x) =: y }}
get =: ".@>@intern
del =: erase@intern

cocurrent 'base'
9!:39 ] 3 13 NB. It makes refdictionary faster.

NB. x is initsize ; occupancy.
NB. y is number of batches (iterations) ; size of batch ; max element.
test_batches =: {{)d
'initsz occupancy' =. x
'n_iter sz mx' =. y
refdict =. conew 'refdictionary'
params =. 'hash' ,&< ('initsize' ; initsz) , ('occupancy' ; occupancy) ,: ('keytype' ; 'boxed')
jdict =. params conew 'jdictionary'
for. i. n_iter do.
  keys =. <@":"0 vals =. sz ?@$ mx NB. Keys, vals for put.
  keys (>@[ set__refdict ])"0 vals
  vals put__jdict keys
  keys =. <@":"0 vals =. sz ?@$ mx NB. New keys, vals for queries.
  refmask =. has__refdict@> keys
  jgetans =. _1 get__jdict keys
  jmask =. 0 <: jgetans
  assert. jmask -: refmask
  assert. (refmask # vals) -: get__refdict@> refmask # keys
  assert. (jmask # vals) -: jmask # jgetans
  del__refdict keys =. (sz ?@$ 2) # keys NB. Delete some keys.
  del__jdict keys
end.
destroy__refdict ''
destroy__jdict ''
EMPTY
}}

(27 ; 0.7) test_batches 5 ; 10 ; 20
(207 ; 0.6) test_batches 10 ; 100 ; 200
(200007 ; 0.8) test_batches 5 ; 100000 ; 200000
