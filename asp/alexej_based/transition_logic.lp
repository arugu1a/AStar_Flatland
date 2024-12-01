% how many time steps is a train allowed to do actions?
% After M is reached the train should be at dest. and stay there 
% -> only act(wait) allowed after M is reached. (THIS IS NOT IMPLEMENTED, trains can go past the target as long as they get there again eventually)
moves(M,ID) :- start(ID,_,St,_) , end(ID,_,End) , M= End. % - St +1.

% Define

{action_(train(ID),A,T) : act(A) } = 1 :- on(X,Y,ID,Dir,T) , not goal(ID,T).
:- action_(train(ID),A,T) , on(X,Y,ID,Dir,T) , cell((Y,X),Tr) , not connection(Tr,Dir,_,A).
% :- action_(train(ID),A,T) , goal(ID,T).

delay(ID1,Del) :- Del = Dep..(Dep+N-1 + 20) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_) , start(ID2,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

action(train(ID),wait,T) :-  start_with_delay(ID,(Y,X),Dep,_) , T = 0..Dep.            % filler actions before Dep
action(train(ID),move_forward,Dep+1) :-  start_with_delay(ID,(Y,X),Dep,Dir).             % spawns train in Flatland TODO BUG in Flatland, multiple trains are allowed to spawn at same X,Y at same Dep
%action(train(ID),wait,Dep+2) :-  start_with_delay(ID,(Y,X),Dep,_).                     % only needed if GIF and path.csv should be synced

on(X,Y,ID,Dir,Dep+2)   :- start_with_delay(ID,(Y,X),Dep,Dir).                          % spawns train in ASP logic

on(X,Y,ID,Dir_out,T+1) :-   action_(train(ID), A, T) ,                   % 
                            on(X',Y',ID,Dir',T) ,                       % Cell the train is on step T
                            cell((Y',X'),Tr') ,                         % 
                            waiting(Move_dir , A , Dir_out) ,           % if Action is waiting -> no movement, but keep dir
                            move_in(Move_dir , (X1,Y1)) ,               % 
                            (X,Y)=(X'+ X1,Y' + Y1),                     % move train position
                            cell((Y,X),Tr) , Tr != 0,                   % new position must be a track
                            not moves(T,ID) ,                           % 
                            connection(Tr',Dir',Dir_out,A).             % dir_out has to taken with action, so this line can be removed. -------------------------

waiting(Move_Dir , wait , Dir) :- Move_Dir=none , direction(Dir).           %
waiting(Dir_out, A , Dir_out) :- act(A) , A != wait , direction(Dir_out).   %

turning(Act) :- Act = move_left ; Act = move_right.                         % not used?
