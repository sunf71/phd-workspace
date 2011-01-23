function [all_hist,index_list]=do_assign_range_llc(opts,assignment_opts,start_images, end_images,voc)
load(opts.image_names);
load(opts.data_locations);
all_hist = zeros(assignment_opts.vocabulary_size*21, (end_images-start_images)+1);
% voc=double(voc');
%%%%%%%%% for integer kmeans vocabulary only %%%%%%
%       voc=double(voc');
counter=1;
for i=start_images:end_images
    
 %%   %%%%%%%%%%%%%%%% For Single detector and descriptor %%%%%%%%%%%%%%%%
%       pyramid = [1, 2, 4]; % spatial block number on each level of the pyramid
%                   weights = [1, 1, 1];
% %                    pyramid = [1];
% %                    weights = [1];
%                    gamma = 0.15;
%                    beta = 1e-3; % a small regularization for stablizing sparse coding
%                    pooling = 'max'; % 'energy', 'absolute', 'max'
%                    load(opts.image_names);
%                    
%                    points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%                    points = getfield(points_out,'descriptor_points');
%                    
%                    %%%%%%%%% detection points 
%                    points_out_det=load([data_locations{i},'/',assignment_opts.detector_name]);
%                    points_det = getfield(points_out_det,'detector_points');
%                    points_det_total=points_det(:,1:3);         
%                    im=sprintf('%s/%s',opts.imgpath,image_names{i});
%                    im=imread(im);
%                    [width height]=size(im);
% 
%                    feature_struct.feaArr=points';
%                    feature_struct.x=points_det_total(:,1);
%                    feature_struct.y=points_det_total(:,2);
%                    feature_struct.width=width;
%                    feature_struct.height=height;
%                   knn=7;
%                    %%%%%%%%%%%%%%%%%%% Do the sparse assignment %%%%%
% %                    All_hist(:,counter) = ScSPM_new(feature_struct,vocabulary, gamma, pyramid, weights, pooling);
%                      all_hist(:,i - start_images + 1) =  LLC_pooling(feature_struct,voc', pyramid, knn);
% %                      fea = LLC_pooling(feaSet, B, pyramid, knn);
%                    counter=counter+1;
%                    index_list=1;

                   
                   
 %%     %%%%%%%%%%%%%%%%%%%% for 5 detectors and descriptors %%%%%%%%%%%%%%%
      pyramid = [1, 2, 4]; % spatial block number on each level of the pyramid
                  weights = [1, 1, 1];
%                    pyramid = [1];
%                    weights = [1];
                   gamma = 0.15;
                   beta = 1e-3; % a small regularization for stablizing sparse coding
                   pooling = 'max'; % 'energy', 'absolute', 'max'
                   load(opts.image_names);
                   
                    %%%%%%%%%%%% for multiple detectors %%%%%%%%%%%
         points=[];
        % %%%%%%%%% for multiple detectors
               points_out1=load([data_locations{i},'/',assignment_opts.descriptor_name]);
               points_out1 = getfield(points_out1,'descriptor_points');

               points_out2=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
               points_out2 = getfield(points_out2,'descriptor_points');

               points_out3=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
               points_out3 = getfield(points_out3,'descriptor_points');

               points_out4=load([data_locations{i},'/',assignment_opts.descriptor_name4]);
               points_out4 = getfield(points_out4,'descriptor_points');

               points_out5=load([data_locations{i},'/',assignment_opts.descriptor_name5]);
               points_out5 = getfield(points_out5,'descriptor_points');

               points=[points_out1;points_out2;points_out3;points_out4;points_out5];
        
    %%%%%%%%%%% collect the different detected points %%%%
               points_out=load([data_locations{i},'/',assignment_opts.detector_name]);
               points_det1 = getfield(points_out,'detector_points');
                    
               points_out=load([data_locations{i},'/',assignment_opts.detector_name2]);
               points_det2 = getfield(points_out,'detector_points');

               points_out=load([data_locations{i},'/',assignment_opts.detector_name3]);
               points_det3 = getfield(points_out,'detector_points');
               
               points_out=load([data_locations{i},'/',assignment_opts.detector_name4]);
               points_det4 = getfield(points_out,'detector_points');
               
               points_out=load([data_locations{i},'/',assignment_opts.detector_name5]);
               points_det5 = getfield(points_out,'detector_points');

               points_det_total=[points_det1(:,1:2);points_det2(:,1:2);points_det3(:,1:2);points_det4(:,1:2);points_det5(:,1:2)];
               im=sprintf('%s/%s',opts.imgpath,image_names{i});
                   im=imread(im);
                   [width height]=size(im);

                   feature_struct.feaArr=points';
                   feature_struct.x=points_det_total(:,1);
                   feature_struct.y=points_det_total(:,2);
                   feature_struct.width=width;
                   feature_struct.height=height;
                  knn=5;
                   %%%%%%%%%%%%%%%%%%% Do the sparse assignment %%%%%
%                    All_hist(:,counter) = ScSPM_new(feature_struct,vocabulary, gamma, pyramid, weights, pooling);
%                      all_hist(:,i - start_images + 1) =  LLC_pooling(feature_struct,voc', pyramid, knn);
                      assignments =  LLC_pooling(feature_struct,voc', pyramid, knn);
%                      fea = LLC_pooling(feaSet, B, pyramid, knn);
                   counter=counter+1;
                   index_list=1;
%       all_hist=1;
       save ([data_locations{i},'/',assignment_opts.name],'assignments');
end
