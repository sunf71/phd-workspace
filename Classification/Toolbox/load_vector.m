function points = load_vector(fname)
%% Loads a vector of points from a file
% Points are written as X Y

file = fopen(fname);

if(file < 0) 
    display('Cannot find file');
    return;
end

points = fscanf(file,'%f',inf);
fclose(file);
