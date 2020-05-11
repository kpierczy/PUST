clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Length of the simulation
SAMPLES_NUMBER = 400;

% Desired output trajectory structure (@see make_trajectory function's description)
Y_zad_trajectory_struct.size = SAMPLES_NUMBER;
Y_zad_trajectory_struct.steps = [10, 1.0; 110, 3; 210, 1.5; 310, 0];

% Desired output trajectory structure initialization (@see make_trajectory function's description)
Z_trajectory_struct.size = SAMPLES_NUMBER;
Z_trajectory_struct.steps = [60, 1; 160, 0; 260, 1; 360, 0];

% DMC parameters constraits
lb_DMC = [1, 1, 2, 2, 0];
ub_DMC = [180, 180, 180, 38, 100];

% Options of the optimisation algorithms
optimisation_options = optimoptions('ga', 'PopulationSize', 100, 'EliteCount', 4);

% 1 - plot cost function; 0 - don't pllot score function
PLOT = 0;

% Lambda's resolution on the plot
LAMBDA_RESOLUTION = 40;

% Parameter that are used for axis while plottin a cost function
%   1 : N
%   2 : Nu
%   3 : D
%   4 : Dz
%   5 : lambda
VARIABLE_PARAMS = {1, 5};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Desired output trajectory
Y_zad = make_trajectory(Y_zad_trajectory_struct);

% Desired noise trajectory
Z = make_trajectory(Z_trajectory_struct);

% Prepare scoring bind functions
DMC_score_bind_point = @(x) DMC_score(Y_zad, Z, [x(1), x(2), x(3), x(4), x(5)]);
DMC_score_bind_list = @(N, Nu, D, Dz, lambda) DMC_score(Y_zad, Z, [N, Nu, D, Dz, lambda]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Optimise parameters with a genetic algorithm
DMC_params = ga(DMC_score_bind_point, 5, [], [], [], [], lb_DMC, ub_DMC, [], [1 2 3 4], optimisation_options);

% Convert parameters vector to the DMC parameters structure
DMC_struct.N = DMC_params(1);
DMC_struct.Nu = DMC_params(2);
DMC_struct.D = DMC_params(3);
DMC_struct.Dz = DMC_params(4);
DMC_struct.lambda = DMC_params(5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close

if PLOT == 1
    
    % Compute meshgrid for the plot
    if VARIABLE_PARAMS{1} ~= 5
        x = linspace(lb_DMC(VARIABLE_PARAMS{1}), ...
                     ub_DMC(VARIABLE_PARAMS{1}), ...
                     ub_DMC(VARIABLE_PARAMS{1}) - lb_DMC(VARIABLE_PARAMS{1}) + 1);
    else
        x = linspace(lb_DMC(VARIABLE_PARAMS{1}), ...
                     ub_DMC(VARIABLE_PARAMS{1}), ...
                     LAMBDA_RESOLUTION);
    end

    if VARIABLE_PARAMS{2} ~= 5
        y = linspace(lb_DMC(VARIABLE_PARAMS{2}), ...
                     ub_DMC(VARIABLE_PARAMS{2}), ...
                     ub_DMC(VARIABLE_PARAMS{2}) - lb_DMC(VARIABLE_PARAMS{2}) + 1);
    else
        y = linspace(lb_DMC(VARIABLE_PARAMS{2}), ...
                     ub_DMC(VARIABLE_PARAMS{2}), ...
                     LAMBDA_RESOLUTION);
    end

    [xg, yg] = meshgrid(x, y);

    % Prepare cell array of all meshgrids
    params_meshrids = cell(5, 1);

    % Sort meshgrids of all parameters
    for i=1:5

        % Check if parameter is a variable one
        if i == VARIABLE_PARAMS{1}
            params_meshrids{i} = xg;
        elseif i == VARIABLE_PARAMS{2}
            params_meshrids{i} = yg;

        % If not variable, create constant meshgrid
        else
            params_meshrids{i} = ones([size(xg, 1), size(xg, 2)]) * DMC_params(i);

        end

    end

    % Call score function for all arguments in the meshgrid
    zg = arrayfun(DMC_score_bind_list, params_meshrids{:});

    % Save plot values
    DMC_xg = xg;
    DMC_yg = yg;
    DMC_zg = zg;

    % Save axis labels
    labels = {'N', 'Nu', 'D', 'Dz', 'lambda'};
    DMC_xg_label = labels{VARIABLE_PARAMS{1}};
    DMC_yg_label = labels{VARIABLE_PARAMS{2}};

    % Draw a plot
    figure
    surf(xg, yg, zg)
    xlabel(DMC_xg_label)
    ylabel(DMC_yg_label)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except DMC_struct