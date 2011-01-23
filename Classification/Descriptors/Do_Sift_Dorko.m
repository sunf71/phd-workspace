function Sift_result=Do_Sift_Dorko(im,descriptor_name,image_dir,points_detect,siftscone)
% siftscone=1;
command1=sprintf('//home/fahad/Matlab_code/convert_pgm.sh %s //home/fahad/Datasets/Temp/mar1.pgm',im);
system(command1);

if(size(points_detect,2)<4)
    %%%%%%%% Grid Detection Case %%%%%%%%%%
    save_points('/home/fahad/Datasets/Temp/detector_points.txt',[points_detect,zeros(size(points_detect,1),1)]);
else
    %%%%%%%% Harris lapLace Case %%%%%%%%
%   save_points('/media/DATA/Datasets/Texture_own/Temp/detector_points.txt',points_detect(:,1:4));


save_points('/home/fahad/Datasets/Temp/detector_points.txt',points_detect(:,:));
%By noha    
%save_points('/home/fahad/Datasets/Temp/detector_points_15scenes.txt',points_detect(:,:));
end

% command2=sprintf('/home/fahad/Datasets/Temp/compute_sift_new.bash mar1.pgm %d',siftscone);
% command2=sprintf('/home/fahad/Datasets/Temp/compute_sift_rot.bash mar1.pgm %d',siftscone);
command2=sprintf('/home/fahad/Datasets/Temp/compute_sift_new.bash mar1.pgm %d',siftscone);
system(command2);

% [sift]=read_corners_txt('/media/DATA/Datasets/Texture_own/Temp/points.txt');  

    points_load=load_vector('/home/fahad/Datasets/Temp/points.txt');
    points1=reshape(points_load,132,size(points_load,1)/132);
    points2=points1(5:132,:);
    descriptor_points=points2';
    Sift_result=descriptor_points;
    
%% Additional steps only for Inria data set where we just take 128*64 window size
% image_read=imread(im);
% [height width dim]=size(image_read);
% 
% desired_height=128;
% desired_width=64;
% 
% x_lo=floor((width-desired_width)/2);
% x_hi=x_lo+desired_width;
% 
% y_lo=floor((height-desired_height)/2);
% y_hi=y_lo+desired_height;
% 
% % x_lo=floor((height-desired_height)/2);
% % x_hi=x_lo+desired_height;
% % 
% % y_lo=floor((width-desired_width)/2);
% % y_hi=y_lo+desired_width;
% 
% %%%%%%%%%%% make a mask to only take points inside the window (128*64)
% points_detect=points_detect(:,1:2);
% detector_points=points_detect((points_detect(:,1) > x_lo) & (points_detect(:,1) <= x_hi) & ...
%                 (points_detect(:,2) > y_lo) & (points_detect(:,2) <= y_hi),:);
% 
% sift_points=points1';
% descriptor_points=sift_points((sift_points(:,1) > x_lo) & (sift_points(:,1) <= x_hi) & ...
%                 (sift_points(:,2) > y_lo) & (sift_points(:,2) <= y_hi),:);
% descriptor_points=descriptor_points(:,5:132);

%descriptor_points=Sift_result';
 save ([image_dir,'/',descriptor_name],'descriptor_points')
%   save ([image_dir,'/','modified_points'],'detector_points')
