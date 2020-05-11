
lst = dir('../../doc/data/exercise_2/responses/');
x = [];
for i = 3 : 1 : size(lst, 1)
    fid = fopen(strcat('../../doc/data/exercise_2/responses/',lst(i).name), 'r');
    fid_e = fopen(strcat('../../doc/data/exercise_2/responses_edited/',lst(i).name(1:end-4),'_edited.txt'), 'w')
    a = 0;
    while feof(fid) == 0
            temp = fgetl(fid);
            temp_form = sscanf(temp, '%f')
            
            fprintf(fid_e,'%d %f', a, temp_form(2));
            fprintf(fid_e,'%s', newline)
            
            a = a + 1;
    end
    fclose(fid);
    fclose(fid_e);
end



