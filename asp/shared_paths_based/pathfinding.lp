{route(ID,Start,Dir,End) : duplicate_route(ID) , start(ID,Start,_,Dir) , end(ID,End,_)}=1 :- duplicate_route.                                      % treat multiple same start&end as one route 
route(ID,Start,Dir,End) :- not duplicate_route(ID) , start(ID,Start,_,Dir) , end(ID,End,_).                                     
duplicate_route(ID1) :- start(ID1,(Y,X),_,Dir) , start(ID2,(Y,X),_,Dir) ,  end(ID1,(Y',X'),_) , end(ID2,(Y',X'),_) , ID1!=ID2.
duplicate_route :- duplicate_route(_).
% For now just one Path. 
% For later: assign different paths from same start,(dir),end to same route. 
% How? Different path answers in ASP have to be part of the same answer set
path(Route,0,Start,Dir,0) :- route(Route,Start,Dir,End).

{action_((R,P),A,Step) : act(A) , A != wait}=1 :- on(X,Y,(R,P),Dir,Step), not Step=50 , not goal((R,P),Step).
:- action_((R,P),A,T) , on(X,Y,(R,P),Dir,T) , cell((Y,X),Tr) , not connection(Tr,Dir,_,A).

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

on(X,Y,(Route,Path),Dir,0) :- path(Route,Path,(Y,X),Dir,_).                          % spawns train in ASP logic

on(X,Y,(R,P),Dir_out,T+1) :-    action_((R,P), A, T) ,                   % 
                                on(X',Y',(R,P),Dir',T) ,                       % Cell the train is on step T
                                cell((Y',X'),Tr') ,                         % 
                                move_in(Dir_out , (X1,Y1)) ,               % 
                                (X,Y)=(X'+ X1,Y' + Y1),                     % move train position
                                cell((Y,X),Tr) , Tr != 0,                   % new position must be a track
                                %not T=100 ,                           % 
                                connection(Tr',Dir',Dir_out,A).             % dir_out has to taken with action, so this line can be removed. -------------------------


% No loops allowed
%:- on(X,Y,(Route,ID),Dir,T) , on(X,Y,(Route,ID),Dir,T2), T2 > T.
% Goal condition
goal(R,P) :- goal((R,P),_).
goal((R,P),T) :- on(X,Y,(R,P),_,T) , route(R,_,_,(Y,X)), time(T).
:- not goal(R,P) , path(R,P,_,_,_).

time(T) :- T= 0..50.

%#show time/1.
%#show duplicate_route/1.
#show route/4.
%#show path/5.
%#show on/5.
%#show action_/3.
%#show a/5.
#show goal/2.

