function []=Do_assignment(opts,assignment_opts)
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
if ~isfield(assignment_opts,'EF_alpha');           assignment_opts.EF_alpha='Unknown';             end

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
             Do_LBP(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},assignment_opts.LBP_option);   
             points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
             points = getfield(points_out,'descriptor_points');
             All_hist(:,counter)=points;
             counter=counter+1;
              waitbar(i/nimages,h);
        end
else
       vocabulary1=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','ColorHUEGrid',num2str(100))]),'voc');
       vocabulary2=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','ColorHUEGrid',num2str(600))]),'voc');
       vocabulary3=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','SIFT_DorkoGrid',num2str(100))]),'voc');
       vocabulary4=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','SIFT_DorkoGrid',num2str(600))]),'voc');
       
       vocabulary5=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','ColorHUEGrid',num2str(50))]),'voc');
       vocabulary6=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','ColorHUEGrid',num2str(20))]),'voc');
       vocabulary7=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','SIFT_DorkoGrid',num2str(50))]),'voc');
       vocabulary8=getfield(load([opts.data_vocabularypath,'/',strcat('Kmeans','SIFT_DorkoGrid',num2str(20))]),'voc');
       
       
       vocabulary_first1=[(1-0.9)*vocabulary1;0.9*vocabulary2];vocabulary_second1=[(1-0.6)*vocabulary3;0.6*vocabulary4];
       vocabulary_first2=[(1-0.8)*vocabulary_first1;0.8*vocabulary5];vocabulary_second2=[(1-0.8)*vocabulary_second1;0.8*vocabulary7];
       vocabulary=[(1-0.2)*vocabulary_first1,0.2*vocabulary_second1];
       vocabulary_size=size(vocabulary,1);
      for i=1:nimages
              if(strcmp(assignment_opts.type,'hard'))
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points1 = getfield(points_out,'descriptor_points');
                  points_out2=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
                  points2 = getfield(points_out2,'descriptor_points');
                  points=[(1-0.2)*points1,0.2*points2];
                  [minz index]=min(distance(points,vocabulary),[],2);
                  All_hist(:,counter)=hist(index,(1:vocabulary_size));
                  counter=counter+1;

              elseif(strcmp(assignment_opts.type,'soft'))
                  points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
                  points = getfield(points_out,'descriptor_points');
                  AA=distance(points,vocabulary);
                  BB=exp(-(AA.*AA)/( assignment_opts.soft_assign^2));
                  BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
                  All_hist(:,counter)=sum(BB,1);
                  counter=counter+1;
              else
                  display('NOT YET IMPLLEMENTED ');
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