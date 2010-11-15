function bestreport = get_best_report()

reports_base_dir = '/share/CIC/amounir/Final_ISA';

all_reports = dir(reports_base_dir);
reportsCount = length(all_reports) - 2;

repNames = {'Sum', 'SumCRF', 'Max', 'MaxCRF', 'Votes','VotesCRF'};

bestreport = struct();
bestreport.avgacc = 0;

% 1. RAD
% 2. Outliers
% 3. GB
% 4. MS
% 5. NC

for reportIter = 1:reportsCount
    
    % Best alltogether
    valid = 1;
    for shft = 1:5
        if (bitget(reportIter, shft * 2 - 1) == 0 && ...
                bitget(reportIter, shft * 2) == 0)
            valid = 0;
        end
    end
    
    if(valid == 0)
        continue;
    end
    
    for repNamesInd = 6:6
        filename = sprintf('%s/%07d/%s.mat', reports_base_dir, ...
            reportIter, repNames{repNamesInd});

        report = load(filename);

        if (report.avgacc > bestreport.avgacc)
            fprintf('\n******************\nBest report change\n******************\n');

            bestreport = report;
            bestreport.index = reportIter;
            bestreport.technique = repNames{repNamesInd};

            bestreport
        end
    end
end

bestreport

end
