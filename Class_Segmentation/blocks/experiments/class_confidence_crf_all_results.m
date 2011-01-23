%   - This script will classify every pixel and calculate the confidence
%     from all of the results.

%% Setting parameters values
paths = char('/home/amounir/Workspace/Superpixels-iccv2009/results/Original_Method_Parallelized/testcrf@p07_p07dsift3_m_0_250_svm_gridsearch/data', ...
         '/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_1/testcrf@p07_p07dsift3_m_0_250_svm_gridsearch/data', ...
         '/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2/testcrf@p07_p07dsift3_m_0_250_svm_gridsearch/data');

combinedResultsPath = '/home/amounir/Workspace/Superpixels-iccv2009/results/combined_result';
mkdir(combinedResultsPath);

paths = cellstr(paths);
numImages = 210;
imagesNums = (423:632);

% VOC 2007 Classes
% ----------------
% 1)  'aeroplane'
% 2)  'bicycle'
% 3)  'bird'
% 4)  'boat'
% 5)  'bottle'
% 6)  'bus'
% 7)  'car'
% 8)  'cat'
% 9)  'chair'
% 10) 'cow'
% 11) 'diningtable'
% 12) 'dog'
% 13) 'horse'
% 14) 'motorbike'
% 15) 'person'
% 16) 'pottedplant'
% 17) 'sheep'
% 18) 'sofa'
% 19) 'train'
% 20) 'tvmonitor'
% 21) 'background'

%% Get edges from gradient of confidences for every image then combine all
for imgInd = 1:numImages
    
  pathsCount = size(paths, 1);
  imageNum = imagesNums(imgInd);

  bw = []; % The edges of the confidence of every class

  gMagMax = []; % Maximum of gradient magnitude for confidence
  gMagMin = []; % Minimum of gradient magnitude for confidence
  gMagSum = []; % Average of gradient magnitude for confidence
  gMagPrd = []; % Product of gradient magnitude for confidence

  for pathInd = 2:pathsCount

    imgFile = sprintf('%s/%05d.mat', paths{pathInd}, imageNum);
    load(imgFile, 'class', 'confidence');

    if isempty(gMagMax)
      gMagMax = ones(size(confidence));
      gMagMin = ones(size(confidence));
      gMagSum = ones(size(confidence));
      gMagPrd = ones(size(confidence));
      
      % Intialize arrays
      gMagMax(1:end) = -1000000;
      gMagMin(1:end) =  1000000;
      gMagAvg(1:end) = 0;
      gMagPrd(1:end) = 1;
    end

    for classInd = 1:21
      
      % Calculate gradients and edges
      [tempBW, thr, gx, gy] = edge(confidence(:, :, classInd), 'sobel');
      
      % Calculate gradient magnitude
      gMag = sqrt(gx .^ 2 + gy .^ 2);

      % Calculate useful values for gradients
      gMagMax(:, :, classInd) = max(gMagMax(:, :, classInd) , gMag);
      gMagMin(:, :, classInd) = min(gMagMin(:, :, classInd) , gMag);
      gMagSum(:, :, classInd) = gMagSum(:, :, classInd) + gMag;
      gMagPrd(:, :, classInd) = gMagPrd(:, :, classInd) .* gMag;
      
    end

  end

  debug = 1;
  if debug
      
      for ind = 1:21
        
        subplot(221)
        imshow(gMagMax(:, :, ind), [])
        subplot(222)
        imshow(gMagMin(:, :, ind), [])
        subplot(223)
        imshow(gMagSum(:, :, ind), [])
        subplot(224)
        imshow(gMagPrd(:, :, ind), [])
        
        pause;
        close all;
      end
      
  end
    
  % Save results in the combined result folder
  save(fullfile(combinedResultsPath, sprintf('%05d.mat', imgInd)), ...
      'gMagMax', 'gMagMin', 'gMagSum', 'gMagPrd', '-MAT');
    
  % Display
  fprintf('Finished (%d / %d)\n', imgInd, numImages);

end

