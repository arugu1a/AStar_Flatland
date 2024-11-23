% EXPERIMENT no waiting on start cell
% :- action(train(ID), A, T) , start(ID,(X',Y'),Dep,Dir) , on(X,Y,ID,Dir,T) , A=wait , (X,Y)=(X',Y').
% :- action(train(ID), A, T) , end(ID,(Y,X),End) , not on(X,Y,ID,Dir,T) , A=wait , direction(Dir).


% no waiting unless already at goal OR no other action possible
%*
:-  action(train(ID), wait, T) , 
    on(X,Y,ID,T) , 
    end(ID,(Y,X),End).
*%
% Logic for trains blocking eachother ---------------------------------------------------------------------
:- on(X,Y,ID1,T) , on(X,Y,ID2,T) , ID1 != ID2.      % Trains are not allowed to occupy same cell

phase_through(ID1,ID2):-    on(X1,Y1,ID1,T) ,    % Trains are not alllowed to swap places (phase through each other)
                            on(X1+X,Y1+Y,ID1,T+1) , 
                            on(X1+X,Y1+Y,ID2,T) , 
                            on(X1,Y1,ID2,T+1) ,
                            ID1 != ID2 , 
                            X = (0;1) ,
                            Y = (0;1) ,
                            X+Y = 1.  

:- phase_through(ID1,ID2) , train(ID1) , train(ID2) .

% Goal condition
goal(ID) :- goal(ID,_).
goal(ID,T) :- on(X,Y,ID,T) , end(ID,(Y,X),End) , time(T,ID).
:- not goal(ID) , train(ID).

time(T,ID) :- T= 0..M , moves(M,ID).

#show goal/2.
#show time/1.

% ISSUE: Trains can spawn on the same cell at the same time step