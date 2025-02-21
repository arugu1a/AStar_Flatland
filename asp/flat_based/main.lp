#include "tracks.lp".
#include "trains.lp".


% fact for matrix generation
pos(ID, (Y, X), Time) :- position(ID, (Y, X), _, Time).

%#show action/3.
#show arrived/1.