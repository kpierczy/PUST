function [uk] = Fuzzy_PID(PID_structs,Ek,uk_1,yk)
% Function calculates control with fuzzy PIDS

% Dizzy function
% exp( -(yk - c)^2 / (2 * sigma ^2))

%%% Parametrs %%%
% PID_structs - array of PID_struct. PID_struct consists of:
% PID_struct.K - amplification of PID
% PID_struct.Ti - parametr of integral for PID
% PID_struct.Td - parameter of derative for PID
% PID_struct.c - parametr for fuzzy function ( average )
% PID_struct.sigma - parametr for fuzzy function 

% Ek - vectors with last 3 errors 

% uk_1 - the last calculated control

% yk - actual output of the object to calculate dizzy function


%%% Initialization %%%
uk =  0;

%%% Calculations %%%

% Calculate parametr to normalize the control
to_normalized = 0;
for i = 1 : size(PID_structs,2)
   to_normalized = to_normalized + exp(-(yk - PID_structs(i).c)^2/(2*PID_structs(i).sigma^2));
end

 % Calculate the control
for i = 1 : size(PID_structs,2)
    uk = uk + exp(-(yk - PID_structs(i).c)^2/(2*PID_structs(i).sigma^2)) * PID(PID_structs(i),Ek,uk_1);
end

% Normalize the control
uk = uk / to_normalized;

% Constraints for control (-1 , 1)
if(uk > 1)
    uk = 1;
end
if(uk < -1)
   uk = -1; 
end

end

