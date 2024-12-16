#include "track_facts.lp".
#include "transition_logic.lp".
#include "interaction_logic.lp".
%#include "malf_test_env005.lp".

% Optimization
%cost_of_action(1,move_forward).
%cost_of_action(2,move_left).
%cost_of_action(2,move_right).
%cost_of_action(3,wait).

%weighted_action(ID,A,W,T) :- action_(train(ID), A , T) , cost_of_action(W,A).
%cost(ID,C) :- C = #sum { W , T : weighted_action(ID,_,W,T) } , train(ID).
%number_of_actions(ID,N) :- N = #count { ID,A,T : action_(train(ID), A , T)} , train(ID).
%#minimize {C : cost(ID,C)}.
%#minimize {N : number_of_actions(ID,N)}.
% #minimize {N : N=#count { ID,A,T : action_(train(ID), A , T)} , train(ID)}.


%action(train(ID), move_forward, 0) :- train(ID).
action(train(ID), A, T) :- action_(train(ID), A, T). %, not goal(ID,T).
%action(train(ID), move_forward, T+1) :- action_(train(ID), _, T) , goal(ID,T).

% these are just used for Display
a(ID,(Y,X),A,Dir,T) :- action(train(ID), A, T) , on(X,Y,ID,Dir,T).
on(X,Y,ID,M) :- on(X,Y,ID,_,M).

%Display
%#show tr_map/3.
%#show a/5.
%#show cost/2.
%#show action/3.
%#show moves/2.
%#show on/5.
%#show delay/2.
