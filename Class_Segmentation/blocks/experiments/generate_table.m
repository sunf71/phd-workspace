rep_paths = {'/share/CIC/amounir/Final_ISA/0000793/', ...
'/share/CIC/amounir/Final_ISA/0000441/', ...
};

final_accuracies = [];

for repI = 1:length(rep_paths)
    load([rep_paths{repI} 'VotesCRF.mat']);
    final_accuracies = [final_accuracies; [accuracies' avgacc]];
end

labels = {'', 'Background','Aeroplane','Bicycle','Bird','Boat','Bottle', ...
    'Bus','Car','Cat','Chair','Cow','Dinningtable','Dog','Horse', ...
    'Motorbike','Person','Pottedplant','Sheep','Sofa','Train', ...
    'TVmonitor', 'Avg Accuracy'};

for label = 1:length(labels)
    if(label > 1)
        fprintf('\n& ')
    end
    fprintf('{\\begin{sideways}%s\\end{sideways}}', labels{label});
end

fprintf('\\\\\n');

segs_labels = {'Best Mix(GB+MS+MC)', ...
    'Worst Mix(GB+MS)' ...
    };

for seg_id = 1:size(final_accuracies, 1)
    fprintf('%s', segs_labels{seg_id})
    
    accs = final_accuracies(seg_id, :);
    for acc_val = 1:length(accs)
        fprintf(' & %d', round(accs(acc_val)));
    end
    
    fprintf('\\\\\n');
end
