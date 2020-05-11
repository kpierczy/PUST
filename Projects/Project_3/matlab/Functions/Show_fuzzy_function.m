function [] = Show_fuzzy_function(PID_structs)
% Function shows dizzy functions to see if they cover whole area

x = -3.325:0.001:0.15;

fig = figure
hold on
for i = 1: size(PID_structs,2);
    plot(x,exp(-(x - PID_structs(i).c).^2/(2*PID_structs(i).sigma^2)))
end

end

