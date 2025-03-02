%Start
time(0..Max_T) :- global(Max_T).
wait_time(0..5).
delay(ID1,Del) :- Del = Dep+1..(Dep+1 + 5) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

on_node(ID,(X,Y),Dir,Dep+1,0)   :-  start_with_delay(ID,(Y,X),Dep,Dir).

%Timestamps
%Wait_time is the additional time the train has waited on the A->B edge waiting is only allowed on edges with length>1 (no waiting on adjacent nodes).
%on_node(ID,A,A_in) :- on_node(ID,A,A_in,T,Wait_time).

{in_motion(ID,A,A_in,A_out,B_in,B,T,T+L+Wait_time,Wait_time) } :- edge_o(A,B,A_in,A_out,B_in,L) , wait_time(Wait_time) , Wait_time<L , on_node(ID,A,A_in,T,W) , end(ID,(Y,X),End) , T<End , A!=(X,Y).
on_node(ID,B,B_in,End,Wait_time) :- in_motion(ID,A,A_in,A_out,B_in,B,Start,End,Wait_time).

% only one action per train per timestep
:-  in_motion(ID,A,A_in,A_out1,B_in,B,Start,End,Wait_time1),
    in_motion(ID,A,A_in,A_out2,B_in,B,Start,End,Wait_time2), 
    A_out1 != A_out2 , Wait_time1 != Wait_time2.


% 
goal(ID) :- on_node(ID,(X,Y),Dir,T,_) , end(ID,(Y,X),End) , T<=End.
:- not goal(ID), train(ID).


#show in_motion/9.
