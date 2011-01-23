function descriptor_points=Do_ColorLSPACE(im,descriptor_name,image_dir,points,scale_magnif,detector_name,normalize_patch_size)

im=imread(im);
im=im2double(im);

if isscalar(points)   %%%%%%%%% for Dense detection %%%%%%%%%
    sigma=points/2*scale_magnif;
    im=color_gauss(im,sigma,0,0);    
    bc=reshape(im,[],3);
    descriptor_points=bc;
else                  %%%%%%%%% for Grid detection %%%%%%%%%%
    
    patches_out=normalize_features1(im,points,normalize_patch_size,scale_magnif);
    patches_R=patches_out(:,:,1)*255;patches_G=patches_out(:,:,2)*255;patches_B=patches_out(:,:,3)*255;
    
    %%%% Formula to incorporate LSPACE 
    patches_R=1/3.*((patches_R+patches_G+patches_B)+eps);
    patches_G=1/2.*((patches_R-patches_B)+eps);
    patches_B=1/2.*(((2.*patches_G)-patches_R-patches_B)+eps);
    
    
    [YY,XX]=ndgrid(-10:10,-10:10);
    weight=exp(-(XX.^2+YY.^2)/50);
    weight=weight(:)/sum(weight(:));
    RR=sum(patches_R.*(weight*ones(1,size(patches_R,2))));
    GG=sum(patches_G.*(weight*ones(1,size(patches_G,2))));
    BB=sum(patches_B.*(weight*ones(1,size(patches_B,2))));
    descriptor_points=[RR',GG',BB'];
    
%     get_scale=max(points(:,3));
%     sigma=get_scale/2*scale_magnif;
%                        %%%%% Extracting Patches %%%%%%%%%
%     im=color_gauss(im,sigma,0,0);    
%     points_grid=[points(:,1),points(:,2)];
%     patch_im=extract_patch_new(im,points_grid);
%     descriptor_points=patch_im;
                       
    
end
save ([image_dir,'/',descriptor_name],'descriptor_points');
