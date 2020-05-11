function [step_response] = Step_response_for_DMC(DMC_struct)
% get the step response for the particular area
% the step will be in the middle of the area

%%% Set variable
% print the Y vector
print = 0;
% set delay to max delay in object
delay = 100;
% set sim_time to be long enough for output of object to become constant
sim_time = 1000;
%%% Initialization %%%

u_min = Find_u_for_y(DMC_struct.c - DMC_struct.sigma);
u_max = Find_u_for_y(DMC_struct.c + DMC_struct.sigma);

U = ones(sim_time,1) * u_max;
U(1:delay + 1) = u_min;
Y = zeros(sim_time,1);

%%% Calculations %%%
    
for i = 1 : sim_time
    Y(i) = Simulation_Control_One_Loop(U,Y,i); 
end

% Cut the vector for the step response
for i = delay : sim_time - 1
    if(abs(Y(i)- Y(i+1))< 10^-6 & i > delay + 10)
        end_of_step_response = i;
        break;
    end
end
% Prepare step response
step_response = Y(delay+2:end_of_step_response);

% Step response minus work point 
step_response = step_response - (DMC_struct.c - DMC_struct.sigma/2);
step_response = step_response - step_response(1);
% Rescale step response
step_response = step_response / (u_max - u_min);

% Show the horizont 
strcat('Horizont of the step response  ' , num2str(size(step_response,1)));


if (print == 1)
    fig = figure
    plot(step_response);
    fig = figure
    plot(U(1:end_of_step_response));
end

end

