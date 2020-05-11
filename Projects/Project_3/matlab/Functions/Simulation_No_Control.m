function [Y] = Simulation_No_Control(U,sim_time)
%%%%%%% Initialization %%%%%%%%%
    % -3.31 is the output for control -1
    Y = ones(sim_time,1) * -3.31;

%%%%%%% Simulation %%%%%%%

    for i = 1:sim_time
        %%% Object simulation %%%
        if ( i > 6 )
            Y(i)=symulacja_obiektu9y(U(i-5),U(i-6),Y(i-1),Y(i-2));
        elseif ( i > 5 )
            Y(i)=symulacja_obiektu9y(U(i-5),-1,Y(i-1),Y(i-2));
        elseif ( i > 2 )
            Y(i)=symulacja_obiektu9y(-1,-1,Y(i-1),Y(i-2));
        elseif ( i > 1 )
            Y(i)=symulacja_obiektu9y(-1,-1,Y(i-1),-3.31);
        else
            Y(i)=symulacja_obiektu9y(-1,-1,-3.31,-3.31);
        end
        
    end

end

