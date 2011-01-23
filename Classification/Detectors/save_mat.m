scale_try1=keys(:,3);
scale_try=1./sqrt(scale_try1);
detector_points=[keys(:,1),keys(:,2),scale_try];
save ([image_descriptor_dir,'/',detector_name], 'detector_points');