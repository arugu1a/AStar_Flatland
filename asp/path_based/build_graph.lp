% nodes are all not straight or curve types (cross is a node)
node((X,Y)) :- cell((Y,X), Tr) , not forward_track(Tr) , Tr !=0. 
node((X,Y)) :- start(_,(Y,X),_,_). 
node((X,Y)) :- end(_,(Y,X),_).
%Straight
forward_track(32800). forward_track(1025).
%Curves
forward_track(4608). forward_track(16386). forward_track(72). forward_track(2064).

%#show node/1.
%#show path/4.
%#show link/4.
%#show edge/5.

%PROBLEM: what about cross or station pieces? cannot distinguish 2 paths on a simple loop without switches A to B to A.
% remove this, just use Dir out
choice(move_forward,a).
choice(move_left,b).
choice(move_right,b).
%connects two positions
link((X,Y),(X',Y'),Dir_in,Dir_out) :- connection(Tr,Dir_in,Dir_out,A) , cell((Y,X),Tr) , cell((Y',X'),Tr') , move_in(Dir_out , (X1,Y1)) , (X',Y')=(X+ X1,Y + Y1) , Dir_out != none , A != wait.

edge((A,B),(C,D),AB_in,AB_out,CD_in,L+2) :- link((A,B),(A',B'),AB_in,AB_out) , link((C',D'),(C,D),_,CD_in) , path((A',B'),(C',D'),_,L) , (A,B) != (C,D) , node((A,B)), node((C,D)).
edge((A,B),(C,D),AB_in,AB_out,CD_in,2) :-   link((A,B),(A',B'),AB_in,AB_out) , link((A',B'),(C,D),_,CD_in) ,                             (A,B) != (C,D) , node((A,B)), node((C,D)) , (A',B')!=(A_,B_) , node((A_,B_)).
edge((A,B),(C,D),AB_in,AB_out,AB_out,1) :-   link((A,B),(C,D)  ,AB_in,AB_out) ,                                                                        node((A,B)), node((C,D)).
path((A,B),(C,D),Dir_in,L+1) :- link((A,B),(A',B'),Dir_in,Dir_out) , path((A',B'),(C,D),Dir_out,L)                                , (A,B)!=(C,D) , cell((B,A),Tr1) , cell((D,C),Tr2) , forward_track(Tr1) , forward_track(Tr2) , not node((A,B)) , not node((C,D)).
path((A,B),(C,D),Dir_in,1)   :- link((A,B),(C,D),Dir_in,Dir_out)                                                              , (A,B)!=(C,D) , cell((B,A),Tr1) , cell((D,C),Tr2) , forward_track(Tr1) , forward_track(Tr2) , not node((A,B)) , not node((C,D)).

edge_count(N) :- N = #count { edge(A,B,A_in,A_out,B_in,L) : edge(A,B,A_in,A_out,B_in,L)}.
%path((A,B),(C,D)) :- link((A,B),(A',B'),_) , link((C',D'),(C,D),_) , path((A',B'),(C',D')) , cell((B,A),Tr1) , cell((D,C),Tr2) , forward_track(Tr1) , forward_track(Tr2) , not node(A,B) , not node(C,D).
%path((A,B),(C,D)) :- link((A,B),(A',B'),_) , link((A',B'),(C,D),_) , cell((B,A),Tr1) , forward_track(Tr1) , cell((B',A'),Tr2) , forward_track(Tr2) , cell((D,C),Tr3) , forward_track(Tr3) , not node(A,B) , not node(C,D) , (A,B) != (C,D).

% TODO
% store length in path -> generate move forwards quickly
% given start,end node, find connected paths.
% COLLSIONS & TIMING:
% if no paths are used in both directions & trains with same start X,Y have different Delays -> collision free
% path__blocked -> train goes in edge(A,B) -> path__blocked(B,A)
% problem: what if multiple edge(B,A)? how to find correct dir_out?

%

%#show edge_count/1.
%#show edge/6.