function [u,VectorUY] = StaticUY(u_max,number_of_points,print)
    % Initialization
    time = 300;
    U = zeros(time,1) - 1;
    u_step = (u_max + 1)/number_of_points;
    
    
    VectorUY = zeros(number_of_points,1);
    u = -1:u_step:u_max-u_step;
    
    % Simulation
    for i = 1 : number_of_points
        Y = Simulation_No_Control(U,time);
        VectorUY(i) = Y(end);
        U = U + u_step;
    end
    if(print == 1)
        plot(u,VectorUY);
    end
end

