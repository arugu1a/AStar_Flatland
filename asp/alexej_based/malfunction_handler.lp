#include "track_facts.lp".

% 

% generate actions that already occured in Flatland
{action(train(ID),A,T) : act(A) } = 1 :- T=0..T_malf-1 , malfunction(ID,_,T_malf).

% Malfunctions require wait actions for the duration of the malfunction.
% CURRENT BUG: Malfunction window does not include timestep of malfunction itself. -> T+Dur+1
{action(train(ID),wait,T_) : T_=T..T+Dur+1} = Dur+1 :- malfunction(ID,Dur,T).

% THIS WAS CHANGED/FIXED IN THE MAIN BRANCH: BUG?: one additional action (the last action that already occured gets eaten by malf. and the conditions seem to be offset by one)
%{action(train(ID),A,T+1) } = 1 :- T=Dur+T_malf , malfunction(ID,Dur,T_malf) , action(train(ID),A,T_malf).

% This only works if there is only one train (per path). % THIS WAS CHANGED/FIXED IN THE MAIN BRANCH: TEMPORARY FIX: T-1 in planned action to account for offset
action(train(ID),Act,T + T_malf + Dur +2) :- planned_action(train(ID),Act,T) , malfunction(ID,Dur,T_malf).

#show action/3.