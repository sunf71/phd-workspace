function detector_points=Do_DOG_Dorko_par(im,detector_name,image_dir)

% command1=sprintf('convert %s //home/fahad/Datasets/Temp/mar1.pgm',im);
command1=sprintf('./convert_pgm.sh %s //home/fahad/Datasets/Temp/%s.pgm', im, im);
system(command1);

command2=sprintf('//home/fahad/Datasets/Temp/compute_Dog_Dorko1.bash %s.pgm', im);
system(command2);
    
points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s_DoGDorkopoints.txt', im));
points1=reshape(points_load,4,size(points_load,1)/4);
detector_points=points1';
  


save ([image_dir,'/',detector_name], 'detector_points');