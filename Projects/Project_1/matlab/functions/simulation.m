% Simulates the process with a pointed regulator. This function is
% a simple bind over the simulation script that makes it able to
% work with regulators adjusting only regulator's parameters
% leaving whole script configuration inside the function.
%
% @param regulator_struct : structure describing a choosen regulator.
%                           For details @see PID @see DMC functions.
%
% @param regulator_type : type of the regulator (0 = PID, 1 = DMC)
function [Y_zad, Y, U, error] = simulation(regulator_struct, regulator_type)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Object's sampling period
SAMPLING_PERIOD = 0.5;

% Simulation time [samples number]
SAMPLES_NUMBER = 500;

% Select regulator type (0 = PID, 1 = DMC)
REGULATOR_TYPE = regulator_type;

if regulator_type == 0
    % PID settings
    PID_struct.K = regulator_struct.K;
    PID_struct.Ti = regulator_struct.Ti;
    PID_struct.Td = regulator_struct.Td;
    PID_struct.Ts = SAMPLING_PERIOD;
elseif regulator_type == 1
    % DMC settings
    DMC_struct.N = regulator_struct.N;
    DMC_struct.Nu = regulator_struct.Nu;
    DMC_struct.lambda = regulator_struct.lambda;
end

% Initial work point
Upp = 1.7;
Ypp = 2.0;

% Trajectory structure initialization (@see make_trajectory function's description)
trajectory_struct.size = SAMPLES_NUMBER;
trajectory_struct.steps = [1, 2.0; 50, 2.4; 220, 1.7; 380, 2.0];

% Set limits to the value and speed of change of the regulator output
U_limits.Umin = 1.4;
U_limits.Umax = 2.0;
U_limits.dUmin = -0.075;
U_limits.dUmax = 0.075;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Control vector
U = ones(SAMPLES_NUMBER, 1) * Upp;

% Output vector
Y = ones(SAMPLES_NUMBER, 1) * Ypp;

% Trajectory vector
Y_zad = make_trajectory(trajectory_struct);

% PID regulator initialization
if REGULATOR_TYPE == 0
    
    % Error values vector
    ek = zeros(3, 1);
    
% DMC regulator initialization
else
    
    % Step response
    step_response = step_response_DMC(1.7, 2.0, 0.2, 0.0001);
    
    % Dynamic range
    D = size(step_response, 1);
    
    % DMC optimalization problem solution
    [K, Mp] = DMC_matrices(step_response, DMC_struct);
    
    % Initialize dUp vector
    dUp = zeros(D-1, 1);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:SAMPLES_NUMBER
   
    % Sample object's output
    if n >= 12
        Y(n) = symulacja_obiektu9Y(U(n-10), U(n-11), Y(n-1), Y(n-2));
    end
    
    % PID simulation
    if REGULATOR_TYPE == 0
        
        % Update errors
        ek(3) = ek(2);
        ek(2) = ek(1);
        ek(1) = Y_zad(n) - Y(n);
        
        % Compute control value
        if n >= 2
            U(n) = PID(ek, PID_struct, U_limits, U(n-1));
        end
        
    % DMC simulation
    else
    
        if n >= 2
                        
            % Compute control value
            U(n) = DMC(Y_zad(n), Y(n), dUp, K, Mp, U_limits, U(n-1));
            
            % Update dUp vector
            dUp = circshift(dUp, 1);
            dUp(1) = U(n) - U(n-1);
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Error_calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error = sum((Y_zad - Y).^2);

end