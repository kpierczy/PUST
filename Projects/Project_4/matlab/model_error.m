%===================================================================%
% Function computes summaric square error of the second-order
% inertion model with the given parameters. Error is computed as
% a sum of squares of differences between samples of the output and 
% an approximated output for the given input.
%
% @param params : array (5 x 1) holding parameters of the model
%        in shape [a1, a2, b1, b2, Td]
% @param G : input of the real system that was used to produce
%        output
% @param T : output of the system produced by the given input
% @param Gpp : value of the input in moments k < 0
% @param Tpp : value of the output in moments k < 0
%
% @returns : summaric error of the model
%
% @note : Lengths of the input and of the output have to be equal!
%===================================================================%
function error = model_error(params, G, T, Gpp, Tpp)

    % Check if lengths of both input and output ar equal
    if size(G, 2) ~= size(T, 2)
       error('Input has different length than output!') 
    end

    % Initialize model's output
    T_model = model_output(params, G, Gpp, Tpp);
    
    % Compute error
    error = sum((T - T_model).^2);

end