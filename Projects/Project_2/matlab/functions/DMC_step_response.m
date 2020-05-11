% Function calculates vector of step response coefficients apropriate
% to use with a DMC algorithm for both input and noise jumps.
%
% @param (U_step, Z_step) : Steps of input values used to calculate step
%                           response
% @param tol : tolerance of output value taken into account
%              when the dynamic range is computed
%
% @attribute STEP_NUMBER : number of moments to simulate
%
function [U_step_response, Z_step_response] = DMC_step_response(U_step, Z_step, tol)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check Upp corectness
if tol < 0
   error("Tolerance should be apositive value!") 
end

% Number of steps to simulate
SAMPLES_NUMBER = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set initial values of input and output vector
ZEROS = zeros(SAMPLES_NUMBER, 1);
U = ones(SAMPLES_NUMBER, 1) * U_step;
Z = ones(SAMPLES_NUMBER, 1) * Z_step;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulate both jumps
U_step_response = simulate_object(U, ZEROS);
Z_step_response = simulate_object(ZEROS, Z);

% Get output samples after the step (step moment = 1)
U_step_response = U_step_response(2:end);
Z_step_response  = Z_step_response(2:end);

% Trim step response to the dynamic rank
U_dynamic_rank = find(abs(U_step_response - U_step_response(size(U_step_response, 1))) < tol, 1, 'first');
Z_dynamic_rank = find(abs(Z_step_response  - Z_step_response (size(Z_step_response , 1))) < tol, 1, 'first');

U_step_response = U_step_response(1:U_dynamic_rank);
Z_step_response  = Z_step_response(1:Z_dynamic_rank);

% scale step response
U_step_response = U_step_response / U_step;
Z_step_response  = Z_step_response  / Z_step;

end