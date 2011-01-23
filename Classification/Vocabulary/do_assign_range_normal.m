function [all_hist,index_list]=do_assign_range_normal(opts,assignment_opts,start_images, end_images,voc)
load(opts.image_names);
load(opts.data_locations);
all_hist = zeros(assignment_opts.vocabulary_size, (end_images-start_images)+1);
% voc=double(voc');
%%%%%%%%% for integer kmeans vocabulary only %%%%%%
%       voc=double(voc');
for i=start_images:end_images
%       points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%       points = getfield(points_out,'descriptor_points');
 
       
%           points=im2uint8(points); %%% checking for integer K means
%           points=double(points);   %%% checking for integer K means
%%%%%%%%%%%% for multiple detectors %%%%%%%%%%%
 points=[];
%%%%%%%%% for multiple detectors
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
%           points=[points_out1;points_out2;points_out3];

%         points=im2uint8(points); %%% checking for integer K means
%         points=double(points);   %%% checking for integer K means
        
      
        
        
      [minz index]=min(distance(points,voc),[],2);
      index_list{i - start_images + 1}=index(:,1);
      all_hist(:,i - start_images + 1)=hist(index,(1:assignment_opts.vocabulary_size));
      
      %%%%%%%%%%%%%%%% Additional step to compute lampert like format
        det1=load([data_locations{i},'/',assignment_opts.detector_name]);
        det_out_1 = getfield(det1,'detector_points');
%         
%         det2=load([data_locations{i},'/',assignment_opts.detector_name2]);
%         det_out_2 = getfield(det2,'detector_points');
%         
%         det3=load([data_locations{i},'/',assignment_opts.detector_name3]);
%         det_out_3 = getfield(det3,'detector_points');
%         
%         det4=load([data_locations{i},'/',assignment_opts.detector_name4]);
%         det_out_4 = getfield(det4,'detector_points');
%         
%         det5=load([data_locations{i},'/',assignment_opts.detector_name5]);
%         det_out_5 = getfield(det5,'detector_points');
%        
%         det_points_final=[det_out_1(:,1:3);det_out_2;det_out_3;det_out_4;det_out_5];
%         
%         assignments=[ det_out_1,index]; 
      
%         save ([data_locations{i},'/',assignment_opts.name,'_hybridindex'],'assignments');
       assignments=[];
end
