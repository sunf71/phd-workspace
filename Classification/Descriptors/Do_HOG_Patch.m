function Texture_result=Do_HOG_Patch(im,descriptor_name,image_dir,points,scale_magnif,normalize_patch_size)

%     %%%% read image and some early preprocessing %%%%% 
%      image=imread(im);
%      imt=sum(image,3)/3;
%      imt=im2double(imt);
% 
%  
%   %%  
%     imt_all=cat(3,imt,imt,imt);
%     patches_out=normalize_features1(imt_all,points,normalize_patch_size,scale_magnif);
%     pt11=patches_out(:,:,1);
%     pt12=reshape(pt11,normalize_patch_size,normalize_patch_size,size(patches_out,2));
%     for ik=1:size(patches_out,2)
%         pt_cell{ik}=pt12(:,:,ik);
%     end
%     pt_cell=cellfun(@uint8, pt_cell,'UniformOutput',false);
%     index_lbp_try1=cellfun(@(xx)  Do_PHOG_Patch(xx),pt_cell,'UniformOutput',false);
%     %% Collect all the LBP's for each image 
%     descriptor_points=zeros(size(patches_out,2),size(index_lbp_try1{1},1));
%        for kk=1:size(patches_out,2)
%            act1=index_lbp_try1{kk};
%            act2=act1(:);
%            descriptor_points(kk,:)=act2;
%        end
%        Texture_result=descriptor_points;
%  
%  save ([image_dir,'/',descriptor_name],'descriptor_points');


%% uncomment the above code if use in serial way
%%% the code below is only to use for parralel on cluster

 %%%% read image and some early preprocessing %%%%% 
     image=imread(im);
     imt=sum(image,3)/3;
     imt=im2double(imt);

 
  %%  
    imt_all=cat(3,imt,imt,imt);
    patches_out=normalize_features1(imt_all,points,normalize_patch_size,scale_magnif);
    pt11=patches_out(:,:,1);
    pt12=reshape(pt11,normalize_patch_size,normalize_patch_size,size(patches_out,2));
    for ik=1:size(patches_out,2)
        pt_cell{ik}=pt12(:,:,ik);
    end
    pt_cell=cellfun(@uint8, pt_cell,'UniformOutput',false);
    descriptor_points=zeros(size(patches_out,2),210);
    for i=1:length(pt_cell)
        current_patch=pt_cell{i};
        PHOG_result=Do_PHOG_Patch(current_patch);
        descriptor_points(i,:)=PHOG_result;
    end    
        
    Texture_result=descriptor_points;
 
 save ([image_dir,'/',descriptor_name],'descriptor_points');