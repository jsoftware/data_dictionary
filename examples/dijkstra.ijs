NB. Dijkstra's algorithm.

load 'dictionary'

NB. x is graph, y is source vertex.
NB. Result is array of two boxes:
NB. * array of shortest-path distances from the source to every vertex
NB. * predecessor array for shortest-path tree.
dijkstra =: {{
  q =. conew&'jdictionary' 'tree' ,&< ('keyshape' ; 2)  ,: 'valueshape' ; 0
  'ds ps' =. ($&_ ; $&_1)@# x  NB. Initialize distances and predecessors.
  '' put__q 0 , y [ ds =. 0 y} ds  NB. Distance to source is 0.
  while. 0 < count__q '' do.
    del__q 'd i' =. min__q ''  NB. Extract vertex with minimum distance.
    if. d > i { ds do. continue. end.  NB. Skip outdated entry.
    'js ws' =. i { x  NB. Adjacent vertices and edge weights.
    NB. Filter out edges that do not improve shortest paths.
    'js ws' =. (#&js (~.@[ ; <.//.) #&ws) (d + ws) < js { ds
    ds =. ds js}~ d + ws  NB. Update distances.
    ps =. i js} ps  NB. Update predecessors.
    '' put__q js ,.~ d + ws  NB. Insert the updated distance–vertex pairs.
  end.
  destroy__q ''
  ds ; ps
}}"2 0

NB. x is density.
NB. y is number of vertices.
NB. Result is table (rank 2) of edges.
randedges =: ] |:@:(?@$~) 2 , *

NB. x is number of vertices.
NB. y is table (rank 2) of weighted edges.
NB. Result is graph: adjacency ,. weights
digraph =: {{
  idxs =. {."1 y
  (idxs ;/@|:/. }."1 y) (~. idxs)} a: $~ x , 2
}}

NB. Convert table of edges to adjacency matrix.
NB. x is number of vertices (vertices are 0, 1, ..., x - 1).
NB. y is table (rank 2). Each row u v w ... represents directed edge u -> v with weight w with optional ignored other attributes.
matrix =: {{
  y =. y (, (,.&0)@:,.~@:i.) x NB. Add edges u -> u with weight 0.
  idxs =. 2&{."1 y NB. Edges u -> v are indices (u, v) to adjacency matrix.
  ws =. , idxs <.//. 2&{"1 y NB. Weights.
  ws (~. idxs)} (2 # x) $ _
}}

NB. https://code.jsoftware.com/wiki/Essays/Floyd
NB. y is adjacency matrix (rank 2).
floyd =: {{
  for_k. i. # y do.
    y =. y <. k ({"1 +/ {) y
  end.
}}

NB. x is density (average number of edges per vertex).
NB. y is number of vertices.
testdijkstra =: {{
  es =. (,. ?@$&1000@#) x randedges y
  g1 =. y digraph es
  g2 =. y matrix es
  r1 =. >@:({."1) g1 dijkstra i. y
  r2 =. floyd g2
  assert. r1 -: r2
  EMPTY
}}"0

3 testdijkstra 10 30 100 300

NB. x is density (average number of edges per vertex).
NB. y is number of vertices.
benchmarkdijkstra =: {{
  es =. (,. ?@$&1000@#) x randedges y
  g =. y digraph es
  6!:2 'g dijkstra 0'
}}"0

echo 'Dijkstra (1e5 vertices, 3e5 edges): ' , (": 3 benchmarkdijkstra 1e5) , 's'