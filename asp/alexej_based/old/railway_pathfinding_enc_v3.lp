% action space:
act(move_forward).
act(move_left).
act(move_right). 
act(wait).

% Directions. The none-direction is only used in Move_dir for waiting and not defined here.
direction(n).
direction(e).
direction(s).
direction(w).

chosen_dir(Dir) :- direction(Dir).

move_in(n    , (0,-1)).
move_in(e    , (1,0) ).
move_in(s    , (0,1) ).
move_in(w    , (-1,0)).
move_in(none , (0,0) ).

%Empty
track(0).
%Straight
track(32800). track(1025).
%Curves
track(4608). track(16386). track(72). track(2064).
%Switches left
track(37408). track(17411). track(32872). track(3089).
%Switches right
track(49186). track(1097). track(34864). track(5633).
%Cross
track(33825).
%Single-slipswitch
track(38433). track(50211). track(33897). track(35889).
%Double-slipswitch
track(38505). track(52275).
%Symmetricalswitch
track(20994). track(16458). track(2136). track(6672).

dir_map_range(Dir_map) :- Dir_map = 0..15. 
dir_map(n , Dir_map) :- 1 = (Dir_map & 8) / 8 , dir_map_range(Dir_map).
dir_map(e , Dir_map) :- 1 = (Dir_map & 4) / 4 , dir_map_range(Dir_map).
dir_map(s , Dir_map) :- 1 = (Dir_map & 2) / 2 , dir_map_range(Dir_map).
dir_map(w , Dir_map) :- 1 = (Dir_map & 1)     , dir_map_range(Dir_map).

tr_map(Dir_map , n , Tr) :- Dir_map = (Tr & 61440) / 4096 , track(Tr).
tr_map(Dir_map , e , Tr) :- Dir_map = (Tr & 3840)  / 256 , track(Tr).
tr_map(Dir_map , s , Tr) :- Dir_map = (Tr & 240)   / 16 , track(Tr).
tr_map(Dir_map , w , Tr) :- Dir_map = (Tr & 15)    , track(Tr).

% Table that maps train direction and action to new direction
% The first two lines should never get used. 
act_dir(Dir_out,Act,Dir) :-   Act = move_forward , Dir_out = Dir , direction(Dir_out).      % THIS MIGHT CAUSE PROBLEMS
act_dir(Dir_out,Act,Dir) :-   Act = wait        ,  Dir_out = Dir , direction(Dir_out).
act_dir(Dir_out,Act,n) :- Act = move_left  , Dir_out = w , direction(Dir_out).
act_dir(Dir_out,Act,n) :- Act = move_right , Dir_out = e , direction(Dir_out).
act_dir(Dir_out,Act,e) :- Act = move_left ,  Dir_out = n , direction(Dir_out).
act_dir(Dir_out,Act,e) :- Act = move_right , Dir_out = s , direction(Dir_out).
act_dir(Dir_out,Act,s) :- Act = move_left ,  Dir_out = e , direction(Dir_out).
act_dir(Dir_out,Act,s) :- Act = move_right , Dir_out = w , direction(Dir_out).
act_dir(Dir_out,Act,w) :- Act = move_left ,  Dir_out = s , direction(Dir_out).
act_dir(Dir_out,Act,w) :- Act = move_right , Dir_out = n , direction(Dir_out).

% all track types that only have one option (or wait)
%forward_only(Track_id) :- track(Track_id) , 1 = A+B+C+D.

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

% no waiting unless already at goal OR no other action possible

:-  action(train(ID), wait, T) , 
    not goal(ID).

% Main filter that checks if an action is valid
:-  action(train(ID), A, T) ,   
    on(X,Y,ID,Dir,T) , 
    cell((Y,X),Tr) , 
    not action_valid(A,Dir,_,Tr).

% EXPERIMENT no waiting on start cell
% :- action(train(ID), A, T) , start(ID,(X',Y'),Dep,Dir) , on(X,Y,ID,Dir,T) , A=wait , (X,Y)=(X',Y').
% :- action(train(ID), A, T) , end(ID,(Y,X),End) , not on(X,Y,ID,Dir,T) , A=wait , direction(Dir).


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

% Optimization
cost_of_action(1,move_forward).
cost_of_action(2,move_left).
cost_of_action(2,move_right).
cost_of_action(3,wait).

weighted_action(ID,A,W,T) :- action(train(ID), A , T) , cost_of_action(W,A).
cost(ID,C) :- C = #sum { W , T : weighted_action(ID,_,W,T) } , train(ID).
number_of_actions(ID,N) :- N = #count { ID,A,T : action(train(ID), A , T)} , train(ID).
%#minimize {C : cost(ID,C)}.
%#minimize {N : number_of_actions(ID,N)}.

% these are just used for Display
a(ID,(X,Y),A,Dir,T) :- action(train(ID), A, T) , on(X,Y,ID,Dir,T).
on(X,Y,ID,M) :- on(X,Y,ID,_,M).

%Display
%#show tr_map/3.
#show a/5.
%#show cost/2.
%#show action/3.
%#show moves/2.
%#show on/5.