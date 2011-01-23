function Sift_result=Do_ColorSIFT_UVA(im,descriptor_name,image_dir,points_detect,siftscone,opts,i,descriptor_opts)
% % command1=sprintf('convert %s //media/DATA/Datasets/Texture_own/Temp/milan1.jpj',im);
% % system(command1);
% load(opts.image_names)
% %%%% if we give our own detector %%%%
% %   b=convert_detector_UVA(points_detect);
% 
% 
%  command2=sprintf('//home/fahad/Datasets/Temp/compute_ColorSIFT_UVA_par.bash %s %s %d', im, image_names{i},siftscone);
% system(command2);
% 
% % fid1=fopen('/media/DATA/Datasets/Texture_own/Temp/milan1.txt');
% % descriptor_points=Convert_ColorSIFT_UVA(fid1);
% 
% 
% 
% fid1=fopen(sprintf('/home/fahad/Datasets/Temp/%s.ColorUVApoints.txt',image_names{i}));
% descriptor_points=Convert_ColorSIFT_UVA(fid1);
%         
%         
% 
% 
% 
% 
% 
% Sift_result=descriptor_points;
% 
% 
% save ([image_dir,'/',descriptor_name],'descriptor_points')
% 
% fclose(fid1);




%%%%%%%%%%%%%%%%% try
load(opts.image_names)
load(opts.data_locations)
im=sprintf('%s/%s',opts.imgpath,image_names{i}); %%% Get the image ready
                    %%% Descriptor name used to save the results
        image_dir=data_locations{i};                     %%% where to save the results, directs to the specific image folder
        i
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
        
%        %%%%%%%% Load the detector points %%%%%%%%
%         points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
%         points_detect = getfield(points_out,'detector_points');  
%         
%         if(size(points_detect,2)<4)
%          save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}),[points_detect,zeros(size(points_detect,1),1)]);   
%         else
%         %%%%%%%% Save the detector points Harris lapLace, DOG; Grid_Dorko (Normal) Case %%%%%%%%
%         save_points(sprintf('/home/fahad/Datasets/Temp/%s.detector_points.txt',image_names{i}),points_detect);
%         end
%         
%         img_nm=image_names{i};
%         img_nm_full=strcat(img_nm,'.O1');
%         %%%%%%%%  FOR CHANNEL O1: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
%         command4=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full, img_nm_full,siftscone);
%         system(command4);
%         
%         %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
%         points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O1.siftpoints.txt', image_names{i}));
%         points_sift=reshape(points_load,132,size(points_load,1)/132);
%         points1=points_sift(5:132,:);
%         descriptor_points=points1;
%         
%         img_nm_full2=strcat(img_nm,'.O2');
%         %%%%%%%%  FOR CHANNEL O2: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
%         command5=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.pgm %s %d', img_nm_full2, img_nm_full2,siftscone);
%         system(command5);
%         
%         %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
%         points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O2.siftpoints.txt', image_names{i}));
%         points_sift=reshape(points_load,132,size(points_load,1)/132);
%         points2=points_sift(5:132,:);
%         descriptor_points=[descriptor_points;points2];
%         
%         img_nm_full3=strcat(img_nm,'.O3');
%         %%%%%%%%  FOR CHANNEL O3: Call the bash script to perform the SIFT description from Dorko's library %%%%%%%%%
%         command6=sprintf('//home/fahad/Datasets/Temp/compute_sift.bash //home/fahad/Datasets/Temp/%s.O3.pgm %s %d', img_nm_full3, img_nm_full3,siftscone);
%         system(command6);
%         
%         %%%%%%%% Load the dscriptor points computed above %%%%%%%%%
%         points_load=load_vector(sprintf('/home/fahad/Datasets/Temp/%s.O3.siftpoints.txt', image_names{i}));
%         points_sift=reshape(points_load,132,size(points_load,1)/132);
%         points3=points_sift(5:132,:);
%         descriptor_points=[descriptor_points;points3]/3;
%         
%         descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
%         descriptor_points=descriptor_points';
%         save ([image_dir,'/',descriptor_name],'descriptor_points')