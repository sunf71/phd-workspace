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

if(assignment_opts.LBP_flag)
           if ~isfield(assignment_opts,'name');    assignment_opts.name=assignment_opts.LBP_option; end
else
           if ~isfield(assignment_opts,'name');    assignment_opts.name=strcat(assignment_opts.type,assignment_opts.vocabulary_name); end
end

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

%load(opts.image_names);
load(opts.data_locations);
[ids,gt]=textread(sprintf(opts.imgsetpath,opts.trainset),'%s %d');
%nimages=opts.nimages;
% vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
% vocabulary_size=size(vocabulary,1);
All_hist=[];local=[];locations=[];All_hist1=[];
counter=1;
h = waitbar(0,'Please wait...');
if(assignment_opts.LBP_flag)
    for i=1:length(ids)
         Do_LBP(sprintf('%s/%s.jpg',opts.imgpath,ids{i}),data_locations{i},assignment_opts.LBP_option);   
         points_out=load([data_locations{i},'/',assignment_opts.LBP_option]);
         points = getfield(points_out,'descriptor_points');
         All_hist(:,counter)=points;
         counter=counter+1;
          waitbar(i/length(ids),h);
    end
else
      vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
      vocabulary_size=size(vocabulary,1);
      for i=1:length(ids)
          if(strcmp(assignment_opts.type,'hard'))
              points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
              points = getfield(points_out,'descriptor_points');
              [minz index]=min(distance(points,vocabulary),[],2);
              All_hist(:,i)=hist(index,(1:vocabulary_size));
              %%%%%%%%%  to localize the locations according to the
              %%%%%%%%%  detector points taken from the detector file and
              %%%%%%%%%  indexes of the clusters (reference Christopher
              %%%%%%%%%  lamphert paper (Damg 08))
              if(assignment_opts.computelocations)
               points_detector=getfield(load([data_locations{i},'/',assignment_opts.detector_name]),'detector_points');
               locations(:,:,i)=[points_detector(:,2),points_detector(:,1),index(:,1)];   
               %%% to read annotation for bb
               rec=PASreadrecord(sprintf(opts.annopath,ids{i}));
                for j=1:length(rec.objects)
                    bb=rec.objects(j).bbox;
                    lbl=rec.objects(j).class;
                
               
                %%%%% add points location of object %%%%
                [minz index]=min(distance(points,vocabulary),[],2);
                All_hist1(:,i)=hist(index,(1:vocabulary_size));
                end

              end
             
          else
              display('NOT YET IMPLLEMENTED jani 123!!');
          end 
          waitbar(i/length(ids),h);
    end
end
close(h);

All_hist1=normalize(All_hist,1);
All_hist=normalize(All_hist,1);     % All_hist=All_hist./(ones(size(All_hist,1),1)*sum(All_hist));
save ([opts.data_assignmentpath,'/',assignment_opts.name],'All_hist');
save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');