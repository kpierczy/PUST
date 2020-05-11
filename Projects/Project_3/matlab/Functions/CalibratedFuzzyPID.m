function [PID_structs] = CalibratedFuzzyPID(number_of_Fuzzy_PIDs)
    if(number_of_Fuzzy_PIDs == 1)
        
        % First fuzzy PID
        PID_struct.K = 0.174;
        PID_struct.Ti = 2.3;
        PID_struct.Td = 0.8;
        PID_struct.Ts = 0.5;
        PID_struct.c = -1.5;
        PID_struct.sigma = 10;
        PID_structs(1) = PID_struct;
        
    elseif(number_of_Fuzzy_PIDs == 2)
        % First fuzzy PID
        PID_struct.K = 0.14;
        PID_struct.Ti = 2.6;
        PID_struct.Td = 0.7;
        PID_struct.Ts = 0.5;
        PID_struct.c = -2.3;
        PID_struct.sigma = 0.4;
        PID_structs(1) = PID_struct;
        
        % Second fuzzy PID
        PID_struct.K = 0.235;
        PID_struct.Ti = 2.09;
        PID_struct.Td = 1.0;
        PID_struct.Ts = 0.5;
        PID_struct.c = -0.5;
        PID_struct.sigma = 0.4;
        PID_structs(2) = PID_struct;
        
    elseif(number_of_Fuzzy_PIDs == 3)
        % First fuzzy PID
        PID_struct.K = 0.15;
        PID_struct.Ti = 2.7;
        PID_struct.Td = 0.6;
        PID_struct.Ts = 0.5;
        PID_struct.c = -2.4;
        PID_struct.sigma = 0.3;
        PID_structs(1) = PID_struct;
        
        % Second fuzzy PID
        PID_struct.K = 0.09;
        PID_struct.Ti = 2.0;
        PID_struct.Td = 1.2;
        PID_struct.Ts = 0.5;
        PID_struct.c = -1.2;
        PID_struct.sigma = 0.3;
        PID_structs(2) = PID_struct;
        
        % Third fuzzy PID
        PID_struct.K = 0.31;
        PID_struct.Ti = 2.9;
        PID_struct.Td = 0.7;
        PID_struct.Ts = 0.5;
        PID_struct.c = -0.2;
        PID_struct.sigma = 0.3;
        PID_structs(3) = PID_struct;
        
    elseif(number_of_Fuzzy_PIDs == 4)
        % First fuzzy PID
        PID_struct.K = 0.14;
        PID_struct.Ti = 2.25;
        PID_struct.Td = 1.0;
        PID_struct.Ts = 0.5;
        PID_struct.c = -2.7;
        PID_struct.sigma = 0.2;
        PID_structs(1) = PID_struct;
        
        % Second fuzzy PID
        PID_struct.K = 0.1;
        PID_struct.Ti = 2.7;
        PID_struct.Td = 0.6;
        PID_struct.Ts = 0.5;
        PID_struct.c = -2.1;
        PID_struct.sigma = 0.2;
        PID_structs(2) = PID_struct;
        
        % Third fuzzy PID
        PID_struct.K = 0.18;
        PID_struct.Ti = 3.7;
        PID_struct.Td = 1.1;
        PID_struct.Ts = 0.5;
        PID_struct.c = -1.3;
        PID_struct.sigma = 0.2;
        PID_structs(3) = PID_struct;
        
        % Forth fuzzy PID
        PID_struct.K = 0.255;
        PID_struct.Ti = 2.57;
        PID_struct.Td = 0.87;
        PID_struct.Ts = 0.5;
        PID_struct.c = -0.5;
        PID_struct.sigma = 0.2;
        PID_structs(4) = PID_struct;
       
    elseif(number_of_Fuzzy_PIDs == 5)
        % First fuzzy PID
        PID_struct.K = 0.14;
        PID_struct.Ti = 3.3;
        PID_struct.Td = 1.0;
        PID_struct.Ts = 0.5;
        PID_struct.c = -2.7;
        PID_struct.sigma = 0.1;
        PID_structs(1) = PID_struct;
        
        % Second fuzzy PID
        PID_struct.K = 0.09;
        PID_struct.Ti = 2.3;
        PID_struct.Td = 0.7;
        PID_struct.Ts = 0.5;
        PID_struct.c = -2.1;
        PID_struct.sigma = 0.1;
        PID_structs(2) = PID_struct;
        
        % Third fuzzy PID
        PID_struct.K = 0.15;
        PID_struct.Ti = 2.9;
        PID_struct.Td = 1.2;
        PID_struct.Ts = 0.5;
        PID_struct.c = -1.6;
        PID_struct.sigma = 0.1;
        PID_structs(3) = PID_struct;
        
        % Forth fuzzy PID
        PID_struct.K = 0.15;
        PID_struct.Ti = 2.8;
        PID_struct.Td = 1.9;
        PID_struct.Ts = 0.5;
        PID_struct.c = -1;
        PID_struct.sigma = 0.1;
        PID_structs(4) = PID_struct;
        
        % Fifth fuzzy PID
        PID_struct.K = 0.34;
        PID_struct.Ti = 3.2;
        PID_struct.Td = 0.6;
        PID_struct.Ts = 0.5;
        PID_struct.c = -0.5;
        PID_struct.sigma = 0.1;
        PID_structs(5) = PID_struct;
        
    end

end

