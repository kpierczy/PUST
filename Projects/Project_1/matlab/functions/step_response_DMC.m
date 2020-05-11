% Function calculates vector of step response coefficients apropriate
% to use with a DMC algorithm
%
% @param (Upp, Ypp) : Work point
% @param step : size of the step ()
% @param tol : tolerance of output value taken into account
%              when the dynamic range is computed
function [step_response] = step_response_DMC(Upp, Ypp, step, tol)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check Upp corectness
if Upp > 2.0 || Upp < 1.4
   error("'Upp' should be in range [1.4; 2.0]") 
end

% Check step corectness
if (Upp + step > 2) || (Upp + step < 1.4)
   error("Sum of the 'Upp' and 'step' should be in range [1.4; 2.0]") 
end

% Number of steps to simulate
STEPS_NUMBER = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set initial values of input and output vector
U = ones(STEPS_NUMBER,1) * Upp;
Y = ones(STEPS_NUMBER,1) * Ypp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U(3:STEPS_NUMBER) = U(3:STEPS_NUMBER) + step;

% Simulate the process
for i=12:STEPS_NUMBER
    Y(i) = symulacja_obiektu9Y(U(i-10), U(i-11), Y(i-1), Y(i-2));
end

% Get output samples after the step (step moment = 3)
step_response = Y(3:size(Y,1));

% Trim step response to the dynamic rank
dynamic_rank = find(abs(step_response - step_response(size(step_response, 1))) < tol, 1, 'first');
step_response = step_response(1:dynamic_rank);

% scale step response
step_response = (step_response - Ypp) / step;

end