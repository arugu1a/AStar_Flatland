%on(ID,edge_o((X,Y),B,Dir,Dir_out,L),(Dep,Dep+L)) :- start(ID, (Y, X), Dep, Dir) , edge_o((X,Y),B,Dir,Dir_out,L).
%{on(ID,edge_o(B,C,Do1,Do2,L2),(T2+1,T2+1+L2))}=1 :- on(ID,edge_o(A,B,Di1,Do1,L1),(T1,T2)) , edge_o(B,C,Do1,Do2,L2) , edge_o(A,B,Di1,Do1,L1) , node(C) , C!=A , direction(Dir_out).% , not on(ID,edge_o(B,C,Do1,Do2,L2),(T+1,T+1+L2)).

% ---- PATHFINDING LOGIC ------
%action_(train(ID),move_forward,0) :- train(ID) , on(ID,edge_o(X,Y,_,_,_,L),0,_).
%{action_(train(ID),Act,S+1) : act(Act) , Act != wait } = 1 :-   on(ID,edge_o(X,Y,_,_,B_in,L1),S,_) , not goal(ID,S).

delay(ID1,Del) :- Del = Dep..(Dep-1 + 5) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

on(ID,edge_o((X,Y),B,Dir_in,Dir_out,Dir_in2,L ),0  ,L+Dep)   :-  start_with_delay(ID, (Y, X), Dep, Dir_in) , edge_o((X,Y),B,Dir_in,Dir_out,Dir_in2,L).

{on(ID,edge_o( B   ,C,B_in  ,B_out  ,C_in   ,L2),S+1,L2+L) : edge_o(B,C,B_in,B_out,C_in,L2) }=1 :- % , connection(Tr,B_in,B_out,Act) , Act!=wait , cell((Y,X), Tr) , B=(X,Y) , wait_time(Wait_time)}=1 :-  
    on(ID,edge_o(A,B,A_in,A_out,B_in,L1),S,L) , L <= Arr , end(ID,_, Arr). %, action_(train(ID),Act,S+1).

% ---- EXPERIMENTS ----

wait_time(0).
%:- on(ID,edge_o(A,B,_,A_out,B_in,L),S1,L1) , on(ID,edge_o(A,B,_,A_out,B_in,L),S2,L2) , S1 != S2.
% too strict, no dual direction use of any edge_o allowed
%:- train(ID1) , train(ID2) , ID1 != ID2 , on(ID1,edge_o(A,B,_,_,_,_),_,_) , on(ID2,edge_o(B,A,_,_,_,_),_,_) .

%:- on(ID,edge_o(A,B,A_in,A_out,B_in,Edge_Length),Step,TimeAtEnd) , TimeAtStart = TimeAtEnd - Edge_Length.

% ---- COLLISION LOGIC ----


%blocked(ID,A,B,TimeAtStart,TimeAtEnd) :- on(ID,edge_o(A,B,A_in,A_out,B_in,Edge_Length),Step,TimeAtEnd) , TimeAtStart = TimeAtEnd - Edge_Length.
%:- blocked(ID1,A,_,T,_) , blocked(ID2,A,_,T,_) , ID1!=ID2.
%:- blocked(ID1,A,_,T,_) , blocked(ID2,_,A,_,T) , ID1!=ID2.
:-  on(ID1,edge_o(A,_,_,_,_,Edge_Length1),_,TimeAtEnd1) , TimeAtStart1 = TimeAtEnd1 - Edge_Length1 , 
    on(ID2,edge_o(A,_,_,_,_,Edge_Length2),_,TimeAtEnd2) , TimeAtStart2 = TimeAtEnd2 - Edge_Length2 , 
    TimeAtStart1 = TimeAtStart2 , ID1!=ID2.
:-  on(ID1,edge_o(A,_,_,_,_,Edge_Length1),_,TimeAtEnd1) , TimeAtStart1 = TimeAtEnd1 - Edge_Length1 , 
    on(ID2,edge_o(_,A,_,_,_,Edge_Length2),_,TimeAtEnd2) , TimeAtStart2 = TimeAtEnd2 - Edge_Length2 , 
    TimeAtStart1 = TimeAtEnd2 , ID1!=ID2.
%:- blocked(ID1,A,B,S1,E1) , blocked(ID2,B,A,S2,E2) , ID1!=ID2 , E2 > E1 > S2.  %&diff{A-B}<=10 :- foo(A) , bar(B).
%&diff{S2-E1}>0:- E2>S1 , blocked(ID1,A,B,S1,E1) , blocked(ID2,B,A,S2,E2) , ID1!=ID2.
%&diff{E1-S2}<=0 :- blocked(ID1,A,B,S1,E1) , blocked(ID2,B,A,S2,E2) , ID1!=ID2.
%&diff{S2-E1}>0
:-  ID1!=ID2 , E2 > E1 > S2 ,
    on(ID1,edge_o(A,B,_,A_out,B_in,L1),_,E1) , S1 = E1 - L1 , 
    on(ID2,edge_o(B,A,_,B_out,A_in,L2),_,E2) , S2 = E2 - L2 , 
    mirrored_dir(B_in,B_out) , mirrored_dir(A_in,A_out).

latest_time(ID,Arr - St) :- start_with_delay(ID,_,St,_) , end(ID,_, Arr).

:- not goal(ID) , train(ID).
goal(ID) :- goal(ID,_).
goal(ID,S) :- on(ID,edge_o(A,(X,Y),A_in,A_out,B_in,L),S,_) , end(ID, (Y, X), Arr).

% ---- EDGES TO ACTIONS ----
%:- action_(train(ID),A,S,_) , A!=move_forward , act(A) , S=0.
%action_filler(train(ID),move_forward,T..L_path-1) :- T=L_path-L+1 , action_(train(ID),A,S+1,_) , on(ID,edge_o(X,Y,Dir,_,Dir_out,L),S,L_path).

%action(train(ID),A,T+1) :- T=L_path-L , action_(train(ID),A,S,_) , on(ID,edge_o(X,Y,Dir,_,Dir_out,L),S,L_path).
%action(train(ID),A,T+1) :- T=L_path-L , action_filler(train(ID),A,S,_) , on(ID,edge_o(X,Y,Dir,_,Dir_out,L),S,L_path).


#show goal/2.
%#show on/4.
%#show start/4.
%#show action_/4.
#show action/3.
%#show action_filler/3.
%#show blocked/5.
%#show delay/2.
%#show double_blocked/8.