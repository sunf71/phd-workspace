function MR8_result=Do_MR8(im,descriptor_name,image_dir,points,scale_magnif,detector_name,normalize_patch_size)

    %%%% read image and some early preprocessing %%%%% 
     image=imread(im);

    image=im2double(image);
    image=sum(image,3)/3;
      
 if(strcmp(detector_name,'DoG'))  %%%% At the moment its for dense use
    
     [featvec] = MR8fast(image);
     descriptor_points=featvec';
     MR8_result=descriptor_points;
     
     
 end


 
     
 
 save ([image_dir,'/',descriptor_name],'descriptor_points');