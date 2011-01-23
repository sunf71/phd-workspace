function []=Do_assignment_pyramids_marcin(opts,assignment_opts,descriptor_opts)
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

%% load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
vocabulary=getfield(load([opts.globaldatapath,'/',assignment_opts.vocabulary_name]),'voc');
vocabulary_size=size(vocabulary,1);

%% apply assignment method to data set and build pyramid
Levels  = 2;
maxBins = 2^(Levels-1);

BOW=[];
h = waitbar(0,'Please wait...');
for ii=1:nimages    ii
    image_dir    = sprintf('%s/%s/',opts.localdatapath,num2string(ii,3));  % location where detector is saved
    %%%%%%%%%FPLBP Patch expirements%%%%%%%%
%     detect_opts.type='lbp_grid';
    %%%%%%%%%%%%%%%%CSLBP%%%%%%%%%%%%%%%%%%%%%%%%%%%
    detect_opts.type='cslbp_grid';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    detect_opts.name=['DET',detect_opts.type];
    points_struct=load([image_dir,'/',detect_opts.name],'points');
    points=points_struct.points;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    %points       = getfield(load([image_dir,descriptor_opts.detector_name]),'points');
    descriptors  = getfield(load([image_dir,assignment_opts.descriptor_name]),'descriptors');
    [minz index] = min(distance(descriptors,vocabulary),[],2);
    [m n p]      = size(read_image_db(opts,ii));
    
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

% BOW = normalize(BOW,1);                                                                    % normalize the BOW histograms to sum-up to one.
save ([opts.globaldatapath,'/',assignment_opts.name],'BOW');                               % save the BOW representation in opts.globaldatapath
save ([opts.globaldatapath,'/',assignment_opts.name,'_settings'],'assignment_opts');