% how many time steps is a train allowed to do actions?
% After M is reached the train should be at dest. and stay there 
% -> only act(wait) allowed after M is reached. (THIS IS NOT IMPLEMENTED, trains can go past the target as long as they get there again eventually)
moves(M,ID) :- start(ID,_,St,_) , end(ID,_,End) , M= End - St +1.

% Generate
{action(train(ID),A,T) : act(A) , train(ID)} = 1 :- moves(M,ID), T=1..M.

% Define

on(X,Y,ID,Dir,1)   :- start(ID,(Y,X),Dep,Dir).                          % Init ignores Departure time
on(X,Y,ID,Dir_out,T+1) :-   action(train(ID), A, T) ,                   % 
                            on(X',Y',ID,Dir',T) ,                       % Cell the train is on step T
                            cell((Y',X'),Tr') ,                         % 
                            waiting(Move_dir , A , Dir_out) ,           % if Action is waiting -> no movement, but keep dir
                            move_in(Move_dir , (X1,Y1)) ,               % 
                            (X,Y)=(X'+ X1,Y' + Y1),                     % move train position
                            cell((Y,X),Tr) , Tr != 0,                   % new position must be a track
                            not moves(T,ID) , 
                            action_valid(A,Dir',Dir_out,Tr').           

waiting(Move_Dir , wait , Dir) :- Move_Dir=none , direction(Dir).           %
waiting(Dir_out, A , Dir_out) :- act(A) , A != wait , direction(Dir_out).   %

turning(Act) :- Act = move_left ; Act = move_right.

forward_only(Dir_map) :- Dir_map = (1;2;4;8).
% Given a train direction and outgoing direction on a specific Track , returns possible Actions that resulted in these 
action_from_dir_dir_map(move_forward,Dir,Dir_out,Dir_map) :- forward_only(Dir_map) , direction(Dir) , direction(Dir_out).      % all tiles without turning options while going towards Dir
action_from_dir_dir_map(wait,Dir,Dir_out,Dir_map)         :- forward_only(Dir_map) , direction(Dir) , direction(Dir_out).
action_from_dir_dir_map(Act,Dir,Dir_out,Dir_map)          :- act_dir(Dir_out,Act,Dir) , not forward_only(Dir_map) , dir_map_range(Dir_map).  

%
action_valid(Act,Dir_in,Dir_out,Tr) :- action_from_dir_dir_map(Act,Dir_in,Dir_out,Dir_map) , 
    tr_map(Dir_map, Dir_in, Tr) ,
    dir_map(Dir_out,Dir_map) , 
    direction(Dir_in) ,
    direction(Dir_out).

% Main filter that checks if an action is valid
:-  action(train(ID), A, T) ,   
    on(X,Y,ID,Dir,T) , 
    cell((Y,X),Tr) , 
    not action_valid(A,Dir,_,Tr).