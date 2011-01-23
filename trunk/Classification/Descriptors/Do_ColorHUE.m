function descriptor_points=Do_ColorHUE(im,descriptor_name,image_dir,points,scale_magnif)

im=imread(im);
im=im2double(im);

if isscalar(points)   %%%%%%%%% for Dense detection %%%%%%%%%
    % settings
    number_of_bins=36;
    sigma_xy=points/2*scale_magnif;           %%%%%% scale %%% previously used to be: sigma_xy=1;
    sigma_z=3;
    %%%%%%% Do Hue Description %%%%%%%%%
    hue_desc=DenseHueDescriptor2(im,number_of_bins,sigma_xy,sigma_z);
    hue_desc=reshape(hue_desc,[],number_of_bins);
    descriptor_points=hue_desc;

else                 %%%%%%%%% for Grid detection %%%%%%%%%%
    %%%% Settings
    number_of_bins=36;
    sigma_z=3;
    get_scale=max(points(:,3));
    sigma_xy=get_scale/2*scale_magnif; 
    
    hue_desc=DenseHueDescriptor2(im,number_of_bins,sigma_xy,sigma_z);
    
    %%%%% Extracting Patches %%%%%%%%%
    points_grid=[points(:,1),points(:,2)];
    im_patch=extract_patch_new(hue_desc,points_grid);
    
   
   
    %%%%%%% Do Hue Description %%%%%%%%%
%     hue_desc=DenseHueDescriptor2(im_grid,number_of_bins,sigma_xy,sigma_z);
%     hue_desc=reshape(hue_desc,[],number_of_bins);
    descriptor_points=im_patch;
   
end   
    
save ([image_dir,'/',descriptor_name],'descriptor_points');
