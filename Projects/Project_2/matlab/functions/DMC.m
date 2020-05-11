% Computes DMC control value basing on the K, Mp and Mzp
% matrices computed by DMC_matrices() function
%
% @param y_zad : expected value of the output
% @param y_k : actual value of the output
% @param dUp : vector of the control changes from
%              the (k - 1) moment to (k - (D - 1)) moment 
%              (D is a dynamic rank)
% @param dZp : vector of the noise changes from the
%              (k) moment to (k - (Dz - 1)) moment
%              (if dZp is an empty array, control value
%               is computed without respect to noise measurement)
% @param matrices : DMC solution matrices (K, Mp and Mzp(if dZp
%                   is not an empty array))

function dU = DMC(y_zad, yk, dUp, dZp, matrices)

% Initialize dimensions
N = size(matrices.Mp, 1);

% Initialize output vectors
Yzad = ones(N,1) * y_zad;
Yk = ones(N,1) * yk;

% Compute unrestrained trajectory
if size(dZp, 1) == 0
    Y_0 = Yk + matrices.Mp * dUp;
else
    Y_0 = Yk + matrices.Mp * dUp + matrices.Mzp * dZp;
end

% Compute optimal vector of future control changes
dU = matrices.K * (Yzad - Y_0);

% Get the first computed control increase
dU = dU(1);

end

