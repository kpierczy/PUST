function [u] = Find_u_for_y(y)
% function finds the the control for specific y according to the Static
% characteristic UY

[STU,STY] = StaticUY(1,1000,0);
for i = 1 : size(STY,1) - 1
    if(y >= STY(i)  & y < STY(i+1) )
        u = STU(i);
        break;
    end
end

end

