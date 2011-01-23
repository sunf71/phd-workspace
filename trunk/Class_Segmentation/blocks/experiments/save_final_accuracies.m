rep_paths = {'/home/amounir/Workspace/Superpixels-iccv2009/results/Original_Method_Parallelized/vismulti@p07_p07dsift3_m_0_250_svm_gridsearch/', ...
'/home/amounir/Workspace/Superpixels-iccv2009/results/MS_Parallelized_2/vismulti@p07_p07dsift3_m_0_250_svm_gridsearch/', ...
'/home/amounir/Workspace/Superpixels-iccv2009/results/GB_AN_1/vismulti@p07_p07dsift3_m_0_250_svm_gridsearch/', ...
'/home/amounir/Workspace/Superpixels-iccv2009/results/NCut_1/vismulti@p07_p07dsift3_m_0_250_svm_gridsearch/', ...
};

final_accuracies = [];

% close all
fig = figure('XVisual',...
    '0x27 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');

for repI = 1:length(rep_paths)
    load([rep_paths{repI} 'report.mat']);
    final_accuracies = [final_accuracies; accuracies'];
end

axes1 = axes('Parent',fig,...
    'XTickLabel',{'Background','Aeroplane','Bicycle','Bird','Boat','Bottle','Bus','Car','Cat','Chair','Cow','Dinningtable','Dog','Horse','Motorbike','Person','Pottedplant','Sheep','Sofa','Train','TVmonitor'},...
    'XTick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]);

xlim(axes1,[-1 21]);

hold(axes1,'all');
bar((0:20), final_accuracies', 'grouped', 'Parent', axes1);

legend('Superpixels', ...
    'Mean-shift', ...
    'Graph-Based', ...
    'Normalized-Cut')

  xlabel 'Classes'
  ylabel 'Accuracy'

hold off
save('/home/amounir/Workspace/Superpixels-iccv2009/results/final_accuracies.mat', ...
    'final_accuracies', '-MAT');

