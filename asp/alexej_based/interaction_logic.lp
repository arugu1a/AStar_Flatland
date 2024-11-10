% EXPERIMENT no waiting on start cell
% :- action(train(ID), A, T) , start(ID,(X',Y'),Dep,Dir) , on(X,Y,ID,Dir,T) , A=wait , (X,Y)=(X',Y').
% :- action(train(ID), A, T) , end(ID,(Y,X),End) , not on(X,Y,ID,Dir,T) , A=wait , direction(Dir).


% no waiting unless already at goal OR no other action possible
:-  action(train(ID), wait, T) , 
    not goal(ID).

% Logic for trains blocking eachother
:- on(X,Y,ID1,T) , on(X,Y,ID2,T) , ID1 != ID2.      % Trains are not allowed to occupy same cell

% FILTER WORKS BUT NO OTHER ROUTES FOUND
phase_through(ID1,ID2):-    on(X1,Y1,ID1,T) ,    % Trains are not alllowed to swap places (phase through each other)
                            on(X2,Y2,ID1,T+1) , 
                            on(X2,Y2,ID2,T) , 
                            on(X1,Y1,ID2,T+1) ,
                            ID1 != ID2.  
                            %(X1,Y1) != (X2,Y2) , 
                            

:- phase_through(ID1,ID2) , train(ID1) , train(ID2) .

% Goal condition
goal(ID) :- on(X,Y,ID,M) , end(ID,(Y,X),End) , moves(M,ID).
:- not goal(ID) , train(ID).