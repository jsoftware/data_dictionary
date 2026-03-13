NB. Sweep line.

load 'dict'

NB. x is the maximum height for jumping and falling.
NB. y is table (rank 2) where each row represents a platform (y, x_left, x_right)
NB. The result is an array of boxes, where each box contains indices of platforms
NB. such that any platform in the box is reachable from any other.
partition =: {{
  ids =: i. # y
  find =. {{
    js =. ids {~^:a: y
    ids =: ids js}~ {: js
    {: js
  }}"0
  NB. Dictionary s will be used as sweep line.
  NB. Key is x-coord of platform right end (r).
  NB. Value is ((l , h) ; id) where:
  NB. * l is x-coord of platform left end
  NB. * h is y-coord of platform
  NB. * id is unique platform ID.
  s =. 'jdict' conew~ 'tree concurrent' ,&< ('keytype' ; datatype y) , ('valuetype' ; 'boxed') ,: 'valueshape' ; 2
  NB. Is key r in y greater then l from value ((l , h) ; id) in x.
  NB. This tells whether entry represents non-empty platform.
  ok =. (> (0 ; 0)&{::)~
  idxs =. /: y
  for_p. idxs { y do. NB. Process platforms in ascending order of h.
    'h l r' =. p
    NB. Find all entries in s that may be reachable from the platform p.
    'r0 val0' =. 1&since__s r
    r0 =. r0"_^:(r > ])  0&{::^:3`(r"_)@.(0 -: */@$) val0
    'rs vals' =. 0 1 range__s l , r0
    if. 0 < # rs do. NB. If there are entries that may be reachable for the platform.
      'lhs js' =. |: vals NB. lhs is array (ls ,. hs). js is array of IDs.
      NB. Replace all of them by 3 platforms: left, middle (p) and right, so that they do not overlap.
      del__s rs NB. First, remove found entries.
      ({. vals) put__s^:ok l NB. Put left platform if it represents non-empty line segment.
      ((({: ,~ r >. {.)@{: lhs) ; {: js) put__s^:ok {: rs NB. Similarly put right platform.
      js =. find js #~ x >: h - {:"1 lhs NB. Filter out entries that are distant more then by h.
      root =. find p_index
      ids =: root js} ids NB. Mark that those entries are reachable from the platform p.
    end.
    r put__s~ p_index ;~ l , h NB. Always put p as middle platform.
  end.
  destroy__s ''
  NB. Map every index to its group root in ids and compute groups.
  ((find i. # y) {~ /: idxs) </. i. # y
}}"0 2

NB. x is the maximum height for jumping and falling.
NB. y is table (rank 2) where each row represents a platform (y, x_left, x_right)
NB. The result is boolean matrix where 0 means not directly reachable, 1 means reachable.
NB. y-coords are compared and pairs of x_coords.
matrix =: ((>: |@:-"1 0~) {."1) *. ([: (>.&{. < <.&{:)"1"1 2~ }."1)@]

NB. y is boolean square matrix.
NB. Result is transitive closure of y.
transitiveclosure =: {{
  for_k. i. # y do.
    y =. y +. k ({"1 *./ {) y
  end.
}}

NB. x is the maximum height for jumping and falling.
NB. y is table (rank 2) where each row represents a platform (y, x_left, x_right)
testpartition =: {{
  r1 =. x partition y
  r2 =. (transitiveclosure x matrix y) </. (i. # y)
  assert. r1 -: r2
  EMPTY
}}

{{ (>: ? 5) testpartition (?@$~ y) ,. 0 1&+"1 /:"1~ (?@$~ ,&2) y }}"0 >: i. 200
