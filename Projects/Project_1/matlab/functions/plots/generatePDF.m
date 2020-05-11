% generates latex code for plot generation
% u and y on the same plot

% directory with delimiter-separated values (DSV)
lst = dir('exercise_4_5/');

% Output file with latex code
fid = fopen('wykresy1.txt', 'w');
            
str_main = ['\\begin{figure}[tb]' newline ...
            '\\tikzsetnextfilename{%s}' newline ...
            '\\begin{tikzpicture}' newline ...
            '\\begin{axis}[' newline ...
            'width=0.5\\textwidth,' newline ...
            'xmin=0,xmax=500,ymin=0,ymax=4,' newline ...
            'xlabel={$k$},' newline ...
            'ylabel={$y(k)$},' newline ...
            'legend pos=south east,]' newline];
        
            
str1 = ['\\addplot[black,semithick, dotted]' newline ...
        'file {exercise_5/%s};' newline];
str2 = ['\\addplot[blue,semithick]' newline ...
        'file {exercise_5/%s};' newline];
str3 = ['\\addplot[green,semithick]' newline ...
        'file {exercise_5/%s};' newline];
        
str_end = ['\\legend{$y_{zad}$,$u(k)$,$y(k)$}' newline ...
           '\\end{axis}' newline ...
           '\\end{tikzpicture}' newline ...
           '\\end{figure}' newline];

for i = 3 : 3 : size(lst)

    fprintf(fid, str_main, lst(i).name(1 : size(lst(i).name,2) - 4) );
    
    name = regexprep('K_0.8_Ti_10000_Td_0_error_36.6129xy_zad.txt','(?<!\d)_','=' );
    name = regexprep(name,'_',', ' );
    name = name(1 : size(name,2) - 10);
    

    
    fprintf(fid, str1, lst(i).name );
    fprintf(fid, str2, lst(i + 1).name );
    fprintf(fid, str3, lst(i + 2).name );
    fprintf(fid, str_end);
end
    fprintf(fid, ['\\end{document}' newline]);
    
    fclose(fid)