function xy_range=Do_pyramidshape(im_index,pyramidslevel,pyramidtype)

%% 
                   %%%%%% Select the shape according to the pyramid type and levels %%%%%%% 
                   
switch (pyramidtype)
    case 1 %%%% lazebnik (CVPR 2006)
        
%           switch (pyramidslevel)
%                 case 0 %%%%% Standard Bow (1 X 1)   Level 0
            
                     %%%%% [ 1 1 h w] %%%%
                     xy_range.xlow{1}=1;                   xy_range.xhigh{1}=im_index.hgt; 
                     xy_range.ylow{1}=1;                   xy_range.yhigh{1}=im_index.wid; 
                     
%                 case 1 %%%%% (2 X 2) Level 1
                    
                     %%%%% [ 1  1  h  w] %%%%                Level 0 
                     xy_range.xlow{1}=1;                     xy_range.xhigh{1}=im_index.hgt; 
                     xy_range.ylow{1}=1;                     xy_range.yhigh{1}=im_index.wid; 
                     
                     %%%%% [ 1  1  h/2  w/2] %%%%            Top left region
                     xy_range.xlow{2}=1;                     xy_range.xhigh{2}=im_index.hgt/2;    
                     xy_range.ylow{2}=1;                     xy_range.yhigh{2}=im_index.wid/2; 
                     
                     %%%%% [ h/2  1  h  w/2] %%%%              Bottom left region
                     xy_range.xlow{3}=im_index.hgt/2;        xy_range.xhigh{3}=im_index.hgt;    
                     xy_range.ylow{3}=1;                     xy_range.yhigh{3}=im_index.wid/2; 
                     
                     %%%%% [ 1  w/2  h/2  w] %%%%          Top right region
                     xy_range.xlow{4}=1;                     xy_range.xhigh{4}=im_index.hgt/2;    
                     xy_range.ylow{4}=im_index.wid/2;        xy_range.yhigh{4}=im_index.wid; 
                     
                     %%%%% [ h/2  w/2  h  w] %%%%            Bottom right region
                     xy_range.xlow{5}=im_index.hgt/2;        xy_range.xhigh{5}=im_index.hgt;    
                     xy_range.ylow{5}=im_index.wid/2;        xy_range.yhigh{5}=im_index.wid; 
                     
%                  case 2 %%%%%% (4 X 4) Level 2
                   
                     %%%%% [ 1 1 w h] %%%%  1
                     xy_range.xlow{1}=1;        xy_range.xhigh{1}=im_index.hgt; 
                     xy_range.ylow{1}=1;        xy_range.yhigh{1}=im_index.wid; 
                     
                     %%%%% [ 1 1 w/2 h/2] %%%% 4
                     xy_range.xlow{2}=1;        xy_range.xhigh{2}=im_index.hgt/2;    
                     xy_range.ylow{2}=1;        xy_range.yhigh{2}=im_index.wid/2; 
                     
                      %%%%% [ w/2 w/2 w h] %%%% 16
                     xy_range.xlow{3}=1;        xy_range.xhigh{3}=im_index.hgt/2;    
                     xy_range.ylow{3}=1;        xy_range.yhigh{3}=im_index.wid/2; 
          
          
          
%           end % pyramids level switch case
     
end % pyramid type switch case