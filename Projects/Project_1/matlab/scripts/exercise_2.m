clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starting work point
Upp = 1.7;
Ypp = 2.0;

% Number of steps of a single simulation
STEPS_NUMBER = 200;
% Number of step responses measured (for a single direction)
STEP_RESPONSES_NUM = 4;
% 1 - print step responses; 0 - don't print
PRINT_RESPONSES = 1;
% 1 - print step responses; 0 - don't print
PRINT_STATIC_CHAR = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set initial values of input and output vector
U_init = ones(STEPS_NUMBER,1) * Upp;
Y_init = ones(STEPS_NUMBER,1) * Ypp;

% Set input and output vectors to initial values
U = U_init;
Y = Y_init;

% Matrix of step responses. Every row of the matrix is a set of samples
% that represents a single step response.
% Note that input step is performed at the n=1, not n=0.
step_responses = zeros(STEP_RESPONSES_NUM * 2, STEPS_NUMBER - 1);

% Matrix of (U,Y) pairs representing object's work points
% The first column contains values of U and the second contains
% values of Y
work_points = zeros(STEP_RESPONSES_NUM * 2, 2);

% Ratios between output and input in a steady state
static_gains = zeros(STEP_RESPONSES_NUM * 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop over positive steps
for step_num = 1:STEP_RESPONSES_NUM

    % Define a step size & an input vector
    step_size = (1 + STEP_RESPONSES_NUM - step_num) * 0.3 / STEP_RESPONSES_NUM;
    U(2:STEPS_NUMBER) = U(2:STEPS_NUMBER) + step_size;
    
    % Simulate the process
    for i=12:STEPS_NUMBER
        Y(i) = symulacja_obiektu9Y(U(i-10), U(i-11), Y(i-1), Y(i-2));
    end

    % Save the step response and the work point to the matrices
    step_responses(step_num, :) = Y(2:STEPS_NUMBER);
    work_points(step_num, :) = [U(2), step_responses(step_num, STEPS_NUMBER - 1)];

    % Restore input and output vectors values
    U = U_init;
    Y = Y_init;
end

% Loop over negative steps
for step_num = 1:STEP_RESPONSES_NUM

    % Define a step size & an input vector
    step_size = step_num * 0.3 / STEP_RESPONSES_NUM;
    U(2:STEPS_NUMBER) = U(2:STEPS_NUMBER) - step_size;
    
    % Simulate the process
    for i=12:STEPS_NUMBER
        Y(i) = symulacja_obiektu9Y(U(i-10), U(i-11), Y(i-1), Y(i-2));
    end

    % Save the step response and the work point to the matrices
    step_responses(STEP_RESPONSES_NUM + step_num, :) = Y(2:STEPS_NUMBER);
    work_points(STEP_RESPONSES_NUM + step_num, :) = [U(2), step_responses(STEP_RESPONSES_NUM + step_num, STEPS_NUMBER - 1)];
    
    % Restore input and output vectors values
    U = U_init;
    Y = Y_init;
end

% Calculate static gains
static_gains = (work_points(:,1) - 1.7) ./ (work_points(:,2) - 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if PRINT_RESPONSES == 1
    for step_num = 1:STEP_RESPONSES_NUM*2
       plot(step_responses(step_num, :), 'DisplayName', sprintf('dU = %f', work_points(step_num, 1) - 1.7))
       hold on
    end
    
    legend('show')
end

for step_num = 1:STEP_RESPONSES_NUM*2
    x = (0:0.5:size(step_responses(step_num, :), 2) / 2 - 0.5);
    y = step_responses(step_num, :)';
    xy = [x(:), y(:)];
    dlmwrite(strcat('../doc/report/data/exercise_2/step_response_', num2str(step_num), '.txt'), xy, 'delimiter', ' ');
end

if PRINT_STATIC_CHAR == 1
    figure;
    plot(work_points(:, 1), work_points(:, 2))
end

x = work_points(:, 1);
y = work_points(:, 2);
xy = [x(:), y(:)];
dlmwrite(strcat('../doc/report/data/exercise_2/static_characteristic.txt'), xy, 'delimiter', ' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clearing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except step_responses static_gains work_points

