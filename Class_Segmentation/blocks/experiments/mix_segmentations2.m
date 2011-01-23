%% Function: mix_segmentations
function [Iseg, map] = mix_segmentations2(segInd)

% Get segmentations paths
segs_paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2', ...
                  '/home/amounir/Workspace/Superpixels-iccv2009/results/GB_AN_1', ...
                  '/home/amounir/Workspace/Superpixels-iccv2009/results/NCut_1');
              
% '/home/amounir/Workspace/Superpixels-iccv2009/results/RAD', ...

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
all_segs(1).technique = 'mean-shift';
all_segs(2).technique = 'graph-based';
% all_segs(3).technique = 'RAD';
all_segs(3).technique = 'normalized-cut';
[map] = mix_segmentations_iter(orgImg, all_segs, x, y);
% [map] = mix_segmentations_rec(map, orgImg, all_segs, find(map >= 0), 'none', all_segs);

% Build segmented image
[Iseg, map] = createSegImage(orgImg, map);

end

function [map] = mix_segmentations_iter(orgImg, all_segs, width, height)

    map = zeros(width, height);

    segsHeap = PQueue('Segment');

    maxes = [];
    segIndices = [];
    segIndIndices = [];

    for segmentationID = 1:length(all_segs)


        segmentation = all_segs(segmentationID);

        startInd = length(maxes + 1);

        maxes = [maxes zeros(1, length(segmentation.segs))];
        segIndices = [segIndices zeros(1, length(segmentation.segs))];
        segIndIndices = [segIndIndices zeros(1, length(segmentation.segs))];

        for segmentID = 1:length(segmentation.segs)
            maxes(startInd + segmentID) = length(segmentation.segs(segmentID).ind);
            segIndices(startInd + segmentID) = segmentationID;
            segIndIndices(startInd + segmentID) = segmentID;
        end

    end

    [maxes maxesInds] = sort(maxes, 'descend');
    segIndices = segIndices(maxesInds);
    segIndIndices = segIndIndices(maxesInds);

    currSeg = 1;
    while currSeg ~= length(maxes)
        
        if(isempty(map == 0))
            break;
        end

        seg = Segment(maxes(currSeg), ...
            all_segs(segIndices(currSeg)).segs(segIndIndices(currSeg)).ind, ...
            all_segs(segIndices(currSeg)).technique);
        currSeg = currSeg + 1;

        indices = seg.indices(ismember(seg.indices, find(map == 0)) == 1);
        if(isempty(indices))
            continue;
        end
        
        segsHeap.offer(Segment(length(indices), indices, seg.technique));

        seg = segsHeap.poll;
        indices = seg.indices(ismember(seg.indices, find(map == 0)) == 1);
        
        try

            while(isempty(indices))
                seg = segsHeap.poll;
                indices = seg.indices(ismember(seg.indices, find(map == 0)) == 1);
            end

        catch mexInfo
            display(mexInfo);
        end
        
        empty = false;

        try
            while(length(indices) >= maxes(currSeg))

                if(isValid_Oppseg(orgImg, indices, seg.technique, all_segs))
                    map(indices) = max(map(:)) + 1;
                end

                if(segsHeap.size == 0)
                    empty = true;
                    break;
                end

                seg = segsHeap.poll;
                indices = seg.indices(ismember(seg.indices, find(map == 0)) == 1);
                
                while(isempty(indices))
                    seg = segsHeap.poll;
                    indices = seg.indices(ismember(seg.indices, find(map == 0)) == 1);
                end

            end
        catch mexInfo
            display(mexInfo);
        end
        
        if(~empty)
            if(~isempty(indices))
                segsHeap.offer(Segment(length(indices), indices, seg.technique));
            end
        end
        
    end
    
    while segsHeap.size ~= 0
        seg = segsHeap.poll;
        indices = seg.indices(ismember(seg.indices, find(map == 0)) == 1);
        if (isempty(indices))
            continue;
        end
        
        if(isValid_Oppseg(orgImg, indices, seg.technique, all_segs))
            map(indices) = max(map(:)) + 1;
        end
    end
    
    [map] = mix_segmentations_rec(map, orgImg, all_segs, find(map == 0), 'none', all_segs);

end

%% Function: mix_segmentations_rec
% - This is a recursive function that mixes the segmentation.
% - The variable segsCount will ensure that the segment will exist in at
% least one segmentation.
function [map] = mix_segmentations_rec(map, orgImg, all_segs, ...
    reqSegIndices, prevSeg, org_segs)

    % No indices to color
    if(isempty(reqSegIndices) || isempty(all_segs))
        map(reqSegIndices) = max(map(:)) + 1;
        return;
    end
    
    % Check if criteria is fullfilled and the segment exists in at least
    % one segmentation.
    if(strcmp(prevSeg, 'none') == 0 && isValid_Oppseg(orgImg, reqSegIndices, prevSeg, org_segs))
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
        all_segs([1:maxSegInd-1 maxSegInd+1:end]), allMaxI, all_segs(maxSegInd).technique, org_segs);

    reqSegIndices = reqSegIndices(~ismember(reqSegIndices, allMaxI));

    % Segment the rest of the image
    map = mix_segmentations_rec(map, orgImg, all_segs, reqSegIndices, ...
        prevSeg, org_segs);

end

%% Function: isValid_Oppseg. Checks valid segmentations using opposite seg.
%            method.
%  Example: If I use an edge based method it uses a color based and vice
%          versa.
function [valid] = isValid_Oppseg(orgImg, reqSegIndices, prevSeg, all_segs)
    if(length(reqSegIndices) <= 50)
        valid = 1;
        return;
    end
    
    if(strcmp(prevSeg, 'none') ~= 0)
        valid = 0;
        return;
    end
    
    if(strcmp(prevSeg, 'mean-shift') ~= 0 || strcmp(prevSeg, 'RAD')) % Color based, compare with edge based
        
        [x, y, z] = size(orgImg);
        
        otherMap = [];
        
        for i = 1:length(all_segs)
            if(strcmp(all_segs(i).technique, 'graph-based') ~= 0)
                otherMap = all_segs(i).map;
            end
        end
        
        [countsVals counts] = count_unique(otherMap(reqSegIndices));
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
        
        otherMap = [];
        
        for i = 1:length(all_segs)
            if(strcmp(all_segs(i).technique, 'mean-shift') ~= 0)
                otherMap = all_segs(i).map;
            end
        end
        
        [countsVals counts] = count_unique(otherMap(reqSegIndices));
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

%% Function: isValid_Outlier. Checks valid segmentation using outliers.
function [valid] = isValid_Outlier(orgImg, reqSegIndices)
    if(length(reqSegIndices) <= 50)
        valid = 1;
        return;
    end
    
    [x, y, z] = size(orgImg);
    for i = 1:z
        chVals = double(orgImg(reqSegIndices + (i - 1) * x * y));
        
        mn = mean(chVals);
        st = std(chVals);
        
        chVals = abs(chVals - mn) / st;
        ratio = sum(chVals > 3) / length(chVals);
        if (ratio > 0.01)
            valid = 0;
            return;
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

seg = RAD(2,1,3,80,tempImg,1);
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





