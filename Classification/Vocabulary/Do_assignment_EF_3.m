function []=Do_assignment_EF(opts,assignment_opts)  %%%%%%%%%%%%% Only for Early Fusion case
% run Assignment on data set
if nargin<2
    assignment_opts=[];
end
display('Computing Assignments');
if ~isfield(assignment_opts,'type');               assignment_opts.type='hard';                    end
if ~isfield(assignment_opts,'vocabulary_name');    assignment_opts.vocabulary_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name');    assignment_opts.descriptor_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name2');   assignment_opts.descriptor_name2='Unknown';     end
if ~isfield(assignment_opts,'EF_alpha');           assignment_opts.EF_alpha='Unknown';                   end

%%% For Soft Assignment %%%%%%%%%
if(strcmp(assignment_opts.type,'soft'))
%            assignment_opts.soft_assign=0.05;
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
All_hist=[];points_total_alpha=[];points_total=[];
h = waitbar(0,'Please wait...');
for iii=1:length(assignment_opts.EF_beta)
   for jj=1:length(assignment_opts.EF_alpha)
      vocabulary{jj}=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name,'_',num2str(assignment_opts.EF_alpha(jj)*10)]),'voc');
   end
end
vocabulary_size=size(vocabulary{1},1);  %only one vocabulary size allowed !

for i=1:nimages
      if(strcmp(assignment_opts.type,'hard'))
          points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
          points = getfield(points_out,'descriptor_points');
          points_out2=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
          points2 = getfield(points_out2,'descriptor_points');
          
          %%%% to incorporate 3rd option 
          points_out3=load([data_locations{i},'/',assignment_opts.descriptor_name3]);
          points3 = getfield(points_out3,'descriptor_points');
          
        for iii=1:length(assignment_opts.EF_beta) 
           for jj=1:length(assignment_opts.EF_alpha)
            points_total_alpha=[(1-assignment_opts.EF_alpha(jj))*points,assignment_opts.EF_alpha(jj)*points2];
            points_total=[(1-assignment_opts.EF_beta(iii))*points_total_alpha,assignment_opts.EF_beta(iii)*points3];
            [minz index]=min(distance(points_total,vocabulary{jj}),[],2);
            All_hist{jj}(:,i)=hist(index,(1:vocabulary_size));
            
           end
        end  
      elseif(strcmp(assignment_opts.type,'soft'))
          points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
          points = getfield(points_out,'descriptor_points');
          points_out2=load([data_locations{i},'/',assignment_opts.descriptor_name2]);
          points2 = getfield(points_out2,'descriptor_points');
          for jj=1:length(assignment_opts.EF_alpha)
            points_total=[(1-assignment_opts.EF_alpha(jj))*points,assignment_opts.EF_alpha(jj)*points2];
              AA=distance(points_total,vocabulary{jj});
              BB=exp(-(AA.*AA)/( assignment_opts.soft_assign^2));
              BB=BB./(sum(BB,2)*ones(1,size(BB,2)));
              All_hist{jj}(:,i)=sum(BB,1);
          end
      else
          display('NOT YET IMPLLEMENTED !!');
      end       
      waitbar(i/nimages,h);
end
close(h);
for jj=1:length(assignment_opts.EF_alpha)
    if isfield(assignment_opts,'name');     assignment_opts.name1=strcat(assignment_opts.name,'_',num2str(assignment_opts.EF_alpha(jj)*10)); end
    if ~isfield(assignment_opts,'name');    assignment_opts.name1=strcat(assignment_opts.type,assignment_opts.vocabulary_name,'_',num2str(assignment_opts.EF_alpha(jj)*10)); end
    All_hist{jj}=normalize(All_hist{jj},1);     % All_hist=All_hist./(ones(size(All_hist,1),1)*sum(All_hist));
    all_hist1=All_hist{jj};
    save ([opts.data_assignmentpath,'/',assignment_opts.name1],'all_hist1');
    save ([opts.data_assignmentpath,'/',assignment_opts.name1,'_settings'],'assignment_opts');
    assignment_opts.name1=[];
end
