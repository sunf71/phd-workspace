function descriptor_points=Do_ColorHUE_7(im,descriptor_name,image_dir,points,scale_magnif,detector_name,normalize_patch_size)

im=imread(im);
im=im2double(im);
number_of_bins=36;
smooth_flag=3;

%  if isscalar(points)   %%%%%%%%% for Dense detection %%%%%%%%%
if(strcmp(detector_name,'Dense'))
%    sigma=points/2*scale_magnif;
% 
%    index1=im2c(im*255,w2c,-2); % compute the probability of the color names for all pixels
%    if(sigma~=0)
%      index1=color_gauss(index1,sigma,0,0);
%    end
%    index1=reshape(index1,[],11);
%    descriptor_points=index1;

% elseif(strcmp(detector_name,'Grid'))                 %%%%%%%%% for Grid detection %%%%%%%%%%
%     %%%% Settings
%      get_scale=max(points(:,3));
%      sigma=get_scale/2*scale_magnif;
%      
%      %%%%%%% Do Color Names Description %%%%%%%%%
%      
%      index1=im2c(im*255,w2c,-2); % compute the probability of the color names for all pixels
%      if(sigma~=0)
%         index1=color_gauss(index1,sigma,0,0);
%      end
%      %%%%% Extracting Patches %%%%%%%%%
%      points_grid=[ceil(points(:,1)),ceil(points(:,2))];
%      im_patch=extract_patch_new(index1,points_grid);
%      descriptor_points=im_patch;

%%%% un comment the code , if to use the normalize patch code of kristian's code modification
% else                                                 %%%%%%%%% for DOG, Harrlap, LOG detectors etc %%%%%%%%
%      %%%% Settings
%      points(:,3)=points(:,3)*scale_magnif;
%      
%      %%%%%%%to convert to Krystian format %%%%%%%%
%       points_scale=1./((points(:,3)).^2);
%       points=[points(:,1),points(:,2),points_scale,zeros(size(points,1),1),points_scale];
% 
%      %%%%%%% Dorko _format %%%%%%%%%%%%
% %        points=[points(:,1),points(:,2),points(:,3),zeros(size(points,1),1),ones(size(points,1),1),zeros(size(points,1),1),ones(size(points,1),1)];
%      
%      
%      
%      %%%%%% convert color patches and normalize them %%%%%
% %      patches_out=color_normalize_regions1(im,points,normalize_patch_size); %%%% used for Dorko's format
%        patches_out=color_normalize_regions_original1(im,points,normalize_patch_size); %%% used for krysitian's format
% 
% 
% 
%      
%       patches_R=patches_out(:,:,1)*255;patches_G=patches_out(:,:,2)*255;patches_B=patches_out(:,:,3)*255;
%       
%       
%       %%%%%%%%% Compute Opponent Descriptor %%%%%%%%%%%
%       
%       descriptor_points=compute_hue_descriptor7(patches_R,patches_G,patches_B,number_of_bins,smooth_flag);
%       
%       %%%%%%% the outcome is 36*Num_features which should be transposed  before saved %%%%%%%
%       descriptor_points=descriptor_points';
   
  else                                                 %%%%%%%%% for DOG, Harrlap, LOG detectors etc %%%%%%%%
     %%%% Settings
     
     
     
     patches_out=normalize_features1(im,points,normalize_patch_size,scale_magnif);

     patches_R=patches_out(:,:,1)*255;patches_G=patches_out(:,:,2)*255;patches_B=patches_out(:,:,3)*255;
      
      
     %%%%%%%%% Compute Opponent Descriptor %%%%%%%%%%%
      
     descriptor_points=compute_hue_descriptor7(patches_R,patches_G,patches_B,number_of_bins,smooth_flag);
      
     %%%%%%% the outcome is 36*Num_features which should be transposed  before saved %%%%%%%
     descriptor_points=descriptor_points';

end

save ([image_dir,'/',descriptor_name],'descriptor_points');