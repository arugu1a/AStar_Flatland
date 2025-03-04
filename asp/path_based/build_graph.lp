% nodes are all not straight or curve types (cross is a node)
node((X,Y)) :- cell((Y,X), Tr) , not forward_track(Tr) , Tr !=0. 
node((X,Y)) :- start(_,(Y,X),_,_). 
node((X,Y)) :- end(_,(Y,X),_).
%Straight
forward_track(32800). forward_track(1025).
%Curves
forward_track(4608). forward_track(16386). forward_track(72). forward_track(2064).

%connects two positions
link((X,Y),(X',Y'),Dir_in,Dir_out) :- connection(Tr,Dir_in,Dir_out,A) , cell((Y,X),Tr) , cell((Y',X'),Tr') , move_in(Dir_out , (X1,Y1)) , (X',Y')=(X+ X1,Y + Y1) , Dir_out != none , A != wait.

% NodeA A_in A_out --- edge --- -> B_in NodeB
edge((A,B),(C,D),AB_in,AB_out,CD_in,L+2) :- link((A,B),(A',B'),AB_in,AB_out) , link((C',D'),(C,D),_,CD_in) , path((A',B'),(C',D'),_,L) , (A,B) != (C,D) , node((A,B)), node((C,D)).
edge((A,B),(C,D),AB_in,AB_out,CD_in,2) :-   link((A,B),(A',B'),AB_in,AB_out) , link((A',B'),(C,D),_,CD_in) ,                             (A,B) != (C,D) , node((A,B)), node((C,D)) , cell((B',A'),Tr') , forward_track(Tr').
edge((A,B),(C,D),AB_in,AB_out,AB_out,1) :-  link((A,B),(C,D)  ,AB_in,AB_out) ,                                                                            node((A,B)), node((C,D)).
path((A,B),(C,D),Dir_in,L+1) :- link((A,B),(A',B'),Dir_in,Dir_out) , path((A',B'),(C,D),Dir_out,L)                                , (A,B)!=(C,D) , cell((B,A),Tr1) , cell((D,C),Tr2) , forward_track(Tr1) , forward_track(Tr2) , not node((A,B)) , not node((C,D)).
path((A,B),(C,D),Dir_in,1)   :- link((A,B),(C,D),Dir_in,Dir_out)                                                                  , (A,B)!=(C,D) , cell((B,A),Tr1) , cell((D,C),Tr2) , forward_track(Tr1) , forward_track(Tr2) , not node((A,B)) , not node((C,D)).

edge_count(N) :- N = #count { edge(A,B,A_in,A_out,B_in,L) : edge(A,B,A_in,A_out,B_in,L)}.
node_count(N) :- N = #count { node((X,Y)) : node((X,Y))}.

% ---- EXPERIMENTS ----
edge_o(A,B,A_in,A_out,B_in,L) :- edge(A,B,A_in,A_out,B_in,L).
%connection(A,B,A_in) :- edge(A,B,A_in,_,_,_).
%1{edge_o(A,B,A_in,A_out,B_in,L) : edge(A,B,A_in,A_out,B_in,L)}1 :- connection(A,B,A_in).
%edge_o_count(N) :- N = #count { edge_o(A,B,A_in,A_out,B_in,L) : edge_o(A,B,A_in,A_out,B_in,L)}.

#show edge_count/1.
#show node_count/1.
#show edge_o_count/1.
%#show edge_o/6.