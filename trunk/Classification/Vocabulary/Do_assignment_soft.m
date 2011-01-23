function []=Do_assignment_soft(opts,assignment_opts)
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
% if(strcmp(assignment_opts.type,'soft'))
%            assignment_opts.soft_assign=0.08;
% end

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
                 points_out1=load([data_locations{i},'/',assignment_opts.detector_option]);
                 points_detect = getfield(points_out1,'detector_points');
                 [pts,index_out]=Do_LBP_hybrid(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option,points_detect);   
                 index_list{i}=index_out(:,1);
                 points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
                 points = getfield(points_out,'descriptor_points');
                 All_hist(:,counter)=points;
                 counter=counter+1;
                 waitbar(i/nimages,h);
              end
        end
else
      vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
        vocabulary=double(vocabulary'); % for integer kmeans
      vocabulary_size=size(vocabulary,1);
      for i=1:nimages
          i
              if(strcmp(assignment_opts.type,'hard'))
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points = getfield(points_out,'descriptor_points');
%                    points=im2uint8(points); %%% checking for integer K means
%                    points=double(points);   %%% checking for integer K means
                  [minz index]=min(distance(points,vocabulary),[],2);
                   index_list{i}=index(:,1);
                  All_hist(:,counter)=hist(index,(1:vocabulary_size));
                  counter=counter+1;
                  points=[];

              elseif(strcmp(assignment_opts.type,'soft'))
%                   points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%                   points = getfield(points_out,'descriptor_points');
%                   AA=distance(points,vocabulary);
%                   BB=exp(-(AA.*AA)/( assignment_opts.soft_assign^2));
%                   BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
%                   All_hist(:,counter)=sum(BB,1);
%                   counter=counter+1;
                  
                   %%%%%%%%%% Load detected points %%%%%%%%
                  points_out_det=load([data_locations{i},'/',assignment_opts.detector_name]);
                  points_det = getfield(points_out_det,'detector_points');
                  
                  points_out_det2=load([data_locations{i},'/',assignment_opts.detector_name2]);
                  points_det2 = getfield(points_out_det2,'detector_points');
                  
                  points_out_det3=load([data_locations{i},'/',assignment_opts.detector_name3]);
                  points_det3 = getfield(points_out_det3,'detector_points');
                  
                  points_det_total=[points_det(:,1:3);points_det2(:,1:3);points_det3(:,1:3)];
                  
                  %%%%%%%%%%%%% New %%%%%
                  
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points = getfield(points_out,desc);
                  
                  dist=distance(points,vocabulary);
                  dist2=-(dist.*dist)/( 2*assignment_opts.soft_assign^2);
                  max_dist2=max(dist2,[],2);
                  BB=exp(dist2-repmat(max_dist2,1,size(dist2,2)));
                  BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
                  All_hist(:,counter)=sum(BB,1);
                  counter=counter+1;

              elseif(strcmp(assignment_opts.type,'soft_CA'))
                  
                  
                  %%%%%%%%%% Load detected points %%%%%%%%
                  points_out_det=load([data_locations{i},'/',assignment_opts.detector_name]);
                  points_det = getfield(points_out_det,'detector_points');
                  
                  points_out_det2=load([data_locations{i},'/',assignment_opts.detector_name2]);
                  points_det2 = getfield(points_out_det2,'detector_points');
                  
                  points_out_det3=load([data_locations{i},'/',assignment_opts.detector_name3]);
                  points_det3 = getfield(points_out_det3,'detector_points');
                  
                  points_det_total=[points_det(:,1:3);points_det2(:,1:3);points_det3(:,1:3)];
                  
                  %%%%%%%%% Load descriptor file %%%%%%%%
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points_desc1 = getfield(points_out,'descriptor_points');
                  
                  points_out2=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
                  points_desc2 = getfield(points_out2,'descriptor_points');
                  
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
                  points_desc3 = getfield(points_out,'descriptor_points');
                  
                  points=[points_desc1;points_desc2;points_desc3];
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  
                  points=im2uint8(points); %%% checking for integer K means
                  points=double(points);   %%% checking for integer K means
                  
                  dist=distance(points,vocabulary);
                  dist2=-(dist.*dist)/( 2*assignment_opts.soft_assign^2);
                  max_dist2=max(dist2,[],2);
                  BB=exp(dist2-repmat(max_dist2,1,size(dist2,2)));
                  BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
                  All_hist(:,counter)=sum(BB,1);
                  
                  min_val=min(BB(:));
                  
                  assignments=zeros(size(BB,1),2*assignment_opts.nn_neighbours_file);
                  for kk=1:assignment_opts.nn_neighbours_file
                     [max1,max2]=max(BB,[],2);
                     assignments(:,kk)=max2;
                     assignments(:,kk+assignment_opts.nn_neighbours_file)=max1;                      
                     BB( (max2-1)*size(BB,1)+(1:size(BB,1) )' )=min_val;
                  end
               %% SAVE ASSIGNMENTS TO IMAGES
                  assignments(:,assignment_opts.nn_neighbours_file+1:assignment_opts.nn_neighbours_file*2)=normalize(assignments(:,assignment_opts.nn_neighbours_file+1:assignment_opts.nn_neighbours_file*2),2);
                  assignments=[points_det_total,assignments];
                  save ([data_locations{i},'/',assignment_opts.name,'_hybrid_index'],'assignments');
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
%        save
%        ([opts.data_assignmentpath,'/',assignment_opts.name,'_hybrid_index'],'index_list');