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
Z_noise_mean = 6;
Z_noise_std_deviation = 0;

% DMC parameters
DMC_struct.N = 20;
DMC_struct.Nu = 10;
DMC_struct.D = 180;
DMC_struct.Dz = 20;
DMC_struct.lambda = 0.1;

% Plotting process output
PLOT_OUTPUT = true;

% Plotting input values (U and Z)
PLOT_INPUT = false;

% Error printing
PRINT_ERROR = true;

% Saving plots to txt files
SAVE_DATA = true;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Desired output trajectory
Y_zad = make_trajectory(Y_zad_trajectory_struct);

% Desired noise trajectory
Z = make_trajectory(Z_trajectory_struct);
Z_measured = Z + (Z_noise_mean + Z_noise_std_deviation .* randn(SAMPLES_NUMBER, 1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[U, Y, error] = simulation(Y_zad, Z, Z_measured, DMC_struct);


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
    hold on 
    stairs(Z_measured)
    xlabel('n')
    ylabel('u / z')
    legend('Input', 'Disturbance', 'Mesured Disturbance')
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

clearvars -except DMC_struct