%% Function: mix_segmentations
function [Iseg, map] = mix_segmentations(segInd)

% Get segmentations paths
segs_paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2', ...
                  '/home/amounir/Workspace/Superpixels-iccv2009/results/GB_AN_1', ...
                  '/home/amounir/Workspace/Superpixels-iccv2009/results/NCut_1');
segs_paths = cellstr(segs_paths);

% Load original image
indices = load('/home/amounir/Workspace/Superpixels-iccv2009/results/all_images_indices.mat');
orgImgPath = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{segInd});
orgImg = imread(orgImgPath);

% Load all segmentations
all_segs = [];
for pathsIter = 1:length(segs_paths)
    seg_path = segs_paths{pathsIter};
    fullPath = sprintf('%s/qseg@p07def/data/%05d.mat', seg_path, segInd);
    segStruct = load(fullPath);
    if (pathsIter == 3)
        if (length(segStruct.segs) < 20)
            continue;
        end
    end
    all_segs = [all_segs segStruct];
end

% Initialize the variables
Iseg = zeros(size(orgImg));
[x, y, z] = size(orgImg);
map = zeros(x, y);

% Mix segmentations
[map] = mix_segmentations_rec(map, orgImg, all_segs, find(map >= 0), ...
    length(all_segs));

% Build segmented image
[Iseg, map] = createSegImage(orgImg, map);

end

%% Function: mix_segmentations_rec
% - This is a recursive function that mixes the segmentation.
% - The variable segsCount will ensure that the segment will exist in at
% least one segmentation.
function [map] = mix_segmentations_rec(map, orgImg, all_segs, ...
    reqSegIndices, segsCount)
    
    debug = 1;
    if debug
        visualize_segregion(reqSegIndices, orgImg);
        pause
    end

    % No indices to color
    if(isempty(reqSegIndices) || isempty(all_segs))
        map(reqSegIndices) = max(map(:)) + 1;
        return;
    end
    
    % Check if criteria is fullfilled and the segment exists in at least
    % one segmentation.
    if(length(all_segs) < segsCount && isValid_Outlier(orgImg, reqSegIndices))
        map(reqSegIndices) = max(map(:)) + 1;
        return;
    end

    maxSegInd = -1;
    allMaxV = -1;
    allMaxI = [];

    % Get the segmentation having the largest segment
    for segInd = 1:length(all_segs)

        curr_seg = all_segs(segInd);
        curr_map = curr_seg.map;
        [V countV] = count_unique(curr_map(reqSegIndices));
        [maxV sI] = max(countV);

        maxV = maxV(1);
        
        % The region should be the intersection of reqSegIndices and the
        % same region
        tAllMaxI = (curr_map == V(sI(1)));
        tAllI = false(size(curr_map));
        tAllI(reqSegIndices) = true;
        interI = (tAllI & tAllMaxI);
        maxI = find(interI == true);

        if (maxV > allMaxV)
            maxSegInd = segInd;
            allMaxV = maxV;
            allMaxI = maxI;
        end

    end

    % Try to segment this segment using the other segmentations
    map = mix_segmentations_rec(map, orgImg, ...
        all_segs([1:maxSegInd-1 maxSegInd+1:end]), allMaxI, segsCount);

    reqSegIndices = reqSegIndices(~ismember(reqSegIndices, allMaxI));

    % Segment the rest of the image
    map = mix_segmentations_rec(map, orgImg, all_segs, reqSegIndices, ...
        segsCount);

end

%% Function: isValid_Outlier. Checks valid segmentation using outliers.
function [valid] = isValid_Outlier(orgImg, reqSegIndices)
    if(length(reqSegIndices) <= 50)
        valid = 1;
        return;
    end
    
    [x, y, z] = size(orgImg);
    mn = []; md = [];
    for i = 1:z
        chVals = double(orgImg(reqSegIndices + (i - 1) * x * y));
        
%         nboot = 1;
%         jbtest
%         [dip, p] = HartigansDipSignifTest(chVals, nboot);
        
%         [h p] = jbtest(chVals, 0.001);
% %         p
%         if (p < 0.01)
%             valid = 0;
%             return;
%         else
%             continue;
%         end
        
        mn = mean(chVals);
        st = std(chVals);
        
        chVals = abs(chVals - mn) / st;
        ratio = sum(chVals > 3) / length(chVals);
        if (ratio > 0.05)
            valid = 0;
%             disp(['0 - ' num2str(ratio) ' - ' num2str(dip) ' ' num2str(p)]);
            return;
        else
%             disp(['1 - ' num2str(ratio) ' ' num2str(dip) ' ' num2str(p)]);
        end
        
    end

    valid = 1;
end

%% Function: isValid_RAD. Checks valid segmentation using RAD.
function [valid] = isValid_RAD(orgImg, reqSegIndices)

tempImg = orgImg;
tempImg(:) = NaN;

[x, y, z] = size(orgImg);

tempImg(reqSegIndices) = orgImg(reqSegIndices);
tempImg(reqSegIndices + x*y) = orgImg(reqSegIndices + x*y);
tempImg(reqSegIndices + 2*x*y) = orgImg(reqSegIndices + 2*x*y);

seg = RAD(2,0.01,3,80,tempImg,1);
ch1 = seg(:, :, 1);
unq = length(unique(ch1));

if (unq > 2)
    valid = 0;
else
    valid = 1;
end

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

%% Function: isValid_Oppseg. Checks valid segmentations using opposite seg.
%            method.
%  Example: If I use an edge based method it uses a color based and vice
%          versa.
function [valid] = isValid_Oppseg(orgImg, reqSegIndices, prevSeg)
    if(length(reqSegIndices) <= 50)
        valid = 1;
        return;
    end
    
    if(strcmp(prevSeg, 'none') ~= 0)
        valid = 0;
        return;
    end
    
    if(strcmp(prevSeg, 'mean-shift') ~= 0) % Color based, compare with edge based
        
        [x, y, z] = size(orgImg);
        
        bw = zeros(x, y);
        bw(reqSegIndices) = 1;
        
        props = regionprops(bw, 'BoundingBox');
        
        if(length(props) > 1)
            valid = 0;
            return;
        end
        
        BB = props.BoundingBox;
        segIm = orgImg(ceil(BB(2)):floor((BB(2) + BB(4))), ceil(BB(1)):floor((BB(1) + BB(3))), :);
        [Iseg map] = graphSeg(segIm, 0.5, 50, 2, 0);
        [countsVals counts] = count_unique(map(:));
        maxCount = max(counts);
        
        % If more than 90% of the segment was segmented in another
        % segmentation
        if (maxCount / length(reqSegIndices) >= 0.75)
            valid = 1;
            return;
        end
        
        valid = 0;
        
        
    else % Edge based, compare with color based
        
        [x, y, z] = size(orgImg);
        
        bw = zeros(x, y);
        bw(reqSegIndices) = 1;
        
        props = regionprops(bw, 'BoundingBox');
        
        if(length(props) > 1)
            valid = 0;
            return;
        end
        
        BB = props.BoundingBox;
        segIm = orgImg(ceil(BB(2)):floor((BB(2) + BB(4))), ceil(BB(1)):floor((BB(1) + BB(3))), :);
        [Iseg map] = msseg(segIm, 11, 8, 40);
        [countsVals counts] = count_unique(map(:));
        maxCount = max(counts);
        
        % If more than 90% of the segment was segmented in another
        % segmentation
        if (maxCount / length(reqSegIndices) >= 0.75)
            valid = 1;
            return;
        end
        
        valid = 0;
        
    end
end




