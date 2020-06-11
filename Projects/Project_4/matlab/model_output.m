
%===================================================================%
% Function computes output of the second-order inertion model with
% the given parameters. 
%
% @param params : array (4 x 1) holding parameters of the model
%        in shape [T1, T2, K, Td]
% @param G : input to the model (size 1 x L)
% @param Gpp : value of the input in moments k < 0
% @param Tpp : value of the output in moments k < 0
%
% @returns : model's output of size (1 x size(G, 2))
%===================================================================%
function T = model_output(params, G, Gpp, Tpp)

    % Get simulation's length
    simulation_time = size(G, 2);

    % Initialize model's output
    T = zeros(1, simulation_time);
    
    % Compute parameters of the differential equation
    alpha_1 = exp(-1/params(1));
    alpha_2 = exp(-1/params(2));
    a1 = - alpha_1 - alpha_2;
    a2 =   alpha_1 * alpha_2;
    b1 = params(3) / (params(1) - params(2)) * ...
        (params(1) * (1 - alpha_1) - params(2) * (1 - alpha_2));
    b2 = params(3) / (params(1) - params(2)) * ...
        (alpha_1 * params(2) * (1 - alpha_2) - alpha_2 * params(1) * (1 - alpha_1));
    
    
    % Compute model's output
    for k = 1:simulation_time
        
        % Initialize vector of components that will be added to compute output
        components = zeros(4, 1);
        
        % Compute bi-related components
        if k > params(4) + 2
            components(1) = b1 * G(k - params(4) - 1);
            components(2) = b2 * G(k - params(4) - 2);            
        elseif k > params(4) + 1
            components(1) = b1 * G(k - params(4) - 1);
            components(2) = b2 * Gpp;
        else
            components(1) = b1 * Gpp;
            components(2) = b2 * Gpp;
        end
        
        % Compute ai-related components
        if k > 2
            components(3) = - a1 * T(k - 1);
            components(4) = - a2 * T(k - 2);            
        elseif k > 1
            components(3) = - a1 * T(k - 1);
            components(4) = - a2 * Tpp;
        else
            components(3) = - a1 * Tpp;
            components(4) = - a2 * Tpp;
        end
        
        % Compute model output
        T(k) = sum(components);
        
    end

end