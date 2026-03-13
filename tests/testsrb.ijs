NB. Comprehensive test of put/del with tree auditing
]params =: 'tree' ,&< ('initcapacity' ; 200)
mydict =: params conew 'jdict'
{{ dord =: ?~ #word [ word =: ?~ 80
(([: 0&(16!:_7) dict__mydict [ put__mydict)"0 +&100) word
([: 13!:8@8^:-. [: 0&(16!:_7) dict__mydict [ del__mydict)"0 +&100 ] dord}}"0 i. 20  NB. keep dic small to reduce audit time
destroy__mydict ''

NB. Test of mget
d =: ('tree',&< '') conew 'jdict'
put__d~ +: i. 10
1 (16!:_7) dict__d
(+: ([+i.@-~)/4 9) -: 2b1011 mget__d +: 4 8
(+: ([+i.@-~)/6 10) -: 2b1011 mget__d +: 6 11
(+: ([+i.@-~)/6 10) -: 2b1001 mget__d +: 6 11
(+: ([+i.@-~)/2 4) -: 2b1001 mget__d +: 2 4
(+: ([+i.@-~)/0 4) -: 2b1010 mget__d +: _2 3
(+: ([+i.@-~)/0 4) -: 2b1011 mget__d +: _2 3
(+: ([+i.@-~)/6 10) -: 2b1010 mget__d +: 5 9
(+:([+i.@-~)/1 6) -: 2b1000 mget__d +: 0 6
(+: ([+i.@-~)/2 5) -: 2b1011 mget__d 3 9
(+: ([+i.@-~)/2 5) -: 2b1010 mget__d 3 9
(+: ([+i.@-~)/2 5) -: 2b1001 mget__d 3 9
(+: ([+i.@-~)/2 5) -: 2b1000 mget__d 3 9

(0 {. +: ([+i.@-~)/4 9) -: (2b1011 0) mget__d +: 4 8
(1 {. +: ([+i.@-~)/4 9) -: (2b1011 1) mget__d +: 4 8
(2 {. +: ([+i.@-~)/4 9) -: (2b1011 2) mget__d +: 4 8
(+: ([+i.@-~)/4 9) -: (2b1011 _1) mget__d +: 4 8

('') -: (2b1011 0) mget__d 4
('') -: (2b1010 0) mget__d 4
('') -: (2b1001 0) mget__d 4
('') -: (2b1000 0) mget__d 4
(,4) -: (2b1011 1) mget__d 4
(,6) -: (2b1010 1) mget__d 4
(,4) -: (2b1001 1) mget__d 4
(,2) -: (2b1000 1) mget__d 4
(4) -: (2b1011) mget__d 4
(6) -: (2b1010) mget__d 4
(4) -: (2b1001) mget__d 4
(2) -: (2b1000) mget__d 4
(,6) -: (2b1011 1) mget__d 5
(,6) -: (2b1010 1) mget__d 5
(,4) -: (2b1001 1) mget__d 5
(,4) -: (2b1000 1) mget__d 5
4 6 -: (2b1011 2) mget__d 4
6 8 -: (2b1010 2) mget__d 4
2 4 -: (2b1001 2) mget__d 4
0 2 -: (2b1000 2) mget__d 4
6 8 -: (2b1011 2) mget__d 5
6 8 -: (2b1010 2) mget__d 5
2 4 -: (2b1001 2) mget__d 5
2 4 -: (2b1000 2) mget__d 5

('') -: 2b1000 0 mget__d ''
(+: i. 1) -: 2b1000 1 mget__d ''
(+: i. 2) -: 2b1000 2 mget__d ''
(+: i. 3) -: 2b1000 3 mget__d ''
(+: 9 - i. _1) -: 2b1001 1 mget__d ''
(+: 9 - i. _2) -: 2b1001 2 mget__d ''
(+: 9 - i. _3) -: 2b1001 3 mget__d ''

destroy__d ''
