function All_hist=Do_assignment_pyramids_lazebnik_par(opts,assignment_opts,start_images, end_images,vocabulary)




display('Computing Pyramids Started !!!!!!');
%% load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
load(opts.data_locations);

%vocabulary_size=size(vocabulary,1);
vocabulary_size=assignment_opts.vocabulary_size;
vocabulary_size=500;
index_list0=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
%% parameters(levels starts with L1)
pyramidLevels=assignment_opts.level;
Levels=pyramidLevels;
maxBins = 2^(Levels-1);binsHigh=maxBins;
BOW=[];pyramid_all = [];

%% apply assignment method to data set and build pyramid     
h = waitbar(0,'Please wait...');

for ii=start_images:end_images
    points=[];
% % %%%%%%%%% for multiple detectors
        points_out1=load([data_locations{ii},'/',assignment_opts.detector_name]);
        points_out1 = getfield(points_out1,'detector_points');
         points=points_out1;
%         
%         points_out2=load([data_locations{ii},'/',assignment_opts.detector_name2]);
%         points_out2 = getfield(points_out2,'detector_points');
%         
%         points_out3=load([data_locations{ii},'/',assignment_opts.detector_name3]);
%         points_out3 = getfield(points_out3,'detector_points');
%         
%         points_out4=load([data_locations{ii},'/',assignment_opts.detector_name4]);
%         points_out4 = getfield(points_out4,'detector_points');
%         
%         points_out5=load([data_locations{ii},'/',assignment_opts.detector_name5]);
%         points_out5 = getfield(points_out5,'detector_points');
%         
%         points=[points_out1(:,1:3);points_out2;points_out3(:,1:3);points_out4;points_out5];

        
        index=index_list0{ii};
        imageread=imread(sprintf('%s/%s',opts.imgpath,image_names{ii}));
         [m n p]      = size(imageread);

%     %%%%%%%%%%% also load descriptor 
%     points_out=load([data_locations{ii},'/',assignment_opts.descriptor_name]);
%     descriptors = getfield(points_out,'descriptor_points'); 
    
    %%%%%%%% end added code by me
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     image_dir    = sprintf('%s/%s',opts.imgpath,image_names{ii});                    % location where detector is saved
%     points       = getfield(load([image_dir,descriptor_opts.detector_name]),'points');
%     descriptors  = getfield(load([image_dir,assignment_opts.descriptor_name]),'descriptors');
%     [minz index] = min(distance(descriptors,vocabulary),[],2);
%     imageread=imread(image_names{ii});
%     [m n p]      = size(imageread);
%% get width and height of input image
texton_ind.x=points(:,1);     
texton_ind.y=points(:,2);
texton_ind.data=index;
hgt=m; wid=n;   
%% compute histogram at the finest level
    pyramid_cell = cell(pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, vocabulary_size);
 for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(wid/binsHigh * (i-1));
            x_hi = floor(wid/binsHigh * i);
            y_lo = floor(hgt/binsHigh * (j-1));
            y_hi = floor(hgt/binsHigh * j);
            
              texton_patch = index((points(:,1) > x_lo) & (points(:,1) <= x_hi) & ...
                (points(:,2) > y_lo) & (points(:,2) <= y_hi));
                   
%             texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...
%                                             (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));
             
            % make histogram of features in bin
            %pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(texton_ind.data);
             pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:vocabulary_size)./length(index);
        end
    end

    %% compute histograms at the coarser levels
    num_bins = binsHigh/2;
    for l = 2:pyramidLevels
        pyramid_cell{l} = zeros(num_bins, num_bins, vocabulary_size);
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
   % BOW(:,ii) =pyramid_all';
    waitbar(ii/nimages,h);
end
BOW =pyramid_all';
close(h);
All_hist=BOW;
                                                                % normalize the BOW histograms to sum-up to one.
