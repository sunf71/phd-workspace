function Sift_result=do_descriptor_range(opts,descriptor_opts,start_images, end_images)
load(opts.image_names);
load(opts.data_locations);

for i=start_images:end_images
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Actual Detection Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (strcmp(descriptor_opts.type,'SIFT_Dorko')) %%%%%%%%%% SIFT Descriptor
        
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder

        %%%%%%%% Convert the image into PGM format %%%%%%%%%%%
        command1=sprintf('//home/fahad/Matlab_code/convert_pgm.sh %s //home/fahad/Datasets/Temp/%s.pgm', im, image_names{i});
        system(command1);
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}),points_detect);
        end
        
        %%%%%%%% Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command2=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', image_names{i}, image_names{i},descriptor_opts.scale_magnif);
        system(command2);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points2=points_sift(5:132,:);
        descriptor_points=points2';
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name], 'descriptor_points');
        
        
        %%%%%% Delete All Temporary Files %%%%%%%%%%
        %%%%%%%%%%%%%% Detector points.txt %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}));
       
        %%%%%%%%%%%%%% LOG.Corns files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',image_names{i}));
        
        %%%%%%%%%%%%%% Points.temp files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',image_names{i}));
        
         %%%%%%%%%%%%%% siftpoints.txt files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',image_names{i}));
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rotation Invariance SIFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%
    elseif (strcmp(descriptor_opts.type,'SIFT_Dorko_Rot')) %%%%%%%%%% SIFT Descriptor
        
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder

        %%%%%%%% Convert the image into PGM format %%%%%%%%%%%
        command1=sprintf('//home/fahad/Matlab_code/convert_pgm.sh %s //home/fahad/Datasets/Temp/%s.pgm', im, image_names{i});
        system(command1);
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}),points_detect);
        end
        
        %%%%%%%% Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command2=sprintf('//home/fahad/Datasets/Temp/compute_sift_rot.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', image_names{i}, image_names{i},descriptor_opts.scale_magnif);
        system(command2);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points2=points_sift(5:132,:);
        descriptor_points=points2';
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name], 'descriptor_points');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Opponent SIFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
       elseif (strcmp(descriptor_opts.type,'Opp_SIFT')) %%%%%%%%%% SIFT Descriptor
        
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        im=imread(im);
        im=im2double(im);
        [O1,O2,O3]=RGB2O(im);
        
        WriteImage(O1, sprintf('/home/fahad/Datasets/Temp/%s.O1',image_names{i}))
        abc=sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i});
        command1=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O1.pgm',abc,image_names{i});
        system(command1);
        
        WriteImage(O2, sprintf('/home/fahad/Datasets/Temp/%s.O2',image_names{i}))
        abc2=sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i});
        command2=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O2.pgm',abc2,image_names{i});
        system(command2);
        
        WriteImage(O3, sprintf('/home/fahad/Datasets/Temp/%s.O3',image_names{i}))
        abc3=sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i});
        command3=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O3.pgm',abc3,image_names{i});
        system(command3);
        
       %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        
        img_nm=image_names{i};
        img_nm_full=strcat(img_nm,'.O1');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),points_detect);
        end
        
        %%  FOR CHANNEL O1: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command4=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full, img_nm_full,descriptor_opts.scale_magnif);
        system(command4);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O1.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points1=points_sift(5:132,:);
        descriptor_points=points1;
        
        %%  FOR CHANNEL O2: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        
        img_nm_full2=strcat(img_nm,'.O2');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),points_detect);
        end
        
        
        command5=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full2, img_nm_full2,descriptor_opts.scale_magnif);
        system(command5);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O2.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points2=points_sift(5:132,:);
        descriptor_points=[descriptor_points;points2];
        
        %%  FOR CHANNEL O3: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        
        img_nm_full3=strcat(img_nm,'.O3');
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),points_detect);
        end
        
        
        command6=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.O3.pgm %s %d', img_nm_full3, img_nm_full3,descriptor_opts.scale_magnif);
        system(command6);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O3.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points3=points_sift(5:132,:);
        descriptor_points=[descriptor_points;points3]/3;
        
        descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
        descriptor_points=descriptor_points';
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name],'descriptor_points')
        
        %%      DELETE ALL TEMPORARY FILES         
        
        %%%%%%%%%%%%%% deleting all temp files %%%%%%%%%%%%%%
        %%%%%%%%%%%%%% TIF Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i}));
        %%%%%%%%%%%%%% PGM Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.pgm',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.pgm',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.pgm',image_names{i}));
        %%%%%%%%%%%%%% Detector points.txt %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3));
        %%%%%%%%%%%%%% LOG.Corns files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full3));
        %%%%%%%%%%%%%% Points.temp files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full3));
         %%%%%%%%%%%%%% siftpoints.txt files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full3));
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WSIFT (CVPR2008 )%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%
 elseif (strcmp(descriptor_opts.type,'WSIFT')) %%%%%%%%%% SIFT Descriptor
        
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        im=imread(im);
        im=im2double(im);
       
%         O1=im(:,:,1);
%         O2=im(:,:,2);
        
        [O11,O12,O13]=RGB2O(im);
        O1=O11./(O13+eps);
        O2=O12./(O13+eps);
        
        WriteImage(O1, sprintf('/home/fahad/Datasets/Temp/%s.O1',image_names{i}))
        abc=sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i});
        command1=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O1.pgm',abc,image_names{i});
        system(command1);
        
        WriteImage(O2, sprintf('/home/fahad/Datasets/Temp/%s.O2',image_names{i}))
        abc2=sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i});
        command2=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O2.pgm',abc2,image_names{i});
        system(command2);
        
%         WriteImage(O3, sprintf('/home/fahad/Datasets/Temp/%s.O3',image_names{i}))
%         abc3=sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i});
%         command3=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O3.pgm',abc3,image_names{i});
%         system(command3);
        
       %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        
        img_nm=image_names{i};
        img_nm_full=strcat(img_nm,'.O1');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),points_detect);
        end
        
        %%  FOR CHANNEL O1: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command4=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full, img_nm_full,descriptor_opts.scale_magnif);
        system(command4);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O1.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points1=points_sift(5:132,:);
        descriptor_points=points1;
        
        %%  FOR CHANNEL O2: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        
        img_nm_full2=strcat(img_nm,'.O2');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),points_detect);
        end
        
        
        command5=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full2, img_nm_full2,descriptor_opts.scale_magnif);
        system(command5);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O2.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points2=points_sift(5:132,:);
        descriptor_points=[descriptor_points;points2]/2;
        
%         %%  FOR CHANNEL O3: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
%         
%         img_nm_full3=strcat(img_nm,'.O3');
%         if(size(points_detect,2)<4)
%          save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),[points_detect,zeros(size(points_detect,1),1)]);   
%         else
%         %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
%         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),points_detect);
%         end
%         
%         
%         command6=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.O3.pgm %s %d', img_nm_full3, img_nm_full3,descriptor_opts.scale_magnif);
%         system(command6);
%         
%         %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
%         points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O3.siftpoints.txt', image_names{i}));
%         points_sift=reshape(points_load,132,size(points_load,1)/132);
%         points3=points_sift(5:132,:);
%         descriptor_points=[descriptor_points;points3]/3;
        
        descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
        descriptor_points=descriptor_points';
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name],'descriptor_points')
        
        %%      DELETE ALL TEMPORARY FILES         
        
        %%%%%%%%%%%%%% deleting all temp files %%%%%%%%%%%%%%
        %%%%%%%%%%%%%% TIF Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i}));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i}));
        %%%%%%%%%%%%%% PGM Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.pgm',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.pgm',image_names{i}));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.pgm',image_names{i}));
        %%%%%%%%%%%%%% Detector points.txt %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3));
        %%%%%%%%%%%%%% LOG.Corns files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full3));
        %%%%%%%%%%%%%% Points.temp files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full3));
         %%%%%%%%%%%%%% siftpoints.txt files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full3));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   END WSIFT %%%%%%%%%%%%%%%%%
    elseif (strcmp(descriptor_opts.type,'UVA_RGSIFT')) %%%%%%%%%% Van de sande descriptors
         %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points'); 
        
        %%%%%%%% Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command2=sprintf('//home/fahad/Datasets/Temp/compute_ColorSIFT_UVA_par.bash %s %s %d', im, image_names{i},descriptor_opts.scale_magnif);
        system(command2);
        
        fid1=fopen(sprintf('/home/fahad/Datasets/Temp/%s.ColorUVApoints.txt',image_names{i}));
        descriptor_points=Convert_ColorSIFT_UVA(fid1);
        
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name], 'descriptor_points');
        fclose(fid1);
        
    elseif (strcmp(descriptor_opts.type,'ColorHUE_7')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        Do_ColorHUE_7(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);

        Sift_result=points_detect;
        
    elseif (strcmp(descriptor_opts.type,'SS')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        

        Do_SelfSimilarity(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i});

        Sift_result=points_detect;
        
        
    elseif (strcmp(descriptor_opts.type,'ColorNM')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        Do_ColorNM(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);

        Sift_result=points_detect;
        
    elseif (strcmp(descriptor_opts.type,'Texture_Patch')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
                                                      
        Do_Texture_Patch(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.texture_type,descriptor_opts.normalize_patch_size);

        Sift_result=points_detect;
   
        
   elseif (strcmp(descriptor_opts.type,'HOG_Patch')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
                                                      
        Do_HOG_Patch(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.normalize_patch_size);

        Sift_result=points_detect;
        
    elseif (strcmp(descriptor_opts.type,'HOG')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
                                                      
        Do_HOG(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.normalize_patch_size);

        Sift_result=points_detect;
        
   elseif (strcmp(descriptor_opts.type,'GIST')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
                                                      
        Do_GIST_BOW(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.normalize_patch_size);

        Sift_result=points_detect;
   elseif (strcmp(descriptor_opts.type,'Opp_Color')) %%%%%%%%%% DOG detector
    
        
        
        %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        Do_ColorOPP(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points_detect,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size,descriptor_opts.mirror_flag);

        Sift_result=points_detect;
    
    elseif (strcmp(descriptor_opts.type,'Grid_Dorko')) %%%%%%%%%% DOG detector
    
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
        
     elseif (strcmp(descriptor_opts.type,'YUVSIFT')) %%%%%%%%%% SIFT Descriptor
        
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        im=imread(im);
        im=im2double(im);
        
        %%%% to compute LSLM %%%%
%         O1=0.209(im(:,:,1)-0.5)+0.715(im(:,:,2)-0.5)+0.076(im(:,:,3)-0.5);
        
%          O1=im(:,:,1);
%         O2=im(:,:,2);
%         O3=im(:,:,3);
        
        %%%% LSIFT
%         O1=1/3.*((im(:,:,1)+im(:,:,2)+im(:,:,3))+eps);
%         O2=1/2.*((im(:,:,1)-im(:,:,3))+eps);
%         O3=1/4.*(((2.*im(:,:,2))-im(:,:,1)-im(:,:,3))+eps);
        
        %%% YUV SIFT
        O1=(0.299.*im(:,:,1))+(0.587.*im(:,:,2))+(0.114.*im(:,:,3));
        O2=(-0.147.*im(:,:,1))-(0.289.*im(:,:,2))+(0.436.*im(:,:,3));
        O3=(0.615.*im(:,:,1))-(0.515.*im(:,:,2))-(0.100.*im(:,:,3));
       
        %%%% CMY SIFT
%         O1=(1-im(:,:,1))+eps;
%         O2=(1-im(:,:,2))+eps;
%         O3=(1-im(:,:,3))+eps;

%         [O1,O2,O3]=RGB2O(im);
        
        WriteImage(O1, sprintf('/home/fahad/Datasets/Temp/%s.O1',image_names{i}))
        abc=sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i});
        command1=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O1.pgm',abc,image_names{i});
        system(command1);
        
        WriteImage(O2, sprintf('/home/fahad/Datasets/Temp/%s.O2',image_names{i}))
        abc2=sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i});
        command2=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O2.pgm',abc2,image_names{i});
        system(command2);
        
        WriteImage(O3, sprintf('/home/fahad/Datasets/Temp/%s.O3',image_names{i}))
        abc3=sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i});
        command3=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O3.pgm',abc3,image_names{i});
        system(command3);
        
       %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        
        img_nm=image_names{i};
        img_nm_full=strcat(img_nm,'.O1');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),points_detect);
        end
        
        %%  FOR CHANNEL O1: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command4=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full, img_nm_full,descriptor_opts.scale_magnif);
        system(command4);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O1.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points1=points_sift(5:132,:);
        descriptor_points=points1;
        
        %%  FOR CHANNEL O2: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        
        img_nm_full2=strcat(img_nm,'.O2');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),points_detect);
        end
        
        
        command5=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full2, img_nm_full2,descriptor_opts.scale_magnif);
        system(command5);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O2.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points2=points_sift(5:132,:);
        descriptor_points=[descriptor_points;points2];
        
        %%  FOR CHANNEL O3: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        
        img_nm_full3=strcat(img_nm,'.O3');
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),points_detect);
        end
        
        
        command6=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.O3.pgm %s %d', img_nm_full3, img_nm_full3,descriptor_opts.scale_magnif);
        system(command6);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O3.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points3=points_sift(5:132,:);
        descriptor_points=[descriptor_points;points3]/3;
        
        descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
        descriptor_points=descriptor_points';
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name],'descriptor_points')
        
        %%      DELETE ALL TEMPORARY FILES         
        
        %%%%%%%%%%%%%% deleting all temp files %%%%%%%%%%%%%%
        %%%%%%%%%%%%%% TIF Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i}));
        %%%%%%%%%%%%%% PGM Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.pgm',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.pgm',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.pgm',image_names{i}));
        %%%%%%%%%%%%%% Detector points.txt %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3));
        %%%%%%%%%%%%%% LOG.Corns files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full3));
        %%%%%%%%%%%%%% Points.temp files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full3));
         %%%%%%%%%%%%%% siftpoints.txt files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full2));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full3));
    
%     end
    
    elseif (strcmp(descriptor_opts.type,'BoostSIFT')) %%%%%%%%%% SIFT Descriptor
        
        %%%%%%%%   Initializations %%%%%%%%%%%    
        im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
        descriptor_name=descriptor_opts.name;            %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        
        im=imread(im);
        im=im2double(im);
       
        simg1=BoostScript(im);       %%%%% saliency based on boosting
        a=max(simg1(:));
        sal_im1=simg1./a;
        
        [O11,O12,O13]=RGB2O(im);
        O1=sal_im1;
        O2=O13;
        
        WriteImage(O1, sprintf('/home/fahad/Datasets/Temp/%s.O1',image_names{i}))
        abc=sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i});
        command1=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O1.pgm',abc,image_names{i});
        system(command1);
        
        WriteImage(O2, sprintf('/home/fahad/Datasets/Temp/%s.O2',image_names{i}))
        abc2=sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i});
        command2=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O2.pgm',abc2,image_names{i});
        system(command2);
        
%         WriteImage(O3, sprintf('/home/fahad/Datasets/Temp/%s.O3',image_names{i}))
%         abc3=sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i});
%         command3=sprintf('convert %s //home/fahad/Datasets/Temp/%s.O3.pgm',abc3,image_names{i});
%         system(command3);
        
       %%%%%%%% Load the detector points %%%%%%%%
        points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
        points_detect = getfield(points_out,'detector_points');  
        
        
        
        img_nm=image_names{i};
        img_nm_full=strcat(img_nm,'.O1');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full),points_detect);
        end
        
        %%  FOR CHANNEL O1: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        command4=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full, img_nm_full,descriptor_opts.scale_magnif);
        system(command4);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O1.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points1=points_sift(5:132,:);
        descriptor_points=points1;
        
        %%  FOR CHANNEL O2: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
        
        img_nm_full2=strcat(img_nm,'.O2');
        
        if(size(points_detect,2)<4)
         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),[points_detect,zeros(size(points_detect,1),1)]);   
        else
        %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
        save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2),points_detect);
        end
        
        
        command5=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full2, img_nm_full2,descriptor_opts.scale_magnif);
        system(command5);
        
        %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
        points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O2.siftpoints.txt', image_names{i}));
        points_sift=reshape(points_load,132,size(points_load,1)/132);
        points2=points_sift(5:132,:);
        descriptor_points=[descriptor_points;points2]/2;
        
%         %%  FOR CHANNEL O3: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
%         
%         img_nm_full3=strcat(img_nm,'.O3');
%         if(size(points_detect,2)<4)
%          save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),[points_detect,zeros(size(points_detect,1),1)]);   
%         else
%         %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
%         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3),points_detect);
%         end
%         
%         
%         command6=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.O3.pgm %s %d', img_nm_full3, img_nm_full3,descriptor_opts.scale_magnif);
%         system(command6);
%         
%         %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
%         points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O3.siftpoints.txt', image_names{i}));
%         points_sift=reshape(points_load,132,size(points_load,1)/132);
%         points3=points_sift(5:132,:);
%         descriptor_points=[descriptor_points;points3]/3;
        
        descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
        descriptor_points=descriptor_points';
        Sift_result=descriptor_points;
        save ([image_dir,'/',descriptor_name],'descriptor_points')
        
        %%      DELETE ALL TEMPORARY FILES         
        
        %%%%%%%%%%%%%% deleting all temp files %%%%%%%%%%%%%%
        %%%%%%%%%%%%%% TIF Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.tif',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.tif',image_names{i}));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.tif',image_names{i}));
        %%%%%%%%%%%%%% PGM Images %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O1.pgm',image_names{i}));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.O2.pgm',image_names{i}));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.O3.pgm',image_names{i}));
        %%%%%%%%%%%%%% Detector points.txt %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',img_nm_full3));
        %%%%%%%%%%%%%% LOG.Corns files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.log.corns',img_nm_full3));
        %%%%%%%%%%%%%% Points.temp files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.points.temp',img_nm_full3));
         %%%%%%%%%%%%%% siftpoints.txt files %%%%%%%%%%%%%%%%%%
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full));
        delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full2));
%         delete(sprintf('/home/fahad/Datasets/Temp/%s.siftpoints.txt',img_nm_full3));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   END WSIFT %%%%%%%%%%%%%%%%%
      end
end
