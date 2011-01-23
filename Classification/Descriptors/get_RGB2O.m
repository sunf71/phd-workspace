function [O1,O2,O3]= get_RGB2O(im)
im=imread(im);
im=im2double(im);
[O1,O2,O3]=RGB2O(im);