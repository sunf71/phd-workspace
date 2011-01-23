function detector_points=do_detect_range(opts,detector_opts,start_images, end_images)
load(opts.image_names);
load(opts.data_locations);

for i=start_images:end_images
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Actual Detection Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (strcmp(detector_opts.type,'HarrLap')) %%%%%%%%%% HarrLap detector
        display('into the detector');
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        detector_name=detector_opts.name;                %%% Detector name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder

        %%%%%%%% Convert the image into PGM format %%%%%%%%%%%
        command1=sprintf('//home/fahad/Matlab_code/convert_pgm.sh %s //home/fahad/Datasets/Temp/%s.pgm', im, image_names{i});
        system(command1);

        %%%%%%%% Call the bash script to perform the detection from Dorko's library %%%%%%%%%
        command2=sprintf('//home/fahad/Datasets/Temp/compute_HarrLap_Dorko.bash //home/fahad/Datasets/Temp/%s.pgm %s', image_names{i}, image_names{i});
        system(command2);

        %%%%%%%% Load the detector points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.Harpoints.txt', image_names{i}));
        points1=reshape(points_load,4,size(points_load,1)/4);
        detector_points=points1';
        save ([image_dir,'/',detector_name], 'detector_points');
%        save('~/foo.mat', 'detector_points');
    end
    
    if (strcmp(detector_opts.type,'DOG_Dorko')) %%%%%%%%%% DOG detector
    
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        detector_name=detector_opts.name;                %%% Detector name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        %%%%%%%% Convert the image into PGM format %%%%%%%%%%%
        command1=sprintf('//home/fahad/Matlab_code/convert_pgm.sh %s //home/fahad/Datasets/Temp/%s.pgm', im, image_names{i});
        system(command1);
        
        %%%%%%%% Call the bash script to perform the detection from Dorko's library %%%%%%%%%
        command2=sprintf('//home/fahad/Datasets/Temp/compute_DOG_Dorkopar.bash //home/fahad/Datasets/Temp/%s.pgm %s', image_names{i},image_names{i});
        system(command2);
        
        %%%%%%%% Load the detector points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.DOGDorkopoints.txt', image_names{i}));
        points1=reshape(points_load,4,size(points_load,1)/4);
        detector_points=points1';


         save ([image_dir,'/',detector_name], 'detector_points');
    end
    
    if (strcmp(detector_opts.type,'Grid_Dorko')) %%%%%%%%%% DOG detector
    
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        detector_name=detector_opts.name;                %%% Detector name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        %%%%%%%% Convert the image into PGM format %%%%%%%%%%%
        command1=sprintf('//home/fahad/Matlab_code/convert_pgm.sh %s //home/fahad/Datasets/Temp/%s.pgm', im, image_names{i});
        system(command1);
        
        %%%%%%%% Call the bash script to perform the detection from Dorko's library %%%%%%%%%
        command2=sprintf('//home/fahad/Datasets/Temp/compute_Gridpar.bash //home/fahad/Datasets/Temp/%s.pgm %s', image_names{i}, image_names{i});
        system(command2);
        
        %%%%%%%% Load the detector points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.Gridpoints.txt', image_names{i}));
        points1=reshape(points_load,4,size(points_load,1)/4);
        detector_points=points1';

        save ([image_dir,'/',detector_name], 'detector_points');
    end
    
    if (strcmp(detector_opts.type,'HarLapv1_MS')) %%%%%%%%%% DOG detector
    
       detector_points=Do_HarrLapv1_MS(sprintf('%s/%s',opts.imgpath,image_names{i}),detector_opts.name,data_locations{i});   
    end
    if (strcmp(detector_opts.type,'BoostHarLapv1_MS')) %%%%%%%%%% DOG detector
    
       detector_points=Do_BoostHarrLapv1_MS(sprintf('%s/%s',opts.imgpath,image_names{i}),detector_opts.name,data_locations{i});   
        
    end
    if (strcmp(detector_opts.type,'LoG_MS')) %%%%%%%%%% DOG detector
    
        detector_points=Do_LoG_MS(sprintf('%s/%s',opts.imgpath,image_names{i}),detector_opts.name,data_locations{i});   
        
    end
    if (strcmp(detector_opts.type,'BoostLoG_MS'))
         detector_points=Do_BoostLoG_MS(sprintf('%s/%s',opts.imgpath,image_names{i}),detector_opts.name,data_locations{i});   
    end
        
      
end
