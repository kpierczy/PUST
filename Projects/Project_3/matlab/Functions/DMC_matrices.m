% Computes analitical solution of the DMC optimization problem
% returning K and Mp matrices used to calculate DMC algorithm's
% output.
%
% @param step_response : vector of step response suited to the DMC
%                        requirements (size of the vector is taken
%                        as dynamic rank)
% @param DMC_struct : structure containing DMC parameters (N, Nu, lambda)
function [K,Mp] = DMC_matrices(DMC_struct)

% Get dynamic rank
D = DMC_struct.D; 
%size(DMC_struct.step_response, 1);

% Initialize M matrix
M  = zeros(DMC_struct.N,DMC_struct.Nu);
for i = 1:DMC_struct.Nu
    M(i:DMC_struct.N,i) = DMC_struct.step_response(1:DMC_struct.N+1-i);
end

% Initialize Mp matrix
Mp = zeros(DMC_struct.N,D-1);
for i = 1:D-1
   for j = 1:DMC_struct.N
       if(i+j>D)
            Mp(j,i) = DMC_struct.step_response(D);
       else    
            Mp(j,i) = DMC_struct.step_response(i+j);
       end
   end
end

for i = 1:D-1
    Mp(:,i) = Mp(:,i) - ones(DMC_struct.N,1) .* DMC_struct.step_response(i);
end

% Solve optimization problem
K = (M' * M + DMC_struct.lambda * eye(DMC_struct.Nu))^(-1) * M';

end
