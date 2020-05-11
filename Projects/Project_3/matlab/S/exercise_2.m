%==========================================================================
% Scripts performes jumps from the work point (u = 0, y = 0)
% of the input values. Number of jumps is uqual to (2 x STEPS_NUMBER + 1)
% as the jump is performed in the positive as well as in the negative 
% direction and also for the 0 value step.
%==========================================================================

clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of steps of a single simulation
SAMPLES_NUMBER = 200;
% Number of step responses (in a single direction)
STEPS_NUMBER = 4;

% Amplitudes of the both inputs jump's
U_Amplitude = 1;

% Step responses printing
PRINT_RESPONSES = true;
% Static characteristic printing
PRINT_STATIC_CHAR = true;

% Step responses saving
SAVE_RESPONSES = true;
% Static characteristic saving
SAVE_STATIC_CHAR = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute number of all (positive and negative) steps for both
% U and Z values
INPUT_CHANGES = STEPS_NUMBER * 2 + 1;

% Cell array of step responses with elements
%
% 1) Vector of values representing U steps values
% 2) Vector of stabilized Y values after performing a jump
% 3) 2D array of step responses for subsequent U steps.
%    The second dimension contains subsequent samples of
%    a particular responses
% 4) Static gains 
%
% The {simulations_data{1}(i), simulations_data{2}(i, :)} tupple, for the
% constant i, contains the entire information about the simulation variant
% - i.e. U and Z steps values and step_response vector
% 
simulations_data = cell(4, 1);

simulations_data{2} = zeros(INPUT_CHANGES, 1);
simulations_data{3} = zeros(INPUT_CHANGES, SAMPLES_NUMBER);
simulations_data{4} = zeros(INPUT_CHANGES, 1);

% Compute U steps for all simulations to perform
simulations_data{1} = linspace(U_Amplitude, - U_Amplitude, INPUT_CHANGES);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop over all U steps
for i = 1:INPUT_CHANGES
    
    % Define controll vector
    U = ones(SAMPLES_NUMBER, 1) * simulations_data{1}(i);

    % Simulate process
    simulations_data{3}(i, :) = simulate_object(U');

    % Complete work point with a stabilized Y value
    simulations_data{2}(i) = simulations_data{3}(i, end);

    % Compute in-point static gains for both U and Z tacks
    simulations_data{4}(i) = simulations_data{2}(i) / simulations_data{1}(i);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Print step responses
if PRINT_RESPONSES

    % Print step responses fo U jumps
    figure
    for step_num = 1:INPUT_CHANGES
       stairs(simulations_data{3}(step_num, :), 'DisplayName', sprintf('dU = %f', simulations_data{1}(step_num)));
       hold on
    end
    xlabel('n')
    ylabel('y')
    title('Step responses for the input jumps')
    legend('show')

end

if SAVE_RESPONSES

    % Time axis
    n = 1 : SAMPLES_NUMBER;

    % Save step responses fo U jumps
    for step_num = 1:INPUT_CHANGES
        y = simulations_data{3}(step_num, :)';
        ny = [n(:), y(:)];
        dlmwrite(strcat('doc/data/Exercise_2/responses/U_jump_to_', num2str(simulations_data{1}(step_num)), '.txt'), ny, 'delimiter', ' ');
    end 

end

if PRINT_STATIC_CHAR
    figure;
    plot(simulations_data{1}, simulations_data{2})
    xlabel('u')
    ylabel('y')
end

if SAVE_STATIC_CHAR
    uz = [simulations_data{1}', simulations_data{2}];
    dlmwrite(strcat('doc/data/Exercise_2/static_characteristic.txt'), uz, 'delimiter', ' ');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except simulations_data
