 function Sift_result=Do_Sift(im,descriptor_name,image_dir,points_detect,scale_magnif)
 % at the moment only works for grid because the scale should be constant
 
 im=imread(im);
 im=im2double(im);
 sift_scale=max(points_detect(:,3))/3*scale_magnif;  % sift will describe a region in the image of size 6*sift_scale
 points_detect1=[points_detect(:,1),points_detect(:,2),zeros(size(points_detect,1),1)];
 
 if(size(im,3)>1)
        if(max(im(:))>1)
            im = rgb2gray(im/255) ;    
        else
            im = rgb2gray(im);    
        end
 end
 Is = imsmooth(im,sqrt(sift_scale^2 - 0.5^2)) ;
%  sift_descriptor = siftdescriptor(Is, points_detect1(:,1:3)',scale ) ;
 sift_descriptor = siftdescriptor(Is, points_detect1',sift_scale ) ;
 Sift_result = sift_descriptor./(eps+ones(size(sift_descriptor,1),1)*sum(sift_descriptor));
 descriptor_points=Sift_result';
 save ([image_dir,'/',descriptor_name],'descriptor_points');
