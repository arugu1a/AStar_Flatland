{route(ID,Start,Dir,End,EndTime-StartTime) : duplicate_route(ID) , start(ID,Start,StartTime,Dir) , end(ID,End,EndTime) }=1 :- duplicate_route.                                      % treat multiple same start&end as one route 
route(ID,Start,Dir,End,EndTime-StartTime) :- not duplicate_route(ID) , start(ID,Start,StartTime,Dir) , end(ID,End,EndTime).                                     
duplicate_route(ID2) :- start(ID1,(Y,X),_,Dir) , start(ID2,(Y,X),_,Dir) ,  end(ID1,(Y',X'),End1) , end(ID2,(Y',X'),End2) , ID1!=ID2 , End1 <= End2.
duplicate_route :- duplicate_route(_).

train_route(ID,Route) :- route(Route,Start,Dir,End,EndTime-StartTime) , start(ID,Start,StartTime,Dir) , end(ID,End,EndTime).
% For now just one Path. 
% For later: assign different paths from same start,(dir),end to same route. 
% How? Different path answers in ASP have to be part of the same answer set
path(Route,0,Start,Dir,0) :- route(Route,Start,Dir,End,_).

{action_((R,P),A,Step) : act(A) , A != wait}=1 :- on(X,Y,(R,P),Dir,Step) , not goal((R,P),Step).%not Step=50
:- action_((R,P),A,T) , on(X,Y,(R,P),Dir,T) , cell((Y,X),Tr) , not connection(Tr,Dir,_,A).

% no path can be longer than number of cells with a track
% BETTER: no path is allowed to loop, how is that formulated?
max_cells(NUM_CELLS)          :- NUM_CELLS = #count {cell((X,Y),ID) : ID!=0 , track(ID) , cell((X,Y),ID)}.
    % path_length((R,P),NUM_STEPS)  :- NUM_STEPS = #count {action_((R,P),A,Step) : act(A) , on(_,_,(R,P),_,Step)} , path(R,P,_,_,_).
%* TODO OTHER TIME 
path(Route,Path,Pos_new,Step+1) :-  path(Route,Path,(X,Y),Act,Step) , 
                                    cell((Y,X),Tr) ,
                                    action_valid(A,Dir,Dir_out,Tr) , 
                                    Pos_new=(X+ X1,Y + Y1) , 
                                    .
*%
%---------------------------------------------------------------------------------------------%
%moves(M,ID) :- start(ID,_,St,_) , end(ID,_,End) , M= End.
%moves(M,(R,P)) :- path(R,P,_,_,_) , M=20.

on(X,Y,(Route,Path),Dir,0) :- path(Route,Path,(Y,X),Dir,_).              % spawns train in ASP logic

on(X,Y,(R,P),Dir_out,T+1) :-    action_((R,P), A, T) ,                   % 
                                on(X',Y',(R,P),Dir',T) ,                 % Cell the train is on step T
                                cell((Y',X'),Tr') ,                       
                                move_in(Dir_out , (X1,Y1)) ,                
                                (X,Y)=(X'+ X1,Y' + Y1),                  % move train position
                                cell((Y,X),Tr) , Tr != 0,                % new position must be a track
                                not route(R,_,_,_,T) ,                   
                                not goal((R,P),T) ,
                                connection(Tr',Dir',Dir_out,A).          % dir_out has to taken with action, so this line can be removed. -------------------------


% No loops allowed
%:- on(X,Y,(Route,ID),Dir,T) , on(X,Y,(Route,ID),Dir,T2), T2 > T.

% Goal condition
goal(R,P) :- goal((R,P),_).
goal((R,P),T) :- on(X,Y,(R,P),_,T) , route(R,_,_,(Y,X),MAX_T) , T<=MAX_T.
:- not goal(R,P) , path(R,P,_,_,_).

%#show duplicate_route/1.
#show train_route/2.
%#show route/5.
%#show path/5.
%#show on/5.
%#show action_/3.
%#show goal/2.
%#show max_cells/1.
%#show path_length/2.