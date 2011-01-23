function []=Do_assignment12(opts,assignment_opts)
 %VOCINIT2009
% run Assignment on data set
if nargin<2
    assignment_opts=[];
end
display('Computing Assignments');
if ~isfield(assignment_opts,'LBP_flag');           assignment_opts.LBP_flag=0;                     end
if ~isfield(assignment_opts,'LBP_option');         assignment_opts.LBP_option='LBP';               end  %%% optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if ~isfield(assignment_opts,'type');               assignment_opts.type='hard';                    end
if ~isfield(assignment_opts,'vocabulary_name');    assignment_opts.vocabulary_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name');    assignment_opts.descriptor_name='Unknown';      end

if(assignment_opts.LBP_flag)
           if ~isfield(assignment_opts,'name');    assignment_opts.name=assignment_opts.LBP_option; end
else
           if ~isfield(assignment_opts,'name');    assignment_opts.name=strcat(assignment_opts.type,assignment_opts.vocabulary_name); end
end

%%% For Soft Assignment %%%%%%%%%
if(strcmp(assignment_opts.type,'soft'))
%            assignment_opts.soft_assign=0.08;
end

%%%%%%% The index flag for Hybrid Method %%%%%%%%%
if ~isfield(assignment_opts,'index_flag');         assignment_opts.index_flag=0;                     end

%if ~isfield(assignment_opts,'detector_type');      assignment_opts.detector_type='Grid';                                              end
%if ~isfield(assignment_opts,'descriptor_type');    assignment_opts.descriptor_type='SIFT';                                            end
%if ~isfield(assignment_opts,'vocabulary_type');    assignment_opts.vocabulary_type='Kmeans';                                          end
%if ~isfield(assignment_opts,'vocabulary_size');    assignment_opts.vocabulary_size=50;                                                end

try
    assignment_opts2=getfield(load([opts.data_assignmentpath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts,assignment_opts2))
        display('Recomputing assignments for this settings');
    else
        display('Overwriting assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end

load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;
% vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
% vocabulary_size=size(vocabulary,1);
All_hist=[];
counter=1;
h = waitbar(0,'Please wait...');
if(assignment_opts.LBP_flag)
        for i=1:nimages
             if (strcmp(assignment_opts.detector_option,'DoG'))
                 Do_LBP(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option);   
                 points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
                 points = getfield(points_out,'descriptor_points');
                 All_hist(:,counter)=points;
                 counter=counter+1;
                 waitbar(i/nimages,h);
                 
                 
             elseif (strcmp(assignment_opts.detector_option,'Grid'))
                 Do_LBP(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option);   
                 points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
                 points = getfield(points_out,'descriptor_points');
                 All_hist(:,counter)=points;
                 counter=counter+1;
                 waitbar(i/nimages,h);
             elseif (strcmp(assignment_opts.detector_option,'HarrLap'))
                 Do_LBP(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option);   
                 points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
                 points = getfield(points_out,'descriptor_points');
                 All_hist(:,counter)=points;
                 counter=counter+1;
                 waitbar(i/nimages,h);
             %%%%%% For DOG_Dorko;Harr_lap, DOG_Color etc
             else
%                  points_out1=load([data_locations{i},'/',assignment_opts.detector_option]);
%                  points_detect = getfield(points_out1,'detector_points');
%                  [pts,index_out]=Do_LBP_hybrid(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option,points_detect);   
%                  index_list{i}=index_out(:,1);
%                  points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
%                  points = getfield(points_out,'descriptor_points');
%                  All_hist(:,counter)=points;
%                  counter=counter+1;
%                  waitbar(i/nimages,h);
i
                   Do_GIST(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.name);
                   points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
                   points = getfield(points_out,'descriptor_points');
                   All_hist(:,counter)=points;
                   counter=counter+1;
                   waitbar(i/nimages,h);
                  
              end
        end
else
      vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
%       vocabulary=double(vocabulary'); %%% for ikmeans
% vocabulary=vocabulary';
      vocabulary_size=size(vocabulary)
      
      for i=1:nimages
         
              if(strcmp(assignment_opts.type,'hard'))
                 % i
%                    points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%                    points = getfield(points_out,'descriptor_points');

%%%%%%%%%%%%%%%%%%%% 3 detectors together %%%%%%%%%%%
                    points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                    points1 = getfield(points_out,'descriptor_points');
                    
                    points_out=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
                    points2 = getfield(points_out,'descriptor_points');
% %                   
                    points_out=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
                    points3 = getfield(points_out,'descriptor_points');
%                     
%                      points_out=load([data_locations{i},'/',assignment_opts.descriptor_name4]);
%                      points4 = getfield(points_out,'descriptor_points');
%                     
%                     points_out=load([data_locations{i},'/',assignment_opts.descriptor_name5]);
%                     points5 = getfield(points_out,'descriptor_points');
% % %                     
%                      points=[points1;points2;points3;points4;points5];
                    
                       points=[points1;points2;points3];
                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  [minz index]=min(distance(points,vocabulary),[],2);
                   index_list{i}=index(:,1);
                  All_hist(:,counter)=hist(index,(1:vocabulary_size));
                  counter=counter+1;
                  points=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% CA for bounding BOX %%%%%%%%%%%%%%%%%
              elseif(strcmp(assignment_opts.type,'bbox'))
              det_points_final=getfield(load([data_locations{i},'/',assignment_opts.index_name]),'assignments');
              i

              a=image_names{i};
              a=a(1:11);
              rec=PASreadrecord(sprintf(VOCopts.annotationpath,a));
              bbox_total=[];
              for ijkl=1:length(rec.objects)
                    b=rec.objects(ijkl).bndbox;
                    x_lo=floor(b.xmin);
                    x_hi=floor(b.xmax);
                    y_lo=floor(b.ymin);
                    y_hi=floor(b.ymax);

                   bbox_pts =  det_points_final(( det_points_final(:,1) > x_lo) & ( det_points_final(:,1) <= x_hi) & ...
                        ( det_points_final(:,2) > y_lo) & ( det_points_final(:,2) <= y_hi),:,:);

                   bbox_total=[bbox_total;bbox_pts];
              end
              all_hist=hist(bbox_total(:,3), 1:assignment_opts.vocabulary_size)./length(bbox_total); 
              All_hist(:,counter)=all_hist;   
                  counter=counter+1;
                  
                  
                  
%%               %%%%%%%%%%%%%% Incorporating Sparse code (Max-Pooling) CVPR 09 %%%%%%%%%%%%%%%%%%%
              elseif(strcmp(assignment_opts.type,'sparse'))
%               pyramid = [1,2,4]; % spatial block number on each level of the pyramid
%               weights = [1,1,1];
%               gamma = 0.15;
%               beta = 1e-3; % a small regularization for stablizing sparse coding
%               pooling = 'max'; % 'energy', 'absolute', 'max'
%               load(opts.image_names);
%                  
%                %%%%%%%%%%% collect the features from different detectors%%%%
%                points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%                points1 = getfield(points_out,'descriptor_points');
%                     
% %                points_out=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
% %                points2 = getfield(points_out,'descriptor_points');
% % 
% %                points_out=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
% %                points3 = getfield(points_out,'descriptor_points');
% %                
% %                points_out=load([data_locations{i},'/',assignment_opts.descriptor_name4]);
% %                points4 = getfield(points_out,'descriptor_points');
% %                
% %                points_out=load([data_locations{i},'/',assignment_opts.descriptor_name5]);
% %                points5 = getfield(points_out,'descriptor_points');
% 
% %                points=[points1;points2;points3;points4;points5];
%                  points=points1;
%                
%                %%%%%%%%%%% collect the different detected points %%%%
%                points_out=load([data_locations{i},'/',assignment_opts.detector_name]);
%                points_det1 = getfield(points_out,'detector_points');
%                     
% %                points_out=load([data_locations{i},'/',assignment_opts.detector_name2]);
% %                points_det2 = getfield(points_out,'detector_points');
% % 
% %                points_out=load([data_locations{i},'/',assignment_opts.detector_name3]);
% %                points_det3 = getfield(points_out,'detector_points');
% %                
% %                points_out=load([data_locations{i},'/',assignment_opts.detector_name4]);
% %                points_det4 = getfield(points_out,'detector_points');
% %                
% %                points_out=load([data_locations{i},'/',assignment_opts.detector_name5]);
% %                points_det5 = getfield(points_out,'detector_points');
% 
% %                points_det=[points_det1(:,1:2);points_det2(:,1:2);points_det3(:,1:2);points_det4(:,1:2);points_det5(:,1:2)];
%                  points_det=points_det1(:,1:2);
%       
%                %%%%%% making a structure similar to the example code %%%%%
%                im=sprintf('%s/%s',opts.imgpath,image_names{i});
%                im=imread(im);
%                [width height]=size(im);
%                
%                feature_struct.feaArr=points';
%                feature_struct.x=points_det(:,1);
%                feature_struct.y=points_det(:,2);
%                feature_struct.width=width;
%                feature_struct.height=height;
%                
%                
%                 %%%%%%%%%%%%%%%%%%% Do the sparse assignment %%%%%
%                All_hist(:,counter) = ScSPM(feature_struct,vocabulary', gamma, pyramid, weights, pooling);
%                
%                counter=counter+1;
%                points=[];
%               
%%               New modified try for sparse assignment using max pooling

                  pyramid = [1, 2, 4]; % spatial block number on each level of the pyramid
                  weights = [1, 1, 1];
%                    pyramid = [1];
%                    weights = [1];
                   gamma = 0.15;
                   beta = 1e-3; % a small regularization for stablizing sparse coding
                   pooling = 'max'; % 'energy', 'absolute', 'max'
                   load(opts.image_names);
                   
                   points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                   points = getfield(points_out,'descriptor_points');
                   
                   %%%%%%%%% detection points 
                   points_out_det=load([data_locations{i},'/',assignment_opts.detector_name]);
                   points_det = getfield(points_out_det,'detector_points');
                   points_det_total=points_det(:,1:3);
                  
%                  points_out_det2=load([data_locations{i},'/',assignment_opts.detector_name2]);
%                  points_det2 = getfield(points_out_det2,'detector_points');
%                   
%                  points_out_det3=load([data_locations{i},'/',assignment_opts.detector_name3]);
%                  points_det3 = getfield(points_out_det3,'detector_points');
                  
%                  points_det_total=[points_det(:,1:3);points_det2(:,1:3);points_det3(:,1:3)];
               
                   im=sprintf('%s/%s',opts.imgpath,image_names{i});
                   im=imread(im);
                   [width height]=size(im);

                   feature_struct.feaArr=points';
                   feature_struct.x=points_det_total(:,1);
                   feature_struct.y=points_det_total(:,2);
                   feature_struct.width=width;
                   feature_struct.height=height;
                  
                   %%%%%%%%%%%%%%%%%%% Do the sparse assignment %%%%%
                   All_hist(:,counter) = ScSPM_new(feature_struct,vocabulary, gamma, pyramid, weights, pooling);

                   counter=counter+1;
                   points=[];




                 %%%%%%%%%%%%%%%%%%%%%% End of Sparse coding method %%%%%%%%%%%%%%%%%%%             
              
              %%%%%%%%%%%%%%%%%%%% SOFT Assignment Conventional %%%%%%%%%%%%%
              elseif(strcmp(assignment_opts.type,'soft'))
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points1 = getfield(points_out,'descriptor_points');
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
                  points2 = getfield(points_out,'descriptor_points');                 
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
                  points3 = getfield(points_out,'descriptor_points');
                  points=[points1;points2;points3];
                  
                  AA=distance(points,vocabulary);
                  BB=exp(-(AA.*AA)/( assignment_opts.soft_assign^2));
                  BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
                  All_hist(:,counter)=sum(BB,1);
                  counter=counter+1;
                  
          %%%%%%%%%%%%%%%%%%%%% SOFT Assignment for CA %%%%%%%%%%%%%%%%        
                  
               elseif(strcmp(assignment_opts.type,'soft_CA'))
                  
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points = getfield(points_out,'descriptor_points');
                  dist=distance(points,vocabulary);
                  dist2=-(dist.*dist)/( 2*assignment_opts.soft_assign^2);
                  max_dist2=max(dist2,[],2);
                  BB=exp(dist2-repmat(max_dist2,1,size(dist2,2)));
                  BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
                  All_hist(:,counter)=sum(BB,1);
                  
                  min_val=min(BB(:));
                  
                  assignments=zeros(size(BB,1),2*assignment_opts.nn_neighbours);
                  for kk=1:assignment_opts.nn_neighbours
                     [max1,max2]=max(BB,[],2);
                     assignments(:,kk)=max2;
                     assignments(:,kk+assignment_opts.nn_neighbours)=max1;                      
                     BB( (max2-1)*size(BB,1)+(1:size(BB,1) )' )=min_val;
                  end
               %%%%% SAVE ASSIGNMENTS TO IMAGES
                  assignments(:,assignment_opts.nn_neighbours+1:assignment_opts.nn_neighbours*2)=normalize(assignments(:,assignment_opts.nn_neighbours+1:assignment_opts.nn_neighbours*2),2);
                  index_list{i}=assignments;
                  counter=counter+1;    
                  
              else
                  display('NOT YET IMPLLEMENTED !!');
              end 
              waitbar(i/nimages,h);
      end
end

%           if(strcmp(assignment_opts.type,'soft'))
%               points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%               points = getfield(points_out,'descriptor_points');
%               AA=distance(points,vocabulary);
%               BB=exp(-(AA.*AA)/( assignment_opts.soft_assign^2));
%               BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
%               All_hist(:,counter)=sum(BB,1);
%           else
%           display('NOT YET IMPLLEMENTED !!');
%           end
close(h);
All_hist=normalize(All_hist,1);     % All_hist=All_hist./(ones(size(All_hist,1),1)*sum(All_hist));
save ([opts.data_assignmentpath,'/',assignment_opts.name],'All_hist');
save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');
display('saved assignments');
% pause
%          save ([opts.data_assignmentpath,'/',assignment_opts.name,'_hybrid_index'],'index_list');