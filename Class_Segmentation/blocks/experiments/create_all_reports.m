function create_all_reports()

cd('/home/amounir/Workspace/Superpixels-iccv2009/results/');
db = load('db_paths.mat');
original_db_paths = db.original_db_paths;

reports_base_dir = '/share/CIC/amounir/Only_Mixed';

reportsCount = 0;
all_reports = dir(reports_base_dir);
for allRepIter = 1:length(all_reports)
    if(all_reports(allRepIter).isdir)
        reportsCount = reportsCount + 1;
    end
end

reportsCount = reportsCount - 2;

sumOrMax = 'Votes';

class_ids = [1:20 0];

parfor reportIter = 1:reportsCount
    
    fprintf('Processing report (%d/%d)\n', reportIter, reportsCount);
    
    filename = sprintf('%s/%07d/%s/report.mat', reports_base_dir, reportIter, sumOrMax);
    if(exist(filename, 'file') == 2)
        continue;
    end
    
    ncats = 21;
    confcounts = zeros(ncats);
    offset = 1; % I don't know what is that :-)

    % Do once for sums
    for imgIter = 423:632
        
        % Load class and confidence matrices
        filename = sprintf('%s/%07d/%s/%05d.mat', reports_base_dir, reportIter, sumOrMax, imgIter);
        [class, confidence] = loadClassConf(filename);
        
        % Load class segmentation
        classseg = sprintf('%s', original_db_paths{imgIter - 422});
        gtim = double(imread(classseg));

        
        resim = class_ids(class);
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
    [sorted ind] = sort(class_ids); 
    
    filename = sprintf('%s/%07d/%s/report.mat', reports_base_dir, reportIter, sumOrMax);
    saveReport(filename, report)

end

bestreport = struct();
bestreport.avgacc = 0;

for reportIter = 1:reportsCount
    filename = sprintf('%s/%07d/%s/report.mat', reports_base_dir, reportIter, sumOrMax);
    report = load(filename);

    if (report.avgacc > bestreport.avgacc)
        fprintf('\n******************\nBest report change\n******************\n');
        bestreport = report;
        bestreport.index = reportIter;
        
        bestreport
    end
end

bestreport
save(fullfile(reports_base_dir, sprintf('bestreport%s.mat', sumOrMax)), ...
    '-STRUCT', 'bestreport', '-MAT')

end

function [class, confidence] = loadClassConf(filename)
    load(filename, 'class', 'confidence');
end

function saveReport(filename, report)
    save(filename, '-STRUCT', 'report', '-MAT');
end
