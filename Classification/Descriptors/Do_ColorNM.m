function descriptor_points=Do_ColorNM(im,descriptor_name,image_dir,points,scale_magnif,detector_name,normalize_patch_size)

load w2c        % load the RGB to color name matrix
im=imread(im);
im=im2double(im);

%  if isscalar(points)   %%%%%%%%% for Dense detection %%%%%%%%%
if(strcmp(detector_name,'Dense'))
   sigma=points/2*scale_magnif;

   index1=im2c(im*255,w2c,-2); % compute the probability of the color names for all pixels
   if(sigma~=0)
     index1=color_gauss(index1,sigma,0,0);
   end
   index1=reshape(index1,[],11);
   descriptor_points=index1;

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
else                                                 %%%%%%%%% for DOG, Harrlap, LOG detectors etc %%%%%%%%
     %%%% Settings
%      points(:,3)=points(:,3)*scale_magnif;
     
     %%%%%%%to convert to Krystian format %%%%%%%%
%       points_scale=1./((points(:,3)).^2);
%       points=[points(:,1),points(:,2),points_scale,zeros(size(points,1),1),points_scale];

     %%%%%%% Dorko _format, Donot use any more %%%%%%%%%%%%
%        points=[points(:,1),points(:,2),points(:,3),zeros(size(points,1),1),ones(size(points,1),1),zeros(size(points,1),1),ones(size(points,1),1)];
     %%%%%%%%
     
     
     %%%%%% convert color patches and normalize them %%%%%
%      patches_out=color_normalize_regions1(im,points,normalize_patch_size); %%%% used for Dorko's format
       
%        patches_out=color_normalize_regions_original1(im,points,normalize_patch_size); %%% used for krysitian's format

     patches_out=normalize_features1(im,points,normalize_patch_size,scale_magnif);
     
     half_size=floor(normalize_patch_size/2);     
     sigma=half_size/2;     
     %%%%% compute spatial weighting (Gauss)
     [yy,xx]=ndgrid(1:2*half_size+1,1:2*half_size+1);
%      [yy,xx]=ndgrid(1:2*half_size,1:2*half_size);
     gauss=1/(2*pi*sigma.^2)*exp(-( (yy-half_size-1).^2+(xx-half_size-1).^2)/(2*sigma.^2));

     
     
     %%%%%%% Do Color Names Description %%%%%%%%%
     if(0)
         patches_R=patches_out(:,:,1)*255;patches_G=patches_out(:,:,2)*255;patches_B=patches_out(:,:,3)*255;
         descriptor_points=zeros(11,size(patches_out,2));  
         load('w2c_4096.mat')
         cw=normalize(wc+eps,2)';
         for kk=1:size(patches_out,2)
               c_hist=Hist3D_cubic(patches_R(:,kk),patches_G(:,kk),patches_B(:,kk),0,255,0,255,0,255,16,16,16);
               c_hist=reshape(c_hist,4096,1);
               c_hist=c_hist./sum(c_hist+eps);
               descriptor_points(:,kk)=cw*c_hist;
         end
         %%%%% the O/P of descriptor_points is 11*Num_features which needs to be opposite before saving %%%%%%%%
         descriptor_points=descriptor_points';
     else
         CN_im=im2c(patches_out*255,w2c,-2); % compute the probability of the color names for all pixels
         descriptors_points=sum(CN_im.*repmat(reshape(gauss,size(CN_im,1),1),[1,size(CN_im,2),size(CN_im,3)]),1);
         

         %%%%%%% To reshape the elements into detector_points*11 (11---> color Names) %%%%%%%%
         descriptor_points=reshape(descriptors_points,[size(descriptors_points,2),size(descriptors_points,3)]);
     end
     %descriptor_points=im_patch;
end

save ([image_dir,'/',descriptor_name],'descriptor_points');

