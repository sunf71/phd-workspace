function all_hist=Do_assignment_pyramids_marcin_par(opts,assignment_opts,start_images, end_images,vocabulary)

%% load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
%  nimages=21294;
load(opts.data_locations);
 vocabulary_size=size(vocabulary,1);
 vocabulary_size=4000;
 %%%%%%%%%% Load the indexes as i will use compressed vocabulary %%%%%%%%%%%%%%%
 index_list0=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
%% apply assignment method to data set and build pyramid
Levels  = 2;
maxBins = 2^(Levels-1);

BOW= [];

for ii=start_images:end_images
%     image_dir    = sprintf('%s/%s/',opts.localdatapath,num2string(ii,3));  % location where detector is saved
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
     %%%%%%%% added specially becaz i use 3 different detectors 
    points=[];
% % %%%%%%%%% for multiple detectors
        points_out1=load([data_locations{ii},'/',assignment_opts.detector_name]);
        points_out1 = getfield(points_out1,'detector_points');
%         
%          points=points_out1;
        points_out2=load([data_locations{ii},'/',assignment_opts.detector_name2]);
        points_out2 = getfield(points_out2,'detector_points');
        
        points_out3=load([data_locations{ii},'/',assignment_opts.detector_name3]);
        points_out3 = getfield(points_out3,'detector_points');
        
        points_out4=load([data_locations{ii},'/',assignment_opts.detector_name4]);
        points_out4 = getfield(points_out4,'detector_points');
        
         points_out5=load([data_locations{ii},'/',assignment_opts.detector_name5]);
         points_out5 = getfield(points_out5,'detector_points');
%         
        points=[points_out1(:,1:3);points_out2;points_out3(:,1:3);points_out4;points_out5];


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
   
     BOW(:,ii - start_images + 1) = [pyramidl2_w pyramidl1_w pyramidl0_w ];
    
%     BOW(:,ii) = [pyramid hist(index,(1:vocabulary_size))./(length(index)*0.5)];
    
%     assignments = [pyramidl2_w pyramidl1_w pyramidl0_w ];
%     save ([data_locations{ii},'/',assignment_opts.name],'assignments');
%     Bow=1;

end
all_hist=BOW;


