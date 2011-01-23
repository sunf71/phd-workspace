% load('home/fahad/Matlab_code/points_total_original_30sr.mat');
% load('points_flowers_sift_sparse.mat');
% display('points for sparse coding and computing voc of 300 loaded!!');
% %%%%%% Sparse Coding
% nBases=300;
% beta=1e-3;
% gamma = 0.15;
% num_iters=50;
%  [B, S, stat] = reg_sparse_coding(points_total1', nBases, eye(nBases), beta, gamma, num_iters);
% 
% 
% 
% %%%%%%%%%% for Fast Kmeans %%%%%%%%%%%%%
% %   [voc,IDX]=Fast_kmeans(points_total1, 500);
% %  [IDX,voc,sumdist]=kmeans(points_total1, 2000,'EmptyAction','singleton','display','final');
% 
% save ('/home/fahad/Matlab_code/flowers_voc_sparse_300','B');
% save ('/home/fahad/Matlab_code/flowers_sparse_code_300','S');
% display('Sparse vocabulary computed and saved Now !!!!!!');


load('PositivePoints.mat');
load('NegativePoints.mat');
points_total111=[points_total;points_total1];
size(points_total111)
display('points for sparse coding and computing voc of 3000 loaded!!');
%%%%%% Sparse Coding
nBases=1000;
beta=1e-3;
gamma = 0.15;
num_iters=10;
 [B, S, stat] = reg_sparse_coding(points_total111', nBases, eye(nBases), beta, gamma, num_iters);



%%%%%%%%%% for Fast Kmeans %%%%%%%%%%%%%
%    [voc,IDX]=Fast_kmeans(points_total1, 500);
%  [IDX,voc,sumdist]=kmeans(points_total1, 2000,'EmptyAction','singleton','display','final');

 save ('/home/fahad/Matlab_code/voc_rao_1000','B');
 save ('/home/fahad/Matlab_code/sparse_code_rao_1000','S');
% save ('/home/fahad/Matlab_code/Inria_1000_SIFT_Sparse','voc');
display('Sparse vocabulary computed and saved Now !!!!!!');