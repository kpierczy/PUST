clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Steps' sizes
U_step = 1;
Z_step = 1;

% Dynamic range value tolerance
tol = 0.0001;

% Plots drawing
U_RESPONSE_PRINT = false;
Z_RESPONSE_PRINT = false;

% Saving data for the report
RESPONSES_SAVE = true;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[U_step_response, Z_step_response] = DMC_step_response(U_step, Z_step, tol);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if U_RESPONSE_PRINT || Z_RESPONSE_PRINT || RESPONSES_SAVE

    % Vector of numbers of samples in the responses
    n_u = (1:size(U_step_response, 1));
    n_z = (1:size(Z_step_response, 1));

    if U_RESPONSE_PRINT
        figure
        stairs(n_u, U_step_response)
        xlabel('n')
        ylabel('y')
        title('Step response of the input step')
    end

    if Z_RESPONSE_PRINT
        figure
        stairs(n_z, Z_step_response)
        xlabel('n')
        ylabel('y')
        title('Step response of the noise step')
    end

    if RESPONSES_SAVE
        % Save responses
        nu = [n_u(:), U_step_response(:)];
        nz = [n_z(:), Z_step_response(:)];
        dlmwrite(strcat('doc/data/exercise_3/U_step_response_DMC.txt'), nu, 'delimiter', ' ');
        dlmwrite(strcat('doc/data/exercise_3/Z_step_response_DMC.txt'), nz, 'delimiter', ' ');
    end
    
end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except U_step_response Z_step_response