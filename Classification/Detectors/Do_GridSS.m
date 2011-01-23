 function detector_points=Do_GridSS(img,detector_name,image_dir,scale,grid_step)

% Function for Grid-Detection
% % Function for Grid-Detection
% input:
%   img      :   input image
%   scale    :   scale of feature points
%   grid_step:   distance between feature points
% output
%   grid_out :   [x,y,scale] of feature points

% if(nargin<4)	scale=2;	end
% if(nargin<5)    grid_step=10;	end
% img123=img;
img=imread(img);
img=im2double(img);

% marg=22; %%%% previous 1
marg=42;
[allXCoords,allYCoords]=meshgrid([marg+1:5:size(img,2)-marg],...
                                 [marg+1:5:size(img,1)-marg]);

allXCoords=allXCoords(:);
allYCoords=allYCoords(:);
detector_points=[allXCoords,allYCoords,ones(size(allXCoords,1)*size(allYCoords,2),1)*scale];

save ([image_dir,'/',detector_name], 'detector_points');




% a=(scale:grid_step:size(img,1)-scale);
% b=(scale:grid_step:size(img,2)-scale);

% a=(ceil(scale/2+1):grid_step:size(img,1)-scale/2);
% b=(ceil(scale/2+1):grid_step:size(img,2)-scale/2);
% 
% 
% [aa, bb]=ndgrid(a,b);
% % grid_out=[bb(:),aa(:),ones(size(aa,1)*size(aa,2),1)*scale];
% detector_points=[bb(:),aa(:),ones(size(aa,1)*size(aa,2),1)*scale];
% 
% save ([image_dir,'/',detector_name], 'detector_points');
