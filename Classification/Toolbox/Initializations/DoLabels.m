%% Create Pascal Labels 

% Ensure the Labels directory exists
if ~ exist(VOCopts.annopath, 'dir')
    mkdir(VOCopts.annopath);
else
    return;
end

% Create test images structure

labels_train=zeros(5011,20);
imgset='trainval';

for i=1:VOCopts.nclasses
    cls=VOCopts.classes{i};
    [ids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d');
    consideredImages=find(gt==1);
    labels_train(consideredImages,i)=1;
end

% Create test images structure

labels_test=zeros(4952,20);
imgset='test';

for i=1:VOCopts.nclasses
    cls=VOCopts.classes{i};
    [ids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d');
    consideredImages=find(gt==1);
    labels_test(consideredImages,i)=1;
end

labels=[labels_train; labels_test];
save(VOCopts.labels, 'labels');

% Save trainset files
trainset = zeros(9963, 1);
trainset(1:5011) = 1;
save(VOCopts.trainset, 'trainset');

% Save testset files
testset = zeros(9963, 1);
testset(5012:end) = 1;
save(VOCopts.testset, 'testset');

% Save image names

image_names = cell(9963, 1);

% Train images
[ids] = textread(sprintf(VOCopts.imgsetpath, 'trainval'),'%s');
for imageName = 1:length(ids)
    image_names{imageName} = sprintf('%s.jpg', ids{imageName});
end

% Test images
[ids] = textread(sprintf(VOCopts.imgsetpath, 'test'),'%s');
for imageName = 1:length(ids)
    imageIndex = imageName + 5011;
    image_names{imageIndex} = sprintf('%s.jpg', ids{imageName});
end

save(VOCopts.image_names, 'image_names');