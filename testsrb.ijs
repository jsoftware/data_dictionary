NB. Comprehensive test of put/del with tree auditing
]params =: 'tree' ,&< ('initsize' ; 200) , ('keytype' ; 4) , ('valueshape' ; '') , ('keyshape' ; '') ,: ('valuetype' ; 4)
mydict =: params conew 'jdictionary'
{{ dord =: ?~ #word [ word =: ?~ 80
(([: 0&(16!:_7) dict__mydict [ put__mydict)"0 +&100) word
([: 13!:8@8^:-. [: 0&(16!:_7) dict__mydict [ del__mydict)"0 +&100 ] dord}}"0 i. 20  NB. keep dic small to reduce audit time
destroy__mydict ''

NB. Test of getkv
]params =: 'tree' ,&< ('initsize' ; 20) , ('keytype' ; 4) , ('valueshape' ; '') , ('keyshape' ; '') ,: ('valuetype' ; 4)
mydict =: params conew 'jdictionary'
(100&+ put__mydict ]) 2 * i. 10
16!:_7 dict__mydict
1 1 1 1 getkv__mydict 3 11
{{
getkv_ref=.{{
1 1 1 1 getkv_ref y
:
'l r k val' =. 4 {.!.1 x   NB. flags
k0n =. y + (-.l,r) * 1 _1 * 0.0001  NB. apply end flags
km =. (#~  [: *./ k0n&(<:`>:"0 1)) 2 * i. 10
0&{::^:(2>#) (k,val) # km ; 100+km
}}
assert. 1 1&(getkv_ref -: getkv__mydict)@,"0/~ <: i. 22
assert. 1 0&(getkv_ref -: getkv__mydict)@,"0/~ <: i. 22
assert. 0 1&(getkv_ref -: getkv__mydict)@,"0/~ <: i. 22
assert. 0 0&(getkv_ref -: getkv__mydict)@,"0/~ <: i. 22
assert. 1 1 1 0&(getkv_ref -: getkv__mydict)@,"0/~ <: i. 22
assert. 1 1 0 1&(getkv_ref -: getkv__mydict)@,"0/~ <: i. 22
1
}}''
destroy__mydict ''
