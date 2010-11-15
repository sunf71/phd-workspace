function [accs] = prepare_seg_accs(rootpath)

prefix = 'vismulti@p07_p07dsift3_m_';
suffix = '_250_svm_gridsearch';
from = 0;
to = 4;

accs = [];

for i = from:to
    s = sprintf('%s/%s%d%s', rootpath, prefix, i, suffix);
    rep = load(fullfile(s, 'report.mat'));
    accs = [accs rep.avgacc];
end

end
