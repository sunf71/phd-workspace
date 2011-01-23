function xy_range=Do_pyramidshape1(im_index,pyramidslevel,pyramidtype)

%% 
                   %%%%%% Select the shape according to the pyramid type and levels %%%%%%% 
                   
switch (pyramidtype)
    case 1 %%%% lazebnik (CVPR 2006)
        

            if(pyramidslevel < 1)
            
                     %%%%% [ 1 1 h w] %%%%
                     xy_range.xlow{1}=1;                   xy_range.xhigh{1}=im_index.hgt; 
                     xy_range.ylow{1}=1;                   xy_range.yhigh{1}=im_index.wid; 
                     

            if (pyramidslevel < 2)   
                     
                     %%%%% [ 1  1  h/2  w/2] %%%%                Top left region
                     xy_range.xlow{2}=1;                         xy_range.xhigh{2}=round(im_index.hgt/2);    
                     xy_range.ylow{2}=1;                         xy_range.yhigh{2}=round(im_index.wid/2); 
                     
                     %%%%% [ h/2  1  h  w/2] %%%%                Bottom left region
                     xy_range.xlow{3}=round(im_index.hgt/2);     xy_range.xhigh{3}=im_index.hgt;    
                     xy_range.ylow{3}=1;                         xy_range.yhigh{3}=round(im_index.wid/2); 
                     
                     %%%%% [ 1  w/2  h/2  w] %%%%                Top right region
                     xy_range.xlow{4}=1;                         xy_range.xhigh{4}=round(im_index.hgt/2);    
                     xy_range.ylow{4}=round(im_index.wid/2);     xy_range.yhigh{4}=im_index.wid; 
                     
                     %%%%% [ h/2  w/2  h  w] %%%%                Bottom right region
                     xy_range.xlow{5}=round(im_index.hgt/2);     xy_range.xhigh{5}=im_index.hgt;    
                     xy_range.ylow{5}=round(im_index.wid/2);     xy_range.yhigh{5}=im_index.wid; 
                     

             if(pyramidslevel <3)
                       
                     %%%%% [1  1  h/4  w/4 ] %%%%                   %%% Region 1
                     xy_range.xlow{6}=1;                            xy_range.xhigh{6}=round(im_index.hgt/4);    
                     xy_range.ylow{6}=1;                            xy_range.yhigh{6}=round(im_index.wid/4);
                     
                     %%%%% [1  w/4  h/4  w/2 ] %%%%                 %%% Region 2
                     xy_range.xlow{7}=1;                            xy_range.xhigh{7}=round(im_index.hgt/4);    
                     xy_range.ylow{7}=round(im_index.wid/4);        xy_range.yhigh{7}=round(im_index.wid/2); 
                     
                     %%%%% [h/4  1  h/2  w/4 ] %%%%                 %%% Region 3
                     xy_range.xlow{8}=round(im_index.hgt/4);        xy_range.xhigh{8}=round(im_index.hgt/2);    
                     xy_range.ylow{8}=1;                            xy_range.yhigh{8}=round(im_index.wid/4); 
                     
                     %%%%% [h/4  w/4  h/2  w/2 ] %%%%               %%% Region 4
                     xy_range.xlow{9}=round(im_index.hgt/4);        xy_range.xhigh{9}=round(im_index.hgt/2);    
                     xy_range.ylow{9}=round(im_index.wid/4);        xy_range.yhigh{9}=round(im_index.wid/2); 
                     
                     %%%%% [1  w/2  h/4  3.*w/4 ] %%%%              %%% Region 5
                     xy_range.xlow{10}=1;                           xy_range.xhigh{10}=round(im_index.hgt/4);    
                     xy_range.ylow{10}=round(im_index.wid/2);       xy_range.yhigh{10}=round(3.*im_index.wid/4); 
                     
                     %%%%% [1  3.*w/4  h/4  w ] %%%%                %%% Region 6
                     xy_range.xlow{11}=1;                           xy_range.xhigh{11}=round(im_index.hgt/4);    
                     xy_range.ylow{11}=round(3.*im_index.wid/4);    xy_range.yhigh{11}=im_index.wid; 
                     
                     %%%%% [h/4  w/2  h/2  3.*w/4 ] %%%%            %%% Region 7
                     xy_range.xlow{12}=round(im_index.hgt/4);       xy_range.xhigh{12}=round(im_index.hgt/2);    
                     xy_range.ylow{12}=round(im_index.wid/2);       xy_range.yhigh{12}=round(3.*im_index.wid/4); 
                     
                     %%%%% [h/4  3.*w/4  h/2  w ] %%%%              %%% Region 8
                     xy_range.xlow{13}=round(im_index.hgt/4);       xy_range.xhigh{13}=round(im_index.hgt/2);    
                     xy_range.ylow{13}=round(3.*im_index.wid/4);    xy_range.yhigh{13}=im_index.wid; 
                     
                     %%%%% [h/2  1  3.*h/4  w/4 ] %%%%              %%% Region 9
                     xy_range.xlow{14}=round(im_index.hgt/2);       xy_range.xhigh{14}=round(3.*im_index.hgt/4);    
                     xy_range.ylow{14}=1;                           xy_range.yhigh{14}=round(im_index.wid/4); 
                     
                     %%%%% [h/2  w/4  3.*h/4  w/2 ] %%%%            %%% Region 10
                     xy_range.xlow{15}=round(im_index.hgt/2);       xy_range.xhigh{15}=round(3.*im_index.hgt/4);    
                     xy_range.ylow{15}=round(im_index.wid/4);       xy_range.yhigh{15}=round(im_index.wid/2);
                     
                     %%%%% [3.*h/4  1  h  w/4 ] %%%%                %%% Region 11
                     xy_range.xlow{16}=round(3.*im_index.hgt/4);    xy_range.xhigh{16}=im_index.hgt;    
                     xy_range.ylow{16}=1;                           xy_range.yhigh{16}=round(im_index.wid/4);
                     
                     %%%%% [3.*h/4  w/4  h  w/2 ] %%%%              %%% Region 12
                     xy_range.xlow{17}=round(3.*im_index.hgt/4);    xy_range.xhigh{17}=im_index.hgt;    
                     xy_range.ylow{17}=round(im_index.wid/4);       xy_range.yhigh{17}=round(im_index.wid/2);
                     
                     %%%%% [h/2  w/2  3.*h/4  3.*w/4 ] %%%%         %%% Region 13
                     xy_range.xlow{18}=round(im_index.hgt/2);       xy_range.xhigh{18}=round(3.*im_index.hgt/4);    
                     xy_range.ylow{18}=round(im_index.wid/2);       xy_range.yhigh{18}=round(3.*im_index.wid/4);
          
                     %%%%% [h/2  3.*w/4  3.*h/4  w ] %%%%           %%% Region 14
                     xy_range.xlow{19}=round(im_index.hgt/2);       xy_range.xhigh{19}=round(3.*im_index.hgt/4);    
                     xy_range.ylow{19}=round(3.*im_index.wid/4);    xy_range.yhigh{19}=im_index.wid;
                     
                     %%%%% [3.*h/4  w/2  h  3.*w/4 ] %%%%           %%% Region 15
                     xy_range.xlow{20}=round(3.*im_index.hgt/4);    xy_range.xhigh{20}=im_index.hgt;    
                     xy_range.ylow{20}=round(im_index.wid/2);       xy_range.yhigh{20}=round(3.*im_index.wid/4);
                     
                     %%%%% [3.*h/4  3.*w/4  h  w ] %%%%             %%% Region 16
                     xy_range.xlow{21}=round(3.*im_index.hgt/4);    xy_range.xhigh{21}=im_index.hgt;    
                     xy_range.ylow{21}=round(3.*im_index.wid/4);    xy_range.yhigh{21}=im_index.wid;
          
          
             end   % end of first if  
            end    % end of second if
           end       % end of third if 
     
end % pyramid type switch case