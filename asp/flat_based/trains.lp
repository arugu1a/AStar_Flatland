command(move_forward).
command(move_left).
command(move_right).
command(wait).

% select one Timestep to spawn
{spawn(ID, EarliestDeparture..ArrivalTime-MinTravelTime)} = 1 :-
                    start(ID, (Y, X), EarliestDeparture, _),
                    end(ID, (B, A), ArrivalTime),
                    speed(ID, Speed),
                    MinTravelTime = |Y-B|+|X-A|*Speed.

:- spawn(_, 0).

action(train(ID), wait, Time) :- spawn(ID, SpawnTime), 
                                Time=0..SpawnTime-1.

action(train(ID), move_forward, SpawnTime) :- spawn(ID, SpawnTime).
position(ID, (Y, X), Direction, SpawnTime+1) :-
                                spawn(ID, SpawnTime),
                                start(ID, (Y, X), _, Direction).

{action((train(ID)), Action, Time)} :-
                    position(ID, (Y, X), _, Time),
                    command(Action),
                    end(ID, _, EndTime),
                    Time <= EndTime.

position(ID, (Y+B, X+A), (B, A), Time+Speed) :-
            position(ID, (Y, X), Direction, Time),
            action(train(ID), Action, Time),
            speed(ID, Speed),
            cell((Y, X), Track),
            connection(Track, Direction, (B, A), Action).

position(ID, (Y, X), Direction, Time+1) :-
            position(ID, (Y, X), Direction, Time),
            action(train(ID), wait, Time),
            speed(ID, Speed).

in_motion(ID, (Y, X), (Y+B, X+A), Time..Time+Speed-1) :-
            position(ID, (Y, X), Direction, Time),
            action(train(ID), Action, Time),
            connection(Track, Direction, (B, A), Action),
            speed(ID, Speed),
            cell((Y, X), Track).

:- position(ID, (Y,X), _, Time), position(ID2, (Y,X),_,Time),
    ID != ID2.

% a train must reach the end position
:- end(ID, (Y, X), _),
    not position(ID, (Y, X), _, _).

% only one action per train per timestep
:- action(train(ID), Action, Time),
    action(train(ID2), Action2, Time),
    Action != Action2,
    ID = ID2.

:- in_motion(ID, (Y, X), (B, A), Time),
    in_motion(ID2, (B, A), (Y, X), Time),
    ID != ID2.

:- in_motion(ID, (Y, X), _, Time),
    position(ID2, (Y, X), _, Time),
    ID != ID2.
