% Computes DMC control value basing on the K and Mp
% matrices computed by DMC_matrices function
%
% @param y_zad : expected value of the output
% @param y_k : actual value of the output
% @param dUp : vector of the control changes from
%              the (k - 1) moment to (k - (D - 1)) moment 
%              (D is a dynamic rank)
% @param K, Mp : DMC solution matrices
% @param Uk_1 : previous control value
function [u] = DMC(DMC_struct,yk,Uk,yzad,iter)

% Initialize vectors
Yzad = ones(DMC_struct.N,1) * yzad;
Yk = ones(DMC_struct.N,1) * yk;
dUp = zeros(DMC_struct.D - 1 , 1 );

% Calculate dUp
for i = 1 : DMC_struct.D-1
    if (i < iter - 1 )
        dUp(i) = Uk(iter - i) - Uk(iter - 1  - i);
    elseif (i == iter - 1)
        dUp(i) = Uk(iter - i);
    end
end 


% Compute unrestrained trajectory
Y_0 = Yk + DMC_struct.Mp * dUp;

% Compute optimal vector of future control changes
dU = DMC_struct.K * (Yzad - Y_0);

% Get the first computed control increase
du = dU(1);

u = Uk(iter-1) + du;

end

