function Do_assignment_par(opts,assignment_opts)
%% Do the assignment

load(opts.image_names);
load(opts.data_locations);

display('Computing the Assignment');

%% Do the assignment for each constructed vocabulary

for available_voc = 1:length(assignment_opts.vocabulary_name)

if exist([opts.data_assignmentpath,'/', assignment_opts.name{1} '.mat']) == 2
    continue;
end

vocabulary = getfield(load([opts.data_vocabularypath, '/', ...
    assignment_opts.vocabulary_name{available_voc}]), 'voc');

all_hist = zeros(assignment_opts.vocabulary_size{available_voc}, ...
    opts.nimages);

index_list = cell(opts.nimages, 1);

parfor i = 1:opts.nimages

    display(sprintf('==> Calculating assignment for Image (%04d/%04d)', ...
        i, opts.nimages));

    points=[];
    for detType = 1:length(assignment_opts.descriptor_name{available_voc})
        points_out = load([data_locations{i}, '/', ...
            assignment_opts.descriptor_name{available_voc}{detType}]);
        points_desc = getfield(points_out, 'descriptor_points');
        points = [points; points_desc];
    end

    [minz index] = min(histogram_distance(points, vocabulary), [], 2);
    index_list{i} = index(:, 1);

    all_hist(:, i) = hist(index, ...
        (1:assignment_opts.vocabulary_size{available_voc}));
end

all_hist = normalize(all_hist' ,1);

save ([opts.data_assignmentpath,'/',assignment_opts.name{available_voc}], ...
    'all_hist');
save ([opts.data_assignmentpath,'/',assignment_opts.name{available_voc}, ...
    '_hybrid_index'], 'index_list');

end

end