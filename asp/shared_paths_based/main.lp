#include "../alexej_based/track_facts.lp".
#include "pathfinding.lp".
#include "train_logic.lp".

%action(train(ID), A, T+1) :- action_(train(ID), A, T).
% these are just used for Display
%a(ID,(Y,X),A,Dir,T) :- action(ID, A, T) , on(X,Y,(R,P),Dir,T-Delay) , delay(ID,Delay).

%#show a/5.