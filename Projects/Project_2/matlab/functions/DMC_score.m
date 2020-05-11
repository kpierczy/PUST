% Bind to the simulation function that makes it able to use
% it with optimalisation functions (e.g. fmincon)
%
% @param Y_zad : desired output trajectory
% @param Z : noise trajectory
% @param params : DMC parameters [N; Nu; D; Du; lambda]
% @returns : simulation's error
%
%
% @note Adjusting simulation parameters takes place inside
%       the body of a simulation() function!
function error = DMC_score(Y_zad, Z, params)

% Construct PID structure passed to PID method
DMC_struct.N = params(1);
DMC_struct.Nu = params(2);
DMC_struct.D = params(3);
DMC_struct.Dz = params(4);
DMC_struct.lambda = params(5);

% Compute simulation
[~, ~, error] = simulation(Y_zad, Z, DMC_struct);

end

