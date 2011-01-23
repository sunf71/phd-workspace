 function detector_points=Do_GridDetection(img,detector_name,image_dir,scale,grid_step)

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

% a=(scale:grid_step:size(img,1)-scale);
% b=(scale:grid_step:size(img,2)-scale);
a=(ceil(scale/2+1):grid_step:size(img,1)-scale/2);
b=(ceil(scale/2+1):grid_step:size(img,2)-scale/2);


[aa, bb]=ndgrid(a,b);
% grid_out=[bb(:),aa(:),ones(size(aa,1)*size(aa,2),1)*scale];
detector_points1=[bb(:),aa(:),ones(size(aa,1)*size(aa,2),1)*scale];

%%%% To do multi-scale grid of Anna Bosch style
dt1=detector_points1;
dt2=[dt1(:,1:2),ones(size(dt1,1),1)*4];
dt3=[dt1(:,1:2),ones(size(dt1,1),1)*6];
dt4=[dt1(:,1:2),ones(size(dt1,1),1)*8];
detector_points=[detector_points1;dt2];

save ([image_dir,'/',detector_name], 'detector_points');
