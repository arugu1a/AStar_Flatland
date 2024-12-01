% Spawn train on path that leads to end
% delay(ID1,Del) :- Del = Dep..(Dep + 20). %, N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_) , start(ID2,(Y,X),Dep,_).
delay_(ID,Del) :- Del=Dep..(Dep + 20) , start(ID,_,Dep,_).
{delay(ID,Del) : delay_(ID,Del) }=1 :- train(ID).
% {start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.


train_on(X,Y,ID,Delay) :- start(ID,(Y,X),Dep,Dir) , delay(ID,Delay). % path(Route,0,(Y,X),Dir,0) , route(Route,(Y,X),Dir,End) , train(ID) , start(ID,_,Dep,Dir) , delay(ID).


% Move train along path
%train_on(X,Y,ID,T+1) :- train_on(X,Y,ID,T) , action_(train(ID), A, T) , action(train(ID), A, T+Dep).%+Offs) , offset(ID,T,Offs).

% --------------------------------------------------------------------------------- 
% allowed_actions(wait,R,Step) :- action_((R,_),_,Step) , route(R,_,_,_).
% allowed_actions(A,R,Step) :- action_((R,_),A,Step) , route(R,_,_,_).
%{action(ID,A,T) : allowed_actions(A,ID,Step)}=1 :- train_on(X,Y,ID,T), not T=50 , Path_Act = action_((R,P),A,T+Offs , time_offset(ID,Offs)).
% --------------------------------------------------------------------------------- 

% moves train up to a collision
train_on(X,Y,ID,T+1) :- train_on(_,_,ID,T) , on(X,Y,(R,P),Dir,T+1-Delay) , delay(ID,Delay), not collide(ID,_,T+1).
action(ID,A,T) :- action_((ID,0),A,T-Delay) , delay(ID,Delay) , train_on(_,_,ID,T).

% Logic for trains blocking eachother ---------------------------------------------------------------------
collide(ID1,ID2,T):- train_on(X,Y,ID1,T) , train_on(X,Y,ID2,T) , ID1 != ID2.      % Trains are not allowed to occupy same cell
:- collide(ID1,ID2,T).

phase_through(ID1,ID2):-    train_on(X1,Y1,ID1,T) ,    % Trains are not alllowed to swap places (phase through each other)
                            train_on(X1+X,Y1+Y,ID1,T+1) , 
                            train_on(X1+X,Y1+Y,ID2,T) , 
                            train_on(X1,Y1,ID2,T+1) ,
                            ID1 != ID2 , 
                            X = (0;1) ,
                            Y = (0;1) ,
                            X+Y = 1.  

:- phase_through(ID1,ID2) , train(ID1) , train(ID2) .

train_on(X,Y,ID,M) :- train_on(X,Y,ID,_,M).

%#show train_on/4.
#show action/3.
%#show collide/3.