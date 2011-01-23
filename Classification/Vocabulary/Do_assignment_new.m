function []=Do_assignment_new(opts,assignment_opts)
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
           assignment_opts.soft_assign=0.08;
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
             if (strcmp(assignment_opts.detector_option,'Grid'))
                 Do_LBP(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option);   
                 points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
                 points = getfield(points_out,'descriptor_points');
                 All_hist(:,counter)=points;
                 counter=counter+1;
                 waitbar(i/nimages,h);
                 
                 
             elseif (strcmp(assignment_opts.detector_option,'DOG_Dorko'))
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
      vocabulary1=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
      vocabulary2=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name2]),'voc');
%       vocabulary=[vocabulary1;vocabulary2];
      vocabulary_size=size(vocabulary1,1);
      
      index1=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
index2=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name2]),'index_list');
      for i=1:nimages
              if(strcmp(assignment_opts.type,'hard'))
                   for j=1:size(vocabulary1,1)
                      i
%                   points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%                   points1 = getfield(points_out,'descriptor_points');
%                   points_out1=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
%                   points2 = getfield(points_out1,'descriptor_points');
%                   
%                   [minz index]=min(distance(points1,vocabulary1),[],2);
%                   [minz index2]=min(distance(points2,vocabulary2),[],2);
                  



cw=index1{i}(index2{i}==j);
if(~isempty(cw))
    cw=[cw;j];
end

%                   cw=index2(index==j);
                  
%                   index_list{i}=index(:,1);
                  All_hist(:,counter)=hist(cw,(1:vocabulary_size));
                  counter=counter+1;
                   end
              elseif(strcmp(assignment_opts.type,'soft'))
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points = getfield(points_out,'descriptor_points');
                  AA=distance(points,vocabulary);
                  BB=exp(-(AA.*AA)/( assignment_opts.soft_assign^2));
                  BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
                  All_hist(:,counter)=sum(BB,1);
                  counter=counter+1;
              else
                  display('NOT YET IMPLLEMENTED jani 123!!');
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
%     save ([opts.data_assignmentpath,'/',assignment_opts.name,'_hybrid_index'],'index_list');