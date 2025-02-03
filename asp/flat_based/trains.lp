action(move_forward).
action(move_left).
action(move_right).
action(wait).

% select one Timestep to spawn
{spawn(ID, EarliestDeparture..ArrivalTime-MinTravelTime)} = 1 :-
                    start(ID, (Y, X), EarliestDeparture, _),
                    end(ID, (Y1, X1), ArrivalTime),
                    speed(ID, Speed),
                    MinTravelTime = |Y-Y1|+|X-X1|*Speed.

action(train(ID), wait, Time) :- spawn(ID, SpawnTime), 
                                Time=0..SpawnTime-1.
                                
action(train(ID), move_forward, SpawnTime) :- spawn(ID, SpawnTime).
position(ID, (Y, X), Direction, SpawnTime+1) :- 
                                spawn(ID, SpawnTime),
                                start(ID, (Y, X), _, Direction).

{action((train(ID)), Action, Time)} :-
                    position(ID, (Y, X), _, Time),
                    action(Action),
                    not end(ID, (Y, X), _),
                    end(ID, _, EndTime),
                    Time < EndTime.

% the following two rules contain a lot of code duplication
% some other syntax?
% maybe it is possible to get rid of moving_to

position(ID, (Y+B, X+A), (B, A), Time+Speed) :-
            position(ID, (Y, X), Incoming_direction, Time),
            action(train(ID), Action, Time),
            speed(ID, Speed),
            cell((Y, X), Track),
            connection(Track, Incoming_direction, (B, A), Action).

moving_to(ID, (Y+B, X+A), Time..Time+Speed-1) :-
            position(ID, (Y, X), Incoming_direction, Time),
            action(train(ID), Action, Time),
            speed(ID, Speed),
            cell((Y, X), Track),
            connection(Track, Incoming_direction, (B, A), Action).

position(ID, (Y, X), Direction, Time+1) :-
            position(ID, (Y, X), Direction, Time),
            action(train(ID), Action, Time),
            Action = wait.


arrived(ID, Time) :- position(ID, (Y, X), _, Time),
                end(ID, (Y, X), _).

% a train must reach the end position
:- end(ID, (Y, X), _),
    not position(ID, (Y, X), _, _).

% only one action per train per timestep
:- action(train(ID), Action, Time),
    action(train(ID2), Action2, Time),
    Action != Action2,
    ID = ID2.

% train is not allowd to move after end, this is obsolete because
% of the choice rule, to be deleted
%* :- action(train(ID), _, Time),
    end(ID, _, Latest_arrival_time),
    Time > Latest_arrival_time-1.
*%

:- moving_to(ID1, (Y, X), Time), moving_to(ID2, (Y, X), Time),
    ID1 != ID2.

%*:- position(ID1, (B, A), _, Time-Speed1),
    speed(ID, Speed1),
    moving_to(ID1, (Y, X), Time),
    position(ID2, (Y, X), _, Time-Speed2),
    speed(ID, Speed2),
    moving_to(ID2, (B, A), Time),
    ID1 != ID2.
*%

