function Texture_result=Do_Texture_Patch(im,descriptor_name,image_dir,points,scale_magnif,texture_type,normalize_patch_size)

    %%%% read image and some early preprocessing %%%%% 
     image=imread(im);
     imt=sum(image,3)/3;
     imt=im2double(imt);

 if(strcmp(texture_type,'Texture_TPLBP'))
    
    imt_all=cat(3,imt,imt,imt);
    patches_out=normalize_features1(imt_all,points,normalize_patch_size,scale_magnif);
    pt11=patches_out(:,:,1);
    pt12=reshape(pt11,normalize_patch_size,normalize_patch_size,size(patches_out,2));
    for ik=1:size(patches_out,2)
        pt_cell{ik}=pt12(:,:,ik);
    end
    index_lbp_try1=cellfun(@(xx) TPLBP(xx),pt_cell,'UniformOutput',false);
    %% Collect all the LBP's for each image 
    descriptor_points=zeros(size(patches_out,2),512);
       for kk=1:size(patches_out,2)
           act1=index_lbp_try1{kk};
           act2=act1(:);
           descriptor_points(kk,:)=act2;
       end
       Texture_result=descriptor_points;
 end

 if(strcmp(texture_type,'Texture_LBP'))
    
    imt_all=cat(3,imt,imt,imt);
    patches_out=normalize_features1(imt_all,points,normalize_patch_size,scale_magnif);
    pt11=patches_out(:,:,1);
    pt12=reshape(pt11,normalize_patch_size,normalize_patch_size,size(patches_out,2));
    for ik=1:size(patches_out,2)
        pt_cell{ik}=pt12(:,:,ik);
    end
    mapping=getmapping(8,'u2'); 
    index_lbp_try1=cellfun(@(xx) Do_CellLBP(xx,1,8,mapping,'nh'),pt_cell,'UniformOutput',false);
    %% Collect all the LBP's for each image 
    descriptor_points=zeros(size(patches_out,2),size(index_lbp_try1{1},2));
       for kk=1:size(patches_out,2)
           act1=index_lbp_try1{kk};
           act2=act1(:);
           descriptor_points(kk,:)=act2;
       end
       Texture_result=descriptor_points;
 end

if(strcmp(texture_type,'Texture_Complete_LBP'))
    
    imt_all=cat(3,imt,imt,imt);
    patches_out=normalize_features1(imt_all,points,normalize_patch_size,scale_magnif);
    pt11=patches_out(:,:,1);
    pt12=reshape(pt11,normalize_patch_size,normalize_patch_size,size(patches_out,2));
    for ik=1:size(patches_out,2)
        pt_cell{ik}=pt12(:,:,ik);
    end
    mapping=getmapping(8,'u2'); 
    index_lbp_try1=cellfun(@(xx) Do_CellLBP(xx,1,8,mapping,'nh'),pt_cell,'UniformOutput',false);
    %% Collect all the LBP's for each image 
    descriptor_points_u2=zeros(size(patches_out,2),size(index_lbp_try1{1},2));
       for kk=1:size(patches_out,2)
           act1=index_lbp_try1{kk};
           act2=act1(:);
           descriptor_points_u2(kk,:)=act2;
       end
       
       %% Collect riu2 LBP
      mapping=getmapping(8,'riu2'); 
      index_lbp_try2=cellfun(@(xx) Do_CellLBP(xx,2,8,mapping,'nh'),pt_cell,'UniformOutput',false);
      descriptor_points_riu2=zeros(size(patches_out,2),size(index_lbp_try2{1},2));
       for kk=1:size(patches_out,2)
           act1=index_lbp_try2{kk};
           act2=act1(:);
           descriptor_points_riu2(kk,:)=act2;
       end
       
       %% Complete LBP code
       mapping=getmapping_clbp(8,'u2'); 
       [index_lbp_try3,index_lbp_try4]=cellfun(@(xx) Do_CellCLBP(xx,1,8,mapping,'nh'),pt_cell,'UniformOutput',false);
      descriptor_points_clbp=zeros(size(patches_out,2),size(index_lbp_try3{1},2));
       for kk=1:size(patches_out,2)
           act1=index_lbp_try3{kk};
           act2=act1(:);
           descriptor_points_clbp(kk,:)=act2;
       end
       descriptor_points_clbp2=zeros(size(patches_out,2),size(index_lbp_try4{1},2));
       for kk=1:size(patches_out,2)
           act1=index_lbp_try4{kk};
           act2=act1(:);
           descriptor_points_clbp2(kk,:)=act2;
       end
       
       descriptor_points=[descriptor_points_u2,descriptor_points_riu2,descriptor_points_clbp,descriptor_points_clbp2];
       Texture_result=descriptor_points;
end
 
 
 
    
 
 save ([image_dir,'/',descriptor_name],'descriptor_points');