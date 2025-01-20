%on(ID,edge((X,Y),B,Dir,Dir_out,L),(Dep,Dep+L)) :- start(ID, (Y, X), Dep, Dir) , edge((X,Y),B,Dir,Dir_out,L).
%{on(ID,edge(B,C,Do1,Do2,L2),(T2+1,T2+1+L2))}=1 :- on(ID,edge(A,B,Di1,Do1,L1),(T1,T2)) , edge(B,C,Do1,Do2,L2) , edge(A,B,Di1,Do1,L1) , node(C) , C!=A , direction(Dir_out).% , not on(ID,edge(B,C,Do1,Do2,L2),(T+1,T+1+L2)).


{action_(train(ID),A,S+1,(X,Y)) : act(A) , A != wait } = 1 :- on(ID,edge(X,Y,_,_,_,L),S,_).
%:- action_(train(ID),A,S,_) , A!=move_forward , act(A) , S=0.
action_(train(ID),move_forward,0,(X,Y)) :- train(ID) , on(ID,edge(X,Y,_,_,_,L),0,_).
action_filler(train(ID),move_forward,T..L_path-1) :- T=L_path-L+1 , action_(train(ID),A,S+1,_) , on(ID,edge(X,Y,Dir,_,Dir_out,L),S,L_path).

action(train(ID),A,T+1) :- T=L_path-L , action_(train(ID),A,S,_) , on(ID,edge(X,Y,Dir,_,Dir_out,L),S,L_path).
action(train(ID),A,T+1) :- T=L_path-L , action_filler(train(ID),A,S,_) , on(ID,edge(X,Y,Dir,_,Dir_out,L),S,L_path).


delay(ID1,Del) :- Del = Dep..(Dep+N-1 + 5) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

on(ID,edge((X,Y),B,Dir_in,Dir_out,Dir_in2,L ),0  ,L+Dep)   :-  start_with_delay(ID, (Y, X), Dep, Dir_in) , edge((X,Y),B,Dir_in,Dir_out,Dir_in2,L).

on(ID,edge( B   ,C,B_in  ,B_out  ,C_in   ,L2),S+1,L2+L) :-  on(ID,edge(A,B,A_in,A_out,B_in,L1),S,L) , edge(A,B,A_in,A_out,B_in,L1) , 
                                                            edge(B,C,B_in,B_out,C_in,L2) , node(C) , C!=A , edge_count(N) ,
                                                            action_(train(ID),Act,S+1,_) , cell((Y,X), Tr) , connection(Tr,B_in,B_out,Act) , B=(X,Y) , 
                                                            L <= Arr - St , start_with_delay(ID,_,St,_) , end(ID,_, Arr).


% too strict, no dual direction use of any edge allowed
%:- train(ID1) , train(ID2) , ID1 != ID2 , on(ID1,edge(A,B,_,_,_,_),_,_) , on(ID2,edge(B,A,_,_,_,_),_,_) .

blocked(ID,A,B,TimeAtStart,TimeAtEnd) :- on(ID,edge(A,B,A_in,A_out,B_in,Edge_Length),Step,TimeAtEnd) , TimeAtStart = TimeAtEnd - Edge_Length.
:- blocked(ID1,A,_,Time,_) , blocked(ID2,A,_,Time,_) , ID1!=ID2.
%:- blocked(ID1,A,B,TimeS1,TimeE1) , blocked(ID2,B,A,TimeS2,TimeE2) , ID1!=ID2 , TimeS2 < TimeE1.


latest_time(ID,Arr - St) :- start_with_delay(ID,_,St,_) , end(ID,_, Arr).

:- not goal(ID) , train(ID).
goal(ID) :- goal(ID,_).
goal(ID,S) :- on(ID,edge(A,(X,Y),A_in,A_out,B_in,L),S,_) , end(ID, (Y, X), Arr).

%#show goal/2.
%#show on/4.
%#show start/4.
%#show action_/4.
%#show action/3.
%#show action_filler/3.
#show blocked/5.
#show delay/2.