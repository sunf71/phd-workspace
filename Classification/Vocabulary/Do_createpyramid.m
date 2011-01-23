function All_hist=Do_createpyramid(im_index,pyramidslevel,pyramidtype)

%% 
                   

                   %%%%%%%%%% Create the shape of pyramids according to the pyramid type option %%%%%%%%%%%
xy_range=Do_pyramidshape1(im_index,pyramidslevel,pyramidtype);
All_hist=[];

  for i=1:pyramidslevel
        
                   %%%%%%%%%% Create a pyramid mask %%%%%%%%%%%
                  
               pyramid_mask=im_index.data ((im_index.x > xy_range.xlow{i}) & (im_index.x <= xy_range.xhigh{i}) & ...
                                           (im_index.y >  xy_range.ylow{i}) & (im_index.y <= xy_range.yhigh{i})) ;

                   %%%%%%%%%% Build the histogram of current pyramid level %%%%%%%%%% 
                   
               histogram_level{i}=hist(im_index.data.*(pyramid_mask));
               
  
 
                  
                  
  end    
  
                   %%%%%%%%%%%% Combine all the histograms %%%%%%%%%%%%%%%
                   for i=1:pyramidslevel
                       
                       All_hist=[All_hist, histogram_level{i}];
                   
                   end