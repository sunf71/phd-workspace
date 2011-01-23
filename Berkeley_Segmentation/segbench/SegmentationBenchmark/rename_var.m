files = dir('.');

for f = 1:length(files)
    files(f).name
    if(files(f).name(1) == '.' || files(f).name(length(files(f).name) - 1) ~= 'a')
        continue;
    end
    
    load(files(f).name);
    sampleLabels = map;
    save(files(f).name, 'sampleLabels');
end
