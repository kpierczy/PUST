% Computes DMC control value basing on the K and Mp
% matrices computed by DMC_matrices function
%
% @param y_zad : expected value of the output
% @param y_k : actual value of the output
% @param dUp : vector of the control changes from
%              the (k - 1) moment to (k - (D - 1)) moment 
%              (D is a dynamic rank)
% @param K, Mp : DMC solution matrices
% @param U_limits : structure containing Umin, Umax and
%                   dUmin, dUmax limitations
% @param Uk_1 : previous control value
function [U] = DMC(y_zad, yk, dUp, K, Mp, U_limits, Uk_1)

% Initialize dimensions
N = size(Mp, 1);
D = size(K, 1) + 1;

% Initialize output vectors
Yzad = ones(N,1) * y_zad;
Yk = ones(N,1) * yk;

% Compute unrestrained trajectory
Y_0 = Yk + Mp * dUp;

% Compute optimal vector of future control changes
dU = K * (Yzad - Y_0);

% Get the first computed control increase
dU = dU(1);

% Apply dU value constraints
if dU > U_limits.dUmax
    dU = U_limits.dUmax;
elseif dU < U_limits.dUmin
    dU = U_limits.dUmin;
end

% Apply U value constraints
if Uk_1 + dU > U_limits.Umax
    U = U_limits.Umax;
elseif Uk_1 + dU < U_limits.Umin
    U = U_limits.Umin;
else
    U = Uk_1 + dU;
end

end

