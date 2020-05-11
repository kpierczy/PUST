function [uk] = Fuzzy_DMC(DMC_structs,yk,Uk,yzad,iter)
% Function calculates control with fuzzy PIDS

% Dizzy function
% exp( -(yk - c)^2 / (2 * sigma ^2))

%%% Parametrs %%%
% DMC_structs - array of DMC_struct. DMC_struct consists of:
% DMC_struct.D - 
% DMC_struct.N - prediction horizont
% DMC_struct.Nu - control horizont
% DMC_struct.lambda - parametr to control the increase of the control
% DMC_struct.c - parametr for fuzzy function ( average )
% DMC_struct.sigma - parametr for fuzzy function 
% DMC_struct.Mp - matrix to calculate the control
% DMC_struct.K - matrix to calculate the control
% DMC_struct.step_response - step response for the dmc


% Uk - vectors with last calculated control

% Yk - vector of last outputs from object

%iter - value, which loop is now

%%% Initialization %%%
uk =  0;

%%% Calculations %%%

% Calculate parametr to normalize the control
to_normalized = 0;
for i = 1 : size(DMC_structs,2)
   to_normalized = to_normalized + exp(-(yk - DMC_structs(i).c)^2/(2*DMC_structs(i).sigma^2));
end

 % Calculate the control
for i = 1 : size(DMC_structs,2)
    uk = uk + exp(-(yk - DMC_structs(i).c)^2/(2*DMC_structs(i).sigma^2)) * DMC(DMC_structs(i),yk,Uk,yzad,iter);
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

