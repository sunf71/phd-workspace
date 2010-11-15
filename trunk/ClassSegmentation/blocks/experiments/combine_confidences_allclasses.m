%% Pascal 2007

function combine_confidences_allclasses(maskFrom, maskTo)

indices = load('/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/all_images_indices.mat');

conmap_paths = char('/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/MixedWithRAD', ...
                    '/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/MS_Parallelized_2', ...
                    '/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/GB_AN_1', ...
                    '/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/MixedWithOutliers', ...
                    '/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/NCut_1');
                
superpixels_path = '/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/results/Original_Method_Parallelized/qseg@p07def/data';

conmap_paths = cellstr(conmap_paths);

% The prefixes for the confidence folder name
namep1 = 'testcrf@p07_p07dsift3_m_';
namep2 = '_250_svm_gridsearch';

neigh_bests = [0 0; 0 0; 0 0; 0 0; 0 0];

all_paths = [];

for pathsIter = 1:length(conmap_paths)
    for neigh = 1:2
        path = sprintf('%s/%s%d%s/%s', conmap_paths{pathsIter}, namep1, ...
            neigh_bests(pathsIter, neigh), namep2, 'data');
        
        if (size(all_paths, 1) == 0)
            all_paths = [path];
        else
            all_paths = char(all_paths, path);
        end
    end
end

all_paths = cellstr(all_paths);
all_paths_len = length(all_paths);

cd('/home/amounir')
mkdir('Final_ISA');
cd('Final_ISA');
system('chmod -R a+wrx .');

len = bitshift(1, length(all_paths)) - 1;
for mask = maskFrom:maskTo
    
    tic;
    
    mkdir(sprintf('%07d', mask));
    cd(sprintf('%07d', mask));
    mkdir('Sum');
    mkdir('Max');
    mkdir('Votes');
    mkdir('SumCRF');
    mkdir('MaxCRF');
    mkdir('VotesCRF');
    system('chmod -R a+wrx .');

    if(exist('VotesCRF.mat', 'file') == 2)
%         cd('..');
%         continue;
    end
    
    fprintf('Processing (%d/%d)\n', mask - maskFrom + 1, maskTo - maskFrom + 1);
    
    iter_paths = [];
    for shft = 1:all_paths_len

        if (bitget(mask, shft) ~= 0)
            if (size(iter_paths, 1) == 0)
                iter_paths = [all_paths{shft}];
            else
                iter_paths = char(iter_paths, all_paths{shft});
            end
        end

    end
    
    iter_paths = cellstr(iter_paths);
    iter_paths_len = length(iter_paths);

    fprintf('Processing images...\n');
    
    for imgIter = 433:632
        
        close all;
        
        confSum = [];
        confMax = [];
        confVotes = [];
        orgImPath = sprintf('/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{imgIter});
        original_image = imread(orgImPath);
        imshow(original_image);
        figure;
        if (exist(sprintf('./VotesCRF/%05d.mat', imgIter), 'file') == 2)
            want_to_see = 0;
            if (want_to_see)
              close all;
              orgImPath = sprintf('/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{imgIter});
              original_image = imread(orgImPath);

              figure, imshow(original_image);

              cat_names ={...
                'aeroplane'
                'bicycle'
                'bird'
                'boat'
                'bottle'
                'bus'
                'car'
                'cat'
                'chair'
                'cow'
                'diningtable'
                'dog'
                'horse'
                'motorbike'
                'person'
                'pottedplant'
                'sheep'
                'sofa'
                'train'
                'tvmonitor'
                'background'};


              classVotesCRF = getfield(load(sprintf('./VotesCRF/%05d.mat', imgIter)),'class');
              figure, imshow(label2rgb(classVotesCRF));
              title('Votes CRF');
              drawnow;
              [x,y] = ginput;
              while size(x, 1) ~= 0
                  text(x, y, cat_names{classVotesCRF(floor(y(1)), floor(x(1)))});
                  [x,y] = ginput;
              end
              
              segs = {'Mean shift', 'Graph based', 'Normalized cut'};
              for seg = 2:4
                  classSeg = getfield(load(sprintf('%s/%05d.mat', iter_paths{seg}, imgIter)), 'class');
                  
                  imshow(label2rgb(classSeg));
                  title(segs{seg - 1});
                  drawnow;
                  [x,y] = ginput;
                  while size(x, 1) ~= 0
                      text(x, y, cat_names{classSeg(floor(y(1)), floor(x(1)))});
                      [x,y] = ginput;
                  end
              end

              close all;
            end
        end

        for pathIter = 1:iter_paths_len
            filename = sprintf('%s/%05d', iter_paths{pathIter}, imgIter);
            confidence = loadConf(filename);
            if (size(confSum, 1) == 0)
                confSum = confidence;
                confMax = confidence;
                confVotes = getVotes(confidence);
            else
                confSum = confSum + confidence;
                confMax = max(confMax, confidence);
                confVotes = confVotes + getVotes(confidence);
            end
        end

        [x, y, c] = size(confSum);

        % Superpixels segmentation path
        spSegPath = sprintf('%s/%05d.mat', superpixels_path, imgIter);

        classRS = reshape(confSum, x * y, c)';
        [vals, inds] = max(classRS);
        % We have to normalize the confidence of the sum
        confSumRS = classRS ./ (sum(classRS)' * ones(1, size(classRS, 1)))';
        confSum = reshape(confSumRS', x, y, c);
        classSum = reshape(inds, x, y);

        % Do CRF process for the classification based on sum
        classSumCRF = do_crf(spSegPath, classSum, confSum);
        

        classRS = reshape(confMax, x * y, c)';
        [vals, inds] = max(classRS);
        % We have to normalize the confidence of the max
        confMaxRS = classRS ./ (sum(classRS)' * ones(1, size(classRS, 1)))';
        confMax = reshape(confMaxRS', x, y, c);
        classMax = reshape(inds, x, y);
        
        % Do CRF process for the classification based on max
        classMaxCRF = do_crf(spSegPath, classMax, confMax);
        
        classRS = reshape(confVotes, x * y, c)';
        [vals, inds] = max(classRS);
        % We have to normalize the confidence of the votes
        confVotesRS = classRS ./ (sum(classRS)' * ones(1, size(classRS, 1)))';
        confVotes = reshape(confVotesRS', x, y, c);
        confVotes = updateConfVotes(confVotes, iter_paths, imgIter);
        classVotes = reshape(inds, x, y);
        
        for habala=1:21
            cat_names ={...
                'aeroplane'
                'bicycle'
                'bird'
                'boat'
                'bottle'
                'bus'
                'car'
                'cat'
                'chair'
                'cow'
                'diningtable'
                'dog'
                'horse'
                'motorbike'
                'person'
                'pottedplant'
                'sheep'
                'sofa'
                'train'
                'tvmonitor'
                'background'};
            imshow(confVotes(:,:,habala), []);
            title(cat_names{habala});
            colormap('jet');
            pause
        end
        
        % Do CRF process for the classification based on votes
        classVotesCRF = do_crf(spSegPath, classVotes, confVotes);

        output_folder = './Sum';
        file = sprintf('%s/%05d.mat', output_folder, imgIter);
        saveClassConf(file, classSum, confSum);
        
        output_folder = './SumCRF';
        file = sprintf('%s/%05d.mat', output_folder, imgIter);
        saveClassConf(file, classSumCRF, confSum);
        
        output_folder = './Max';
        file = sprintf('%s/%05d.mat', output_folder, imgIter);
        saveClassConf(file, classMax, confMax);
        
        output_folder = './MaxCRF';
        file = sprintf('%s/%05d.mat', output_folder, imgIter);
        saveClassConf(file, classMaxCRF, confMax);
        
        output_folder = './Votes';
        file = sprintf('%s/%05d.mat', output_folder, imgIter);
        saveClassConf(file, classVotes, confVotes);
        
        output_folder = './VotesCRF';
        file = sprintf('%s/%05d.mat', output_folder, imgIter);
        saveClassConf(file, classVotesCRF, confVotes);
        
        want_to_see = 0;
        if (want_to_see)
          close all;
          orgImPath = sprintf('/home/amounir/SRVFile//Workspace/Superpixels-iccv2009/VOCdevkit/VOC2007/JPEGImages/%s.jpg', indices.indices{imgIter});
          original_image = imread(orgImPath);

          figure, imshow(original_image);
          
          cat_names ={...
            'aeroplane'
            'bicycle'
            'bird'
            'boat'
            'bottle'
            'bus'
            'car'
            'cat'
            'chair'
            'cow'
            'diningtable'
            'dog'
            'horse'
            'motorbike'
            'person'
            'pottedplant'
            'sheep'
            'sofa'
            'train'
            'tvmonitor'
            'background'};
          
          figure, imshow(label2rgb(classSum));
          title('Sum');
          drawnow;
          [x,y] = ginput;
          while size(x, 1) ~= 0
              cat_names{classSum(floor(y(1)), floor(x(1)))}
              [x,y] = ginput;
          end
          
          imshow(label2rgb(classSumCRF));
          title('Sum CRF');
          drawnow;
          [x,y] = ginput;
          while size(x, 1) ~= 0
              cat_names{classSumCRF(floor(y(1)), floor(x(1)))}
              [x,y] = ginput;
          end
          
          imshow(label2rgb(classMax));
          title('Max');
          drawnow;
          [x,y] = ginput;
          while size(x, 1) ~= 0
              cat_names{classMax(floor(y(1)), floor(x(1)))}
              [x,y] = ginput;
          end
          
          imshow(label2rgb(classMaxCRF));
          title('Max CRF');
          drawnow;
          [x,y] = ginput;
          while size(x, 1) ~= 0
              cat_names{classMaxCRF(floor(y(1)), floor(x(1)))}
              [x,y] = ginput;
          end
          
          imshow(label2rgb(classVotes));
          title('Votes');
          drawnow;
          [x,y] = ginput;
          while size(x, 1) ~= 0
              cat_names{classVotes(floor(y(1)), floor(x(1)))}
              [x,y] = ginput;
          end
          
          figure, imshow(label2rgb(classVotesCRF));
          title('Votes CRF');
          drawnow;
          [x,y] = ginput;
          while size(x, 1) ~= 0
              text(x, y, cat_names{classVotesCRF(floor(y(1)), floor(x(1)))});
              [x,y] = ginput;
          end
          
          close all;
        end

        fprintf('  ** Processed (%03d/%d) images **\n', length(dir('./Votes/')) - 2, 210);

    end
    
    fprintf('  ==> Processed all images.\n');
    
    reportsBases = {'Sum', 'Max', 'Votes', 'SumCRF', 'MaxCRF', 'VotesCRF'};
    
    % Create all reports then delete the temp files.
    
    fprintf('Creating reports...\n');
    
    for repInd = 1:length(reportsBases)

        report = create_report(fullfile('.', reportsBases{repInd}));
        system(sprintf('rm -rf %s/', reportsBases{repInd}));
        saveReport([reportsBases{repInd} '.mat'], report)

    end
    
    fprintf('  ==> Created all reports.\n');
    

    toc;

    cd('..');
end

end

%% Save the report
function saveReport(repBase, report)
    save(repBase, '-STRUCT', 'report', '-MAT');
end

%% Update confidence from votes
function confVotes = updateConfVotes(confVotes, iter_paths, imgIter)
    [x y c] = size(confVotes);
    confVotesRS = reshape(confVotes, x*y, c);

    concatConfs = [];
    for pIter = 1:length(iter_paths)
        filename = sprintf('%s/%05d', iter_paths{pIter}, imgIter);
        conf = loadConf(filename);
        concatConfs = [concatConfs reshape(conf, x*y, c)];
    end
    
    [sortedV sortedVInds] = sort(confVotesRS', 'descend');
    [sortedC sortedCInds] = sort(concatConfs', 'descend');

    for i = 1:x*y

        sV = sortedV(:, i);
        sC = sortedC(:, i);
        sVI = sortedVInds(:, i);
        sCI = sortedCInds(:, i);

        currVI = 1;
        newconfs = zeros(1, length(sV));
        for j = 1:length(sC)
            if(currVI > length(sVI))
                continue;
            end
            
            sciInd = sCI(j);
            sciInd = mod(sciInd, length(sV));
            if (sciInd == 0)
                sciInd = length(sV);
            end

            if (sVI(currVI) == sciInd)
                newconfs(sVI(currVI)) = sC(j);
                currVI = currVI + 1;
            end
        end
        
        % And then normalize it
        newconfs = newconfs ./ sum(newconfs);
        confVotesRS(i, :) = newconfs;
        
    end
    
    confVotes = reshape(confVotesRS, x, y, c);
end

%% Prepare the parameters for the CRF
function classCRF = do_crf(segPath, class, confidence)

    % Prepare trained parameters
    params = struct();
    params.luv = 1;
    params.l_edge = 0.2680;
    
    load(segPath);
    
    % Build bounrdary
    boundary = boundarylen(double(map), length(segs));
    
    % Build seglabel and seg prob for unary parameter
    seglabel = zeros(length(segs), 1);
    segprob = zeros(21, length(segs));
    
    [x y z] = size(confidence);
    confidenceRS = reshape(confidence, x*y, z);
    for segInd = 1:length(segs)
        [uniques counts] = count_unique(class(segs(segInd).ind));
        [vals inds] = sort(counts, 'descend');
        
        bestInds = find(class(segs(segInd).ind) == uniques(inds(1)));

        % The probability is the mean of the confidences
        probs = mean(confidenceRS(segs(segInd).ind(bestInds), :));
        
        seglabel(segInd) = uniques(inds(1));
        segprob(:, segInd) = probs;
    end
    
    unary = -log(segprob);

    % Do the CRF process
    seglabel = seglabel - 1;
    newlabels = crfprocess(segs, seglabel, unary, params, boundary);
    newlabels = newlabels + 1;
    
    % Update the class segmentations
    classCRF = ones(size(class)) * 21;
    for segInd = 1:length(segs)
        classCRF(segs(segInd).ind) = newlabels(segInd);
    end
    
end

%% Update confidences using votations for locations
function votes = getVotes(confidence)

    [x, y, c] = size(confidence);
    confRS = reshape(confidence, x * y, c)';
    votesRS = confRS;
    
    [sorted sortedInd] = sort(confRS, 'descend');
    
    % - Indices represent the values for the votes. Position = 1/index
    % - Example: First element will take a value of 1/2
    % - In this representation we guarantee something like 1st and 4th is
    % worse than two seconds.
    indices = [2:22];
    
    [w h] = size(confRS);
    
    for i = 1:h
        votesRS(sortedInd(:, i), i) = 1 ./ indices;
    end
    
    votes = reshape(votesRS', x, y, c);
end

%% Parfor auxillaries
function conf = loadConf(filename)
    load(filename, 'confidence');
    conf = confidence;
end

function saveClassConf(filename, class, confidence)
    try
        save(filename, 'class', 'confidence', '-MAT');
    catch
    end
end
