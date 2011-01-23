indices = load('/home/amounir/Workspace/Superpixels-iccv2009/results/all_images_indices.mat');

% figure;

for segInd = 1:632
    
segInd
    
orgImgPath = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{segInd});
orgImg = imread(orgImgPath);

fOrgImg = imfilter(orgImg, fspecial('gaussian', 3, 1));

seg = RAD(2,0.01,3,80,fOrgImg,1);
map = gslabel(seg(:, :, 1));

seg = uint8(seg);

result = struct();
result.Iseg = seg;
result.map = map;

imshow(seg);
drawnow;

% subplot(121);
% imshow(orgImg);
% 
% subplot(122);
% imshow(seg);

ofname = sprintf('./Pascal2007RADSegs/%05d.mat', segInd);
save(ofname, '-STRUCT', 'result', '-MAT');

% pause
end
