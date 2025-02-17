% how many time steps is a train allowed to do actions?
% After M is reached the train should be at dest. and stay there 
% -> only act(wait) allowed after M is reached.
past_malfunctions_delay(M,ID) :- M = #sum {Dur,ID,T : malfunction(ID,Dur,T)} , train(ID).
past_malfunctions_delay(M) :- #max {M : past_malfunctions_delay(M,ID)} , past_malfunctions_delay(M,ID).
moves(M,ID) :- start(ID,_,St,_) , end(ID,_,End) , M= End+Past_malf_del , past_malfunctions_delay(Past_malf_del,_).

{action_(train(ID),A,T) : act(A) %*, A != wait *% } = 1 :- on(X,Y,ID,Dir,T) , not goal(ID,T).
:- action_(train(ID), A, T) ,  malfunction(ID,_,T) , A!=wait. % this works if solve.py provide_context has past = convert_formers_to_clingo(actions[:timestep])

delay(ID1,Del) :- Del = Dep..(Dep+N-1 + 5) , N = #count { ID : start(ID,(Y,X),Dep,_) } , start(ID1,(Y,X),Dep,_).
{start_with_delay(ID,(Y,X),Del,Dir) : delay(ID,Del)}=1 :- start(ID,(Y,X),Dep,Dir).     % delay has to return Del = Dep + time needed so all trains can depart on this spot.

action(train(ID),wait,T) :-  start_with_delay(ID,(Y,X),Dep,_) , T = 0..Dep.            % filler actions before Dep
action(train(ID),move_forward,Dep+1) :-  start_with_delay(ID,(Y,X),Dep,Dir).           % spawns train in Flatland

on(X,Y,ID,Dir,Dep+2)   :- start_with_delay(ID,(Y,X),Dep,Dir).                          % spawns train in ASP logic

on(X,Y,ID,Dir_out,T+1) :-   action_(train(ID), A, T) ,                    
                            on(X',Y',ID,Dir',T) ,
                            cell((Y',X'),Tr') ,                          
                            waiting(Move_dir , A , Dir_out) ,          % if Action is waiting -> no movement, but keep dir
                            move_in(Move_dir , (X1,Y1)) ,               % 
                            (X,Y)=(X'+ X1,Y' + Y1),                     % move train position
                            not moves(T,ID) ,                           % 
                            connection(Tr',Dir',Dir_out,A).             % dir_out has to taken with action, so this line can be removed. -------------------------

waiting(none , wait , Dir) :- direction(Dir).           
waiting(Dir_out, A , Dir_out) :- act(A) , A != wait , direction(Dir_out).   

turning(Act) :- Act = move_left ; Act = move_right.                         % not used?

#show action/3.
%#show waiting/3.
%#show malf/5.
%#show X : X = malf(ID,start_of_malf,none,Move_dir,T) , malf(ID,_,_,Move_dir,T).
%#show on/4.
%#show past_malfunctions_delay/2.