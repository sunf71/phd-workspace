function []=run_detector(opts,dtype)
% run detector on data set

load(opts.image_names)
load(opts.data_locations)
load(opts.nimages)

for i=1:nimages
    DoG_color(sprintf('%s/%s',opts.imgpath,image_names{i}),'DoG',data_locations{i},diag(3),0,0);
end