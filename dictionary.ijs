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
  occupancy =: 0.5
  initsize =: 100
  name =: ''
  NB. Parse params and update above attributes.
  parse creation_parameters
  NB. Init dictionary object in JE.
  internal_parameters =. (0 , initsize , <. initsize * % occupancy) ; '' ; (keytype ; keyshape) ; < (valuetype ; valueshape)
  dict =: 16!:0 (16!:_1) internal_parameters NB. FIXME - keyhash (gerund) instead of 16!:0 as x for 16!:_1 causes domain error!
  size =: initsize
  NB. Assign names.
  if. name -: '' do.
    get =: dict 16!:_2
    put =: dict 16!:_3
    del =: dict 16!:_4
  else.
    'prefix suffix' =. split_name name
    (prefix , '_get' , suffix) =: dict 16!:_2
    (prefix , '_put' , suffix) =: dict 16!:_3
    (prefix , '_del' , suffix) =: dict 16!:_4
  end.
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

NB. y is string representing a name with possibly specified locale. Returns two boxes: name ; suffix with locale.
NB. Right part of hook.
NB. If '_' is the last character of y then the name has explicitly specified locale, so get the indexes of '_'.
NB. Left part of hook.
NB. Use the indexes to split the name or if the number of indexes is less than 2 then suppose name is from base.
NB. Note that number of indexes may be smaller then number of '_' e.g. 0 when condition from right part of the hook was false.
split_name =: ('__' ,~&< [)`(({. ,&< }.)~ _2&{)@.(2 <: #@])  ''"_`([: I. '_'&=)@.('_' -: {:)
