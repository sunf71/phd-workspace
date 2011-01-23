function [Iseg map] = segment_mix(imInd)

% Load original image
imPath = sprintf('/home/amounir/Workspace/Superpixels-iccv2009/results/Pascal2007MixRADSegs/%05d.mat', imInd);
mixStruct = load(imPath);

Iseg = mixStruct.Iseg;
map = mixStruct.map;

end
