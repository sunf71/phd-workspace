safeExit = 0;

while (~safeExit)

safeExit = 1;

try

clear param;
neighbors = [4 3 2 1 0];
dict_sizes = [400];
classifiers = {'svm'};

globalparam = struct();
globalparam.prefix  = ...
    '/home/amounir/Workspace/ClassSegmentation/results/MeanShift_1_VOC2010';
globalparam.crf = 1;
globalparam.crf_trainmethod = 'gridsearch';
globalparam.crf_restrict = 0;
globalparam.pascal_submission_test = 0;

globalparam.detections = 1;

% globalparam.segmentationType = 'quickshift';
globalparam.segmentationType = 'meanshift';
% globalparam.segmentationType = 'graphbased';
% globalparam.segmentationType = 'normalizedcut';

if 0
globalparam.qseg_sigma = 4;
globalparam.qseg_ratio = 0.5;
globalparam.qseg_tau = 6;
globalparam.qseg_tag = sprintf('s%dr%.1ft%d', globalparam.qseg_sigma, ...
  globalparam.qseg_ratio, globalparam.qseg_tau);
end

%%%%%%%%%%%%%% Pascal 2010
for cl = 1:length(classifiers)
for d = 1:length(dict_sizes)
for n = 1:length(neighbors)
  param = globalparam;
  param.crf_traingoal = 'intersection-union';
  param.classifier = classifiers{cl};
  param.dict_size = dict_sizes(d);
  if param.dict_size ~= 400
    param.dict_tag = sprintf('ikm%d', param.dict_size);
  end
  param.db_type = 'pascal2010';
  param.db_path = '/home/amounir/Workspace/ClassSegmentation/VOCdevkit';
  param.db_tag  = 'p10';
  param.fg_cat  = '';
  param.testall = 1;
  param.feat_dsift_size = 3;
  param.feat_tag = sprintf('dsift%d', param.feat_dsift_size);
 
  param.hists_per_cat = 250;

  param.neighbors = neighbors(n);
  param.hists_per_image = 5;
  quickrec
  clear param;
end
end
end

catch
    system('chmod -R a+rwx .');
    safeExit = 0;
end

end
