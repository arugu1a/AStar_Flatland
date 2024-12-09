% Spawn train on path that leads to end
delay_(ID,Del) :- Del=Dep..(Dep + 10) , start(ID,_,Dep,_).
{delay(ID,Del) : delay_(ID,Del) }=1 :- train(ID).

time(ID,T) :- delay(ID,Delay) , T = Delay..EndTime , end(ID,_,EndTime).
%:- action_((R,0),_,Step) , not time(ID,T) , T=Del..EndTime , train_route(ID,R) , delay_(ID,Del) , end(ID,_,EndTime).

% filler actions before Dep
action(train(ID),wait,T) :-  delay(ID,Delay) , T = 0..Delay.           
action(train(ID),move_forward,Delay+1) :-  delay(ID,Delay).           


% take actions from path with time offset
action(train(ID),A,T+2) :- action_((R,0),A,T-Delay) , delay(ID,Delay) , train_route(ID,R) , time(ID,T).

% Logic for trains blocking eachother ---------------------------------------------------------------------

collide(ID1,ID2,T):-    on(X,Y,(R1,0),Step1) , 
                        on(X,Y,(R2,0),Step2) , 
                        (R1,0) != (R2,0) , 
                        delay(ID1,Del1) , 
                        delay(ID2,Del2) , 
                        T = Step1+Del1,
                        T = Step2+Del2, 
                        train_route(ID1,R1), 
                        train_route(ID2,R2).

% Trains are not allowed to occupy same cell at the same time                         
:- collide(ID1,ID2,T).

phase_through(ID1,ID2):-    on(X1,Y1,(R1,0),Step1) ,    % Trains are not alllowed to swap places (phase through each other)
                            on(X1+X,Y1+Y,(R1,0),Step1+1) , 
                            on(X1+X,Y1+Y,(R2,0),Step2) , 
                            on(X1,Y1,(R2,0),Step2+1) ,
                            (R1,0) != (R2,0) , 
                            X = (0;1) ,
                            Y = (0;1) ,
                            X+Y = 1 , 
                            delay(ID1,Del1) , 
                            delay(ID2,Del2) , 
                            T = Step1+Del1,
                            T = Step2+Del2, 
                            train_route(ID1,R1), 
                            train_route(ID2,R2). 

:- phase_through(ID1,ID2) , train(ID1) , train(ID2) .

%#show time/2.
%#show delay/2.
%#show action/3.
%#show collide/3.