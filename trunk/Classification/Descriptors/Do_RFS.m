function RFS_result=Do_RFS(im,descriptor_name,image_dir,points,scale_magnif,detector_name,normalize_patch_size)

    %%%% read image and some early preprocessing %%%%% 
     image=imread(im);

    image=im2double(image);
    image=sum(image,3)/3;
      
 if(strcmp(detector_name,'DoG'))  %%%% At the moment its for dense use
     
      F=makeRFSfilters;
      responses(:,:,11)=conv2(image,F(:,:,11),'valid');
    
%      [featvec] = MR8fast(image);
      descriptor_points1=responses;
      
      descriptor_points=reshape(descriptor_points1,size(descriptor_points1,1)*size(descriptor_points1,2),size(descriptor_points1,3));
      RFS_result=descriptor_points;
     
     
 end


 
     
 
 save ([image_dir,'/',descriptor_name],'descriptor_points');