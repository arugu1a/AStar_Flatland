#include "track_facts.lp".
% #include "malf_test_env005.lp".

% malfunction(0,5,26).

% train(0).

% generate actions that already occured in Flatland
{action(train(ID),A,T) : act(A) } = 1 :- T=0..T_malf , malfunction(ID,_,T_malf).

% Malfunctions require wait actions for the duration of the malfunction.
{action(train(ID),wait,T_) : T_=T+1..T+Dur} = Dur :- malfunction(ID,Dur,T).

% BUG?: one additional action (the last action that already occured gets eaten by malf. and the conditions seem to be offset by one)
{action(train(ID),A,T+1) } = 1 :- T=Dur+T_malf , malfunction(ID,Dur,T_malf) , action(train(ID),A,T_malf).

% This only works if there is only one train (per path). % TEMPORARY FIX: T-1 in planned action to account for offset
action(train(ID),Act,T + T_malf + Dur +2) :- planned_action(train(ID),Act,T-1) , malfunction(ID,Dur,T_malf).

% Test for malfunctions, delate later!
foobar(12345).
#show foobar/1.
#show action/3.