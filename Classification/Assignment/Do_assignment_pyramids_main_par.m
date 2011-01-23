function []=Do_assignment_pyramids_main_par(opts,assignment_opts)

% run Hybrid on data set
if nargin < 2
    assignment_opts = [];
end

display('Computing Spatial Pyramids Assignment');

% Adjust the parameters
if ~isfield(assignment_opts, 'type')
    assignment_opts.type='Unknown';
end

if ~isfield(assignment_opts, 'level')
    assignment_opts.level = 'Unknown';
end

if ~isfield(assignment_opts, 'pyramid_type')
    assignment_opts.pyramid_type = 'Unknown';
end   

if ~isfield(assignment_opts,'soft_assign');      
    assignment_opts.soft_assign='Unknown';    
end

if ~isfield(assignment_opts,'descriptor_name');  
    assignment_opts.descriptor_name='Unknown'; 
end   

if ~isfield(assignment_opts,'detector_name');    
    assignment_opts.detector_name='Unknown';
end   

if ~isfield(assignment_opts,'vocabulary_name');  
    assignment_opts.vocabulary_name='Unknown';
end    

if ~isfield(assignment_opts,'name');
    assignment_opts.name='Unknown';
end

try
    assignment_opts2 = getfield(load([opts.data_assignmentpath, '/', ...
        assignment_opts.name, '_settings']), 'assignment_opts');
    
    if(isequal(assignment_opts, assignment_opts2))
        display('Recomputing Spatial Pyramids assignments for this settings');
    else
        display('Overwriting Spatial Pyramids assignment with same name, but other Assignment settings');
    end
    
end

switch(assignment_opts.pyramid_type)
    case 'Marcin':
        Do_assignment_pyramids_marcin_par(opts, ...
            assignment_opts);

    case 'Lazebnik':
        Do_assignment_pyramids_lazebnik_par(opts, ...
            assignment_opts);

    case 'Noha':
        Do_assignment_pyramids_lazebnik_par_noha(opts, ...
            assignment_opts);
        
    case 'Adaptive':
        Do_assignment_adaptive_pyramids(opts, ...
            assignment_opts);
end

end








