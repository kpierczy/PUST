% Bind to the simulation function that makes it able to use
% it with optimalisation functions (e.g. fmincon)
%
% @param params : PID parameters [K, Ti, Td]
%
% @note Adjusting simulation parameters takes place inside
%       the body of a simulation() function!
function error = PID_score(params)

% Construct PID structure passed to PID method
PID_struct.K = params(1);
PID_struct.Ti = params(2);
PID_struct.Td = params(3);

% Compute simulation
[~,~,~, error] = simulation(PID_struct, 0);

end

