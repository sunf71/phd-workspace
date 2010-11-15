load('/home/amounir/Workspace/Superpixels-iccv2009/results/seg_size_accuracy.mat');
load('/home/amounir/Workspace/Superpixels-iccv2009/results/how_many_segs.mat');

for classID = 1:21

    accs = seg_size_accuracy(classID, :);
    counts = how_many_segs(classID, :);

    indices = find(counts ~= 0);

    acc_values = zeros(1, length(indices));
    for ind = 1:length(indices)
        acc_values(ind) = accs(indices(ind)) / counts(indices(ind));
    end
    
    figure, plot(indices, acc_values, '-');

end
