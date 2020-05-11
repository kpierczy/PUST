% Computes analitical solution of the DMC optimization problem
% returning K, Mp and Mzp matrices used to calculate DMC algorithm's
% output.
%
% @param step_response : vector of step response suited to the DMC
%                        requirements (dynamic ranks passed in the DMC_struct
%                        cannot be higher than sizes of these vectors)
% @param DMC_struct : structure containing DMC parameters (N, Nu, D, Dz, lambda)
%                     If Dz value is 0, the noise measurement is not taken
%                     int account. Z_step_response can be an empty array
%                     then.
function [K, Mp, Mzp] = DMC_matrices(U_step_response, Z_step_response, DMC_struct)

% Check if required dynamic rank is available
if DMC_struct.D > size(U_step_response, 1)
    error('Required dynamic rank is higher than available length of the step response.')
end
   
if DMC_struct.Dz > size(Z_step_response, 1)
    error('Required noise dynamic rank is higher than available length of the noise step response.')
end

% Check if U_step_response is available
if size(U_step_response, 1) == 0
   error('Input step response cannot be empty!') 
end

% Initialize M matrix
M  = zeros(DMC_struct.N, DMC_struct.Nu);
for i = 1 : DMC_struct.Nu
    M(i : DMC_struct.N, i) = U_step_response(1 : (DMC_struct.N + 1 - i));
end

% Initialize Mp matrix
Mp = zeros(DMC_struct.N, DMC_struct.D - 1);
for i = 1 : (DMC_struct.D - 1)
   for j = 1 : DMC_struct.N
       if(i + j > DMC_struct.D)
            Mp(j, i) = U_step_response(DMC_struct.D);
       else    
            Mp(j, i) = U_step_response(i + j);
       end
   end
   Mp(:, i) = Mp(:, i) - U_step_response(i);
end

% Initialize Mzp matrix
if DMC_struct.Dz ~= 0
    Mzp = zeros(DMC_struct.N, DMC_struct.Dz);
    for i = 1 : DMC_struct.Dz
        for j = 1 : DMC_struct.N
            if(i + j - 1) > DMC_struct.Dz
                Mzp(j, i) = Z_step_response(end);
            else
                Mzp(j, i) = Z_step_response(i + j - 1);
            end
        end
        if(i > 1)
           Mzp(:, i) = Mzp(:, i) - Z_step_response(i - 1);
        end
    end
else
    Mzp = [];
end

% Solve optimization problem
K = (M' * M + DMC_struct.lambda * eye(DMC_struct.Nu))^(-1) * M';

end
