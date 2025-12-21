require 'format/printf'   NB. for debug only

PRBATCH =: 0   NB. 1 to display batch ops
INDEX_TYPES =: ('hash concurrent' ; 'tree concurrent')&,^:IF64 'hash' ; 'tree'

NB. INITIALIZATION.
NB. Test name attribute.
NB. x is boxed name of index type.
NB. y is name of dictionary without locale (different locales are added in the test).
test_dict_name =: {{)d
op_names_boxed =. (y , '_del') ; (y , '_get') ; y , '_put'
op_names_string =. ' ' joinstring op_names_boxed
check_names_z_ =: [: (3 -: +/@,) op_names_boxed E."0 1 nl

params =. x , < 'name' ; y , '_abc_'
dict =. params conew 'jdictionary'
assert. check_names_abc_ ''
assert. destroy__dict ''
erase_abc_ op_names_string

params =. x , < 'name' ; y
dict =. params conew 'jdictionary'
assert. check_names_base_ ''
assert. destroy__dict ''
erase_base_ op_names_string

params =. x , < 'name' ; y , '__'
dict =. params conew 'jdictionary'
assert. check_names__ ''
assert. destroy__dict ''
erase__ op_names_string

EMPTY
}}"0 _

INDEX_TYPES test_dict_name 'mydict'
INDEX_TYPES test_dict_name 'my_d_ict'
INDEX_TYPES test_dict_name 'd_i_c_t'

NB. INCORRECT KEYS/VALUES.

GetError =: {{)a
u :: (<:@(13!:11)@'' >@{ 9!:8@'')
}}

{{
params =. y , < 'valueshape' ; 5
jdict =. params conew 'jdictionary'
assert. 'domain error' -: (i. 5) put__jdict GetError 2.3 3.4
assert. 'domain error' -: (2 5 $ 'abcde') put__jdict GetError 0 1
assert. 'domain error' -: (3 5 $ 3.14) put__jdict GetError 2 3 4
assert. 'rank error' -: _1 get__jdict GetError 100
assert. 'domain error' -: get__jdict GetError 3.14
assert. 'domain error' -: has__jdict GetError 2r3 3r4
assert. 'domain error' -: del__jdict GetError 'abc'
destroy__jdict ''
EMPTY
}}"0 INDEX_TYPES

NB. TYPES AND SHAPES.

coclass 'naivedictionary'

create =: {{
keys =: 0 $ a:
vals =: 0 $ a:
}}

destroy =: codestroy

has =: {{ keys e.~ < y }}

put =: {{
del y
keys =: keys , < y
vals =: vals , < x
EMPTY
}}

get =: {{ > vals {~ keys i. < y }}

del =: {{
idx =. keys i. < y
if. idx < # keys do.
  keys =: keys -. < y
  vals =: (idx {. vals) , (>: idx) }. vals
end.
assert. (# keys) -: # vals
EMPTY
}}

cocurrent 'base'

rand_integer =: {{ >: ? <. 3 }}
rand_floating =: {{ 8 c. -: rand_integer '' }}
rand_boolean =: {{ ? 2 }}
rand_byte =: {{ ({~ ?@#) 'abc' }}
rand_complex =: {{ (rand_floating '') j. rand_floating '' }}
rand_extended =: {{ x: rand_integer '' }}
rand_rational =: {{ x: rand_floating '' }}
rand_boxed =: {{ < (2 3 $ rand_complex '') ; 1 2 $ rand_integer '' }}

NB. x is jdict
NB. y is gerund generating atom of keytype  ;
NB.      gerund generating atom of valuetype ;
NB.      shape of key ;
NB.      shape of value ;
NB.      shape of batch ;
NB.      number of iterations
test_type =: {{)d
'genkey genval keyshape valshape batchshape n_iter' =. y
naivedict =. '' conew 'naivedictionary'
keyrank =. # keyshape
valrank =. # valshape
for. i. n_iter do.
  NB. Put.
  keys =. (batchshape , keyshape) genkey"0@$ 0
  vals =. (batchshape , valshape) genval"0@$ 0
  vals put__naivedict"(valrank , keyrank) keys
  vals put__x keys
  NB. Get.
  keys =. (batchshape , keyshape) genkey"0@$ 0
  vals =. (batchshape , valshape) genval"0@$ 0
  naivemask =. has__naivedict"keyrank keys
  fillatom =. {. valuetype__x c. ''
  jgetans =. (valshape $ fillatom) get__x keys
  jhasans =. has__x keys
  jmask =. +./@,"valrank ] fillatom ~: jgetans
  assert. jmask -: jhasans
  assert. jmask -: naivemask
  naivegetans =. get__naivedict"keyrank (, naivemask) # (_ , keyshape) ($ ,) keys
  if. 1 -: +./ , naivemask do.
    assert. naivegetans -: (, jmask) # (_ , valshape) ($ ,) jgetans
  end.
  NB. Delete.
  keys =. ((<. -: batchshape) , keyshape) genkey"0@$ 0
  del__naivedict"keyrank keys
  del__x keys
end.
destroy__naivedict ''
destroy__x ''
EMPTY
}}

{{
keyshape =. 3 2
valueshape =. 5 8
params =. y , < ('keytype' ; 'boolean') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_boolean`'' ; rand_integer`'' ; keyshape ; valueshape ; 5 25 ; 100

keyshape =. 2 3
valueshape =. 4 5 4
params =. y , < ('valuetype' ; 'floating') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_integer`'' ; rand_floating`'' ; keyshape ; valueshape ; 100 ; 100

keyshape =. 7 1
valueshape =. 1 7
params =. y , < ('keytype' ; 'floating') , ('valuetype' ; 'complex') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_floating`'' ; rand_complex`'' ; keyshape ; valueshape ; 10 10 ; 100

keyshape =. 3 3
valueshape =. 2 2 2
params =. y , < ('keytype' ; 'complex') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_complex`'' ; rand_integer`'' ; keyshape ; valueshape ; 2 3 4 5 ; 100

keyshape =. 9
valueshape =. 10
params =. y , < ('keytype' ; 'extended') , ('valuetype' ; 'rational') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_extended`'' ; rand_rational`'' ; keyshape ; valueshape ; 7 7 ; 100

keyshape =. 5
valueshape =. 6
params =. y , < ('keytype' ; 'rational') , ('valuetype' ; 'literal') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_rational`'' ; rand_byte`'' ; keyshape ; valueshape ; 3 2 ; 100

keyshape =. 8
valueshape =. 5 5
params =. y , < ('keytype' ; 'literal') , ('valuetype' ; 'extended') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_byte`'' ; rand_extended`'' ; keyshape ; valueshape ; 100 ; 100

keyshape =. 2 2
valueshape =. 2 4
params =. y , < ('keytype' ; 'boxed') , ('valuetype' ; 'boxed') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_boxed`'' ; rand_boxed`'' ; keyshape ; valueshape ; 25 2 ; 100
}}"0 INDEX_TYPES

{{
keyshape =. 3 2
valueshape =. 5 8
params =. y , < ('keytype' ; 'boolean') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_boolean`'' ; rand_integer`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 2 3
valueshape =. 4 5 4
params =. y , < ('valuetype' ; 'floating') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_integer`'' ; rand_floating`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 7 1
valueshape =. 1 7
params =. y , < ('keytype' ; 'floating') , ('valuetype' ; 'complex') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_floating`'' ; rand_complex`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 3 3
valueshape =. 2 2 2
params =. y , < ('keytype' ; 'complex') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_complex`'' ; rand_integer`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 9
valueshape =. 10
params =. y , < ('keytype' ; 'extended') , ('valuetype' ; 'rational') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_extended`'' ; rand_rational`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 5
valueshape =. 6
params =. y , < ('keytype' ; 'rational') , ('valuetype' ; 'literal') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_rational`'' ; rand_byte`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 8
valueshape =. 5 5
params =. y , < ('keytype' ; 'literal') , ('valuetype' ; 'extended') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_byte`'' ; rand_extended`'' ; keyshape ; valueshape ; (i. 0) ; 3000

keyshape =. 2 2
valueshape =. 2 4
params =. y , < ('keytype' ; 'boxed') , ('valuetype' ; 'boxed') , ('keyshape' ; keyshape) ,: ('valueshape' ; valueshape)
jdict =. params conew 'jdictionary'
jdict test_type rand_boxed`'' ; rand_boxed`'' ; keyshape ; valueshape ; (i. 0) ; 3000
}}"0 INDEX_TYPES

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

NB. x is boxed name of index type.
NB. y is initial size ; number of batches (iterations) ; size of batch ; max element.
test_batches =: {{)d
'initsz n_iter sz mx' =. y
refdict =. conew 'refdictionary'
params =. x , < ('initsize' ; initsz) ,: ('keytype' ; 'boxed')
jdict =. params conew 'jdictionary'
for. i. n_iter do.
  keys =. <@":"0 vals =. sz ?@$ mx NB. Keys, vals for put.
  keys (>@[ set__refdict ])"0 vals
qprintf^:PRBATCH'$keys keys $vals vals '
  vals put__jdict keys
  keys =. <@":"0 vals =. sz ?@$ mx NB. New keys, vals for queries.
qprintf^:PRBATCH'$keys keys $vals vals '
  refmask =. has__refdict@> keys
  jgetans =. _1 get__jdict keys
  jhasans =. has__jdict keys
  jmask =. 0 <: jgetans
qprintf^:PRBATCH'jgetans refmask jmask '
  assert. jmask -: jhasans
  assert. jmask -: refmask
  if. 1 -: +./ refmask do. NB. Reference dictionary fails for get__refdict@> 0 $ 0
    assert. (refmask # vals) -: get__refdict@> refmask # keys
  end.
  assert. (jmask # vals) -: jmask # jgetans
  del__refdict keys =. (sz ?@$ 2) # keys NB. Delete some keys.
  del__jdict keys
end.
destroy__refdict ''
destroy__jdict ''
EMPTY
}}"0 _

NB. RUN BATCHES.

INDEX_TYPES test_batches 21 ; 10000 ; 10 ; 20
INDEX_TYPES test_batches 3 ; 10000 ; 10 ; 20
INDEX_TYPES test_batches 142 ; 1000 ; 100 ; 200
INDEX_TYPES test_batches 7 ; 100 ; 1000 ; 2000
INDEX_TYPES test_batches 200001 ; 5 ; 100000 ; 200000
