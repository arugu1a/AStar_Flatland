% simple_3x3_track.lp
% encoding of "simple_3x3_track.png"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a train and its start and end point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start(train ID, (Y,X), earliest departure time, direction)
% end(train ID, (Y,X), latest arrival time)

train(0).
start(0, (1, 2), 0, e).
end(0, (0, 2), 8).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    3x3 map (simple_3x3_track.png)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cell((y, x) track type)
% y-coordinate represents columns, x-coordinate represents rows (weird!! why??)
% (0, 0) is in the top left

cell((0, 0), 16386).	cell((1, 0), 1025). 	cell((2, 0), 4608).
cell((0, 1), 49186). 	cell((1, 1), 1025). 	cell((2, 1), 37408).
cell((0, 2), 72). 		cell((1, 2), 1025). 	cell((2, 2), 2064).


