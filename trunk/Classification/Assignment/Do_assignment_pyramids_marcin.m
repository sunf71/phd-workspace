function all_hist=Do_assignment_pyramids_marcin(opts,assignment_opts)
% assign feature points to visual vocabulary
% input:
%           opts                            : contains information about data set
%           assignment_opts                 : contains information about assignment method
%           assignment_opts.type            : the asssignment method which
%           is used
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

%% load data set information and vocabulary
load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;

index_list0=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
vocabulary_size=assignment_opts.vocabulary_size;
dictionarySize=vocabulary_size;

% vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
% vocabulary_size=size(vocabulary,1);

%% apply assignment method to data set and build pyramid
Levels  = 2;
maxBins = 2^(Levels-1);

BOW=[];
h = waitbar(0,'Please wait...');
for ii=1:nimages    
    ii
    
    %%%%%%%%%%%%% if one detector used
    points_out_har=load([data_locations{ii},'/',assignment_opts.detector_name]);
    points_har = getfield(points_out_har,'detector_points');
    points=points_har;

%%%%%%%%%%%% if combination of detectors %%%%%%%
%     points_out_har=load([data_locations{ii},'/',assignment_opts.detector_name]);
%     points_har = getfield(points_out_har,'detector_points');
%     points_out_dog_dorko=load([data_locations{ii},'/',assignment_opts.detector_name2]);
%     points_dog_dorko = getfield(points_out_dog_dorko,'detector_points');
%     points_dog_dorko=[points_dog_dorko,zeros(size(points_dog_dorko,1),1)];
%     points_out_grid_dorko=load([data_locations{ii},'/',assignment_opts.detector_name3]);
%     points_grid_dorko = getfield(points_out_grid_dorko,'detector_points');
%     points=[points_har;points_dog_dorko;points_grid_dorko];
    
    %%%%%%%%%%% also load descriptor 
%     points_out=load([data_locations{ii},'/',assignment_opts.descriptor_name]);
%     descriptors = getfield(points_out,'descriptor_points'); 

    
%     [minz index] = min(distance(descriptors,vocabulary),[],2);
index=index_list0{ii};
    
    %%%%%%%%% read the image
    imageread=imread(sprintf('%s/%s',opts.imgpath,image_names{ii}));
    [m n p]      = size(imageread);
    
    pyramidl2      = [];
    nbars = 3;
     % construct horizontal bars
    for bi=1:nbars
        % determine bin coordinates
        x_lo = 0; x_hi = n;
        y_lo = floor(m/nbars*(bi-1)); y_hi = floor(m/nbars*bi);

        bin_indices = index((points(:,1) > x_lo) & (points(:,1) <= x_hi) & ...
            (points(:,2) > y_lo) & (points(:,2) <= y_hi));

        pyramidl2 = [pyramidl2 hist(bin_indices, 1:vocabulary_size)./length(index)];
        
    end
    %level2 weigthing
    pyramidl2_w=[pyramidl2.*0.5];
    
    %level1
    pyramidl1     = [];
    for bi=1:maxBins
        for bj=1:maxBins
            % determine bin coordinates
            x_lo = floor(n/maxBins * (bi-1)); x_hi = floor(n/maxBins * bi);
            y_lo = floor(m/maxBins * (bj-1)); y_hi = floor(m/maxBins * bj);

            bin_indices = index((points(:,1) > x_lo) & (points(:,1) <= x_hi) & ...
                (points(:,2) > y_lo) & (points(:,2) <= y_hi));
            
            pyramidl1 = [pyramidl1 hist(bin_indices, 1:vocabulary_size)./length(index)];
        end
    end
   %level 1 weighting
        pyramidl1_w = [pyramidl1.*0.25 ]; 
    %level0 
    pyramidl0=hist(index,(1:vocabulary_size))./length(index);%level0   
    
    %level 0 weighting
        pyramidl0_w = [pyramidl0.*0.25 ];  
   
    BOW(:,ii) = [pyramidl2_w pyramidl1_w pyramidl0_w ];
    %BOW(:,ii) = [pyramid hist(index,(1:vocabulary_size))./(length(index)*0.5)];
    waitbar(ii/nimages,h);
end

close(h);

all_hist=BOW;