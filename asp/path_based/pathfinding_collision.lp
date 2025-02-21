% ---- COLLISION ----

% node collision
:- on_node(ID1,A,_,T,_) , on_node(ID2,A,_,T,_) , ID1!=ID2.
% wait collisions
:- on_node(ID1,A,_,T,1) , on_node(ID2,A,_,T+1,_) , ID1!=ID2.
% edge collision
critical_edge(T1,T2,T1',T2',edge_o(A,B,A_in,A_out,B_in,L)) :- 
    T2>0 , T1 = T2-L-Wait_time , T1' = T2'-L-Wait_time' , 
    on_node(ID1,B,B_in,T2,Wait_time) , on_node(ID2,A,A_in',T2',Wait_time') ,
    edge_o(A,B,A_in,A_out,B_in,L) , edge_o(B,A,B_in',B_out',A_in',L) , 
    mirrored_dir(B_in,B_out') , mirrored_dir(A_out,A_in') , ID1!=ID2 , T1'>=T1 : T1'<=T2 ; T1'<=T2 : T1'>=T2.

:- critical_edge(T1,T2,T1',T2',edge_o(A,B,A_in,A_out,B_in,L)). 

% ---- ----
#show on_node/5.
%#show on_node_count/1.
%#show blocked/4.
%#show action/3.
#show critical_edge/5.