
function All_hist=Do_assignment_pyramids_lazebnik_par3_3(opts,assignment_opts)

display('Computing Pyramids Started !!!!!!');
%% load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
load(opts.data_locations);
%vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
%vocabulary_size=1000;
vocabulary_size=4000;
assignment_opts.index_name='ikmeansSIFT_DorkoGrid_Dorko12000_aib4000_hybrid_index';
index_list0=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
%% parameters(levels starts with L1)
pyramidLevels=assignment_opts.level;
Levels=pyramidLevels;
maxBins = Levels;binsHigh=maxBins;
BOW=[];
%% apply assignment method to data set and build pyramid     
% h = waitbar(0,'Please wait...');
%for ii=start_images:end_images
no_levels=Levels*Levels+5;
BOW = zeros(no_levels*vocabulary_size, nimages);

tic;

parfor ii=1:nimages
    points=[];
% % %%%%%%%%% for multiple detectors
        points_out1=load([data_locations{ii},'/',assignment_opts.detector_name]);
        points_out1 = getfield(points_out1,'detector_points');
        
        points_out2=load([data_locations{ii},'/',assignment_opts.detector_name2]);
        points_out2 = getfield(points_out2,'detector_points');
        
        points_out3=load([data_locations{ii},'/',assignment_opts.detector_name3]);
        points_out3 = getfield(points_out3,'detector_points');
        
        points_out4=load([data_locations{ii},'/',assignment_opts.detector_name4]);
        points_out4 = getfield(points_out4,'detector_points');
        
        points_out5=load([data_locations{ii},'/',assignment_opts.detector_name5]);
        points_out5 = getfield(points_out5,'detector_points');
%         
        points=[points_out1(:,1:3);points_out2;points_out3;points_out4;points_out5];
        
        index=index_list0{ii};
        imageread=imread(sprintf('%s/%s',opts.imgpath,image_names{ii}));
         [m n p]      = size(imageread);

%% get width and height of input image
% texton_ind.x=points(:,1);     
% texton_ind.y=points(:,2);
% texton_ind.data=index;
hgt=m; wid=n;   
%% compute histogram at the finest level
    pyramid_cell = cell(pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, vocabulary_size);

%% level3 (9 cells)

index=index_list0{ii};pyramidl2 = [];
 for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(wid/binsHigh * (i-1));
            x_hi = floor(wid/binsHigh * i);
            y_lo = floor(hgt/binsHigh * (j-1));
            y_hi = floor(hgt/binsHigh * j);
            
              texton_patch = index((points(:,1) > x_lo) & (points(:,1) <= x_hi) & ...
                (points(:,2) > y_lo) & (points(:,2) <= y_hi));
             pyramidl2 = [pyramidl2 hist(texton_patch, 1:vocabulary_size)./length(index)];
        end
    end

%level2 weigthing
    pyramidl2_w=[pyramidl2.*0.5];

%level1
    Levels  = 2;
    maxBins=2^(Levels-1);
    pyramidl1=[];
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
    pyramidl0=hist(index,(1:vocabulary_size))./length(index);   
    
   %level 0 weighting
    pyramidl0_w = [pyramidl0.*0.25 ]; 
    
    fprintf('  ==> Finished Image %04d\n', ii);
    
   % save pyramid
    BOW(:,ii) = [pyramidl2_w pyramidl1_w pyramidl0_w];

end

toc;

All_hist=BOW;
%assignment_opts.name='ikmeansSIFT_DorkoGrid_Dorko12000_4000Noha3'
save ([opts.data_assignmentpath,'/',assignment_opts.name], '-v7.3','All_hist');
save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');
display('histogram saved.. press any key to continue')
pause