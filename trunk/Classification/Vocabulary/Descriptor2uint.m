function descriptor_points=Descriptor2uint(points_total,descriptor_name)

           %%%%%%%%%%% case DORKO SIFT normalized length=1%%%%%%%%%%%
           
 if(strcmp(descriptor_name,'SIFT'))
     descriptor_points=uint8(points_total.*255);
 end
 
 
 descriptor_points(descriptor_points>255)=255;