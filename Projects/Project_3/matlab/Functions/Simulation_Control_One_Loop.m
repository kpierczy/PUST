function [y] = Simulation_Control_One_Loop(U,Y, i)
% Function will calculate single output
% Parameters
% U - vector with all the control till this moment
% Y - vector with all of the outputs till this moment
% i - number of iteration ( function needs it to determine , if it has
%     enough control and outputs or if it needs to replace some with 0)

%%% Calculations %%%
    if ( i > 6 )
        y=symulacja_obiektu9y(U(i-5),U(i-6),Y(i-1),Y(i-2));
    elseif ( i > 5 )
        y=symulacja_obiektu9y(U(i-5),0,Y(i-1),Y(i-2));
    elseif ( i > 2 )
        y=symulacja_obiektu9y(0,0,Y(i-1),Y(i-2));
    elseif ( i > 1 )
        y=symulacja_obiektu9y(0,0,Y(i-1),0);
    else
        y=symulacja_obiektu9y(0,0,0,0);
    end

end

