fid = fopen('../../doc/data/exercise_2/static_characteristic.txt', 'r');
x = [];
y = [];
z = [];
while feof(fid) == 0
    temp = fgetl(fid);
    
    temp_form = sscanf(temp, '%f')
    
    x = [x; temp_form(1:9)]
    y = [y; temp_form(10:18)]
    z = [z; temp_form(19:27)]
end

% x = x(2:end);
% y = y(2:end);
% z = z(2:end);

fclose(fid)