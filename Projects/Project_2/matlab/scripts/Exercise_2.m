clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scripts performes jumps form the work point (u = 0, z = 0, y = 0)
% for both input and noise values. Number of jumps for the each
% of inputs is uqual to (2 x STEPS_NUMBER + 1) as the jump is performed
% in the positive as well as in the negative direction and also for the
% 0 value step.

% Number of steps of a single simulation
SAMPLES_NUMBER = 200;
% Number of step responses measured (in a single direction)
STEPS_NUMBER = 4;

% Amplitudes of the both inputs jump's
U_Amplitude = 8;
Z_Amplitude = 4;

% Step responses printing
PRINT_RESPONSES = false;
% Static characteristic printing
PRINT_STATIC_CHAR = false;

% Step responses saving
SAVE_RESPONSES = false;
% Static characteristic saving
SAVE_STATIC_CHAR = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute number of all (positive and negative) steps for both
% U and Z values
INPUT_CHANGES = STEPS_NUMBER * 2 + 1;

% Cell array of step responses with elements
%
% 1) Vector of values representing sizes of U steps
% 2) Vector of values representing sizes of 2 steps
% 3) Vector of stabilized Y values after performing a jump
% 4) 3D array of step responses for subsequent U and Z
%    steps pairs. The third dimension contains subsequent
%    samples of the responses
% 5) Static gain for U track
% 6) Static gain for Z track
%
% The {simulations_data{1}(i), simulations_data{2}(i), simulations_data{3}(i, :)}
% tupple, for the constant i, contains the entire information about the
% simulation variant - i.e. U and Z steps values and step_response vector
% 
simulations_data = cell(6, 1);

simulations_data{3} = zeros(INPUT_CHANGES, INPUT_CHANGES);
simulations_data{4} = zeros(INPUT_CHANGES, INPUT_CHANGES, SAMPLES_NUMBER);
simulations_data{5} = zeros(INPUT_CHANGES, INPUT_CHANGES);
simulations_data{6} = zeros(INPUT_CHANGES, INPUT_CHANGES);

% Compute pairs of U and Z steps for all simulations to perform
U_points = linspace(U_Amplitude, - U_Amplitude, INPUT_CHANGES);
Z_points = linspace(Z_Amplitude, - Z_Amplitude, INPUT_CHANGES);
[simulations_data{1}, simulations_data{2}] = meshgrid(U_points, Z_points);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop over alle U and Z steps pairs
for i = 1:INPUT_CHANGES
    for j = 1:INPUT_CHANGES
        % Define U and Z vectors
        U = ones(SAMPLES_NUMBER, 1) * simulations_data{1}(i, j);
        Z = ones(SAMPLES_NUMBER, 1) * simulations_data{2}(i, j);

        % Simulate process
        simulations_data{4}(i, j, :) = simulate_object(U, Z);

        % Complete work point with a stabilized Y value
        simulations_data{3}(i, j) = simulations_data{4}(i, j, end);

        % Compute in-point static gains for both U and Z tacks
        simulations_data{5}(i, j) = simulations_data{3}(i, j) / simulations_data{1}(i, j);
        simulations_data{6}(i, j) = simulations_data{3}(i, j) / simulations_data{2}(i, j);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if PRINT_RESPONSES || SAVE_RESPONSES
    
    % Get indeces of simulations when either U or Z
    % step size was zero (only one of the input values jumped)
    Z_const_indeces = find(simulations_data{2} == 0);
    U_const_indeces = find(simulations_data{1} == 0);
    
    % Convert 3D step responses matrix to the 2D step responses list
    % (it's required to use indexing with indexes returned by the
    % find() function)
    step_responses = zeros(INPUT_CHANGES^2, SAMPLES_NUMBER);
    for j = 1:INPUT_CHANGES
        for i = 1:INPUT_CHANGES
            step_responses((j - 1) * INPUT_CHANGES + i, :) = simulations_data{4}(i, j, :);
        end
    end
    
    % Creta cell array of data containing only informations about
    % simulations when only one of the input values changed
    
    U_jump_simulations = cell(2, 1);
    U_jump_simulations{1} = simulations_data{1}(Z_const_indeces);
    U_jump_simulations{2} = step_responses(Z_const_indeces, :);
    
    Z_jump_simulations = cell(2, 1);
    Z_jump_simulations{1} = simulations_data{2}(U_const_indeces);
    Z_jump_simulations{2} = step_responses(U_const_indeces, :);
    
    % Print step responses
    if PRINT_RESPONSES
        
        % Print step responses fo U jumps
        figure
        for step_num = 1:size(U_jump_simulations{1}, 1)
           stairs(U_jump_simulations{2}(step_num, :), 'DisplayName', sprintf('dU = %f', U_jump_simulations{1}(step_num)));
           hold on
        end
        xlabel('n')
        ylabel('y')
        title('Step responses for the input jumps')
        legend('show')
        
        % Print step responses fo Z jumps
        figure
        for step_num = 1:size(Z_jump_simulations{1}, 1)
           stairs(Z_jump_simulations{2}(step_num, :), 'DisplayName', sprintf('dZ = %f', Z_jump_simulations{1}(step_num)));
           hold on
        end
        xlabel('n')
        ylabel('y')
        title('Step responses for the noise jumps')
        legend('show')
        
    end
    
    if SAVE_RESPONSES
        
        % Time axis
        n = 1 : SAMPLES_NUMBER;
        
        % Save step responses fo U jumps
        for step_num = 1:size(U_jump_simulations{1}, 1)
            y = U_jump_simulations{2}(step_num, :)';
            ny = [n(:), y(:)];
            dlmwrite(strcat('doc/data/exercise_2/U_steps/U_jump_to_', num2str(U_jump_simulations{1}(step_num)), '.txt'), ny, 'delimiter', ' ');
        end 
        
        % Save step responses fo Z jumps
        for step_num = 1:size(Z_jump_simulations{1}, 1)
            y = Z_jump_simulations{2}(step_num, :)';
            ny = [n(:), y(:)];
            dlmwrite(strcat('doc/data/exercise_2/Z_steps/Z_jump_to_', num2str(Z_jump_simulations{1}(step_num)), '.txt'), ny, 'delimiter', ' ');
        end 
        
    end

end

if PRINT_STATIC_CHAR
    figure;
    surf(simulations_data{1}, simulations_data{2}, simulations_data{3})
    xlabel('u')
    ylabel('z')
    zlabel('y')
end

if SAVE_STATIC_CHAR
    uzy = [simulations_data{1}, simulations_data{2}, simulations_data{3}];
    dlmwrite(strcat('doc/data/exercise_2/static_characteristic.txt'), uzy, 'delimiter', ' ');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except simulations_data
