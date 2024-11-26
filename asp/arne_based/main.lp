% main.lp

#include "track_type_encoding.lp".
#include "train_encoding.lp".

% translation from move to the simplified action
action(train(Train_ID), Action, Time) :- move(Train_ID, _, (Train_ID, Time), _, Action).

a(Train_ID, (Y, X), Time) :- move(Train_ID, (Y, X), (_, Time), _, _).

%#show move/5.
#show action/3.
%#show a/3.
%#show time/2.
%#show kick/5.
