% Bind to the simulation function that makes it able to use
% it with optimalisation functions (e.g. fmincon)
%
% @param params : DMC parameters [N; Nu; lambda]
% @note Adjusting simulation parameters takes place inside
%       the body of a simulation() function!
function error = DMC_score(params)

% Construct PID structure passed to PID method
DMC_struct.N = params(1);
DMC_struct.Nu = params(2);
DMC_struct.lambda = params(3);

% Compute simulation
[~,~,~, error] = simulation(DMC_struct, 1);

end

