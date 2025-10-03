coclass 'jdictionary'

SIZE_GROWTH_GEOMETRIC_STEP =: 2

create =: {{)m
'index_type creation_parameters' =. y
select. index_type
case. 'hash' do.
  NB. Default values of params.
  keytype =: 4
  keyshape =: i. 0
  valuetype =: 4
  valueshape =: i. 0
  keyhash =: 16!:0`''
  keycompare =: 16!:0`''
  occupancy =: 0.5
  initsize =: 100
  NB. Parse params and update above attributes.
  parse creation_parameters
  NB. Init dictionary object in JE.
  internal_parameters =. (0 , initsize , <. initsize * % occupancy) ; '' ; (keytype ; keyshape) ; < (valuetype ; valueshape)
  if. keyhash -: keycompare do. keyfn =. keyhash `: 6 else. keyfn =. keyhash `: 6 : (keycompare `: 6) end.
  dict =: keyfn f. (16!:_1) internal_parameters 
  size =: initsize
  NB. Assign names.
  get =: dict 16!:_2
  put =: dict 16!:_3
  del =: dict 16!:_4
end.
EMPTY
}}

destroy =: codestroy

resize =: {{)m
size =: SIZE_GROWTH_GEOMETRIC_STEP * size
dict (16!:_1) 0 , size , <. size * % occupancy
}}

NB. Utils.
NB. Gives type ID (e.g. 4) from type name (e.g. integer).
typeid_from_typename =: {{)m
n =. 1 2 4 8 16 32 64 128 1024 2048 4096 8192 16384 32768 65536 131072 262144
n =. n , 5 6 7 9 10 11
n =. n , _1 NB. _1 if y is not a name of any type.
t =. '/boolean/literal/integer/floating/complex/boxed/extended/rational'
t =. t , '/sparse boolean/sparse literal/sparse integer/sparse floating'
t =. t , '/sparse complex/sparse boxed/symbol/unicode/unicode4'
t =. t , '/integer1/integer2/integer4/floating2/floating4/floating16'
n {~ (<;._1 t) i. < y 
}}

NB. Parse attribute and set its value.
parse =: {{)m
'attribute value' =: y
if. ('literal' -: datatype value) *. (attribute -: 'keytype') +. attribute -: 'valuetype' do.
  value =. typeid_from_typename value
end.
(attribute) =: value
EMPTY
}}"1
