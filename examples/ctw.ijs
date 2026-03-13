NB. Context-Tree Weighting method (lossless compression).
NB. https://ieeexplore.ieee.org/document/382012
NB. Numbers in the comments correspond to the formula numbers in the paper.

load 'dict'

ktratio =: >:@:+ %~ 1r2 + [ NB. (9).
f =: {.@[ 1r2&*@:+ (* {:)~ NB. (12).

NB. x is D.
NB. y is x(1 - D, T).
enc =: {{
'a b' =. 'jdict' (conew ,&< conew)~ 'hash' ,&< 'keytype' ; 'extended'
'pe pw' =. 'jdict' (conew ,&< conew)~ 'hash' ,&< ('keytype' ; 'extended') ,: 'valuetype' ; 'rational'
B =. 0x
for_bit. x }. y do.
  idxs =. (bit_index ,: x) (1x , 1x&(]F::(+ +:)));.0 y
  as =. 0 get__a idxs
  bs =. 0 get__b idxs
  pes =. 1x get__pe idxs
  NB. Dummy 0-update to find pc.
  pes1 =. pes * as ktratio bs NB. (9).
  pws1 =. 1x get__pw >:`<:@.(2&|) }. idxs
  pc =. ({: pes1) ]F.:f pws1 ,.~ }: pes1 NB. (14), (12).
  B =. B + pc * bit NB. (29).
  NB. Actual update of nodes.
  pes1 =. pes * as ktratio`(ktratio~)@.bit bs NB. (9).
  pes1 put__pe idxs
  idxs put__pw~ ({: pes1) |.@, ({: pes1) ]F::f pws1 ,.~ }: pes1 NB. (12).
  if. bit do. idxs put__b~ >: bs else. idxs put__a~ >: as end.
end.
NB. (36).
L =. >: 2 >.@:^. % get__pw~ 1
destroy__pw '' [ destroy__pe '' [ destroy__b '' [ destroy__a ''
F =. >.&.(*&(2x ^ L)) B
2 ~:/\ 0x , 0x ]F:.(+^:(F&>:@:+)) 1r2 ^ >: i. L
}}"0 1

NB. x is x(1 - D, 0)
NB. y is T ; c
dec =: {{
'T c' =. y
F =. +/@:(* 1r2 ^ #\) c NB. (35).
D =. # x
'a b' =. 'jdict' (conew ,&< conew)~ 'hash' ,&< 'keytype' ; 'extended'
'pe pw' =. 'jdict' (conew ,&< conew)~ 'hash' ,&< ('keytype' ; 'extended') ,: 'valuetype' ; 'rational'
B =. 0x
for. i. T do.
  idxs =. 1x , 1x ]F::(+ +:) (-D) {. x
  as =. 0 get__a idxs
  bs =. 0 get__b idxs
  pes =. 1x get__pe idxs
  NB. Dummy 0-update to find pc.
  pes1 =. pes * as ktratio bs NB. (9).
  pws1 =. 1x get__pw >:`<:@.(2&|) }. idxs
  pc =. ({: pes1) ]F.:f pws1 ,.~ }: pes1 NB. (14), (12).
  x =. x , bit =. F >: B + pc
  B =. B + pc * bit NB. (29).
  NB. Actual update of nodes.
  pes1 =. pes * as ktratio`(ktratio~)@.bit bs NB. (9).
  pes1 put__pe idxs
  idxs put__pw~ ({: pes1) |.@, ({: pes1) ]F::f pws1 ,.~ }: pes1 NB. (12).
  if. bit do. idxs put__b~ >: bs else. idxs put__a~ >: as end.
end.
destroy__pw '' [ destroy__pe '' [ destroy__b '' [ destroy__a ''
x
}}"1

NB. Example from paper.
0 1 1 1 0 0 0 0 0 1 -: 3 enc 0 1 0 0 1 1 0 1 0 0
0 1 0 0 1 1 0 1 0 0 -: 0 1 0 dec 7 ; 0 1 1 1 0 0 0 0 0 1

NB. Binary Bounded Memory Tree Source.
NB. x is Theta ,&< S (reversed suffixes in sorted order).
NB. y is T.
gen =: {{
'Theta S' =. x
D =. >./@:(#@>) S
s =. 0 $ 0
beta =. S&(#@[ {&Theta@:<:@:- (I.~ |.)~)
for. i. y do.
  s =. s , (? 0) < beta < |. (-D) {. s
end.
s
}}

NB. Example.
T =: 500
D =: 100 NB. 2 is sufficient for below tree source, but this is a test of dictionary.
NB. Fig. 1.
X =: (D # 0) , (0.5 0.3 0.1 ,&< 0 0 ; 0 1 ; , 1) gen T
C =: D enc X
Y =: (D # 0) dec T ; C
X -: Y
