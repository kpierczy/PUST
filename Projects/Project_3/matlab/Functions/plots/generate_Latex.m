% generates latex code for plot generation
% u and y on the same plot
% @param lst : directory with delimiter-separated values (DSV) from
%                   which latex code is generated
% @param output_file : output file with latex code
function [] = generate_Latex(data_dir, output_file)

    lst = dir(data_dir);
    
    % Output file with latex code
    fid = fopen(output_file, 'w');
    % File with opening lines of Latex file
    fid_opening = fopen('latex/latex_opening.txt', 'r');
    
    % copy paste opening
    while feof(fid_opening) == 0
        temp = fgetl(fid_opening);
        fwrite(fid, sprintf('%s\n', temp));
    end
    
    fclose(fid_opening);

    str_main = ['%%newplot' newline ...
                '\\begin{figure}[tb]' newline ...
                '\\tikzsetnextfilename{%s}' newline ...
                '\\begin{tikzpicture}' newline ...
                '\\begin{groupplot}[group style={group size=1 by 3,vertical sep=\\odstepionowy},' newline ...
                'width=\\szer,height=\\wys]' newline];

    % y, y^zad plot
    str1 = ['\\nextgroupplot' newline ...
            '[xmin=0,xmax=400,ymin=-3,ymax=5,' newline ...
            'xlabel=$k$,ylabel={$y(k)$,$y^{\\mathrm{zad}}(k)$},legend cell align=left,' newline ...
            'legend pos=north east]' newline ...
            '\\addplot[const plot,color=black,semithick, dotted] file {%s};' newline ...
            '\\addplot[const plot,color=blue,semithick] file {%s};' newline ...
            '\\legend{$y^{\\mathrm{zad}}$,$y$}' newline newline ];
    % u plot
    str2 = ['\\nextgroupplot' newline ...
            '[xmin=0,xmax=400,ymin=-3,ymax=5,' newline ...
            'xlabel=$k$,ylabel=$u(k)$,legend cell align=left,' newline ...
            'legend pos=north east]' newline ...
            '\\addplot[const plot,color=green,semithick] file {%s};' newline ...
            '\\legend{$u(k)$}' newline newline];
        
    % noise plot
    str3 = ['\\nextgroupplot' newline ...
            '[xmin=0,xmax=400,ymin=-3,ymax=5,' newline ...
            'xlabel=$k$,ylabel=$z(k)$,legend cell align=left,' newline ...
            'legend pos=north east]' newline ...
            '\\addplot[const plot,color=gray,semithick] file {%s};' newline ...
            '\\legend{$z(k)$}' newline newline];

    str_end = ['\\end{groupplot}' newline ...
               '\\end{tikzpicture}' newline ...
               '\\end{figure}' newline newline ];

    for i = 3 : 1 : 3
        
        name1 = regexprep(fullfile('..\',data_dir,lst(i).name),'\','/');
        name2 = regexprep(fullfile('..\',data_dir,lst(i + 3).name),'\','/');
        name3 = regexprep(fullfile('..\',data_dir,lst(i + 1).name),'\','/');
        name4 = regexprep(fullfile('..\',data_dir,lst(i + 2).name),'\','/');
        
        
        fprintf(fid, str_main, lst(i).name(1 : size(lst(i).name,2) - 4) );
        fprintf(fid, str1, name1, name2 );
        fprintf(fid, str2, name3 );
        fprintf(fid, str3, name4 );
        fprintf(fid, str_end);
    end
        fprintf(fid, ['\\end{document}' newline]);

        fclose(fid);
        fclose('all')
end

