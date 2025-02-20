%Start
time(0..Max_T) :- global(Max_T).

delay(ID1,Del) :- Del = Dep..(Dep + 10) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

on_node(ID,(X,Y),Dir,Dep+1,0)   :-  start_with_delay(ID,(Y,X),Dep,Dir).

%Timestamps
%Wait_time is the additional time the train has waited on the A->B edge waiting is only allowed on edges with length>1 (no waiting on adjacent nodes).
on_node(ID,A,A_in) :- on_node(ID,A,A_in,T,Wait_time).
{on_node(ID,B,B_in,T+L+Wait_time,Wait_time) : edge_o(A,B,A_in,A_out,B_in,L) , Wait_time=0..1 , Wait_time<L }=1 :- on_node(ID,A,A_in,T,W) , end(ID,(Y,X),End) , T<End , A!=(X,Y).

goal(ID) :- on_node(ID,(X,Y),Dir,T,_) , end(ID,(Y,X),End) , T<=End.
:- not goal(ID), train(ID).