function [Iseg map] = read_mixed_seg(seg_id)

opdir = 'OppsegSegs';
ifname = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/results/%s/%05d.mat', opdir, seg_id);
load(ifname);

end