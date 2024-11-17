% cardinal direction vector encoding for the grid space
% n: north, e: east, s: south, w: west

#const n = (-1, 0).
#const e = (0, 1).
#const s = (1, 0).
#const w = (0, -1).

% these 4 facts might be obsolete
direction(w).
direction(e).
direction(n).
direction(s).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    track type encoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% connection(1, 2, 3, 4)
% 1: track type; for refrence, please see "Track Types.pdf"
% 2: incoming direction, the orientation/direction the train has when entering a cell with this track type
% 3: outgoing direction based on the incoming direction
% 4: according action the train takes

% Type #1
% straight tracks
% 1025
connection(1025, e, e, move_forward).
connection(1025, w, w, move_forward).
% 32800
connection(32800, n, n, move_forward).
connection(32800, s, s, move_forward).
% 4608
connection(4608, n, w, move_forward).
connection(4608, e, s, move_forward).
% 16386
connection(16386, n, e, move_forward).
connection(16386, w, s, move_forward).
% 72
connection(72, s, e, move_forward).
connection(72, w, n, move_forward).
% 2064
connection(2064, e, n, move_forward).
connection(2064, s, w, move_forward).

% Type #2
% simple switches
% 37408
connection(37408, n, n, move_forward).
connection(37408, n, w, move_left).
connection(37408, s, s, move_forward).
connection(37408, e, s, move_forward).
% 17411
connection(17411, n, e, move_forward).
connection(17411, e, e, move_forward).
connection(17411, w, w, move_forward).
connection(17411, w, s, move_left).
% 32872
connection(32872, n, n, move_forward).
connection(32872, s, s, move_forward).
connection(32872, w, n, move_forward).
connection(32872, s, e, move_left).
% 3089
connection(3089, s, w, move_forward).
connection(3089, e, e, move_forward).
connection(3089, e, n, move_left).
connection(3089, w, w, move_forward).
% 49186
connection(49186, n, n, move_forward).
connection(49186, n, e, move_right).
connection(49186, s, s, move_forward).
connection(49186, w, s, move_forward).
% 1097
connection(1097, e, e, move_forward).
connection(1097, w, n, move_right).
connection(1097, s, e, move_forward).
connection(1097, w, w, move_forward).
% 34864
connection(34864, n, n, move_forward).
connection(34864, s, w, move_right).
connection(34864, e, n, move_forward).
connection(34864, s, s, move_forward).
% 5633
connection(5633, e, e, move_forward).
connection(5633, e, s, move_right).
connection(5633, n, w, move_forward).
connection(5633, w, w, move_forward).

% Type #3
% diamond crossing
% 33825
connection(33825, e, e, move_forward).
connection(33825, s, s, move_forward).
connection(33825, n, n, move_forward).
connection(33825, w, w, move_forward).

% Type #4
% single-slip switches
% 38433
connection(38433, e, e, move_forward).
connection(38433, s, s, move_forward).
connection(38433, n, n, move_forward).
connection(38433, w, w, move_forward).
connection(38433, n, w, move_left).
connection(38433, e, s, move_right).
% 50211
connection(50211, e, e, move_forward).
connection(50211, s, s, move_forward).
connection(50211, n, n, move_forward).
connection(50211, w, w, move_forward).
connection(50211, n, e, move_right).
connection(50211, w, s, move_left).
% 33897
connection(33897, e, e, move_forward).
connection(33897, s, s, move_forward).
connection(33897, n, n, move_forward).
connection(33897, w, w, move_forward).
connection(33897, w, n, move_right).
connection(33897, s, e, move_left).
% 35889
connection(35889, e, e, move_forward).
connection(35889, s, s, move_forward).
connection(35889, n, n, move_forward).
connection(35889, w, w, move_forward).
connection(35889, s, w, move_right).
connection(35889, e, n, move_left).

% Type #5
% double-slip switches
% 38505
connection(38505, e, e, move_forward).
connection(38505, s, s, move_forward).
connection(38505, n, n, move_forward).
connection(38505, w, w, move_forward).
connection(38505, s, e, move_left).
connection(38505, e, s, move_right).
connection(38505, n, w, move_left).
connection(38505, w, n, move_right).
% 52275
connection(52275, e, e, move_forward).
connection(52275, s, s, move_forward).
connection(52275, n, n, move_forward).
connection(52275, w, w, move_forward).
connection(52275, s, w, move_right).
connection(52275, e, n, move_left).
connection(52275, n, e, move_right).
connection(52275, w, s, move_left).

% Type #6
% symmetrical switches
% 20994
connection(20994, e, s, move_forward).
connection(20994, w, s, move_forward).
connection(20994, n, w, move_forward).
connection(20994, n, e, move_forward).
% 16458
connection(16458, n, e, move_forward).
connection(16458, s, e, move_forward).
connection(16458, w, n, move_forward).
connection(16458, w, s, move_forward).
% 2136
connection(2136, e, n, move_forward).
connection(2136, w, n, move_forward).
connection(2136, s, w, move_forward).
connection(2136, s, e, move_forward).
% 6672
connection(6672, n, w, move_forward).
connection(6672, s, w, move_forward).
connection(6672, e, n, move_forward).
connection(6672, e, s, move_forward).