
segs_paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2', ...
                    '/home/amounir/Workspace/Superpixels-iccv2009/results/GB_AN_1', ...
                    '/home/amounir/Workspace/Superpixels-iccv2009/results/NCut_1', ...
                    '/home/amounir/Workspace/Superpixels-iccv2009/results/Original_Method_Parallelized', ...
                    '/home/amounir/Workspace/Superpixels-iccv2009/results/MixedWithOppseg', ...
                    '/home/amounir/Workspace/Superpixels-iccv2009/results/MixedWithRAD', ...
                    '/home/amounir/Workspace/Superpixels-iccv2009/results/MixedWithOutliers');
                
segs_paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2');
                
segs_paths = cellstr(segs_paths);


indices = load('/home/amounir/Workspace/Superpixels-iccv2009/results/all_images_indices.mat');

% figure;

titles = {'Mean shift', ...
          'Graph based', ...
          'Normalized Cut', ...
          'Superpixels', ...
          'Mixed with Oppseg', ...
          'Mixed with RAD', ...
          'Mixed with Outliers'};
      
titles = {'Mean shift', ...
};

for segInd = 1:632

    close all;
    fprintf('Segmentation # %d ...\n', segInd);
    
    % Show the original in the top left
%     showInd = 111;
    orgImPath = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{segInd});
    original_image = imread(orgImPath);
%     subplot(showInd);
    figure, imshow(original_image);
    title('Original image');
    
    % Start showing the segmentations
%     showInd = 111;
    for pathsIter = 1:length(segs_paths)
        seg_path = segs_paths(pathsIter);
        fullPath = sprintf('%s/qseg@p07def/data/%05d.mat', seg_path{1}, segInd);
        segStruct = load(fullPath);
        
        segsCount = length(segStruct.segs);
        segIm = segStruct.Iseg;
        
%         subplot(showInd);
        figure, imshow(segStruct.Iseg);
        figure, imshow(label2rgb(segStruct.map));
        title(sprintf('%s, Segs = %d', titles{pathsIter}, segsCount));
%         showInd = showInd + 1;
    end
    
    drawnow;

    pause;

end