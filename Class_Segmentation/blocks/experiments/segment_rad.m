function [Iseg map] = segment_rad(imInd)

% Load original image
indices = load('/home/amounir/Workspace/Superpixels-iccv2009/results/all_images_indices.mat');
orgImgPath = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{imInd});
orgImg = imread(orgImgPath);

imPath = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/results/RADSegs/%05d.mat', imInd);
radStruct = load(imPath);
map = radStruct.map;

[Iseg, map] = createSegImage(orgImg, map);

end

%% Function: createSegImage
% This function creates the final segmented image from the segmentation map
% and the original image.
function [Iseg L] = createSegImage(img, L)
    
    [x, y, k] = size(img);
    Iseg = img;

    % Get unique values from the map
    values = unique(L);

    for iter = 1:length(values);
        label = values(iter);
        indices = find(L == label);
        avg = sum(img(indices)) / length(indices);
        Iseg(indices) = avg;
        
        if (k == 3)
            avg = sum(img(indices + x * y)) / length(indices);
            Iseg(indices + x * y) = avg;
            
            avg = sum(img(indices + 2 * x * y)) / length(indices);
            Iseg(indices + 2 * x * y) = avg;
        end
        
        L(indices) = iter;
    end
    
    Iseg = reshape(Iseg, size(img));
end





