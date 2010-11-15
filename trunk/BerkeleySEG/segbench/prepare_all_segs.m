function prepare_all_segs(from, to)

baseResDir = '/home/amounir/Workspace/BerkeleySEG/segbench/BSDS300/human/color';
baseDSDir = '/home/amounir/Workspace/BerkeleySEG/segbench/BSDS300/images/test';

inds = dir(baseDSDir);
inds = inds(3:end);


%% Mean shift segmentations

% parfor imgInd = 1:length(inds)
for imgInd = from:to
    imgInd
    
    iid = str2double(inds(imgInd).name(1:end-4));
    opFile = [baseResDir '/1/' int2str(iid) '.bmp'];
    opFileMat = [baseResDir '/1/' int2str(iid) '.mat'];

    if (exist(opFileMat, 'file') == 2)
        continue;
    end

    im = readImg(imgFilename(iid));
    
    [Iseg map] = msseg(im, 11, 8, 40);
    map = map + 1;
    
    saveVars(opFileMat, Iseg, map);
    bw = edge(int16(map), 'canny');
    saveBMP(bw, opFile);
end

%% Normalized cut segmentations
% parfor imgInd = 1:length(inds)
for imgInd = from:to
    imgInd
    
    iid = str2num(inds(imgInd).name(1:end-4));
    opFile = [baseResDir '/2/' int2str(iid) '.bmp'];
    opFileMat = [baseResDir '/2/' int2str(iid) '.mat'];

    if (exist(opFileMat, 'file') == 2)
        continue;
    end

    im = imread(imgFilename(iid));
    
    [Iseg map] = segmentMinCut(im);
    map = map + 1;

    saveVars(opFileMat, Iseg, map);
    bw = edge(int16(map), 'canny');
    saveBMP(bw, opFile);
end


%% Graph-Based

% parfor imgInd = 1:length(inds)
for imgInd = from:to
    imgInd
    
    iid = str2num(inds(imgInd).name(1:end-4));
    opFile = [baseResDir '/3/' int2str(iid) '.bmp'];
    opFileMat = [baseResDir '/3/' int2str(iid) '.mat'];

    if (exist(opFileMat, 'file') == 2)
        continue;
    end

    im = imread(imgFilename(iid));
    
    [Iseg map] = graphSeg(im, 0.5, 50, 2, 0);
    map = map + 1;

    saveVars(opFileMat, Iseg, map);
    bw = edge(int16(map), 'canny');
    saveBMP(bw, opFile);
end
end

function saveBMP(bmp, filename)
    imwrite(bmp, filename, 'bmp');
end

function im = readImg(filename)
    im = imread(filename);
end

function saveVars(fname, Iseg, map)
    save(fname, 'Iseg', 'map', '-MAT');
end