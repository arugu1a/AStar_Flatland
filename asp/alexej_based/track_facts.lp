% action space:
act(move_forward).
act(move_left).
act(move_right). 
%act(wait).

% Directions. The none-direction is only used in Move_dir for waiting and not defined here.
direction(n).
direction(e).
direction(s).
direction(w).

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