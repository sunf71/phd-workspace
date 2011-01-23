function [all_hist,index_list]=do_assign_range_normal_plus_ikmeans(opts,assignment_opts,start_images, end_images,voc)
load(opts.image_names);
load(opts.data_locations);
all_hist = zeros(assignment_opts.vocabulary_size, (end_images-start_images)+1);

%%%%%%%%% for integer kmeans vocabulary only %%%%%%
       voc=double(voc');
for i=start_images:end_images
        points_out=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
        points = getfield(points_out,'descriptor_points');

%%%%%%%%%%%% for multiple detectors %%%%%%%%%%%
%  points=[];
% % %%%%%%%%% for multiple detectors
%         points_out1=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%         points_out1 = getfield(points_out1,'descriptor_points');
%         
%         points_out2=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
%         points_out2 = getfield(points_out2,'descriptor_points');
%         
%         points_out3=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
%         points_out3 = getfield(points_out3,'descriptor_points');
%         
%         points_out4=load([data_locations{i},'/',assignment_opts.descriptor_name4]);
%         points_out4 = getfield(points_out4,'descriptor_points');
%         
%         points_out5=load([data_locations{i},'/',assignment_opts.descriptor_name5]);
%         points_out5 = getfield(points_out5,'descriptor_points');
%         
%         points=[points_out1;points_out2;points_out3;points_out4;points_out5];

          points=im2uint8(points); %%% checking for integer K means
          points=double(points);   %%% checking for integer K means
        
       
        dist=distance(points,voc);
        dist2=-(dist.*dist)/( 2*assignment_opts.soft_assign^2);
        max_dist2=max(dist2,[],2);
        BB=exp(dist2-repmat(max_dist2,1,size(dist2,2)));
        BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
        all_hist(:,i - start_images + 1)=sum(BB,1);
                  
        min_val=min(BB(:));
        assignments=zeros(size(BB,1),2*assignment_opts.nn_neighbours_file);
              for kk=1:assignment_opts.nn_neighbours_file
                 [max1,max2]=max(BB,[],2);
                 assignments(:,kk)=max2;
                 assignments(:,kk+assignment_opts.nn_neighbours_file)=max1;                      
                 BB( (max2-1)*size(BB,1)+(1:size(BB,1) )' )=min_val;
              end
      
        %%%% SAVE ASSIGNMENTS TO IMAGES
        assignments(:,assignment_opts.nn_neighbours_file+1:assignment_opts.nn_neighbours_file*2)=normalize(assignments(:,assignment_opts.nn_neighbours_file+1:assignment_opts.nn_neighbours_file*2),2);
        index_list{i - start_images + 1}=assignments;
        %%%%%%%%%%%%%%%%%%%%%%% for saving lampert like format , collect detetctors
%        det1=load([data_locations{i},'/',assignment_opts.detector_name]);
%        det_out_1 = getfield(det1,'detector_points');
        
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
        
%         assignments=[det_points_final,assignments]; 
           save ([data_locations{i},'/',assignment_opts.name,'_hybrid_index'],'assignments');
                 
      
      
      
end
