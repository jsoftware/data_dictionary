NB. INITIALIZATION.
NB. Test name attribute.
cocurrent 'base'

require 'format/printf'   NB.  for debug only

PRBASIC=:1   NB. 1 to display simple ops
PRBATCH=:0   NB. 1 to display batch ops


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
]params =: 'hash' ,&< ('initsize' ; 4) , ('occupancy' ; 0.66) , ('keytype' ; 'integer') , ('valueshape' ; 3) , ('keyshape' ; 2) ,: ('valuetype' ; 4)
mydict =: params conew 'jdictionary'

qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
1 2 3 put__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
1 2 3 -: get__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
7 8 9 put__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
7 8 9 -: get__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(1 2 3,:4 5 6) put__mydict 2 3,:2 3  NB. Double put existent
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
4 5 6 -: get__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
del__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(5 6 7,:1 2 3) put__mydict 2 3,:2 3  NB. Double put nonexistent
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
1 2 3 -: get__mydict 2 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
4 5 6 put__mydict 1 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
4 5 6 -: get__mydict 1 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
2 3 4 put__mydict 4 5
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
3 4 5 put__mydict 5 6
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(_3 ]\ 1 2 3 2 3 4 3 4 5) -: get__mydict 2 3 , 4 5 ,: 5 6
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
4 5 6 -: get__mydict 1 3
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(4 5 6,:5 6 7) put__mydict 6 7,:7 8
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
3 4 5 -: get__mydict 5 6
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
get__mydict :: (100"_) 7 7
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
90 91 92 -: 90 91 92 get__mydict 7 7
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
50 51 52 put__mydict 7 7  NB. Put to nonexistent
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
50 51 52 -: get__mydict 7 7
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
60 61 62 put__mydict 7 7  NB. Put to existent
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
60 61 62 -: get__mydict 7 7
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(10 11 12,:20 21 22) put__mydict 8 8,:8 8  NB. Double put nonexistent
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
20 21 22 -: get__mydict 8 8
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(30 31 32,40 41 42,:50 51 52) put__mydict 9 9,9 9,:9 9  NB. Triple put nonexistent - keeps last
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
50 51 52 -: get__mydict 9 9
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(60 61 62,:70 71 72) put__mydict 8 8,:8 8  NB. Double put existent
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
70 71 72 -: get__mydict 8 8
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
(80 81 82,83 84 85,:90 91 92) put__mydict 9 9,9 9,:9 9  NB. Triple put existent - keeps last
qprintf^:PRBASIC'0(16!:_5)dict__mydict a.i.0{::dict__mydict }.dict__mydict '
90 91 92 -: get__mydict 9 9

destroy__mydict ''

NB. Repeat for boxed key
]params =: 'hash' ,&< ('initsize' ; 10) , ('occupancy' ; 0.66) , ('keytype' ; 'boxed') , ('valueshape' ; 3) , ('keyshape' ; 2) ,: ('valuetype' ; 4)
mydict =: params conew 'jdictionary'

qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
1 2 3 put__mydict <"(0) 2 3
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
1 2 3 -: get__mydict <"(0) 2 3
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
4 5 6 put__mydict <"(0) 1 3
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
4 5 6 -: get__mydict <"(0) 1 3
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
2 3 4 put__mydict <"(0) 4 5
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
3 4 5 put__mydict <"(0) 5 6
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
(_3 ]\ 1 2 3 2 3 4 3 4 5) -: get__mydict <"(0) 2 3 , 4 5 ,: 5 6
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
4 5 6 -: get__mydict <"(0) 1 3
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
(4 5 6,:5 6 7) put__mydict <"(0) 6 7,:7 8
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
3 4 5 -: get__mydict <"(0) 5 6
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
get__mydict :: (100"_) <"(0) 7 7
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
90 91 92 -: 90 91 92 get__mydict <"(0) 7 7
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
50 51 52 put__mydict <"(0) 7 7  NB. Put to nonexistent
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
50 51 52 -: get__mydict <"(0) 7 7
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
60 61 62 put__mydict <"(0) 7 7  NB. Put to existent
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
60 61 62 -: get__mydict <"(0) 7 7
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
(10 11 12,:20 21 22) put__mydict <"(0) 8 8,:8 8  NB. Double put nonexistent
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
20 21 22 -: get__mydict <"(0) 8 8
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
(30 31 32,40 41 42,:50 51 52) put__mydict <"(0) 9 9,9 9,:9 9  NB. Triple put nonexistent - keeps last
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
50 51 52 -: get__mydict <"(0) 9 9
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
(60 61 62,:70 71 72) put__mydict <"(0) 8 8,:8 8  NB. Double put existent
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
70 71 72 -: get__mydict <"(0) 8 8
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
(80 81 82,83 84 85,:90 91 92) put__mydict <"(0) 9 9,9 9,:9 9  NB. Triple put existent - keeps last
qprintf^:PRBASIC'(<@<@<@<@(0&(16!:_5)){&.>2&{.@}.)dict__mydict '
90 91 92 -: get__mydict <"(0) 9 9

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
refdict__   =: refdict =. conew 'refdictionary'
params =. 'hash' ,&< ('initsize' ; initsz) , ('occupancy' ; occupancy) ,: ('keytype' ; 'boxed')
jdict__   =: jdict =. params conew 'jdictionary'
for. i. n_iter do.
  keys =. <@":"0 vals =. sz ?@$ mx NB. Keys, vals for put.
  keys (>@[ set__refdict ])"0 vals
qprintf^:PRBATCH'$keys keys $vals vals '
  vals put__jdict keys
  keys =. <@":"0 vals =. sz ?@$ mx NB. New keys, vals for queries.
qprintf^:PRBATCH'$keys keys $vals vals '
  refmask =. has__refdict@> keys
  jgetans =. _1 get__jdict keys
  jmask =. 0 <: jgetans
qprintf^:PRBATCH'jgetans refmask jmask '
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
}}

NB. ADVANCED.

NB. Create/remove threads so that there are exactly n_threads worker threads.
NB. y is number of worker threads.
set_threads =: {{)m
{{55 T. 0}}^:] 0 >. y -~ 1 T. ''
{{0 T. 0}}^:] 0 >. y - 1 T. ''
assert. y -: 1 T. ''
}}

NB. GET, PUT IN MULTIPLE THREADS.
NB. Keys and values are integers (permutations).

NB. y is number of iterations , number of worker threads , number of keys and values
test_multithreading1 =: {{)m
'n_iter n_threads sz' =. y
jdict =. ('hash' ; '') conew 'jdictionary'
'keys vals' =. ?~ ,~ sz
NB. smoutput'put init',' ',":{.3 T.''
vals put__jdict keys
NB. x is jdict
NB. y is number of iterations ; keys
prog =: {{)d
  'n_iter keys' =. y
  sz =. # keys
  for_el. i. n_iter do.
    vals =. get__x keys
NB. smoutput'put ',":el,{.3 T.''
    vals put__x keys NB. Put exactly the same keys and values.
NB. smoutput'fin put ',":el,{.3 T.''
    keys =. vals
  end.
  }}
NB. Run prog in main thread.
res_mt =. jdict prog n_iter ; keys
NB. Copy input for each thread and run prog in each thread.
set_threads n_threads
res_wts =. jdict prog t.''"1 (n_threads , 2) $ n_iter ; keys
NB. Check if result from each thread is the same as the result from main thread.
mask =. (res_mt -: >)"0 res_wts
erase 'prog'
destroy__jdict ''
mask NB. Should be equal to n_threads $ 1
}}

NB. Given matrix represented by dyadic verb magic which returns value of matrix at index (x, y).
NB. Each thread (task per column) will add values from one column to dictionary which stores sums of rows.
NB. Dictionary stores pairs of atomic values (currect_row_sum and counter_of_additions).
NB. When a row is handled by all threads, the last thread (according to counter for the row) removes it from dictionary and stores value in global array.
NB. y is number of rows , number of columns , number of threads
test_multithreading2 =: {{)m
'rows cols n_threads' =. y
params =. 'hash' ,&< ('valueshape' ; 2) ,: 'valuetype' ; 'boxed'
jdict =. params conew 'jdictionary'
(16&T."0 (rows , 2) $ 0) put__jdict i. rows
row_sums =: rows $ 0
magic =: {{ (2 * x + 3) + 3 * y + 7 }}
NB. x is jdict
NB. y is number of rows , number of columns, index of column
prog =: {{)d
  'rows cols col' =. y
  for_row. i. rows do.
    res =. row magic col
    val =. get__x row
    old_sum =. 17 T. ({. val) , < res
    old_cnt =. 17 T. ({: val) , < 1
    if. cols -: >: old_cnt do.
      row_sums =: (old_sum + res) row} row_sums
      del__x row
    end.
  end.
  EMPTY
  }}
set_threads n_threads
jdict prog t.''"1 ] (rows , cols)&,"0 i. cols
correct_row_sums =. +/"1 (i. rows) magic"0/ i. cols
assert. row_sums -: correct_row_sums
erase 'magic'
erase 'prog'
erase 'row_sums'
destroy__jdict ''
EMPTY
}}

NB. RUN ADVANCED.

(21 ; 0.7) test_batches 10000 ; 10 ; 20
(3 ; 0.7) test_batches 10000 ; 10 ; 20
(142 ; 0.6) test_batches 1000 ; 100 ; 200
(7 ; 0.6) test_batches 100 ; 1000 ; 2000
(200001 ; 0.8) test_batches 5 ; 100000 ; 200000

test_multithreading1 10000 5 200

{{ for. i. 30 do. test_multithreading2 1 1 1 end. }} ''

{{ for. i. 30 do. test_multithreading2 100 200 5 end. }} ''
