neighs = [0:4];

sp = '/home/amounir/Workspace/Superpixels-iccv2009/results/MixedWithOutliers';
ms = '/home/amounir/Workspace/Superpixels-iccv2009/results/MixedWithOppseg';
gb = '/home/amounir/Workspace/Superpixels-iccv2009/results/MixedWithRAD';

figure

[accs] = prepare_seg_accs(sp);
plot(neighs, accs, '--bs', 'LineWidth', 2);
hold on;

[accs] = prepare_seg_accs(ms);
plot(neighs, accs, '--gs', 'LineWidth', 2);
hold on;

[accs] = prepare_seg_accs(gb);
plot(neighs, accs, '--rs', 'LineWidth', 2);
hold on;
 
title('Neighbourhood effect on average accuracy');
  xlabel 'Neighbourhood'
  ylabel 'Average accuracy'

legend('Outliers','Altseg','RAD');

hold off;
