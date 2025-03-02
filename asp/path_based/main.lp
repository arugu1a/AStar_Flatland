#include "../alexej_based/track_facts.lp".
#include "./build_graph.lp".
#include "./pathfinding_.lp".
#include "./pathfinding_collision.lp".

% Actions added to handle spawn in and expected action list length for Flatland
action(train(ID),wait,0..Dep-1) :- Dep > 0 , start_with_delay(ID,(Y,X),Dep,Dir).
action(train(ID),move_forward,Dep) :- start_with_delay(ID,(Y,X),Dep,Dir).
action(train(ID),move_forward,T)   :- on_node(ID,(X,Y),Dir,T,_) , end(ID,(Y,X),End).

% No Wait on edge: T1=T2-L
action(train(ID),Act,T1)           :- T1 = T2-L ,                           on_node(ID,A,A_in,T1,_) , on_node(ID,B,B_in,T2,_) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2. % action on node
action(train(ID),move_forward,T)   :- T1 = T2-L , T2-T1>1 , T=T1+1..T2-1  , on_node(ID,A,A_in,T1,_) , on_node(ID,B,B_in,T2,_) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2. % action on edge

%Wait on edge: T1 = T2-L-1 
%if wait_time=1 -> edge_o T2-T1 = L+1. not just move forward, but move_forwards (T1..T2-2), wait, move_forward
action(train(ID),Act,T1)           :- T1 = T2-L-W , W>0 ,                                 on_node(ID,A,A_in,T1,_) , on_node(ID,B,B_in,T2,W) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2. % action on node
action(train(ID),move_forward,T)   :- T1 = T2-L-W , W>0 , T2-T1>1 , T=T1+1..T2-2-W ,      on_node(ID,A,A_in,T1,_) , on_node(ID,B,B_in,T2,W) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2. % actions up to wait pos
action(train(ID),wait,T)           :- T1 = T2-L-W , W>0 , T2-T1>1 , T=T2-1-W..T2-2      , on_node(ID,A,A_in,T1,_) , on_node(ID,B,B_in,T2,W) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2. % 
action(train(ID),move_forward,T)   :- T1 = T2-L-W , W>0 , T2-T1>1 , T=T2-1              , on_node(ID,A,A_in,T1,_) , on_node(ID,B,B_in,T2,W) , edge_o(A,B,A_in,A_out,B_in,L) , connection(Tr,A_in,A_out,Act) , Act!=wait , cell((Y,X), Tr) , A=(X,Y) , T1 < T2. %