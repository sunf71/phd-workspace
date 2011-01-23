function []=Do_assignment_DetSW(opts,assignment_opts)

% run Hybrid on data set
if nargin<2
    assignment_opts=[];
end

display('Computing Detection Histograms Assignments');
if ~isfield(assignment_opts,'type');             assignment_opts.type='Unknown';      end    %%%%%%%% The name of first histogram whose probability is to be computed
if ~isfield(assignment_opts,'level');            assignment_opts.level='Unknown';    end    %%%%%%%% The name of 2nd histogram whose probability is to be computed
if ~isfield(assignment_opts,'pyramid_type');     assignment_opts.pyramid_type='Unknown';     end    %%%%%%%%  Mother histogram ,The name of histogram whose features decide the size of histogram
if ~isfield(assignment_opts,'soft_assign');      assignment_opts.soft_assign='Unknown';    end    %%%%%%%% The name of 3rd histogram whose probability is to be computed
if ~isfield(assignment_opts,'descriptor_name');  assignment_opts.descriptor_name='Unknown';          end    %%%%%%%% The name of first index (Histogram_name)
if ~isfield(assignment_opts,'detector_name');    assignment_opts.detector_name='Unknown';        end    %%%%%%%% The name of 2nd index (histogram_name1)
if ~isfield(assignment_opts,'vocabulary_name');  assignment_opts.vocabulary_name='Unknown';         end    %%%%%%%% The name of mother index, this will decide the final size of histogram (histogram_name2)
if ~isfield(assignment_opts,'name');             assignment_opts.name='Unknown';         end    %%%%%%%% The name of 3rd indexindex, this will decide the final size of histogram (histogram_name2)


try
    assignment_opts2=getfield(load([opts.data_assignmentpath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts,assignment_opts2))
        display('Recomputing Detection assignments for this settings');
    else
        display('Overwriting Detection assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end
%%
       if(strcmp(assignment_opts.histogram_method,'first'))
            %%%%%%%%% Positive bbox +  negative bbox from all examples except positive bbox %%%%%%%%%%%
             All_hist_pos=Do_assignment_DetSW_Pos(opts,assignment_opts);
             All_hist_pos_plus=Do_assignment_DetSW_PosPlus(opts,assignment_opts);
             All_hist_negBB=Do_assignment_DetSW_NegBB(opts,assignment_opts);
             %%%%%%%% preparing for Saving %%%%%%%
             All_hist=[All_hist_pos,All_hist_pos_plus,All_hist_negBB];
             train_truth_pos=[All_hist_pos,All_hist_pos_plus];
             train_truth=zeros(size(All_hist,2),1);
             train_truth(1:size(train_truth_pos,2),1)=1;
%              assignment_opts.trainhist=strcat(assignment_opts.name,'_',assignment_opts.histogram_method);
%              assignment_opts.traintruth=strcat(assignment_opts.name,'_',assignment_opts.histogram_method,'_','train_truth');
%%            
       elseif(strcmp(assignment_opts.histogram_method,'second'))
           %%%% Positive bbox + random neg bbox from negative images + random neg bbox from pos images + neg bb from neg images %%%%
            All_hist_pos=Do_assignment_DetSW_Pos(opts,assignment_opts);
            All_hist_neg=Do_assignment_DetSW_Neg(opts,assignment_opts);
            All_hist_negpos=Do_assignment_DetSW_NegPos(opts,assignment_opts);
            All_hist_negBB=Do_assignment_DetSW_NegBB(opts,assignment_opts);
%%
       elseif(strcmp(assignment_opts.pyramid_type,'third'))  
           %%%%%%%%% Positive bbox + random negative bbox from positive images %%%%%%%%%%%
            All_hist_pos=Do_assignment_DetSW_Pos(opts,assignment_opts);
            All_hist_negpos=Do_assignment_DetSW_NegPos(opts,assignment_opts);
%%
       elseif(strcmp(assignment_opts.pyramid_type,'fourth'))  
           %%%%%%%%% Positive bbox + random negative bbox from positive images %%%%%%%%%%%
%             All_hist_pos=Do_assignment_DetSW_Pos(opts,assignment_opts);
%             All_hist_negpos=Do_assignment_DetSW_NegPos(opts,assignment_opts);
           
       end   
%%           %%%%%%%%% Save the Spatial Pyramids Histogram %%%%%%%%%%%
            %assignment_opts.name='fastkmeansSIFT_DorkoGrid1000Lazebnik3_new';
            save ([opts.data_assignmentpath,'/',assignment_opts.trainhist],'All_hist');
            save ([opts.data_assignmentpath,'/',assignment_opts.traintruth],'train_truth');
            save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');
