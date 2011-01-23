function All_hist=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,m,n,x_lo,x_hi,y_lo,y_hi)

%% load data set information and vocabulary
% load(opts.image_names);
% nimages=opts.nimages;
% load(opts.data_locations);
vocabulary_size=assignment_opts.vocabulary_size;
dictionarySize=vocabulary_size;
%% parameters(levels starts with L1)
pyramidLevels=assignment_opts.level;
Levels=pyramidLevels;
maxBins = 2^(Levels-1);binsHigh=maxBins;
BOW=[];pyramid_all = [];
%% get width and height of input image
texton_ind.x=points(:,1);     
texton_ind.y=points(:,2);
texton_ind.data=index;
hgt=m; wid=n;   
%% Additional lines just to get the exact index number for each sub image for normalization
points2=points((points(:,1) > x_lo) & (points(:,1) <= x_hi) & ...
                (points(:,2) > y_lo) & (points(:,2) <= y_hi),:);

            
            
 texton_patch_index = index((points2(:,1) > x_lo) & (points2(:,1) <= x_hi) & ...
                (points2(:,2) > y_lo) & (points2(:,2) <= y_hi));

%% compute histogram at the finest level
    pyramid_cell = cell(pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, dictionarySize);
 for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(wid/binsHigh * (i-1));
            x_hi = floor(wid/binsHigh * i);
            y_lo = floor(hgt/binsHigh * (j-1));
            y_hi = floor(hgt/binsHigh * j);
            
              texton_patch = index((points2(:,1) > x_lo) & (points2(:,1) <= x_hi) & ...
                (points2(:,2) > y_lo) & (points2(:,2) <= y_hi));
  
%              pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(index);
               pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(texton_patch_index);
               
        end
    end


    %% compute histograms at the coarser levels
    num_bins = binsHigh/2;
    for l = 2:pyramidLevels
        pyramid_cell{l} = zeros(num_bins, num_bins, dictionarySize);
        for i=1:num_bins
            for j=1:num_bins
                pyramid_cell{l}(i,j,:) = ...
                pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
                pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
            end
        end
        num_bins = num_bins/2;
    end

    %% stack all the histograms with appropriate weights
    pyramid = [];
    for l = 1:pyramidLevels-1
        pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
    end
    pyramid = [pyramid pyramid_cell{pyramidLevels}(:)' .* 2^(1-pyramidLevels)];

    % save pyramid
    pyramid_all = [pyramid_all; pyramid];
    BOW=pyramid_all;

% end
BOW =pyramid_all';

All_hist=BOW;
                                                                % normalize the BOW histograms to sum-up to one.
% save ([opts.data_assignmentpath ,'/',assignment_opts.name],'All_hist');                               % save the BOW representation in opts.globaldatapath
% save ([opts.data_assignmentpath ,'/',assignment_opts.name,'_settings'],'assignment_opts');