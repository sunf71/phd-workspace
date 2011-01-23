function Texture_result=Do_HOG(im,descriptor_name,image_dir,points,scale_magnif,normalize_patch_size)

    %%%% read image and some early preprocessing %%%%% 
     image=imread(im);
      imt=sum(image,3)/3;
     imt=im2double(imt);

 
  %%  
     imt_all=cat(3,imt,imt,imt);
    patches_out=normalize_features1(imt_all,points,normalize_patch_size,scale_magnif);
    pt11=patches_out(:,:,1);
    pt12=reshape(pt11,normalize_patch_size,normalize_patch_size,size(patches_out,2));
    
    for kt=1:size(patches_out,2)
        feat = features_opp(pt12(:,:,kt), 8);
        feats = feat(:);
        descriptor_points(kt,:)=feats;
    end
    
%     for ik=1:size(patches_out,2)
%         pt_cell{ik}=pt12(:,:,ik);
%     end
%     pt_cell=cellfun(@uint8, pt_cell,'UniformOutput',false);
%     index_lbp_try1=cellfun(@(xx)  Do_PHOG_Patch(xx),pt_cell,'UniformOutput',false);
%     %% Collect all the LBP's for each image 
%     descriptor_points=zeros(size(patches_out,2),50);
%        for kk=1:size(patches_out,2)
%            act1=index_lbp_try1{kk};
%            act2=act1(:);
%            descriptor_points(kk,:)=act2;
%        end
       Texture_result=descriptor_points(:,1:31);
 

 

 
 
 
    
 
 save ([image_dir,'/',descriptor_name],'descriptor_points');