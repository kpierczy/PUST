% Calculates PID regulator output based on the given
% regulator's parameters and error values from last
% three moments.
%
% @param ek : vector errors from the actual and
%             two eariler mooments in form
%             [e(k); e(k-1); e(k-2)]
% @param PID_struct : structure containing K, Ti, Td
%                     PID's settings and Ts sampling period
% @param U_limits : structure containing Umin, Umax and
%                   dUmin, dUmax limitations
% @param Uk_1 : previous control value
function [U] = PID(ek, PID_struct, U_limits, Uk_1)

% Conver PID coefficients
r0 = PID_struct.K * ( 1 + PID_struct.Ts/(2*PID_struct.Ti) + PID_struct.Td/PID_struct.Ts);
r1 = PID_struct.K * ( PID_struct.Ts/(2*PID_struct.Ti) - 2*PID_struct.Td/PID_struct.Ts - 1);
r2 = PID_struct.K*PID_struct.Td/PID_struct.Ts;

% Compute control value
dU = r0*ek(1) + r1*ek(2) + r2*ek(3);

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

