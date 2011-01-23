function descriptor_points=Do_Sift_Dorko_color1_javier(channels,descriptor_name,image_dir,points_detect,siftscone)
% siftscone=1;
O1=channels(:,:,1);
O2=channels(:,:,2);
O3=channels(:,:,3);

% im=imread(im);
% im=im2double(im);
% [O1,O2,O3]=RGB2O(im);


% imwrite(uint8(255*O1/max(O1(:))),'/media/DATA/Datasets/Texture_own/Temp/O1.tif','tif');
WriteImage(O1, '/media/DATA/Datasets/Texture_own/Temp/O1')
abc='/media/DATA/Datasets/Texture_own/Temp/O1.tif';
command1=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O1.pgm',abc);
system(command1);

% imwrite(uint8(255*O2/max(O2(:))),'/media/DATA/Datasets/Texture_own/Temp/O2.tif','tif');
WriteImage(O2, '/media/DATA/Datasets/Texture_own/Temp/O2')
abc1='/media/DATA/Datasets/Texture_own/Temp/O2.tif';
command2=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O2.pgm',abc1);
system(command2);
   
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O3, '/media/DATA/Datasets/Texture_own/Temp/O3')
abc2='/media/DATA/Datasets/Texture_own/Temp/O3.tif';
command3=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O3.pgm',abc2);
system(command3);

delete('/media/DATA/Datasets/Texture_own/Temp/detector_points.txt')
delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
% delete('/media/DATA/Datasets/Texture_own/Temp/points1.txt')
% delete('/media/DATA/Datasets/Texture_own/Temp/points2.txt')
% delete('/media/DATA/Datasets/Texture_own/Temp/log1.corns')
% delete('/media/DATA/Datasets/Texture_own/Temp/points1.temp')
% delete('/media/DATA/Datasets/Texture_own/Temp/log2.corns')
% delete('/media/DATA/Datasets/Texture_own/Temp/points2.temp')
delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')



save_points('/media/DATA/Datasets/Texture_own/Temp/detector_points.txt',[points_detect,zeros(size(points_detect,1),1)]);


    %%%%%%%%%%%%%%%%% For channal O1 %%%%%%%%%%%%%%
    command4=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O1.pgm  %d',siftscone);
    system(command4);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O1 %%%%%%%%%%%%%
     points_load1=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
     points1=reshape(points_load1,132,size(points_load1,1)/132);
     points2=points1(5:132,:);
     descriptor_points=points2;
    
    %%%%%%%%%%%%%%%%% For channal O2 %%%%%%%%%%%%%%
    delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
    delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
    delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
    command5=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O2.pgm  %d',siftscone);
    system(command5);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load2=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_2=reshape(points_load2,132,size(points_load2,1)/132);
    points_2=points_2(5:132,:);
    descriptor_points=[descriptor_points;points_2];

    
    %%%%%%%%%%%%%%%%% For channal O3 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command6=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O3.pgm  %d',siftscone);
     system(command6);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_3=reshape(points_load3,132,size(points_load3,1)/132);
    points_3=points_3(5:132,:);
    descriptor_points=[descriptor_points;points_3]/3;
    
    
    

  descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
  descriptor_points=descriptor_points';
  save ([image_dir,'/',descriptor_name],'descriptor_points')
