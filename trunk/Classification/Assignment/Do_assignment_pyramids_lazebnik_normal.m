function All_hist=Do_assignment_pyramids_lazebnik_normal(opts,assignment_opts)
% assign feature points to visual vocabulary
% input:
%           opts                            : contains information about data set
%           assignment_opts                 : contains information about assignment method
%           assignment_opts.type            : the asssignment method which is used
%           assignment_opts.descriptor_name : name of vocabulary  (voc)
%           assignment_opts.vocabulary_name : name of descriptors (input)

% if no settings available use default settings
if ~isfield(assignment_opts,'type');               assignment_opts.type='1nn';                     end
if ~isfield(assignment_opts,'vocabulary_name');    assignment_opts.vocabulary_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name');    assignment_opts.descriptor_name='Unknown';      end
if ~isfield(assignment_opts,'name');               assignment_opts.name=strcat(assignment_opts.type,assignment_opts.vocabulary_name); end

%% check if assignment already exists
try
    assignment_opts2=getfield(load([opts.globaldatapath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts,assignment_opts2))
        display('Recomputing assignments for these settings');
    else
        display('Overwriting assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end
display('Computing Pyramids Started !!!!!!');
%% load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
load(opts.data_locations);
% vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
index_list0=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
vocabulary_size=assignment_opts.vocabulary_size;
dictionarySize=vocabulary_size;
%% parameters(levels starts with L1)
pyramidLevels=assignment_opts.level;
Levels=pyramidLevels;
maxBins = 2^(Levels-1);binsHigh=maxBins;
BOW=[];pyramid_all = [];

%% apply assignment method to data set and build pyramid     
h = waitbar(0,'Please wait...');
%14597:14597
for ii=1:nimages
   
    ii
    %%%%%%%% added specially becaz i use 3 different detectors 
    points_out_har=load([data_locations{ii},'/',assignment_opts.detector_name]);
    points = getfield(points_out_har,'detector_points');

%     points_out123=load([data_locations{ii},'/','modified_points']);
%     points = getfield(points_out123,'detector_points');

    %%%%%%%%%%% also load descriptor 
    points_out=load([data_locations{ii},'/',assignment_opts.descriptor_name]);
    descriptors = getfield(points_out,'descriptor_points'); 
    
    %%%%%%%% end added code by me
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    image_dir    = sprintf('%s/%s',opts.imgpath,image_names{ii});                    % location where detector is saved
%     points       = getfield(load([image_dir,descriptor_opts.detector_name]),'points');
%     descriptors  = getfield(load([image_dir,assignment_opts.descriptor_name]),'descriptors');
%     [minz index] = min(distance(descriptors,vocabulary),[],2);
index=index_list0{ii};
    %%%%%%%%% read the image
    imageread=imread(sprintf('%s/%s',opts.imgpath,image_names{ii}));
    [m n p]      = size(imageread);
%% get width and height of input image
texton_ind.x=points(:,1);     
texton_ind.y=points(:,2);
texton_ind.data=index;
% hgt=m; wid=n;  
hgt=128; wid=64;  
%% compute histogram at the finest level
    pyramid_cell = cell(pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, dictionarySize);
 for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = 3+(floor(wid/binsHigh * (i-1)));
            x_hi = 3+(floor(wid/binsHigh * i));
            y_lo = 3+(floor(hgt/binsHigh * (j-1)));
            y_hi = 3+(floor(hgt/binsHigh * j));
            
              texton_patch = index((points(:,1) > x_lo) & (points(:,1) <= x_hi) & ...
                (points(:,2) > y_lo) & (points(:,2) <= y_hi));
                   
%             texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...
%                                             (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));
             
            % make histogram of features in bin
            %pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(texton_ind.data);
             pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(index);
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
   % BOW(:,ii) =pyramid_all';
    waitbar(ii/nimages,h);
end
BOW =pyramid_all';
close(h);
All_hist=BOW;
                                                                % normalize the BOW histograms to sum-up to one.
save ([opts.data_assignmentpath ,'/',assignment_opts.name],'All_hist');                               % save the BOW representation in opts.globaldatapath
save ([opts.data_assignmentpath ,'/',assignment_opts.name,'_settings'],'assignment_opts');