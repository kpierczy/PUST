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

% DMC parameters
DMC_struct.N = 159;
DMC_struct.Nu = 171;
DMC_struct.D = 94;
DMC_struct.Dz = 28;
DMC_struct.lambda = 1.444353511953043e-06;

% Plotting process output
PLOT_OUTPUT = true;

% Plotting input values (U and Z)
PLOT_INPUT = true;

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

clearvars -except DMC_struct