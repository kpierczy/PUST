% Simulates the process with a pointed regulator. This function is
% a kind of thesimple 'bind' over the simulation script that makes
% easier with regulator, adjusting only regulator's parameters
% leaving whole script configuration inside the function.
%
% @note : Y_zad and Z parameters was introduce to make it easier to
%         compare regulators with respect to different trajectories
%
% @param Y_zad, Z : trajcetories of the required output and disturbance
% @param Z_measured : disturbance trajectory measured by the regulator
% @param DMC_struct : structure describing a choosen regulator.
%                     For details @see DMC function. If Dz is 0,
%                     the Z vector is not taken into account
% @returns : input vector and the error
%
% @attribute SAMPLES_NUMBER : number of moments to simulate
% @attribute U_step, Z_step : sizes of the steps used to compute
%                             step responses
% @attribute tol : dynamic range value tolerance
%
function [U, Y, error] = simulation(Y_zad, Z, Z_measured, DMC_struct)

if size(Y_zad, 1) ~= size(Z, 1)
   error('Lengths of both trajectories are not equal!') 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulation time [samples number]
SAMPLES_NUMBER = size(Y_zad, 1);

% Steps of the U and Z used to get the step response
U_step = 2;
Z_step = 2;

% Dynamic range value tolerance
tol = 0.0001;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Control vector
U = zeros(SAMPLES_NUMBER, 1);

% Output vector
Y = zeros(SAMPLES_NUMBER, 1);

% Step responses
[U_step_response, Z_step_response] = DMC_step_response(U_step, Z_step, tol);

% DMC optimalization problem solution
[matrices.K, matrices.Mp, matrices.Mzp] = DMC_matrices(U_step_response, Z_step_response, DMC_struct);

% Initialize dUp vector
dUp = zeros(DMC_struct.D - 1, 1);

% Initialize dZp vector
dZp = zeros(DMC_struct.Dz, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:SAMPLES_NUMBER

    %===========================================
    % @note : We assume that values of U and 
    %         Z before n = 1 were zero
    %===========================================
    
    % Sample object's output
    Y(n) = simulate_object_step(U, Z, Y, n);
    
    % If noise is taken into account
    if DMC_struct.Dz ~= 0
        % Update dZp vector 
        if n == 1
            dZp(1) = Z_measured(1);
        else
            dZp = circshift(dZp, 1);
            dZp(1) = Z_measured(n) - Z_measured(n-1);  
        end
    end

    if n == 1
        % Compute control value
        U(1) = DMC(Y_zad(n), Y(n), dUp, dZp, matrices);
        
        % Update dUp vector 
        dUp(1) = U(1);
    else
        % Compute control value
        U(n) = U(n-1) + DMC(Y_zad(n), Y(n), dUp, dZp, matrices);
        
        % Update dUp vector 
        dUp = circshift(dUp, 1);
        dUp(1) = U(n) - U(n-1);
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Error_calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error = sum((Y_zad - Y).^2);

end