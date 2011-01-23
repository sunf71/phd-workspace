% load('home/fahad/Matlab_code/points_total_original_30sr.mat');
load('sift_points_flowers_pyramids.mat');
display('points of 5 detectors loaded , starting computing flower pyramid check vocabulary !!');
% %%%%%%Uncomment in case of integer Kmeans
%  vl_setup
% % %%%%%%%% compute the hikmeans vocabulary 
%    points_total1=im2uint8(points_total1);
% %   points_total1=Descriptor2uint(points_total1,'SIFT');
%   display('Computing The Vocabulary Now !!!!!');
%   [voc,A] = vl_ikmeans(points_total1',6000,'method', 'elkan');


%%%%%%%%%% for Fast Kmeans %%%%%%%%%%%%%
  [voc,IDX]=Fast_kmeans(points_total1, 1000);
%  [IDX,voc,sumdist]=kmeans(points_total1, 2000,'EmptyAction','singleton','display','final');

save ('/home/fahad/Matlab_code/SIFT_flower_1000_pyramidcheck','voc');
display('vocabulary computed and saved Now !!!!!!');