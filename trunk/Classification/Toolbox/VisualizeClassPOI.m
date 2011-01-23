function VisualizeClassPOI(classID)
% Visualizes the image that contains the interest points of the class that
% carries the following classID. Works on PASCAL VOC 2007.

vocroot = '/home/amounir/Workspace/Datasets/Pascal';
voccode = '/home/amounir/Workspace/Datasets/Pascal/VOCcode2007';
which_train = 'trainval' ;
which_test = 'test' ;

addpath(voccode) ;

db.TRAIN      = 0 ;
db.TEST       = 1 ;
db.VALIDATION = 2 ;
db.depth      = 1 ;

% initialize VOC 
VOCINIT2007;

% get categories
db.VOCopts = VOCopts;
db.VOCopts.testset = which_test;
db.VOCcolors = VOClabelcolormap(256);

db.images_path = fileparts(VOCopts.imgpath);
cat_names = [VOCopts.classes] ;
cat_ids   = 1:length(cat_names);
% add a background category
cat_names{length(cat_names)+1} = 'background';
cat_ids   = [cat_ids 0];

ncats = length(cat_names) ;

% scan all
db.cat_names = {} ;

cn = 1 ;
for c = 1:ncats
    cat_name = cat_names{c} ;
    db.cat_names{cn}   = cat_name ;
    db.cat_ids{cn}     = cat_ids(c);
    cn = cn + 1;
end

ncats = length(db.cat_names);    
train_ids = textread(sprintf(VOCopts.seg.imgsetpath, which_train), '%s');

DIMX = 1000;
DIMY = 1000;

for classInd = 1:20

    if exist(sprintf('finalConfidences%d.mat', classInd)) == 2
        continue;
    end

    finalConfidences = zeros(DIMX, DIMY);

    for i = 1:length(train_ids)
        i
        orgImagePath = sprintf(VOCopts.imgpath, train_ids{i});
        classSegPath = sprintf(VOCopts.seg.clsimgpath, train_ids{i});

        classSegImage = imresize(imread(classSegPath), [1000 1000]);
        personIndices = find(classSegImage == classInd);
        finalConfidences(personIndices) = finalConfidences( ...
            personIndices) + 1;
    end

    figure, imshow(finalConfidences, []);
    colormap('jet');
    title(db.cat_names{classInd});
    save(sprintf('finalConfidences%d.mat', classInd), 'finalConfidences');

end

foregroundBlobsCount = [ ...
    1, ... % Aeroplane     1
    1, ... % Bicycle       2
    1, ... % Bird          3
    1, ... % Boat          4
    1, ... % Bottle        5
    1, ... % Bus           6
    1, ... % Car           7
    1, ... % Cat           8
    1, ... % Chair         9
    1, ... % Cow           10
    1, ... % Diningtable   11
    1, ... % Dog           12
    1, ... % Horse         13
    1, ... % Motorbike     14
    1, ... % Person        15
    1, ... % Pottedplant   16
    1, ... % Sheep         17
    1, ... % Sofa          18
    1, ... % Train         19
    1  ... % TVMonitor     20
    ];

figure
for classInd = 1:20
    load(sprintf('finalConfidences%d.mat', classInd));
    meanValues = mean(finalConfidences(:));
    splitFB = imfill(finalConfidences > meanValues, 'holes');
    regions = regionprops(splitFB, 'PixelList');

    subplot(121);
    imshow(splitFB);

    pixelSizes = zeros(length(regions), 1);
    for i = 1:length(regions)
        pixelSizes(i) = size(regions(i).PixelList, 1);
    end

    [vals, inds] = sort(pixelSizes, 'descend');
    for i = foregroundBlobsCount(classInd) + 1:length(regions)
        pixelsList = regions(inds(i)).PixelList;
        pixelsIndices = sub2ind([DIMX DIMY], pixelsList(:, 2), ...
            pixelsList(:, 1));
        splitFB(pixelsIndices) = 0;
    end

    % Remember to save as reference_image =
    % getfield(load('reference_image.mat'), 'reference_image');
    subplot(122);
    imshow(splitFB);
    title(db.cat_names{classInd});
    pause;
end

% el7etta elly kol showayya ne3melha :D
load(sprintf('finalConfidences%d.mat', 5));
meanValues = mean(finalConfidences(:));
splitFB = imfill(finalConfidences > meanValues, 'holes');
regions = regionprops(splitFB, 'PixelList');
pixelSizes = zeros(length(regions), 1);
for i = 1:length(regions)
    pixelSizes(i) = size(regions(i).PixelList, 1);
end

[vals, inds] = sort(pixelSizes, 'descend');
for i = 2:length(regions)
    pixelsList = regions(inds(i)).PixelList;
    pixelsIndices = sub2ind([1000 1000], pixelsList(:, 2), ...
        pixelsList(:, 1));
    splitFB(pixelsIndices) = 0;
end

reference_image = splitFB + 1;
save('reference_image_bottle.mat', 'reference_image', '-MAT');
end