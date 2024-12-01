#include "../alexej_based/track_facts.lp".
#include "pathfinding.lp".
#include "train_logic.lp".

%action(train(ID), A, T+1) :- action_(train(ID), A, T).
% these are just used for Display
a((R,P),(Y,X),A,Dir,Step) :- action_((R,P), A, Step) , on(X,Y,(R,P),Dir,Step).

%#show a/5.