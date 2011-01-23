function All_hist_pos=Do_assignment_DetSW_Pos(opts,assignment_opts)

VOCINIT2007

if nargin<2
    assignment_opts=[];
end
display('Computing Assignments');
if ~isfield(assignment_opts,'LBP_flag');           assignment_opts.LBP_flag=0;                     end
if ~isfield(assignment_opts,'LBP_option');         assignment_opts.LBP_option='LBP';               end  %%% optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if ~isfield(assignment_opts,'type');               assignment_opts.type='hard';                    end
if ~isfield(assignment_opts,'vocabulary_name');    assignment_opts.vocabulary_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name');    assignment_opts.descriptor_name='Unknown';      end


%%%%%%% The index flag for Hybrid Method %%%%%%%%%
if ~isfield(assignment_opts,'index_flag');         assignment_opts.index_flag=0;                     end

                                               
try
    assignment_opts2=getfield(load([opts.data_assignmentpath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts,assignment_opts2))
        display('Recomputing Positive assignments for this settings');
    else
        display('Overwriting Positive assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end

load(opts.image_names);
load(opts.trainset);
load(opts.data_locations);
nimages=opts.nimages;
labels=getfield(load(opts.labels),'labels');
All_hist=[];
counter=1;
counter2=1;
nimages=5011;
% index_list1=getfield(load([opts.data_assignmentpath,'/',assignment_opts.index_name]),'index_list');
      for i=1:nimages
            if(trainset(i)==1) 
%                 if(labels(i,assignment_opts.cls_num)==1)  
                       
                      det_points_final=getfield(load([data_locations{i},'/',assignment_opts.index_name]),'assignments');
                      a=image_names{i};
                      a=a(1:end-4);
        %               a=a(1:11);
                      rec=PASreadrecord(sprintf(VOCopts.annotationpath,a));
%                       atttt=rec.objects.difficult;
%                       if(atttt==1)
%                           counter2=counter2+1
%                       end
                      bbox_total=[];
                      for ijkl=1:length(rec.objects)
                          if(isequal(rec.objects(1,ijkl).class,opts.classes{assignment_opts.cls_num}))
                                b=rec.objects(ijkl).bndbox;
                                x_lo=floor(b.xmin);
                                x_hi=floor(b.xmax);
                                y_lo=floor(b.ymin);
                                y_hi=floor(b.ymax);

                                bbox_total =  det_points_final(( det_points_final(:,1) > x_lo) & ( det_points_final(:,1) <= x_hi) & ...
                                    ( det_points_final(:,2) > y_lo) & ( det_points_final(:,2) <= y_hi),:,:);
                               
                               all_hist=hist(bbox_total(:,3), 1:assignment_opts.vocabulary_size)./length(bbox_total); 
                               if(~isnan(all_hist))
                                   All_hist(:,counter)=all_hist;   
                                   counter=counter+1; 
                               end
                          else
%                               display('Picking a negative example');
%                                bbox_total=[bbox_total;bbox_pts];
                          end %%% if for class comparison
                      end %%% for the length of objects in image
%                       all_hist=hist(bbox_total(:,3), 1:assignment_opts.vocabulary_size)./length(bbox_total); 
%                       All_hist(:,counter)=all_hist;   
%                          counter=counter+1; 
%                 end  %%% labels of a particular class
            end   %%%% training images only       
      end   %%% loop over number of images
All_hist_pos=All_hist;

% All_hist=normalize(All_hist,1);     % All_hist=All_hist./(ones(size(All_hist,1),1)*sum(All_hist));
% save ([opts.data_assignmentpath,'/',assignment_opts.name],'All_hist');
% save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');
% display('saved assignments');
% % pause
%          save ([opts.data_assignmentpath,'/',assignment_opts.name,'_hybrid_index'],'index_list');