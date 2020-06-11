%===================================================================%
% Script loads 'step_responses_data.mat' workspace prepared by the
% 'Exercise_2.m' script. Step responses saved to the 
% 'G_jump_simulations' cell array are used to perform approximation
% of the heater-cooling process with the second-order inertion.
%
% Approximation is computed by minimalization of the sum of squares
% of differences between step responses and output of the 
% appproximating model. Optimisation process is performed by the
% ga() (Genetic Algorithm) function, as some of the model's
% parameters has to be integer values.
%
% @note : Script's result is a 'approximation_params' cell aray that
%         is saved to the doc/data folder. This array should conatins
%         structures that should be loaded in the Exercise_4.m and 
%         binded as a second argument to the simulate_approximation()
%         function which, in turn, is passed to the DMC model.
%===================================================================%

%===================================================================%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================================================================%

% model parameters constraits
lb_model = [-50, -50, -50, 0];
ub_model = [ 50,  50,  50, 10];

% Options of the optimisation algorithms
optimisation_options = optimoptions( ...
    'ga', ...
    'PopulationSize', 200,     ...
    'EliteCount', 20,          ...
    'FunctionTolerance', 1e-7, ...
    'MaxGenerations', 2000     ...
);

% If true, optimisation is performed and new comparisons between
% models and object are computed. Otherwise saved
% 'doc/data/exercise_3/approximation_params.mat' workspace is loaded
% and plots are based on saved values
OPTIMISE = true;

% Controll plotting comparison between model and object
PRINT_COMPARISON = true;

% Controll plotting comparison between model and object
SAVE_COMPARISON = true;

if PRINT_COMPARISON || SAVE_COMPARISON
   
    % Size of steps at which models should be compared with object
    G1_step = 10;
    G2_step = 10;
    
    % Plot's output limits
    limit_low = 100;
    limit_high = 200;
    
end

%===================================================================%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================================================================%

Gpp = [32, 39];
Tpp = [137.94, 147.95];

U = cell(2, 2);
U{1, 1} = ones(1, 100) * 44;
U{2, 1} = ones(1, 100) * 49;
U{1, 2} = ones(1, 100) * 44;
U{2, 2} = ones(1, 100) * 49;

Y = cell(2, 2);
Y{1, 1} = G1T1';
Y{2, 1} = G2T1';
Y{1, 2} = G1T3';
Y{2, 2} = G2T3';

params = cell(2, 2);

object = cell(2, 2);
object{1, 1} = G1T1';
object{1, 2} = G1T3';
object{2, 1} = G2T1';
object{2, 2} = G2T3';

%===================================================================%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================================================================%

if OPTIMISE

    % Optimise parameters with a genetic algorithm
    for heater = 1:2
        for output = 1:2
            bind = @(x) model_error(x, U{heater, output}, Y{heater, output}, Gpp(heater), Tpp(output));
            params{heater, output} = ga(bind, 4, [], [], [], [], lb_model, ub_model, [], [4], optimisation_options);
        end
    end

    % Convert vectors of parameters to parameters structures
    approximation_params = cell(2, 2);
    for heater = 1:2
        for output = 1:2
            approximation_params{heater, output}.T1 = params{heater, output}(1);
            approximation_params{heater, output}.T2 = params{heater, output}(2);
            approximation_params{heater, output}.K = params{heater, output}(3);
            approximation_params{heater, output}.Td = params{heater, output}(4);
        end
    end

end
    
% Convert parameters structures to vectors of parameters
params = cell(2, 2);
for heater = 1:2
    for output = 1:2
        params{heater, output} = zeros(4, 1);
        params{heater, output}(1) = approximation_params{heater, output}.T1;
        params{heater, output}(2) = approximation_params{heater, output}.T2;
        params{heater, output}(3) = approximation_params{heater, output}.K;
        params{heater, output}(4) = approximation_params{heater, output}.Td;
    end
end
   
% Initialize input trajectories that will be used to compare 
% models with real heater-cooling object

G1       = ones(100, 1) * 44;
G2       = ones(100, 1) * 49;

% Compute model's output
model = cell(2, 2);
model{1, 1} = model_output(params{1, 1}, G1', Gpp(1), Tpp(1))';
model{1, 2} = model_output(params{1, 2}, G1', Gpp(1), Tpp(2))';
model{2, 1} = model_output(params{2, 1}, G2', Gpp(2), Tpp(1))';
model{2, 2} = model_output(params{2, 2}, G2', Gpp(2), Tpp(2))';

%===================================================================%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================================================================%  
        
object = Y;

if PRINT_COMPARISON || SAVE_COMPARISON
    
    % Plot comparisons
    T = [1, 3];
    
    for heater = 1:2
        for output = 1:2
            figure
            plot(object{heater, output})
            hold on
            plot(model{heater, output})
            axis([1 100 limit_low limit_high])
            xlabel('Time [s]')
            ylabel(sprintf('T%d', T(output)))
            legend('Object', 'Model')
            title(sprintf( ...
                'Comparison between object and model for G%d-T%d track', ...
                heater, T(output)) ...
            )
        end
    end
        
    for heater = 1:2
        for output = 1:2
            t  = (0 : 100 - 1)';
            m = model{heater, output};
            o = object{heater, output};
            dlmwrite(sprintf( ...
                    'doc/report/data/exercise_3/model_step_responses/G%dT%d.txt', ...
                    heater, T(output)), ... 
                [t(:), o(:)], 'delimiter', ' ');
            dlmwrite(sprintf( ...
                    'doc/report/data/exercise_3/model_step_responses/G%dT%d.txt', ...
                    heater, T(output)), ... 
                [t(:), m(:)], 'delimiter', ' ');
        end
    end
    
end


%===================================================================%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================================================================%

clearvars -except G1T1 G2T1 G1T3 G2T3
