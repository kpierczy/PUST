% generates latex code for plot generation
% u and y on the same plot
% @param lst : directory with delimiter-separated values (DSV) from
%                   which latex code is generated
% @param output_file : output file with latex code
function [] = generate_Latex_includes(data_dir, output_file)

lst = dir(data_dir);
fid1 = fopen (output_file, 'w');

format1 = ['\\begin{center}' newline ...
           '\\begin{figure}' newline ...
'\\makebox[\\textwidth]{\\includegraphics[width=\\paperwidth]{%s}}' newline];

format2 = ['\\caption{%s}' newline ...
           '\\label{%s}' newline];

for i = 3 : 1 : size(lst)
    
    name_file_caption = lst(i).name(35 : end);
    name_file_caption = regexprep(name_file_caption, '(?<!\d)_','=' );
    name_file_caption = regexprep(name_file_caption,'_',', ' );
    name_file_caption = name_file_caption(1 : size(name_file_caption,2) - 4);
    
    name_plot_file = regexprep(fullfile('data\exercise_4', lst(i).name),'\','/');
    name_plot_label = lst(i).name(1 : size(lst(i).name,2) - 4);
    
    
    fprintf(fid1, format1, name_plot_file);
    fprintf(fid1, format2, name_file_caption, name_plot_label);
    fprintf(fid1, ['\\end{figure}' newline '\\end{center}' newline]);
end

is_closed = fclose(fid1);
end