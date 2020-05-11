% Script runs fuzzy PIDs control
% IMPORTANT: Set Ts variable in function PID, before running this script (default value is 0.5s) 

clear;

% Set use_calibrated_control to 1 if you want to use calibrated fuzzy
% controllers; set it to 0, if you want to manual provide parameters for
% fuzzy controllers
use_calibrated_control = 1;

% Set save_data to True, if you want to save plot in to txt files.
save_data = true;
number_of_exercise = '7';

if(use_calibrated_control == 0)
    %%% Set fuzzy PIDs
    % Example of PID_struct
    % PID_struct.K - amplification of PID
    % PID_struct.Ti - parametr of integral for PID
    % PID_struct.Td - parameter of derative for PID
    % PID_struct.Ts - sampling rate of the control
    % PID_struct.c - parametr for fuzzy function ( average )
    % PID_struct.sigma - parametr for fuzzy function 

    % First fuzzy PID
    PID_struct.K = 1.3;
    PID_struct.Ti = 1.5;
    PID_struct.Td = 0.25;
    PID_struct.Ts = 0.5;
    PID_struct.c = 0.03;
    PID_struct.sigma = 0.01;
    PID_structs(1) = PID_struct;

    % Second fuzzy PID
    PID_struct.K = 1.6;
    PID_struct.Ti = 1;
    PID_struct.Td = 0.4;
    PID_struct.Ts = 0.5;
    PID_struct.c = 0.1;
    PID_struct.sigma = 0.02;
    PID_structs(2) = PID_struct;

    %%% Set fuzzy DMC
    % example of DMC_struct
    % DMC_struct.D - 
    % DMC_struct.N - prediction horizont
    % DMC_struct.Nu - control horizont
    % DMC_struct.lambda - parametr to control the increase of the control
    % DMC_struct.c - parametr for fuzzy function ( average )
    % DMC_struct.sigma - parametr for fuzzy function 

    %First DMC
    DMC_struct.D = 19;
    DMC_struct.N = 14;
    DMC_struct.Nu = 14;
    DMC_struct.lambda = 1;
    DMC_struct.c = 0.03;
    DMC_struct.sigma = 0.02;
    DMC_structs(1) = DMC_struct;

    %Second DMC
    DMC_struct.D = 18;
    DMC_struct.N = 14;
    DMC_struct.Nu = 14;
    DMC_struct.lambda = 1;
    DMC_struct.c = 0.1;
    DMC_struct.sigma = 0.03;
    DMC_structs(2) = DMC_struct;
else
    PID_structs = CalibratedFuzzyPID(5);
    DMC_structs = CalibratedFuzzyDMC(5,1);
end
% If you want to use already calibrated fuzzy controller write number

% This function is for testing if fuzzy function covers whole area
%Show_fuzzy_function(DMC_structs)

% Declare vector of Yzad as vertical vector N,1.
% each Yzad starts with 50 samples with value of 0 to avoid using
% if-statements in code ( for example i must be greater than 0 in Array(i) )
Yzad = [ ones(100,1)*0.05; ones(100,1)* -1.5; ones(100,1)*-2 ; ones(100,1)*-3; ones(100,1)*-0.5; ones(100,1)*0.1; ones(100,1)* 0 ];

% Choose control - PID or DMC
regulator = 'DMC';

% ( User only modify part above this comment)
%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%
Yzad = [zeros(50,1); Yzad];
Y = zeros(size(Yzad,1),1);
U = zeros(size(Yzad,1),1);
error = 0;

% Initialization of DMC
if(strcmp(regulator,'DMC'))
    for i = 1 : size(DMC_structs,2)
        DMC_structs(i).step_response = Step_response_for_DMC(DMC_structs(i));
        [DMC_structs(i).K,DMC_structs(i).Mp] = DMC_matrices(DMC_structs(i));
    end
end

%%% Simulation %%%

for i = 50 : size(Yzad,1)
    % Calculate the output of the object
    Y(i) = Simulation_Control_One_Loop(U,Y,i);
   
    if (strcmp(regulator,'PID'))
        % Calculate the control
        Ek = [Yzad(i) - Y(i) ; Yzad(i-1) - Y(i-1) ; Yzad(i-2) - Y(i-2) ];
        U(i) = Fuzzy_PID(PID_structs,Ek,U(i-1),Y(i));
    elseif (strcmp(regulator,'DMC'))
        U(i) = Fuzzy_DMC(DMC_structs,Y(i),U,Yzad(i),i);
    end
    
    % Calculate the error
    error = error + abs( Yzad(i) - Y(i) );    
end

fig = figure;
plot(Y)
hold on
plot(Yzad)

%fig = figure
%plot(U)

error


if save_data
    
    if(strcmp(regulator,'DMC'))
         % Time axis
        n = 1 : size(Yzad,1); 

        % Input
        nu = [n(:), U(:)];
        dlmwrite(strcat('Plots/exercise_',num2str(number_of_exercise),'/Input_plot_DMC_number_of_fuzzy_reg_',num2str(size(DMC_structs,2)),'_error_',num2str(error),'.txt'), nu, 'delimiter', ' ');

        % Output
        ny = [n(:), Y(:)];
        dlmwrite(strcat('Plots/exercise_',num2str(number_of_exercise),'/Output_plot_DMC_number_of_fuzzy_reg_',num2str(size(DMC_structs,2)),'.txt'), ny, 'delimiter', ' ');

        % Desired output
        ny_zad = [n(:), Yzad(:)];
        dlmwrite(strcat('Plots/exercise_',num2str(number_of_exercise),'/Desired_plot_DMC_number_of_fuzzy_reg_',num2str(size(DMC_structs,2)),'.txt'), ny_zad, 'delimiter', ' ');

    elseif(strcmp(regulator,'PID'))
        
        n = 1 : size(Yzad,1); 
        
        % Input
        nu = [n(:), U(:)];
        dlmwrite(strcat('Plots/exercise_',num2str(number_of_exercise),'/Input_plot_PID_number_of_fuzzy_reg_',num2str(size(PID_structs,2)),'_error_',num2str(error),'.txt'), nu, 'delimiter', ' ');

        % Output
        ny = [n(:), Y(:)];
        dlmwrite(strcat('Plots/exercise_',num2str(number_of_exercise),'/Output_plot_PID_number_of_fuzzy_reg_',num2str(size(PID_structs,2)),'.txt'), ny, 'delimiter', ' ');

        % Desired output
        ny_zad = [n(:), Yzad(:)];
        dlmwrite(strcat('Plots/exercise_',num2str(number_of_exercise),'/Desired_plot_PID_number_of_fuzzy_reg_',num2str(size(PID_structs,2)),'.txt'), ny_zad, 'delimiter', ' ');
        
    end
end