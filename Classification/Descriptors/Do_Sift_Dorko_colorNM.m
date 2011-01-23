function descriptor_points=Do_Sift_Dorko_colorNM(im,descriptor_name,image_dir,points_detect,siftscone)
load w2c        % load the RGB to color name matrix
% siftscone=1;
im=imread(im);
im=im2double(im);

% sigma=points/2*scale_magnif;

index1=im2c(im*255,w2c,-2); % compute the probability of the color names for all pixels
%    if(sigma~=0)
%      index1=color_gauss(index1,sigma,0,0);
%    end


%%%%% Extract 11 color names %%%%%%
O1=index1(:,:,1);   O1=reshape(O1,size(O1,1),size(O1,2));
O2=index1(:,:,2);   O2=reshape(O2,size(O2,1),size(O2,2));
O3=index1(:,:,3);   O3=reshape(O3,size(O3,1),size(O3,2));
O4=index1(:,:,4);   O4=reshape(O4,size(O4,1),size(O4,2));
O5=index1(:,:,5);   O5=reshape(O5,size(O5,1),size(O5,2));
O6=index1(:,:,6);   O6=reshape(O6,size(O6,1),size(O6,2));
O7=index1(:,:,7);   O7=reshape(O7,size(O7,1),size(O7,2));
O8=index1(:,:,8);   O8=reshape(O8,size(O8,1),size(O8,2));
O9=index1(:,:,9);   O9=reshape(O9,size(O9,1),size(O9,2));
O10=index1(:,:,10); O10=reshape(O10,size(O10,1),size(O10,2));
O11=index1(:,:,11); O11=reshape(O11,size(O11,1),size(O11,2));


%%%%%%%%%%%%%%%%% color Name 1: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O1/max(O1(:))),'/media/DATA/Datasets/Texture_own/Temp/O1.tif','tif');
WriteImage(O1, '/media/DATA/Datasets/Texture_own/Temp/O1')
abc='/media/DATA/Datasets/Texture_own/Temp/O1.tif';
command1=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O1.pgm',abc);
system(command1);

%%%%%%%%%%%%%%%%% color Name 2: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O2/max(O2(:))),'/media/DATA/Datasets/Texture_own/Temp/O2.tif','tif');
WriteImage(O2, '/media/DATA/Datasets/Texture_own/Temp/O2')
abc1='/media/DATA/Datasets/Texture_own/Temp/O2.tif';
command2=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O2.pgm',abc1);
system(command2);

%%%%%%%%%%%%%%%%% color Name 3: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O3, '/media/DATA/Datasets/Texture_own/Temp/O3')
abc2='/media/DATA/Datasets/Texture_own/Temp/O3.tif';
command3=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O3.pgm',abc2);
system(command3);

%%%%%%%%%%%%%%%%% color Name 4: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O4, '/media/DATA/Datasets/Texture_own/Temp/O4')
abc3='/media/DATA/Datasets/Texture_own/Temp/O4.tif';
command4=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O4.pgm',abc3);
system(command4);

%%%%%%%%%%%%%%%%% color Name 5: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O5, '/media/DATA/Datasets/Texture_own/Temp/O5')
abc4='/media/DATA/Datasets/Texture_own/Temp/O5.tif';
command5=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O5.pgm',abc4);
system(command5);

%%%%%%%%%%%%%%%%% color Name 6: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O6, '/media/DATA/Datasets/Texture_own/Temp/O6')
abc5='/media/DATA/Datasets/Texture_own/Temp/O6.tif';
command6=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O6.pgm',abc5);
system(command6);

%%%%%%%%%%%%%%%%% color Name 7: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O7, '/media/DATA/Datasets/Texture_own/Temp/O7')
abc6='/media/DATA/Datasets/Texture_own/Temp/O7.tif';
command7=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O7.pgm',abc6);
system(command7);

%%%%%%%%%%%%%%%%% color Name 8: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O8, '/media/DATA/Datasets/Texture_own/Temp/O8')
abc7='/media/DATA/Datasets/Texture_own/Temp/O8.tif';
command8=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O8.pgm',abc7);
system(command8);

%%%%%%%%%%%%%%%%% color Name 9: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O9, '/media/DATA/Datasets/Texture_own/Temp/O9')
abc8='/media/DATA/Datasets/Texture_own/Temp/O9.tif';
command9=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O9.pgm',abc8);
system(command9);

%%%%%%%%%%%%%%%%% color Name 10: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O10, '/media/DATA/Datasets/Texture_own/Temp/O10')
abc9='/media/DATA/Datasets/Texture_own/Temp/O10.tif';
command10=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O10.pgm',abc9);
system(command10);

%%%%%%%%%%%%%%%%% color Name 11: %%%%%%%%%%%%%%%%%
% imwrite(uint8(255*O3/max(O3(:))),'/media/DATA/Datasets/Texture_own/Temp/O3.tif','tif');
WriteImage(O11, '/media/DATA/Datasets/Texture_own/Temp/O11')
abc10='/media/DATA/Datasets/Texture_own/Temp/O11.tif';
command11=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/O11.pgm',abc10);
system(command11);

%%%%%%%%%%%%%%%% Some preprocessing %%%%%%%%%%%%%%%
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


    %%%%%%%%%%%%%%%%% For Color Name 1 %%%%%%%%%%%%%%
    command12=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O1.pgm  %d',siftscone);
    system(command12);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O1 %%%%%%%%%%%%%
     points_load1=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
     points1=reshape(points_load1,132,size(points_load1,1)/132);
     points2=points1(5:132,:);
     descriptor_points=points2;
    
    %%%%%%%%%%%%%%%%% For Color Name 2 %%%%%%%%%%%%%%
    delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
    delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
    delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
    command13=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O2.pgm  %d',siftscone);
    system(command13);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load2=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_2=reshape(points_load2,132,size(points_load2,1)/132);
    points_2=points_2(5:132,:);
    descriptor_points=[descriptor_points;points_2];

    
    %%%%%%%%%%%%%%%%% For Color Name 3 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command14=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O3.pgm  %d',siftscone);
     system(command14);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_3=reshape(points_load3,132,size(points_load3,1)/132);
    points_3=points_3(5:132,:);
    descriptor_points=[descriptor_points;points_3];
    
    %%%%%%%%%%%%%%%%% For Color Name 4 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command16=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O4.pgm  %d',siftscone);
     system(command16);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_4=reshape(points_load3,132,size(points_load3,1)/132);
    points_4=points_4(5:132,:);
    descriptor_points=[descriptor_points;points_4];
    
    %%%%%%%%%%%%%%%%% For Color Name 5 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command17=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O5.pgm  %d',siftscone);
     system(command17);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_5=reshape(points_load3,132,size(points_load3,1)/132);
    points_5=points_5(5:132,:);
    descriptor_points=[descriptor_points;points_5];
    
    %%%%%%%%%%%%%%%%% For Color Name 6 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command18=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O6.pgm  %d',siftscone);
     system(command18);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_6=reshape(points_load3,132,size(points_load3,1)/132);
    points_6=points_6(5:132,:);
    descriptor_points=[descriptor_points;points_6];
    
     %%%%%%%%%%%%%%%%% For Color Name 7 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command19=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O7.pgm  %d',siftscone);
     system(command19);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_7=reshape(points_load3,132,size(points_load3,1)/132);
    points_7=points_7(5:132,:);
    descriptor_points=[descriptor_points;points_7];
    
    %%%%%%%%%%%%%%%%% For Color Name 8 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command20=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O8.pgm  %d',siftscone);
     system(command20);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_8=reshape(points_load3,132,size(points_load3,1)/132);
    points_8=points_8(5:132,:);
    descriptor_points=[descriptor_points;points_8];
    
    %%%%%%%%%%%%%%%%% For Color Name 9 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command21=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O9.pgm  %d',siftscone);
     system(command21);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_9=reshape(points_load3,132,size(points_load3,1)/132);
    points_9=points_9(5:132,:);
    descriptor_points=[descriptor_points;points_9];
    
    %%%%%%%%%%%%%%%%% For Color Name 10 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command22=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O10.pgm  %d',siftscone);
     system(command22);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_10=reshape(points_load3,132,size(points_load3,1)/132);
    points_10=points_10(5:132,:);
    descriptor_points=[descriptor_points;points_10];
    
    %%%%%%%%%%%%%%%%% For Color Name 11 %%%%%%%%%%%%%%
     delete('/media/DATA/Datasets/Texture_own/Temp/points.txt')
     delete('/media/DATA/Datasets/Texture_own/Temp/log.corns')
     delete('/media/DATA/Datasets/Texture_own/Temp/points.temp')
     command23=sprintf('/media/DATA/Datasets/Texture_own/Temp/compute_sift.bash O11.pgm  %d',siftscone);
     system(command23);
    %%%%%%%%%%%%%%%%% Read The points from Points.txt for channal O2 %%%%%%%%%%%%%
    points_load3=load_vector('/media/DATA/Datasets/Texture_own/Temp/points.txt');
    points_11=reshape(points_load3,132,size(points_load3,1)/132);
    points_11=points_11(5:132,:);
    descriptor_points=[descriptor_points;points_11]/11;
    
    
    
    
    
    

  descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
  descriptor_points=descriptor_points';
  save ([image_dir,'/',descriptor_name],'descriptor_points')
