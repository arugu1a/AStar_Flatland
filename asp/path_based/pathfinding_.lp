%Start

delay(ID1,Del) :- Del = Dep..(Dep + 10) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

on_node(ID,(X,Y),Dir,Dep)   :-  start_with_delay(ID,(Y,X),Dep,Dir).

%Stepwise
%{on_node(ID,B,B_in,S+1) : edge_o(A,B,A_in,A_out,B_in,L) }=1:-  on_node(ID,A,A_in,S) , S<1000.

%Timestamps
{on_node(ID,B,B_in,T+L) : edge_o(A,B,A_in,A_out,B_in,L) }=1:- on_node(ID,A,A_in,T) , end(ID,(Y,X),End) , T<End , A!=(X,Y).

goal(ID) :- on_node(ID,(X,Y),Dir,T) , end(ID,(Y,X),End) , T<=End.
:- not goal(ID), train(ID).

%Both ---> this kills Performance
%{on_node(ID,B,B_in,S+1,T+L) : edge_o(A,B,A_in,A_out,B_in,L) }=1:-  on_node(ID,A,A_in,S,T) , S<1000.

% ---- COLLISION ----

% node collision
:- on_node(ID1,A,_,T) , on_node(ID2,A,_,T) , ID1!=ID2.
% edge collision
critical_edge(T1,T2,T1',T2',edge_o(A,B,A_in,A_out,B_in,L)) :- 
    T2>0 , T1 = T2-L , T1' = T2'-L , 
    on_node(ID,B,B_in,T2) , on_node(ID2,A,A_in',T2') ,
    edge_o(A,B,A_in,A_out,B_in,L) , edge_o(B,A,B_in',B_out',A_in',L) , 
    mirrored_dir(B_in,B_out') , mirrored_dir(A_out,A_in') , ID2!=ID , T1 <= T1' <= T2 .

:- critical_edge(T1,T2,T1',T2',edge_o(A,B,A_in,A_out,B_in,L)). 

%generate actions causes grounding issues on larger maps?
%generate actions 1st line generates actions on nodes, 2nd line filler actions
action(ID,move_forward,Dep) :- start_with_delay(ID,(Y,X),Dep,Dir).                  %only for Flatland, Spawn in
action(ID,move_forward,T2+1)   :- action(ID,Act1,T1) , action(ID,Act2,T2) , T2>T1.  %only for Flatland, filler action reguired for "TypeError: object of type 'NoneType' has no len()" bug
action(ID,Act,T1)           :- T1 = T2-L , on_node(ID,A,A_in,T1) , on_node(ID,B,B_in,T2) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2.
action(ID,move_forward,T)   :- T2-T1>1 , T=T1+1..T2-1 , T1 = T2-L , on_node(ID,A,A_in,T1) , on_node(ID,B,B_in,T2) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2.
% ---- ----
%#show on_node/4.
%#show on_node_count/1.
%#show blocked/4.
#show action/3.
#show critical_edge/6.