old_results_dir = '/home/amounir/results/MS_Parallelized_2';
new_results_dir = '/home/amounir/results/MS_Parallelized_2';

cd(old_results_dir);
dirs = dir;

for d = 1:length(dirs)
  if(strcmp(dirs(d).name, '.') || strcmp(dirs(d).name, '..'))
      continue;
  end
  if(dirs(d).isdir)
    cd(dirs(d).name);
    if(exist('cfg.mat', 'file') == 2)
      cfg = load('cfg.mat');
      cfg.path = new_results_dir;
      save('cfg.mat','-STRUCT', 'cfg');
    end
    cd('..');
  end
end
