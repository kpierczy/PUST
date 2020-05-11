function [DMC_structs] = CalibratedFuzzyDMC(number_of_Fuzzy_DMCs,is_lambda_calibrated)
    if(number_of_Fuzzy_DMCs == 1)
        %First DMC
        DMC_struct.D = 51;
        DMC_struct.N = 15;
        DMC_struct.Nu = 7;
        DMC_struct.c = -1.5;
        DMC_struct.sigma = 0.9;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.2;
        end
        DMC_structs(1) = DMC_struct;
        
    elseif(number_of_Fuzzy_DMCs == 2)
        %First DMC
        DMC_struct.D = 25;
        DMC_struct.N = 15;
        DMC_struct.Nu = 10;
        DMC_struct.c = -2.5;
        DMC_struct.sigma = 0.6;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.1;
        end
        DMC_structs(1) = DMC_struct;
        
        %Second DMC
        DMC_struct.D = 25;
        DMC_struct.N = 15;
        DMC_struct.Nu = 10;
        DMC_struct.c = -0.7;
        DMC_struct.sigma = 0.6;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.1;
        end
        DMC_structs(2) = DMC_struct;
        
        
    elseif(number_of_Fuzzy_DMCs == 3)
        %First DMC
        DMC_struct.D = 58;
        DMC_struct.N = 16;
        DMC_struct.Nu = 14;
        DMC_struct.c = -2.6;
        DMC_struct.sigma = 0.21;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 8;
        end
        DMC_structs(1) = DMC_struct;
        
        %Second DMC
        DMC_struct.D = 49;
        DMC_struct.N = 16;
        DMC_struct.Nu = 14;
        DMC_struct.c = -1.5;
        DMC_struct.sigma = 0.21;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 20;
        end
        DMC_structs(2) = DMC_struct;
        
        %Third DMC
        DMC_struct.D = 39;
        DMC_struct.N = 16;
        DMC_struct.Nu = 14;
        DMC_struct.c = -0.4;
        DMC_struct.sigma = 0.21;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.9;
        end
        DMC_structs(3) = DMC_struct;
        
        
    elseif(number_of_Fuzzy_DMCs == 4)
        %First DMC
        DMC_struct.D = 60;
        DMC_struct.N = 15;
        DMC_struct.Nu = 10;
        DMC_struct.c = -2.8;
        DMC_struct.sigma = 0.2;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.1;
        end
        DMC_structs(1) = DMC_struct;
        
        %Second DMC
        DMC_struct.D = 54;
        DMC_struct.N = 15;
        DMC_struct.Nu = 10;
        DMC_struct.c = -1.98;
        DMC_struct.sigma = 0.2;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 30;
        end
        DMC_structs(2) = DMC_struct;
        
        %Third DMC
        DMC_struct.D = 45;
        DMC_struct.N = 15;
        DMC_struct.Nu = 10;
        DMC_struct.c = -1.2;
        DMC_struct.sigma = 0.2;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 15;
        end
        DMC_structs(3) = DMC_struct;
        
        %Forth DMC
        DMC_struct.D = 38;
        DMC_struct.N = 15;
        DMC_struct.Nu = 10;
        DMC_struct.c = -0.35;
        DMC_struct.sigma = 0.2;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.01;
        end
        DMC_structs(4) = DMC_struct;
        
        
    elseif(number_of_Fuzzy_DMCs == 5)
        %First DMC
        DMC_struct.D = 60;
        DMC_struct.N = 14;
        DMC_struct.Nu = 14;
        DMC_struct.c = -2.8;
        DMC_struct.sigma = 0.2;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 8;
        end
        DMC_structs(1) = DMC_struct;
        
        %Second DMC
        DMC_struct.D = 55;
        DMC_struct.N = 14;
        DMC_struct.Nu = 14;
        DMC_struct.c = -2.1;
        DMC_struct.sigma = 0.2;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 10;
        end
        DMC_structs(2) = DMC_struct;
        
        %Third DMC
        DMC_struct.D = 49;
        DMC_struct.N = 14;
        DMC_struct.Nu = 14;
        DMC_struct.c = -1.6;
        DMC_struct.sigma = 0.3;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 10;
        end
        DMC_structs(3) = DMC_struct;
        
        %Forth DMC
        DMC_struct.D = 41;
        DMC_struct.N = 14;
        DMC_struct.Nu = 14;
        DMC_struct.c = -1.0;
        DMC_struct.sigma = 0.3;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.6;
        end
        DMC_structs(4) = DMC_struct;
        
        %Fifth DMC
        DMC_struct.D = 40;
        DMC_struct.N = 14;
        DMC_struct.Nu = 14;
        DMC_struct.c = -0.5;
        DMC_struct.sigma = 0.3;
        if(is_lambda_calibrated == 0)
            DMC_struct.lambda = 1;
        else
            DMC_struct.lambda = 0.2;
        end
        DMC_structs(5) = DMC_struct;
        
        
    end
    
end

