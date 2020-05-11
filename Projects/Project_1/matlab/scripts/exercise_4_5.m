clear -except PID_params DMC_params
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine plot printing (0 = don't print, 1 = print)
PRINT = 1;

% PID settings
if exist('PID_params')
    PID_struct.K = PID_params(1);
    PID_struct.Ti = PID_params(2);
    PID_struct.Td = PID_params(3);
else
    PID_struct.K = 1.0107;
    PID_struct.Ti = 10.4463;
    PID_struct.Td = 1.449;
end

% DMC settings
if exist('DMC_params')
    DMC_struct.N = DMC_params(1);
    DMC_struct.Nu = DMC_params(2);
    DMC_struct.lambda = DMC_params(3);
else
    DMC_struct.N = 20;
    DMC_struct.Nu = 4;
    DMC_struct.lambda = 0.0373;
end

% Select regulator type (0 = PID, 1 = DMC)
regulator_type = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set an appropriate regulator_struct
if regulator_type == 0
   regulator_struct = PID_struct; 
elseif regulator_type == 1
    regulator_struct = DMC_struct;
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Y_zad, Y, U, error] = simulation(regulator_struct, regulator_type);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = (1:size(U, 1));
y_zad = Y_zad;
y = Y;
u = U;
xy = [x(:), y(:)];
xy_zad = [x(:), y_zad(:)];
xu = [x(:), u(:)];
if (regulator_type == 0)
    dlmwrite(strcat('../doc/report/data/exercise_4_5/K_', num2str(PID_struct.K),'_Ti_',num2str(PID_struct.Ti),'_Td_',num2str(PID_struct.Td),'xy.txt'), xy, 'delimiter', ' ');
    dlmwrite(strcat('../doc/report/data/exercise_4_5/K_', num2str(PID_struct.K),'_Ti_',num2str(PID_struct.Ti),'_Td_',num2str(PID_struct.Td),'_error_',num2str(error),'xy_zad.txt'), xy_zad, 'delimiter', ' ');
    dlmwrite(strcat('../doc/report/data/exercise_4_5/K_', num2str(PID_struct.K),'_Ti_',num2str(PID_struct.Ti),'_Td_',num2str(PID_struct.Td),'xu.txt'), xu, 'delimiter', ' ');
else
    dlmwrite(strcat('../doc/report/data/exercise_4_5/N_', num2str(DMC_struct.N),'_Nu_',num2str(DMC_struct.Nu),'_lambda_',num2str(DMC_struct.lambda),'xy.txt'), xy, 'delimiter', ' ');
    dlmwrite(strcat('../doc/report/data/exercise_4_5/N_', num2str(DMC_struct.N),'_Nu_',num2str(DMC_struct.Nu),'_lambda_',num2str(DMC_struct.lambda),'_error_',num2str(error),'xy_zad.txt'), xy_zad, 'delimiter', ' ');
    dlmwrite(strcat('../doc/report/data/exercise_4_5/N_', num2str(DMC_struct.N),'_Nu_',num2str(DMC_struct.Nu),'_lambda_',num2str(DMC_struct.lambda),'xu.txt'), xu, 'delimiter', ' ');
end

% @todo : Implement writing Y_zad, Y, and U signals printing to the txt file

if PRINT == 1
    close
    stairs(Y)
    hold on
    stairs(Y_zad)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except Y_zad Y U error