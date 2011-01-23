function All_hist=Convert_Image_Hist_Inria(opts,assignment_opts,index_im,im,patch_step,image_dir)
index=index_im(:,5);
points=index_im(:,1:2);
[H,W]=size(im);
% window parameter
IW=64; IH=128;
samples_x=(0:patch_step:W-IW);
samples_y=(0:patch_step:H-IH);
counter=1;
tic;
profile on
for i=1:length(samples_y)
    for j=1:length(samples_x)
       
        %% take each points in this window 
        win_x_lo = samples_x(j);
        win_y_lo = samples_y(i);
        win_x_hi = samples_x(j)+IW;
        win_y_hi = samples_y(i)+IH;
%        win_patch = index((points(:,1) > win_x_lo) & (points(:,1) <= win_x_hi) & ...
%                (points(:,2) > win_y_lo) & (points(:,2) <=win_y_hi));
        
       All_hist1(:,counter)=Do_assignment_pyramids_Inria(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
        counter=counter+1;
    end
end
toc;
All_hist=All_hist1;

 save ([image_dir,'/','histogram_test_sift'], 'All_hist');