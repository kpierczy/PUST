% Calculates PID regulator output based on the given
% regulator's parameters and error values from last
% three moments.
%
% @param Ek : vector errors from the actual and
%             two eariler mooments in form
%             [e(k); e(k-1); e(k-2)]
% @param PID_struct : structure containing K, Ti, Td
%                     PID's settings and Ts sampling period
% @param uk_1 : previous control value
function [u] = PID(PID_struct,Ek, uk_1)

% Conver PID coefficients
r0 = PID_struct.K * ( 1 + PID_struct.Ts/(2*PID_struct.Ti) + PID_struct.Td/PID_struct.Ts);
r1 = PID_struct.K * ( PID_struct.Ts/(2*PID_struct.Ti) - 2*PID_struct.Td/PID_struct.Ts - 1);
r2 = PID_struct.K*PID_struct.Td/PID_struct.Ts;

% Compute control value
dU = r0*Ek(1) + r1*Ek(2) + r2*Ek(3);
u = uk_1 + dU;

end

