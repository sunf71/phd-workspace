function texton_index=Do_Getindex(im,image_dir,pyramid_opts,opts)

%%%% Load the indexes in order to build a pỳramid 
index_list=getfield(load([opts.data_assignmentpath,'/',pyramid_opts.index_name]),'index_list');

%%%% Get the descriptor points in order to get the x and y coordinates 
points_out=load([image_dir,'/',pyramid_opts.detector_name]);
points = getfield(points_out,'detector_points');

im1=imread(im);

%%%% make a structure in order to give it to the build pyramid funciton 
texton_index.data=index_list;  %%%% indexes
texton_index.x=points(:,2);
texton_index.y=points(:,1);
texton_index.wid=size(im1,2);
texton_index.hgt=size(im1,1);
