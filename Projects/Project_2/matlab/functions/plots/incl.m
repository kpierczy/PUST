lst = dir('exercise_6/')
fid1 = fopen ('wstaw_wykr1.txt', 'w');

format1 = ['\\begin{center}' newline ...
           '\\begin{figure}' newline ...
'\\makebox[\\textwidth]{\\includegraphics[width=\\paperwidth]{data/exercise_6/%s}}' newline];

format2 = ['\\caption{%s}' newline ...
           '\\label{%s}' newline];

for i = 3 : 1 : size(lst)
    
    name = regexprep(lst(i).name,'(?<!\d)_','=' );
    name = regexprep(name,'_',', ' );
    name = name(1 : size(name,2) - 10);
    
    fprintf(fid1, format1, lst(i).name);
    fprintf(fid1, format2, name, lst(i).name(1 : size(lst(i).name,2) - 4));
    fprintf(fid1, ['\\end{figure}' newline '\\end{center}' newline])
end

is_closed = fclose(fid1);
