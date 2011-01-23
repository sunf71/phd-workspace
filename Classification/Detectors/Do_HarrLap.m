function detector_points=Do_HarrLap(im,detector_name,image_dir)

 command1=sprintf('./convert_pgm.sh %s //home/fahad/Datasets/Temp/mar1.pgm',im);
 system(command1);


command2=sprintf('//home/fahad/Datasets/Temp/compute_HarrLap_Dorko.bash mar1.pgm');
system(command2);
    
    points_load=load_vector('/home/fahad/Datasets/Temp/Harpoints.txt');
%     points1=reshape(points_load,4,size(points_load,1)/4); %%% when its dorko's format
      points1=reshape(points_load,4,size(points_load,1)/4);

 %   points2=points1(5:132,:);
    detector_points=points1';
  %  Sift_result=descriptor_points;
  
%     detector_points=detector_points(:,1:3);  %%%% used for Dorko's format


save ([image_dir,'/',detector_name], 'detector_points');
% pause