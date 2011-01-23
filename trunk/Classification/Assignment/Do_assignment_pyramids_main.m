function []=Do_assignment_pyramids_main(opts,assignment_opts)

% run Hybrid on data set
if nargin<2
    assignment_opts=[];
end

display('Computing Spatial Pyramids  Assignments');
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
        display('Recomputing Spatial Pyramids assignments for this settings');
    else
        display('Overwriting Spatial Pyramids assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end

       if(strcmp(assignment_opts.pyramid_type,'Lazebnik'))

           
            %%%%%%%%% Compute the Spatial Pyramids Assignment %%%%%%%%%%%
%             All_hist=Do_assignment_pyramids_lazebnik_normal(opts,assignment_opts);

             All_hist=Do_assignment_pyramids_lazebnik(opts,assignment_opts);
            
       elseif(strcmp(assignment_opts.pyramid_type,'Marcin'))
           
           %%%%%%%%% Compute the Spatial Pyramids Assignment %%%%%%%%%%%
            All_hist=Do_assignment_pyramids_marcin(opts,assignment_opts);
       elseif(strcmp(assignment_opts.pyramid_type,'Lazebnik'))
           All_hist=Do_assignment_pyramids_lazebnik(opts,assignment_opts);
           
       elseif(strcmp(assignment_opts.pyramid_type,'Noha'))  
           %for pascal
           All_hist=Do_assignment_pyramids_lazebnik_par3_3(opts,assignment_opts);
           %others
           %All_hist=Do_assignment_pyramids_lazebnik_par3_3_scenes(opts,assignment_opts);%,1, 1,vocabulary)
       end   
            %%%%%%%%% Save the Spatial Pyramids Histogram %%%%%%%%%%%
            %assignment_opts.name='fastkmeansSIFT_DorkoGrid1000Lazebnik3_new';
            save ([opts.data_assignmentpath,'/',assignment_opts.name], '-v7.3','All_hist');
            %save ([opts.data_assignmentpath,'/',assignment_opts.name],'All_hist');
            save ([opts.data_assignmentpath,'/',assignment_opts.name,'_settings'],'assignment_opts');
