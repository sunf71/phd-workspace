function All_hist=Convert_Image_Hist_Inria2(opts,assignment_opts,index_im,im,patch_step,image_dir)
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


% for i=1:length(samples_y)
%     for j=1:length(samples_x)

%% added by me 

[aa, bb]=ndgrid(samples_x,samples_y);
total_patches=[aa(:), bb(:)];

patch_length=floor(length(total_patches)/6);
a1=1:patch_length;
 All_hist1=zeros(6300,length(a1));
for mk=1:patch_length
    
    win_x_lo = total_patches(mk,1);
    win_y_lo = total_patches(mk,2);
    win_x_hi = total_patches(mk,1)+IW;
    win_y_hi = total_patches(mk,2)+IH;
    All_hist1(:,counter)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
    counter=counter+1;
end


counter2=1;
%% second part of patch
a2=patch_length+1:patch_length*2;
 All_hist2=zeros(6300,length(a2));
for mk=patch_length+1:patch_length*2
    
    win_x_lo = total_patches(mk,1);
    win_y_lo = total_patches(mk,2);
    win_x_hi = total_patches(mk,1)+IW;
    win_y_hi = total_patches(mk,2)+IH;
    All_hist2(:,counter2)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
    counter2=counter2+1;
end




counter3=1;
%% third part of patch
a3=(patch_length*2)+1:patch_length*3;
 All_hist3=zeros(6300,length(a3));
for mk=(patch_length*2)+1:patch_length*3
   
    win_x_lo = total_patches(mk,1);
    win_y_lo = total_patches(mk,2);
    win_x_hi = total_patches(mk,1)+IW;
    win_y_hi = total_patches(mk,2)+IH;
    All_hist3(:,counter3)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
    counter3=counter3+1;
end



counter4=1;
%% 4th part of patch
a4=(patch_length*3)+1:patch_length*4;
 All_hist4=zeros(6300,length(a4));
for mk=(patch_length*3)+1:patch_length*4
    
    win_x_lo = total_patches(mk,1);
    win_y_lo = total_patches(mk,2);
    win_x_hi = total_patches(mk,1)+IW;
    win_y_hi = total_patches(mk,2)+IH;
    All_hist4(:,counter4)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
    counter4=counter4+1;
end

counter5=1;
%% 5th part of patch
a5=(patch_length*4)+1:patch_length*5;
 All_hist5=zeros(6300,length(a5));
for mk=(patch_length*4)+1:patch_length*5
    
    win_x_lo = total_patches(mk,1);
    win_y_lo = total_patches(mk,2);
    win_x_hi = total_patches(mk,1)+IW;
    win_y_hi = total_patches(mk,2)+IH;
    All_hist5(:,counter5)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
    counter5=counter5+1;
end


counter6=1;
%% 6th part of patch
 a6=(patch_length*5)+1:length(total_patches);
 All_hist6=zeros(6300,length(a6));
for mk=(patch_length*5)+1:length(total_patches)
    
    win_x_lo = total_patches(mk,1);
    win_y_lo = total_patches(mk,2);
    win_x_hi = total_patches(mk,1)+IW;
    win_y_hi = total_patches(mk,2)+IH;
    All_hist6(:,counter6)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
    counter6=counter6+1;
end

toc;

%% from anu, rubbish code
% for i=1:first_break_y
%     for j=1:first_break_x
%        counter
%         %% take each points in this window 
%         win_x_lo = samples_x(j);
%         win_y_lo = samples_y(i);
%         win_x_hi = samples_x(j)+IW;
%         win_y_hi = samples_y(i)+IH;
% %        win_patch = index((points(:,1) > win_x_lo) & (points(:,1) <= win_x_hi) & ...
% %                (points(:,2) > win_y_lo) & (points(:,2) <=win_y_hi));
%         
%        All_hist1(:,counter)=Do_assignment_pyramids_Inria2(opts,assignment_opts,points,index,IH,IW,win_x_lo,win_x_hi,win_y_lo,win_y_hi);
%         counter=counter+1;
%     end
% end
% toc;





All_hist=[All_hist1,All_hist2,All_hist3,All_hist4,All_hist5,All_hist6];

 save ([image_dir,'/','histogram_test_sift'], 'All_hist');