function report = create_report(report_dir)


db = load('/home/amounir/Workspace/Superpixels-iccv2009/results/db_paths.mat');
original_db_paths = db.original_db_paths;

class_ids = [1:20 0];
    
ncats = 21;
confcounts = zeros(ncats);
offset = 1; % I don't know what is that :-)

% Do once for sums
for imgIter = 423:632

    % Load class and confidence matrices
    filename = sprintf('%s/%05d.mat', report_dir, imgIter);
    [class, confidence] = loadClassConf(filename);

    % Load class segmentation
    classseg = sprintf('%s', original_db_paths{imgIter - 422});
    gtim = double(imread(classseg));

    close all;
    figure, imshow(label2rgb(gtim));

    resim = class_ids(class);
    
    figure, imshow(label2rgb(resim));
    
    pause
    continue;
    
    locs = gtim < 255; %exclude border / void regions
    ind = find(locs);
    sumim = offset + gtim + (resim-(1-offset))*ncats;
    confcounts(:) = vl_binsum(confcounts(:), ones(size(ind)), sumim(ind));

end
    
% Now create the report information.

conf = zeros(ncats);
rawcounts = confcounts;
overall_acc = 100*sum(diag(confcounts)) / sum(confcounts(:));

accuracies = zeros(ncats,1);
accuracies_int = zeros(ncats,1);
for j = 1:ncats
    rowsum = sum(confcounts(j,:));
    if rowsum > 0, conf(j, :) = 100*confcounts(j,:)/rowsum; end;
    accuracies(j) = conf(j,j);

    gtj=sum(confcounts(j,:));
    resj=sum(confcounts(:,j));
    gtjresj=confcounts(j,j);
    % The accuracy is: true positive / (true positive + false positive + false negative) 
    % which is equivalent to the following percentage:
    accuracies_int(j)=100*gtjresj/(gtj+resj-gtjresj);   
end

report = struct();
report.pixelscorrect = overall_acc;
report.accuracies = accuracies;
report.accuracies_int = accuracies_int;
report.avgacc = mean(accuracies);
report.avgacc_int = mean(accuracies_int);
report.conf = conf;

end

function [class, confidence] = loadClassConf(filename)
    load(filename, 'class', 'confidence');
end
