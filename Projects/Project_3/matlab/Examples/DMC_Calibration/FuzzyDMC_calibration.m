clear
clc

% First argument passed to the FuzzyDMC constructor is a cell array
% of structures containing regulator-specific parameters like horizons,
% or lambda values. In this example we will create 4 regulater with the
% same parameters that will differ in membership functions that
% describes them. Shape of the example object is [1, 0, 1] (SISO)
%
% @note : rss is an abbreviation from 'regulator specific structure'

% Set number of regulators
regulators_num = 5;

% Determine DMCs parameters (in this example the same for all regulators)

% Create cell array of 4 identical regulators
regulators = cell(regulators_num, 1);

% For each regulator we define different parameters concerning
% process of step responses gathering and fuzzy sets shapes

regulators{1, 1}.N        = 14;
regulators{1, 1}.Nu       = 14;
regulators{1, 1}.D        = 60;
regulators{1, 1}.Dz       = 0;
regulators{1, 1}.lambda   = 8;
regulators{1, 1}.c        = -2.8;
regulators{1, 1}.sigma    = -0.2;   
regulators{1, 1}.sr_point = -1;
regulators{1, 1}.sr_step_size = 0.2;

regulators{2, 1}.N        = 14;
regulators{2, 1}.Nu       = 14;
regulators{2, 1}.D        = 55;
regulators{2, 1}.Dz       = 0;
regulators{2, 1}.lambda   = 10;
regulators{2, 1}.c        = -2.1;
regulators{2, 1}.sigma    = 0.2;   
regulators{2, 1}.sr_point = -0.5;
regulators{2, 1}.sr_step_size = 0.2;
 
regulators{3, 1}.N        = 14;
regulators{3, 1}.Nu       = 14;
regulators{3, 1}.D        = 41;
regulators{3, 1}.Dz       = 0;
regulators{3, 1}.lambda   = 10;
regulators{3, 1}.c        = 1.0;
regulators{3, 1}.sigma    = 0.3;   
regulators{3, 1}.sr_point = 0;
regulators{3, 1}.sr_step_size = 0.6;

regulators{4, 1}.N        = 14;
regulators{4, 1}.Nu       = 14;
regulators{4, 1}.D        = 60;
regulators{4, 1}.Dz       = 0;
regulators{4, 1}.lambda   = 0.6;
regulators{4, 1}.c        = 2.8;
regulators{4, 1}.sigma    = 0.3;   
regulators{4, 1}.sr_point = 0.5;
regulators{4, 1}.sr_step_size = 0.2;

regulators{5, 1}.N        = 14;
regulators{5, 1}.Nu       = 14;
regulators{5, 1}.D        = 40;
regulators{5, 1}.Dz       = 0;
regulators{5, 1}.lambda   = 0.2;
regulators{5, 1}.c        = -0.5;
regulators{5, 1}.sigma    = 0.3;   
regulators{5, 1}.sr_point = 1;
regulators{5, 1}.sr_step_size = 0.2;

cs.shape = [1, 0, 1];
cs.object = @(U)(simulate(U));
cs.membership_fun = 'gaussian';

FuzzyDMC_reg = FuzzyDMC(regulators, cs);

FuzzyDMC_reg.sets_base = 'output';

%========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%========================================================================

% Simulation length
sim_time = 700;

% Lets initialize some desired trajectory
y_zad_trajectory_struct.size  = sim_time;
y_zad_trajectory_struct.steps = [1, 0.1; 100, -0.5; 200, -1; 300, -2; ...
                                 400, 0; 500, -3.5; 600, 0.5];
y_zad = make_trajectory(y_zad_trajectory_struct);

% Initialize PVs vector
y = zeros(sim_time, 1);

% Initialize CVs vector
u = zeros(sim_time, 1);

for i=1:sim_time
    y(i) = simulate_step(u, y, i);
    u(i) = FuzzyDMC_reg.compute(y_zad(i), y(i));
end


%========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%========================================================================

figure
hold on
plot(y)
plot(y_zad)


%========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cleaning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%========================================================================

clear
