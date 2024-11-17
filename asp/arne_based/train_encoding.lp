
% time fact, so that for every train every time step has a fact time(train ID, valid time step)
% this leads to the train ID being stored twice in a move 
% -> ToDo: if the time generation is incorporated into the move generation than this can be avoided
% it is probably possible to get rid of time facts all together

time(Train_ID, Start_time..End_time) :- start(Train_ID, (_, _), Start_time, _), end(Train_ID, (_, _), End_time).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    train step logic encoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extra action generation so output matches flatlands demands

action(train(Train_ID), move_forward, Start_time) :- start(Train_ID, _, Start_time, _).
action(train(Train_ID), wait, Time) :- start(Train_ID, _, Start_time, _), Time=0..Start_time-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start kick
kick(Train_ID, (Train_ID, Time), (X, Y), Outgoing_direction, Action) :- start(Train_ID, (X, Y), Time, Incoming_direction),
																			cell((X, Y), TrackType),
																			connection(TrackType, Incoming_direction, Outgoing_direction, Action).

% start wait kick
% dirty workaround:	setting the kick position to (Y-B, X-A) to preserve the direction of the train but 
% 					at the same time achieve a illusory +(0, 0) movement
kick(Train_ID, (Train_ID, Time), (X-B, Y-A), (B, A), wait) :- start(Train_ID, (X, Y), Time, (B, A)).

{move(Train_ID, (X + B, Y + A), (Train_ID, Time+1), (B, A), Action)} :- kick(Train_ID, (Train_ID, Time), (X, Y), (B, A), Action),
																			time(Train_ID, Time),
																			end(Train_ID, (_, _), End_time),
																			Time<End_time.
																			
kick(Train_ID, (Train_ID, Time), (X, Y), Outgoing_direction, Action) :- move(Train_ID, (X, Y), (Train_ID, Time), Incoming_direction, _),
																			cell((X, Y), Track_type),
																			connection(Track_type, Incoming_direction, Outgoing_direction, Action),
																			not end(Train_ID, (X, Y), _).

% wait kicks
% same workaround as in the start wait kick																
kick(Train_ID, (Train_ID, Time), (X-B, Y-A), (B, A), wait) :- move(Train_ID, (X, Y), (Train_ID, Time), (B, A), _),
																			cell((X, Y), _),
																			not end(Train_ID, (X, Y), _).


% there has to be a move to the end cell		
:- not move(Train_ID, (X, Y), (_, _), _, _), end(Train_ID, (X, Y), _).

% there cannot be a move without a legal time
% !this should become redundant when simplifing time() and correcting the move generation
:- move(_, (_, _), (_, Time), (_, _), _), not time(_, Time).

% there cannot be 2 moves at the same time step
:- {move(Train_ID, (_, _), (Train_ID, Time), _, _)} > 1, time(Train_ID, Time).

% two different trains cannot move to same cell
:- move(Train_ID_1, (X, Y), (Train_ID_1, Time), (_, _), _), move(Train_ID_2, (X, Y), (Train_ID_2, Time), (_, _), _), Train_ID_1 != Train_ID_2.

%WIP, 2 trains cannot swap spaces
:- move(Train_ID_1, (X, Y), (Train_ID_1, Time), (B, A), _),
	move(Train_ID_2, (X-B, Y-A), (Train_ID_2, Time), (_, _), _),
	Train_ID_1 != Train_ID_2.


% translation from move to the simplified action
action(train(Train_ID), Action, Time) :- move(Train_ID, _, (Train_ID, Time), _, Action).
a(Train_ID, (X, Y), Time) :- move(Train_ID, (X, Y), (_, Time), _, _).


%#show move/5.
#show action/3.
%#show a/3.
%#show time/2.