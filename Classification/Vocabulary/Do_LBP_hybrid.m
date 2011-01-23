function [descriptor_points,patch_index]=Do_LBP_hybrid(img,image_dir,LBP_option,detector_points)
%%% LBP_optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if(strcmp(LBP_option,'LBP'))
    mapping=getmapping(16,'u2'); 
    im = imread(img);
    im=im2double(im);
    im=sum(im,3)/3;
    index = lbp(im,2,16,mapping,'h');
    descriptor_points=index;
    
elseif(strcmp(LBP_option,'LBP_Rot'))
%     mapping=getmapping(16,'riu2'); 
    mapping1=getmapping(8,'riu2'); 
%     mapping2=getmapping(24,'riu2'); 
    im = imread(img);
    im=im2double(im);
    im=sum(im,3)/3;
    
    %% for First LBP_Rot 
%     index1 = lbp(im,2,8,mapping1,'h');
    index_1 = lbp(im,2,8,mapping1,'noth');
    index_1=index_1(:,:)+1;
    %%% for second LBP_Rot
%     index_lbp12=lbp(im,3,16,mapping,'h');
    %%%% for third LBP_Rot
%     index_lbp125=lbp(im,5,24,mapping2,'h');
     
    
    %%% Extract detector_points from the LBP code image %%%%
%     patch_im=extract_patch_new(index_1,floor(detector_points));
         detector_points=floor(detector_points);
        test2=reshape(index_1,size(index_1,1)*size(index_1,2),1);
        index2=sub2ind([size(index_1,1),size(index_1,2)],detector_points(:,2),detector_points(:,1));
        patch_index=test2(index2,:);
        
   %%%% Creating the histogram of LBP code %%%%%%
   bins=max(max(mapping1))+1;
   descriptor_points=hist(index_1(detector_points(:,2):detector_points(:,1)),1:bins);
    
%     descriptor_points=index1;

end

save ([image_dir,'/',LBP_option], 'descriptor_points');
