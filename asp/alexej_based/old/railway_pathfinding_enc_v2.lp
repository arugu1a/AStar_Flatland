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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Track Types and their corresponding 16-bit encoding. 
% TODO for later: throw tuple encoding out and replace with calculating 
% Bit-and on ID and bitmasks:
% N: 1st tuple: 15      . Div to get rid of trailing 0's: 16
% E: 2nd tuple: 240     . Div to get rid of trailing 0's: 256
% S: 3nd tuple: 3840    . Div to get rid of trailing 0's: 4096
% W: 4nd tuple: 61440   . Div to get rid of trailing 0's: 65536
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Empty
track_type_map(0, track((0,0,0,0) , (0,0,0,0) , (0,0,0,0) , (0,0,0,0))).
%Straight
track_type_map(32800, track((1,0,0,0) , (0,0,0,0) , (0,0,1,0) , (0,0,0,0))).
track_type_map(1025, track((0,0,0,0) , (0,1,0,0) , (0,0,0,0) , (0,0,0,1))).
%Curves
track_type_map(4608, track((0,0,0,1) , (0,0,1,0) , (0,0,0,0) , (0,0,0,0))).
track_type_map(16386, track((0,1,0,0) , (0,0,0,0) , (0,0,0,0) , (0,0,1,0))).
track_type_map(72, track((0,0,0,0) , (0,0,0,0) , (0,1,0,0) , (1,0,0,0))).
track_type_map(2064, track((0,0,0,0) , (1,0,0,0) , (0,0,0,1) , (0,0,0,0))).
%Switches left
track_type_map(37408, track((1,0,0,1) , (0,0,1,0) , (0,0,1,0) , (0,0,0,0))).
track_type_map(17411, track((0,1,0,0) , (0,1,0,0) , (0,0,0,0) , (0,0,1,1))).
track_type_map(32872, track((1,0,0,0) , (0,0,0,0) , (0,1,1,0) , (1,0,0,0))).
track_type_map(3089, track((0,0,0,0) , (1,1,0,0) , (0,0,0,1) , (0,0,0,1))).
%Switches right
track_type_map(49186, track((1,1,0,0) , (0,0,0,0) , (0,0,1,0) , (0,0,1,0))).
track_type_map(1097, track((0,0,0,0) , (0,1,0,0) , (0,1,0,0) , (1,0,0,1))).
track_type_map(34864, track((1,0,0,0) , (1,0,0,0) , (0,0,1,1) , (0,0,0,0))).
track_type_map(5633, track((0,0,0,1) , (0,1,1,0) , (0,0,0,0) , (0,0,0,1))).
%Cross
track_type_map(33825, track((1,0,0,0) , (0,1,0,0) , (0,0,1,0) , (0,0,0,1))).
%Single-slipswitch
track_type_map(38433, track((1,0,0,1) , (0,1,1,0) , (0,0,1,0) , (0,0,0,1))).
track_type_map(50211, track((1,1,0,0) , (0,1,0,0) , (0,0,1,0) , (0,0,1,1))).
track_type_map(33897, track((1,0,0,0) , (0,1,0,0) , (0,1,1,0) , (1,0,0,1))).
track_type_map(35889, track((1,0,0,0) , (1,1,0,0) , (0,0,1,1) , (0,0,0,1))).
%Double-slipswitch
track_type_map(38505,track((1,0,0,1) , (0,1,1,0) , (0,1,1,0) , (1,0,0,1))).
track_type_map(52275,track((1,1,0,0) , (1,1,0,0) , (0,0,1,1) , (0,0,1,1))).
%Symmetricalswitch
track_type_map(20994,track((0,1,0,1) , (0,0,1,0) , (0,0,0,0) , (0,0,1,0))).
track_type_map(16458,track((0,1,0,0) , (0,0,0,0) , (0,1,0,0) , (1,0,1,0))).
track_type_map(2136 ,track((0,0,0,0) , (1,0,0,0) , (0,1,0,1) , (1,0,0,0))).
track_type_map(6672 ,track((0,0,0,1) , (1,0,1,0) , (0,0,0,1) , (0,0,0,0))).


fourbit_tuple(0..1,0..1,0..1,0..1).
dir_map(n , Dir_map) :- (1,B,C,D) = Dir_map , fourbit_tuple(A,B,C,D).
dir_map(e , Dir_map) :- (A,1,C,D) = Dir_map , fourbit_tuple(A,B,C,D).
dir_map(s , Dir_map) :- (A,B,1,D) = Dir_map , fourbit_tuple(A,B,C,D). 
dir_map(w , Dir_map) :- (A,B,C,1) = Dir_map , fourbit_tuple(A,B,C,D). 

%  Dir_out from matching 4bit tuple of tr_map and Dir that the train wants to go. 
tr_allowed(Dir_out, Dir , Tr_id ) :- tr_map(Dir_map, Dir, Tr_id) , dir_map(Dir_out,Dir_map) , direction(Dir_out).

% Dir selects nth tuple N..W Dir_map.
tr_map(Dir_map, Dir, Tr_id) :- tr_map2(Dir_map, Dir, Tr) , track_type_map(Tr_id, Tr).
tr_map2(Dir_map, Dir, track(N,E,S,W))   :- Dir=n , Dir_map = N , track_type_map(_,track(N,E,S,W)).
tr_map2(Dir_map, Dir, track(N,E,S,W))   :- Dir=e  , Dir_map = E , track_type_map(_,track(N,E,S,W)).
tr_map2(Dir_map, Dir, track(N,E,S,W))   :- Dir=s , Dir_map = S , track_type_map(_,track(N,E,S,W)).
tr_map2(Dir_map, Dir, track(N,E,S,W))   :- Dir=w  , Dir_map = W , track_type_map(_,track(N,E,S,W)).




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
forward_only(Track_id) :- track_type_map(Track_id , track(A,B,C,D)) , 1 = A+B+C+D , fourbit_tuple(A,B,C,D).

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
% Given a train direction and outgoing direction on a specific Track , returns possible Actions that resulted in these 
action_from_dir_dir_map(move_forward,Dir,Dir_out,Dir_map) :- Dir_map = (A,B,C,D) , A+B+C+D = 1 , direction(Dir) , direction(Dir_out) , fourbit_tuple(A,B,C,D).      % all tiles without turning options while going towards Dir
action_from_dir_dir_map(wait,Dir,Dir_out,Dir_map) :- Dir_map = (A,B,C,D) , A+B+C+D = 1 , direction(Dir) , direction(Dir_out) , fourbit_tuple(A,B,C,D).
action_from_dir_dir_map(Act,Dir,Dir_out,Dir_map) :- act_dir(Dir_out,Act,Dir) , Dir_map = (A,B,C,D) , fourbit_tuple(A,B,C,D) , A+B+C+D != 1.  

%
action_valid(Act,Dir_in,Dir_out,Tr) :- action_from_dir_dir_map(Act,Dir_in,Dir_out,Dir_map) , 
    tr_map(Dir_map, Dir_in, Tr) ,
    dir_map(Dir_out,Dir_map) , 
    direction(Dir_in) ,
    direction(Dir_out).

%  
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
:- not on(X,Y,ID,M) , end(ID,(Y,X),End) , moves(M,ID).

% these are just used for Display
a(ID,(X,Y),A,Dir,T) :- action(train(ID), A, T) , on(X,Y,ID,Dir,T).
on(X,Y,ID,M) :- on(X,Y,ID,_,M).

%Display
#show a/5.
% #show action/3.
%#show moves/2.
%#show on/5.