function []=Do_assignment_CollectHist_2010(opts,assignment_opts)
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

load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;
nimages=21294;
% vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
% vocabulary_size=size(vocabulary,1);
All_hist=[];local=[];locations=[];All_hist1=[];
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
%       vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
%       vocabulary_size=size(vocabulary,1);
      
      All_hist=zeros(32000,nimages);
      counter=1;
%       index_list=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
%          index_list=getfield(load([opts.data_assignmentpath,'/','ikmeansSIFT_DorkoGrid_Dorko12000_aib300_hybrid_index']),'index_list');
      for i=1:nimages
          if(strcmp(assignment_opts.type,'pyramid'))
%               points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
%               points = getfield(points_out,'descriptor_points');
              %points=
%               [minz index]=min(distance(points,vocabulary),[],2);

%               All_hist(:,i)=hist(index,(1:vocabulary_size));
              %%%%%%%%%  to localize the locations according to the
              %%%%%%%%%  detector points taken from the detector file and
              %%%%%%%%%  indexes of the clusters (reference Christopher
              %%%%%%%%%  lamphert paper (Damg 08))
     %         if(assignment_opts.computelocations)
%                points_detector=getfield(load([data_locations{i},'/',assignment_opts.detector_name]),'detector_points');

%%%%%%%%%%%%%%%%% extract all 3 detector types points %%%%%%%%%%%%%%%%%%%%

                points_out_har=load([data_locations{i},'/',assignment_opts.name]);
                points_har = getfield(points_out_har,'assignments');
%                 points=points(:,1:2);
                
%                 points_out_dog_dorko=load([data_locations{i},'/',assignment_opts.detector_name2]);
%                 points_dog_dorko = getfield(points_out_dog_dorko,'detector_points');
%                  
%                 points_out_grid_dorko=load([data_locations{i},'/',assignment_opts.detector_name3]);
%                 points_grid_dorko = getfield(points_out_grid_dorko,'detector_points');
%                  
%                 points_out_grid_dorko4=load([data_locations{i},'/',assignment_opts.detector_name4]);
%                 points_grid_dorko4 = getfield(points_out_grid_dorko4,'detector_points');
%                  
%                 points_out_grid_dorko5=load([data_locations{i},'/',assignment_opts.detector_name5]);
%                 points_grid_dorko5 = getfield(points_out_grid_dorko5,'detector_points');
                 
%                 points=[points_har(:,1:3);points_dog_dorko(:,1:3);points_grid_dorko(:,1:3);points_grid_dorko4;points_grid_dorko5];

                 i
               
%                  index=index_list{i};
%                 locations{i}=[points(:,1),points(:,2),points(:,3),index'];
%                  assignments=[points(:,1),points(:,2),index'];
All_hist(:,counter)=points_har';
counter=counter+1;
                   

%                  assignments=[];
%                locations(:,:,i)=[points_detector(:,1),points_detector(:,2),index(:,1)];    
%               locations(:,i)=[points_detector(:,2),points_detector(:,1),index(:,1)];
%                locations{i}=[points_detector(1),points_detector(2),index];
%               %local(:,counter)=[,index(:)]
%               local{counter}=([points(:,1:2),index(:)])
                %%%%% add points location of object %%%%
             %%   [minz index]=min(distance(points,vocabulary),[],2);
             %%   All_hist1(:,i)=hist(index,(1:vocabulary_size));

          %    end
             
          else
              display('NOT YET IMPLLEMENTED jani !!');
          end 
          waitbar(i/nimages,h);
    end
end
close(h);
% save (['/home/fahad/Datasets/Pascal_2010/VOCdevkit/VOC2010/Data/Global/ikmeansWSIFT_LCC_Hist'],'All_hist');
 save -v7.3 '/home/fahad/Datasets/Pascal_2010/VOCdevkit/VOC2010/Data/Global/Assignment/ikmeansCMYSIFTHarLapv1_MS10000_aib4000_Marcin3' All_hist
% save -v7.3 '/home/fahad/Datasets/Pascal_2010/VOCdevkit/VOC2010/Data/Global/Assignment/fastkmeansSIFT_DorkoHarLapv1_MS3000_LCC_Lazebnik3' All_hist
size(All_hist)
display(' Pyramid Assignment collected and done');
pause
%All_hist1=normalize(All_hist,1);
All_hist=normalize(All_hist,1);     % All_hist=All_hist./(ones(size(All_hist,1),1)*sum(All_hist));
save ([opts.data_assignmentpath,'/',assignment_opts.name],'All_hist');
save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');