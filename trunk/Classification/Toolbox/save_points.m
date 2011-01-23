function save_points(fname, points)
%% Save points in a vector into a file

if exist(fname) == 2
    system(['rm ' fname]);
end

fprintf('%s', fname);
file = fopen(fname, 'w');

for i = 1:size(points, 1)
    for j = 1:size(points, 2)
        fprintf(file,'%f ', points(i, j));
    end

    fprintf(file, '\n');
end

fclose(file);
