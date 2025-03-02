% ---- COLLISION ----

% node collision
:- on_node(ID1,A,_,T,_) , on_node(ID2,A,_,T,_) , ID1!=ID2.

% wait collisions (a train drives on a waiting train traveling the same direction)
:-  on_node(ID1,B,B_in,T,W) , on_node(ID2,B,B_in,T',W') , ID1!=ID2 , T>T', 
    T <= T'+W.

% edge collision
%critical_edge(A,B,ID1,ID2,T1,T2,T1',T2') 
:-  in_motion(ID1,A,A_in,A_out,B_in,B,T1,T2,Wait_time) , in_motion(ID2,B,B_in',B_out',A_in',A,T1',T2',Wait_time') ,
    mirrored_dir(B_in,B_out') , mirrored_dir(A_out,A_in') , ID1!=ID2 , T1<=T1'<=T2. 
:-  in_motion(ID1,A,A_in,A_out,B_in,B,T1,T2,Wait_time) , in_motion(ID2,B,B_in',B_out',A_in',A,T1',T2',Wait_time') ,
    mirrored_dir(B_in,B_out') , mirrored_dir(A_out,A_in') , ID1!=ID2 , T1<=T2'<=T2.

% ---- ----
%#show on_node/5.
%#show on_node_count/1.
%#show blocked/4.
%#show action/3.
#show critical_edge/8.