action(move_forward).
action(move_left).
action(move_right).
%action(wait).

% select one Timestep to spawn
% TODO speed
{spawn(ID, EarliestDeparture..ArrivalTime-MinTravelTime)} = 1 :-
                    start(ID, (Y, X), EarliestDeparture, _),
                    end(ID, (Y1, X1), ArrivalTime),
                    MinTravelTime = |Y-Y1|+|X-X1|.

%action(train(ID), wait, Time) :- spawn(ID, SpawnTime), 
%                                Time=0..SpawnTime-1.
action(train(ID), move_forward, SpawnTime) :- spawn(ID, SpawnTime).
position(ID, (Y, X), Direction, SpawnTime+1) :- 
                                spawn(ID, SpawnTime),
                                start(ID, (Y, X), _, Direction).

{action((train(ID)), Action, Time)} :- 
                    position(ID, (Y, X), _, Time),
                    action(Action),
                    not end(ID, (Y, X), _).

position(ID, (Y+B, X+A), (B, A), Time+1) :-
            position(ID, (Y, X), Incoming_direction, Time),
            action(train(ID), Action, Time),
            cell((Y, X), Track),
            connection(Track, Incoming_direction, (B, A), Action).

arrived(ID, Time) :- position(ID, (Y, X), _, Time),
                end(ID, (Y, X), _).

:- end(ID, (Y, X), _),
    not position(ID, (Y, X), _, _).

:- action(train(ID), Action, Time),
    action(train(ID2), Action2, Time),
    Action != Action2,
    ID = ID2.

:- action(train(ID), _, Time),
    end(ID, _, Latest_arrival_time),
    Time > Latest_arrival_time-1.

