clearvars -except DMC_struct
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sampling period [s]
SAMPLING_PERIOD = 0.5;

% Length of the simulation
SAMPLES_NUMBER = 200;

% Desired output trajectory structure (@see make_trajectory function's description)
Y_zad_trajectory_struct.size = SAMPLES_NUMBER;
Y_zad_trajectory_struct.steps = [10, 1.0];

% Desired noise parameters (frequency in [Hz])
Z_amplitude = 3;
Z_frequency = 0.1;

% DMC parameters
DMC_struct.N = 180;
DMC_struct.Nu = 180;
DMC_struct.D = 180;
DMC_struct.Dz = 1;
DMC_struct.lambda = 0.0327;

% Plotting process output
PLOT_OUTPUT = true;

% Plotting input values (U and Z)
PLOT_INPUT = true;

% Error printing
PRINT_ERROR = true;

% Saving plots to txt files
SAVE_DATA = false;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Desired output trajectory
Y_zad = make_trajectory(Y_zad_trajectory_struct);

% Generate desired noise trajectory (sinusoidal)
t_base = linspace(SAMPLING_PERIOD, SAMPLES_NUMBER * SAMPLING_PERIOD, SAMPLES_NUMBER)';
Z = Z_amplitude * sin(2 * pi * Z_frequency * t_base);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[U, Y, error] = simulation(Y_zad, Z, DMC_struct);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close

if PLOT_OUTPUT
    figure
    stairs(Y)
    hold on
    stairs(Y_zad)
    xlabel('n')
    ylabel('y')
    legend('Output', 'Desired output')
end

if PLOT_INPUT
    figure
    stairs(U)
    hold on
    stairs(Z)
    xlabel('n')
    ylabel('u / z')
    legend('Input', 'Noise')
end

if SAVE_DATA
    
    % Time axis
    n = 1 : SAMPLES_NUMBER; 
    
    % Input
    nu = [n(:), U(:)];
    dlmwrite('doc/data/exercise_4/Input_plot.txt', nu, 'delimiter', ' ');
    
    % Noise
    nz = [n(:), Z(:)];
    dlmwrite('doc/data/exercise_4/Noise_plot.txt', nz, 'delimiter', ' ');
    
    % Output
    ny = [n(:), Y(:)];
    dlmwrite('doc/data/exercise_4/Output_plot.txt', ny, 'delimiter', ' ');
    
    % Desired output
    ny_zad = [n(:), Y_zad(:)];
    dlmwrite('doc/data/exercise_4/Desired_output_plot.txt', ny_zad, 'delimiter', ' ');
end

if PRINT_ERROR
   display(error) 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except error
